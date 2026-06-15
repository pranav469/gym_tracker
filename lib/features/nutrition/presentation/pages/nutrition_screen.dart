import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;


// ─── Theme ────────────────────────────────────────────────────────────────────

const kGreen = Color(0xFF1D9E75);
const kGreenDark = Color(0xFF0F6E56);
const kGreenLight = Color(0xFFE1F5EE);
const kBg = Color(0xFFF5F5F0);
const kCard = Colors.white;
const kBorder = Color(0xFFE0DED7);
const kTextPrimary = Color(0xFF1C1C1A);
const kTextSecondary = Color(0xFF888780);
const kAmber = Color(0xFFD4880A);
const kAmberLight = Color(0xFFFFF3D9);
const kBlue = Color(0xFF378ADD);
const kBlueLight = Color(0xFFE6F1FB);
const kPurple = Color(0xFF7C5CBF);
const kPurpleLight = Color(0xFFF0EBFF);
const kRed = Color(0xFFE05252);
const kRedLight = Color(0xFFFFEBEB);

// ─── Models ───────────────────────────────────────────────────────────────────

class FoodItem {
  final String name;
  final int calories;
  final double protein;
  final double carbs;
  final double fat;
  final String portion;

  const FoodItem({
    required this.name,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.portion,
  });
}

class MealSection {
  final String name;
  final IconData icon;
  final Color color;
  final List<FoodItem> foods;

  const MealSection({
    required this.name,
    required this.icon,
    required this.color,
    required this.foods,
  });

  int get totalCalories => foods.fold(0, (s, f) => s + f.calories);
  double get totalProtein => foods.fold(0.0, (s, f) => s + f.protein);
}


// ─── Nutrition Screen ─────────────────────────────────────────────────────────

class NutritionScreen extends StatefulWidget {
  const NutritionScreen({super.key});

  @override
  State<NutritionScreen> createState() => _NutritionScreenState();
}

class _NutritionScreenState extends State<NutritionScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animCtrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..forward();

  late final Animation<double> _fadeAnim =
  CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut);

  final List<MealSection> _meals = [
    const MealSection(
      name: 'Breakfast',
      icon: Icons.wb_sunny_outlined,
      color: kAmber,
      foods: [
        FoodItem(name: 'Eggs', calories: 148, protein: 12, carbs: 1, fat: 10, portion: '2 large'),
        FoodItem(name: 'Milk', calories: 122, protein: 8, carbs: 12, fat: 5, portion: '240 ml'),
        FoodItem(name: 'Banana', calories: 105, protein: 1, carbs: 27, fat: 0, portion: '1 medium'),
      ],
    ),
    const MealSection(
      name: 'Lunch',
      icon: Icons.restaurant_outlined,
      color: kGreen,
      foods: [
        FoodItem(name: 'Rice', calories: 242, protein: 4, carbs: 53, fat: 0, portion: '1 cup cooked'),
        FoodItem(name: 'Chicken Breast', calories: 335, protein: 63, carbs: 0, fat: 7, portion: '200 g'),
      ],
    ),
    const MealSection(
      name: 'Dinner',
      icon: Icons.nightlight_outlined,
      color: kPurple,
      foods: [],
    ),
    const MealSection(
      name: 'Snacks',
      icon: Icons.fastfood_outlined,
      color: kBlue,
      foods: [
        FoodItem(name: 'Protein Bar', calories: 210, protein: 20, carbs: 22, fat: 6, portion: '1 bar'),
        FoodItem(name: 'Apple', calories: 95, protein: 0, carbs: 25, fat: 0, portion: '1 medium'),
      ],
    ),
  ];

  // Totals
  static const _calGoal = 2500;
  static const _protGoal = 160.0;
  static const _carbGoal = 280.0;
  static const _fatGoal = 70.0;

  int get _totalCal => _meals.fold(0, (s, m) => s + m.totalCalories);
  double get _totalProt => _meals.fold(0.0, (s, m) => s + m.totalProtein);
  double get _totalCarbs =>
      _meals.fold(0.0, (s, m) => m.foods.fold(s, (ss, f) => ss + f.carbs));
  double get _totalFat =>
      _meals.fold(0.0, (s, m) => m.foods.fold(s, (ss, f) => ss + f.fat));

  void _showAddFood(MealSection meal) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _AddFoodSheet(
        mealName: meal.name,
        onAdd: (item) => setState(() {
          final idx = _meals.indexOf(meal);
          _meals[idx] = MealSection(
            name: meal.name,
            icon: meal.icon,
            color: meal.color,
            foods: [...meal.foods, item],
          );
        }),
      ),
    );
  }

  void _showFoodDetail(FoodItem food) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _FoodDetailSheet(food: food),
    );
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    return Scaffold(
      backgroundColor: kBg,
      body: FadeTransition(
        opacity: _fadeAnim,
        child: CustomScrollView(
          slivers: [
            _buildAppBar(top),
            SliverToBoxAdapter(child: _buildCalorieRing()),
            SliverToBoxAdapter(child: _buildMacroRow()),
            SliverToBoxAdapter(child: _buildMacroBreakdownCard()),
            SliverToBoxAdapter(child: const SizedBox(height: 20)),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: const _SectionLabel('Meals'),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 10)),
            ..._meals.map((m) => SliverToBoxAdapter(
              child: _MealCard(
                meal: m,
                onAddFood: () => _showAddFood(m),
                onFoodTap: _showFoodDetail,
              ),
            )),
            const SliverToBoxAdapter(child: SizedBox(height: 32)),
          ],
        ),
      ),
    );
  }

  // ── App bar ───────────────────────────────────────────────────────────────

  Widget _buildAppBar(double top) {
    return SliverToBoxAdapter(
      child: Container(
        color: kCard,
        padding: EdgeInsets.only(top: top + 14, left: 16, right: 16, bottom: 14),
        child: Row(
          children: [
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Monday, Jun 15',
                      style: TextStyle(fontSize: 12, color: kTextSecondary)),
                  Text('Nutrition',
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: kTextPrimary)),
                ],
              ),
            ),
            // Date nav
            Row(
              children: [
                _iconBtn(Icons.chevron_left, () {}),
                const SizedBox(width: 4),
                _iconBtn(Icons.chevron_right, () {}),
              ],
            ),
            const SizedBox(width: 8),
            _iconBtn(Icons.tune_rounded, () {}),
          ],
        ),
      ),
    );
  }

  Widget _iconBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: kBg,
          borderRadius: BorderRadius.circular(9),
          border: Border.all(color: kBorder),
        ),
        child: Icon(icon, size: 17, color: kTextPrimary),
      ),
    );
  }

  // ── Calorie ring ──────────────────────────────────────────────────────────

  Widget _buildCalorieRing() {
    final pct = (_totalCal / _calGoal).clamp(0.0, 1.0);
    final remaining = (_calGoal - _totalCal).clamp(0, _calGoal);
    return Container(
      color: kCard,
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
      child: Row(
        children: [
          AnimatedBuilder(
            animation: _animCtrl,
            builder: (_, __) => SizedBox(
              width: 110,
              height: 110,
              child: CustomPaint(
                painter: _DonutPainter(
                    progress: pct * _animCtrl.value,
                    trackColor: const Color(0xFFF0EEE8),
                    fillColor: kGreen),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('$_totalCal',
                          style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: kTextPrimary)),
                      const Text('kcal',
                          style:
                          TextStyle(fontSize: 11, color: kTextSecondary)),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _RingStat(
                    label: 'Goal', value: '$_calGoal kcal', color: kTextSecondary),
                const SizedBox(height: 8),
                _RingStat(
                    label: 'Eaten',
                    value: '$_totalCal kcal',
                    color: kGreen),
                const SizedBox(height: 8),
                _RingStat(
                    label: 'Remaining',
                    value: '$remaining kcal',
                    color: remaining > 0 ? kTextPrimary : kRed),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: AnimatedBuilder(
                    animation: _animCtrl,
                    builder: (_, __) => LinearProgressIndicator(
                      value: pct * _animCtrl.value,
                      minHeight: 5,
                      backgroundColor: const Color(0xFFF0EEE8),
                      valueColor:
                      const AlwaysStoppedAnimation<Color>(kGreen),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text('${(pct * 100).round()}% of daily goal',
                    style: const TextStyle(
                        fontSize: 11, color: kTextSecondary)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Macro row ─────────────────────────────────────────────────────────────

  Widget _buildMacroRow() {
    return Container(
      color: kCard,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Row(
        children: [
          _MacroPill(
              label: 'Protein',
              current: _totalProt,
              goal: _protGoal,
              unit: 'g',
              color: kGreen,
              anim: _animCtrl),
          const SizedBox(width: 8),
          _MacroPill(
              label: 'Carbs',
              current: _totalCarbs,
              goal: _carbGoal,
              unit: 'g',
              color: kAmber,
              anim: _animCtrl),
          const SizedBox(width: 8),
          _MacroPill(
              label: 'Fat',
              current: _totalFat,
              goal: _fatGoal,
              unit: 'g',
              color: kBlue,
              anim: _animCtrl),
        ],
      ),
    );
  }

  // ── Macro breakdown ───────────────────────────────────────────────────────

  Widget _buildMacroBreakdownCard() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Container(
        decoration: BoxDecoration(
          color: kCard,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: kBorder, width: 0.5),
        ),
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Macro breakdown',
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: kTextPrimary)),
            const SizedBox(height: 12),
            _MacroBar(
                label: 'Protein',
                current: _totalProt,
                goal: _protGoal,
                unit: 'g',
                color: kGreen,
                anim: _animCtrl),
            const SizedBox(height: 10),
            _MacroBar(
                label: 'Carbs',
                current: _totalCarbs,
                goal: _carbGoal,
                unit: 'g',
                color: kAmber,
                anim: _animCtrl),
            const SizedBox(height: 10),
            _MacroBar(
                label: 'Fat',
                current: _totalFat,
                goal: _fatGoal,
                unit: 'g',
                color: kBlue,
                anim: _animCtrl),
          ],
        ),
      ),
    );
  }
}

// ─── Shared small widgets ─────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) => Text(
    text.toUpperCase(),
    style: const TextStyle(
        fontSize: 12,
        color: kTextSecondary,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.7),
  );
}

class _RingStat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _RingStat(
      {required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 68,
          child: Text(label,
              style: const TextStyle(fontSize: 12, color: kTextSecondary)),
        ),
        Text(value,
            style: TextStyle(
                fontSize: 13, fontWeight: FontWeight.w600, color: color)),
      ],
    );
  }
}

class _MacroPill extends StatelessWidget {
  final String label;
  final double current;
  final double goal;
  final String unit;
  final Color color;
  final Animation<double> anim;

  const _MacroPill({
    required this.label,
    required this.current,
    required this.goal,
    required this.unit,
    required this.color,
    required this.anim,
  });

  @override
  Widget build(BuildContext context) {
    final pct = (current / goal).clamp(0.0, 1.0);
    final bg = color.withOpacity(0.08);
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: TextStyle(
                    fontSize: 11, color: color, fontWeight: FontWeight.w500)),
            const SizedBox(height: 4),
            Text('${current.toInt()} $unit',
                style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: kTextPrimary)),
            Text('/ ${goal.toInt()} $unit',
                style:
                const TextStyle(fontSize: 10, color: kTextSecondary)),
            const SizedBox(height: 6),
            AnimatedBuilder(
              animation: anim,
              builder: (_, __) => ClipRRect(
                borderRadius: BorderRadius.circular(2),
                child: LinearProgressIndicator(
                  value: pct * anim.value,
                  minHeight: 3,
                  backgroundColor: color.withOpacity(0.15),
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MacroBar extends StatelessWidget {
  final String label;
  final double current;
  final double goal;
  final String unit;
  final Color color;
  final Animation<double> anim;

  const _MacroBar({
    required this.label,
    required this.current,
    required this.goal,
    required this.unit,
    required this.color,
    required this.anim,
  });

  @override
  Widget build(BuildContext context) {
    final pct = (current / goal).clamp(0.0, 1.0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                        color: color, shape: BoxShape.circle)),
                const SizedBox(width: 6),
                Text(label,
                    style: const TextStyle(
                        fontSize: 12, color: kTextSecondary)),
              ],
            ),
            Text('${current.toInt()} / ${goal.toInt()} $unit',
                style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: kTextPrimary)),
          ],
        ),
        const SizedBox(height: 5),
        AnimatedBuilder(
          animation: anim,
          builder: (_, __) => ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: pct * anim.value,
              minHeight: 6,
              backgroundColor: const Color(0xFFF0EEE8),
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Meal Card ────────────────────────────────────────────────────────────────

class _MealCard extends StatefulWidget {
  final MealSection meal;
  final VoidCallback onAddFood;
  final void Function(FoodItem) onFoodTap;

  const _MealCard({
    required this.meal,
    required this.onAddFood,
    required this.onFoodTap,
  });

  @override
  State<_MealCard> createState() => _MealCardState();
}

class _MealCardState extends State<_MealCard> {
  bool _expanded = true;

  @override
  Widget build(BuildContext context) {
    final meal = widget.meal;
    final isEmpty = meal.foods.isEmpty;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
      child: Container(
        decoration: BoxDecoration(
          color: kCard,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: kBorder, width: 0.5),
        ),
        child: Column(
          children: [
            // Header
            InkWell(
              onTap: () => setState(() => _expanded = !_expanded),
              borderRadius: BorderRadius.circular(14),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 13, 14, 13),
                child: Row(
                  children: [
                    Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: meal.color.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child:
                      Icon(meal.icon, size: 17, color: meal.color),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(meal.name,
                              style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: kTextPrimary)),
                          Text(
                            isEmpty
                                ? 'No foods logged'
                                : '${meal.totalCalories} kcal · ${meal.foods.length} item${meal.foods.length > 1 ? 's' : ''}',
                            style: const TextStyle(
                                fontSize: 11, color: kTextSecondary),
                          ),
                        ],
                      ),
                    ),
                    if (!isEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: meal.color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${meal.totalCalories} kcal',
                          style: TextStyle(
                              fontSize: 11,
                              color: meal.color,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    const SizedBox(width: 6),
                    Icon(
                      _expanded
                          ? Icons.keyboard_arrow_up_rounded
                          : Icons.keyboard_arrow_down_rounded,
                      color: kTextSecondary,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),

            // Food list
            AnimatedSize(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOut,
              child: _expanded
                  ? Column(
                children: [
                  if (meal.foods.isNotEmpty)
                    const Divider(
                        height: 0.5, color: kBorder, indent: 14, endIndent: 14),
                  if (isEmpty)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        decoration: BoxDecoration(
                          color: kBg,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            Icon(meal.icon,
                                size: 24,
                                color: kTextSecondary.withOpacity(0.5)),
                            const SizedBox(height: 6),
                            const Text('Nothing logged yet',
                                style: TextStyle(
                                    fontSize: 12, color: kTextSecondary)),
                          ],
                        ),
                      ),
                    ),
                  ...meal.foods.map(
                        (f) => _FoodRow(
                      food: f,
                      mealColor: meal.color,
                      onTap: () => widget.onFoodTap(f),
                    ),
                  ),
                  // Add food
                  InkWell(
                    onTap: widget.onAddFood,
                    borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(14)),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 11),
                      decoration: BoxDecoration(
                        border: meal.foods.isNotEmpty
                            ? const Border(
                            top: BorderSide(
                                color: kBorder, width: 0.5))
                            : null,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add, size: 15, color: meal.color),
                          const SizedBox(width: 5),
                          Text('Add Food',
                              style: TextStyle(
                                  fontSize: 13,
                                  color: meal.color,
                                  fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ),
                  ),
                ],
              )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Food Row ─────────────────────────────────────────────────────────────────

class _FoodRow extends StatelessWidget {
  final FoodItem food;
  final Color mealColor;
  final VoidCallback onTap;

  const _FoodRow(
      {required this.food, required this.mealColor, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
        child: Row(
          children: [
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                  color: mealColor, shape: BoxShape.circle),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(food.name,
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: kTextPrimary)),
                  Text(food.portion,
                      style: const TextStyle(
                          fontSize: 11, color: kTextSecondary)),
                ],
              ),
            ),
            // Mini macros
            Row(
              children: [
                _MiniMacro(value: '${food.protein.toInt()}g', label: 'P', color: kGreen),
                const SizedBox(width: 6),
                _MiniMacro(value: '${food.carbs.toInt()}g', label: 'C', color: kAmber),
                const SizedBox(width: 6),
                _MiniMacro(value: '${food.fat.toInt()}g', label: 'F', color: kBlue),
              ],
            ),
            const SizedBox(width: 10),
            Text('${food.calories}',
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: kTextPrimary)),
            const Text(' kcal',
                style: TextStyle(fontSize: 11, color: kTextSecondary)),
            const SizedBox(width: 2),
            const Icon(Icons.chevron_right, size: 16, color: kTextSecondary),
          ],
        ),
      ),
    );
  }
}

class _MiniMacro extends StatelessWidget {
  final String value;
  final String label;
  final Color color;

  const _MiniMacro(
      {required this.value, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(value,
          style: TextStyle(
              fontSize: 10, color: color, fontWeight: FontWeight.w600)),
    );
  }
}

// ─── Food Detail Sheet ────────────────────────────────────────────────────────

class _FoodDetailSheet extends StatelessWidget {
  final FoodItem food;
  const _FoodDetailSheet({required this.food});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.55,
      decoration: const BoxDecoration(
        color: kCard,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                    color: kBorder, borderRadius: BorderRadius.circular(2))),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(food.name,
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: kTextPrimary)),
                    Text(food.portion,
                        style: const TextStyle(
                            fontSize: 13, color: kTextSecondary)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: kGreenLight,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text('${food.calories} kcal',
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: kGreenDark)),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Text('Macronutrients',
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: kTextPrimary)),
          const SizedBox(height: 14),
          Row(
            children: [
              _DetailMacroCard(
                  label: 'Protein',
                  value: food.protein,
                  unit: 'g',
                  color: kGreen,
                  bgColor: kGreenLight),
              const SizedBox(width: 10),
              _DetailMacroCard(
                  label: 'Carbs',
                  value: food.carbs,
                  unit: 'g',
                  color: kAmber,
                  bgColor: kAmberLight),
              const SizedBox(width: 10),
              _DetailMacroCard(
                  label: 'Fat',
                  value: food.fat,
                  unit: 'g',
                  color: kBlue,
                  bgColor: kBlueLight),
            ],
          ),
          const Spacer(),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    side: const BorderSide(color: kBorder),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Close',
                      style: TextStyle(color: kTextPrimary)),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kRed,
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: const Text('Remove',
                      style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DetailMacroCard extends StatelessWidget {
  final String label;
  final double value;
  final String unit;
  final Color color;
  final Color bgColor;

  const _DetailMacroCard({
    required this.label,
    required this.value,
    required this.unit,
    required this.color,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: TextStyle(fontSize: 11, color: color.withOpacity(0.8))),
            const SizedBox(height: 4),
            Text('${value.toInt()} $unit',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: color)),
          ],
        ),
      ),
    );
  }
}

// ─── Add Food Sheet ───────────────────────────────────────────────────────────

class _AddFoodSheet extends StatefulWidget {
  final String mealName;
  final void Function(FoodItem) onAdd;

  const _AddFoodSheet({required this.mealName, required this.onAdd});

  @override
  State<_AddFoodSheet> createState() => _AddFoodSheetState();
}

class _AddFoodSheetState extends State<_AddFoodSheet> {
  final _nameCtrl = TextEditingController();
  final _calCtrl = TextEditingController();
  final _protCtrl = TextEditingController();
  final _carbCtrl = TextEditingController();
  final _fatCtrl = TextEditingController();
  final _portionCtrl = TextEditingController();

  static const _quickFoods = [
    ('🥚', 'Eggs', 148, 12.0, 1.0, 10.0, '2 large'),
    ('🍌', 'Banana', 105, 1.0, 27.0, 0.0, '1 medium'),
    ('🍗', 'Chicken', 335, 63.0, 0.0, 7.0, '200 g'),
    ('🥛', 'Milk', 122, 8.0, 12.0, 5.0, '240 ml'),
    ('🍚', 'Rice', 242, 4.0, 53.0, 0.0, '1 cup'),
    ('🥜', 'Peanut Butter', 188, 8.0, 6.0, 16.0, '2 tbsp'),
  ];

  void _quickAdd(
      String name, int cal, double prot, double carbs, double fat, String portion) {
    widget.onAdd(FoodItem(
        name: name,
        calories: cal,
        protein: prot,
        carbs: carbs,
        fat: fat,
        portion: portion));
    Navigator.pop(context);
  }

  void _submit() {
    final name = _nameCtrl.text.trim();
    if (name.isEmpty) return;
    widget.onAdd(FoodItem(
      name: name,
      calories: int.tryParse(_calCtrl.text) ?? 0,
      protein: double.tryParse(_protCtrl.text) ?? 0,
      carbs: double.tryParse(_carbCtrl.text) ?? 0,
      fat: double.tryParse(_fatCtrl.text) ?? 0,
      portion: _portionCtrl.text.isEmpty ? '1 serving' : _portionCtrl.text,
    ));
    Navigator.pop(context);
  }

  @override
  void dispose() {
    for (final c in [_nameCtrl, _calCtrl, _protCtrl, _carbCtrl, _fatCtrl, _portionCtrl]) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return Container(
      padding: EdgeInsets.fromLTRB(20, 14, 20, bottom + 24),
      decoration: const BoxDecoration(
        color: kCard,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                      color: kBorder,
                      borderRadius: BorderRadius.circular(2))),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Add to ${widget.mealName}',
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: kTextPrimary)),
                      const Text('Quick pick or enter manually',
                          style: TextStyle(
                              fontSize: 12, color: kTextSecondary)),
                    ],
                  ),
                ),
                IconButton(
                    icon: const Icon(Icons.close, color: kTextSecondary),
                    onPressed: () => Navigator.pop(context)),
              ],
            ),
            const SizedBox(height: 14),

            // Quick foods
            const Text('Quick add',
                style: TextStyle(
                    fontSize: 12,
                    color: kTextSecondary,
                    fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _quickFoods
                  .map((f) => GestureDetector(
                onTap: () =>
                    _quickAdd(f.$2, f.$3, f.$4, f.$5, f.$6, f.$7),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 7),
                  decoration: BoxDecoration(
                    color: kBg,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: kBorder),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(f.$1,
                          style: const TextStyle(fontSize: 14)),
                      const SizedBox(width: 5),
                      Text(f.$2,
                          style: const TextStyle(
                              fontSize: 12,
                              color: kTextPrimary,
                              fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
              ))
                  .toList(),
            ),

            const SizedBox(height: 16),
            const Divider(color: kBorder),
            const SizedBox(height: 10),

            // Manual entry
            const Text('Enter manually',
                style: TextStyle(
                    fontSize: 12,
                    color: kTextSecondary,
                    fontWeight: FontWeight.w500)),
            const SizedBox(height: 10),
            _TextField(ctrl: _nameCtrl, hint: 'Food name', icon: Icons.edit_outlined),
            const SizedBox(height: 8),
            _TextField(ctrl: _portionCtrl, hint: 'Portion (e.g. 1 cup)', icon: Icons.scale_outlined),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(child: _TextField(ctrl: _calCtrl, hint: 'Calories', icon: Icons.local_fire_department_outlined, isNum: true)),
                const SizedBox(width: 8),
                Expanded(child: _TextField(ctrl: _protCtrl, hint: 'Protein g', icon: Icons.egg_alt_outlined, isNum: true)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(child: _TextField(ctrl: _carbCtrl, hint: 'Carbs g', icon: Icons.grain_outlined, isNum: true)),
                const SizedBox(width: 8),
                Expanded(child: _TextField(ctrl: _fatCtrl, hint: 'Fat g', icon: Icons.opacity_outlined, isNum: true)),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: kGreen,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: const Text('Add Food',
                    style: TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TextField extends StatelessWidget {
  final TextEditingController ctrl;
  final String hint;
  final IconData icon;
  final bool isNum;

  const _TextField({
    required this.ctrl,
    required this.hint,
    required this.icon,
    this.isNum = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: ctrl,
      keyboardType: isNum
          ? const TextInputType.numberWithOptions(decimal: true)
          : TextInputType.text,
      style: const TextStyle(fontSize: 14, color: kTextPrimary),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(fontSize: 13, color: kTextSecondary),
        prefixIcon:
        Icon(icon, size: 17, color: kTextSecondary),
        isDense: true,
        filled: true,
        fillColor: kBg,
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: kBorder, width: 0.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: kBorder, width: 0.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: kGreen, width: 1.2),
        ),
      ),
    );
  }
}

// ─── Donut painter ────────────────────────────────────────────────────────────

class _DonutPainter extends CustomPainter {
  final double progress;
  final Color trackColor;
  final Color fillColor;

  const _DonutPainter({
    required this.progress,
    required this.trackColor,
    required this.fillColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = math.min(cx, cy) - 8;
    final rect = Rect.fromCircle(center: Offset(cx, cy), radius: r);

    canvas.drawCircle(
        Offset(cx, cy),
        r,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 10
          ..color = trackColor);

    canvas.drawArc(
        rect,
        -math.pi / 2,
        2 * math.pi * progress,
        false,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 10
          ..strokeCap = StrokeCap.round
          ..color = fillColor);
  }

  @override
  bool shouldRepaint(_DonutPainter old) => old.progress != progress;
}