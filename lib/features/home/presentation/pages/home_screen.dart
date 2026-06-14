import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'dart:math';
//
// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});
//
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(child: Scaffold(
//       body: SingleChildScrollView(
//
//       ),
//     ));
//   }
// }





// ─── Home Screen ──────────────────────────────────────────────────────────────

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Water: 12 dots = 3 L, each dot = 250 ml
  int _waterDots = 9; // 2.3 L ≈ 9 dots filled

  static const _green = Color(0xFF1D9E75);
  static const _greenDark = Color(0xFF0F6E56);
  static const _amber = Color(0xFFBA7517);
  static const _amberLight = Color(0xFFFAEEDA);
  static const _amberMid = Color(0xFFFAC775);
  static const _blue = Color(0xFF378ADD);
  static const _blueLight = Color(0xFFE6F1FB);

  final _stats = const [
    NutritionStat(
      label: 'Protein',
      current: 130,
      goal: 160,
      unit: 'g',
      icon: Icons.egg_alt_outlined,
      color: _green,
    ),
    NutritionStat(
      label: 'Calories',
      current: 2100,
      goal: 2500,
      unit: 'kcal',
      icon: Icons.local_fire_department_outlined,
      color: _amber,
    ),
  ];

  final _exercises = const [
    Exercise('Bench Press'),
    Exercise('Incline DB Press'),
    Exercise('Cable Fly'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F0),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHero(),
            const SizedBox(height: 20),
            _buildSection('Nutrition', _buildNutrition()),
            const SizedBox(height: 20),
            _buildSection("Today's Workout", _buildWorkout()),
            const SizedBox(height: 20),
            _buildSection('Achievement', _buildAchievement()),
            const SizedBox(height: 20),
            _buildSection('Quick Add', _buildQuickAdd()),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  // ── Hero ──────────────────────────────────────────────────────────────────

  Widget _buildHero() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1D9E75), Color(0xFF0A5740)],
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
      ),
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 20,
        left: 20,
        right: 20,
        bottom: 24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Greeting
          Text(
            'Good morning',
            style: TextStyle(
              color: Colors.white.withOpacity(0.72),
              fontSize: 13,
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(height: 2),
          const Text(
            'Pranav 👋',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),

          // Weight row
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.monitor_weight_outlined,
                      color: Colors.white, size: 20),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Current weight',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 12,
                      ),
                    ),
                    const Text(
                      '72.5 kg',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '↓ 0.3 kg this week',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),

          // Ring + summary
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 76,
                height: 76,
                child: CustomPaint(
                  painter: _RingPainter(progress: 0.80),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          '80%',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          'today',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.65),
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'DAILY GOAL',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 11,
                        letterSpacing: 0.06 * 11,
                      ),
                    ),
                    const SizedBox(height: 5),
                    _heroRow('Protein', '130 / 160 g'),
                    _heroRow('Calories', '2100 / 2500'),
                    _heroRow('Water', '2.3 / 3 L'),
                    _heroRow('Workout', '✓ done',
                        valueColor: const Color(0xFF9FE1CB)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _heroRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(color: Colors.white, fontSize: 13)),
          Text(
            value,
            style: TextStyle(
              color: valueColor ?? Colors.white.withOpacity(0.6),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  // ── Section wrapper ────────────────────────────────────────────────────────

  Widget _buildSection(String title, Widget child) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF888780),
              fontWeight: FontWeight.w500,
              letterSpacing: 0.7,
            ),
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }

  // ── Nutrition ──────────────────────────────────────────────────────────────

  Widget _buildNutrition() {
    return Column(
      children: [
        Row(
          children: _stats
              .map((s) => Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                  right: s == _stats.last ? 0 : 10),
              child: _MacroCard(stat: s),
            ),
          ))
              .toList(),
        ),
        const SizedBox(height: 10),
        _buildWaterCard(),
      ],
    );
  }

  Widget _buildWaterCard() {
    const totalDots = 12;
    final waterPct = _waterDots / totalDots;

    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.water_drop_outlined,
                  size: 20, color: Color(0xFF888780)),
              const Spacer(),
              _PctBadge(
                label: '${(waterPct * 100).round()}%',
                color: const Color(0xFF378ADD),
                bgColor: const Color(0xFFE6F1FB),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '${(_waterDots * 0.25).toStringAsFixed(1)} L',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF2C2C2A),
                ),
              ),
              const SizedBox(width: 4),
              const Text(
                'of 3 L water',
                style: TextStyle(fontSize: 12, color: Color(0xFF888780)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: LinearProgressIndicator(
              value: waterPct,
              minHeight: 4,
              backgroundColor: const Color(0xFFE8E8E4),
              valueColor:
              const AlwaysStoppedAnimation<Color>(Color(0xFF378ADD)),
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: List.generate(totalDots, (i) {
              final filled = i < _waterDots;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _waterDots = (i < _waterDots) ? i : i + 1;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    color: filled
                        ? const Color(0xFF378ADD)
                        : const Color(0xFFF1EFE8),
                    shape: BoxShape.circle,
                    border: filled
                        ? null
                        : Border.all(
                        color: const Color(0xFFD3D1C7), width: 0.5),
                  ),
                  child: filled
                      ? const Icon(Icons.check, color: Colors.white, size: 12)
                      : null,
                ),
              );
            }),
          ),
          const SizedBox(height: 4),
          const Text(
            'Tap a dot to log water',
            style: TextStyle(fontSize: 11, color: Color(0xFF888780)),
          ),
        ],
      ),
    );
  }

  // ── Workout ────────────────────────────────────────────────────────────────

  Widget _buildWorkout() {
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: const Color(0xFFE1F5EE),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.fitness_center,
                    color: Color(0xFF0F6E56), size: 18),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Chest + Triceps',
                      style: TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                    Text(
                      '3 exercises · ~45 min',
                      style:
                      TextStyle(fontSize: 12, color: Color(0xFF888780)),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFE1F5EE),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.check, color: Color(0xFF0F6E56), size: 13),
                    SizedBox(width: 3),
                    Text(
                      'Done',
                      style: TextStyle(
                        color: Color(0xFF0F6E56),
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Divider(height: 0.5, color: Color(0xFFE8E8E4)),
          ),
          ..._exercises.map(
                (e) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                children: [
                  const Icon(Icons.check_circle_outline,
                      size: 16, color: Color(0xFF1D9E75)),
                  const SizedBox(width: 8),
                  Text(e.name,
                      style: const TextStyle(
                          fontSize: 13, color: Color(0xFF5F5E5A))),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add, size: 16, color: Colors.white),
              label: const Text('Add another workout',
                  style: TextStyle(color: Colors.white, fontSize: 14)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1D9E75),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 11),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Achievement ────────────────────────────────────────────────────────────

  Widget _buildAchievement() {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFAEEDA), Color(0xFFFAC775)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: const Color(0xFFEF9F27), width: 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.emoji_events_outlined,
                color: Color(0xFF854F0B), size: 22),
          ),
          const SizedBox(width: 12),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'NEW PERSONAL RECORD',
                style: TextStyle(
                  fontSize: 10,
                  color: Color(0xFF854F0B),
                  letterSpacing: 0.6,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'Bench Press PR',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF633806),
                ),
              ),
              SizedBox(height: 1),
              Text(
                '75 kg × 5 reps · set today',
                style: TextStyle(fontSize: 13, color: Color(0xFF854F0B)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Quick Add ──────────────────────────────────────────────────────────────

  Widget _buildQuickAdd() {
    final actions = [
      (Icons.add_circle_outline, 'Log meal'),
      (Icons.water_drop_outlined, 'Log water'),
      (Icons.fitness_center, 'New workout'),
      (Icons.monitor_weight_outlined, 'Log weight'),
    ];

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 2.8,
      children: actions.map((a) {
        return InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(12),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border:
              Border.all(color: const Color(0xFFD3D1C7), width: 0.5),
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                Icon(a.$1, size: 18, color: const Color(0xFF888780)),
                const SizedBox(width: 8),
                Text(a.$2,
                    style: const TextStyle(
                        fontSize: 13, color: Color(0xFF2C2C2A))),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ─── Shared widgets ───────────────────────────────────────────────────────────

class _Card extends StatelessWidget {
  final Widget child;
  const _Card({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFD3D1C7), width: 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(14),
      child: child,
    );
  }
}

class _PctBadge extends StatelessWidget {
  final String label;
  final Color color;
  final Color bgColor;
  const _PctBadge(
      {required this.label, required this.color, required this.bgColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(label,
          style: TextStyle(
              fontSize: 11, fontWeight: FontWeight.w500, color: color)),
    );
  }
}

class _MacroCard extends StatelessWidget {
  final NutritionStat stat;
  const _MacroCard({required this.stat});

  @override
  Widget build(BuildContext context) {
    final badgeBg = stat.color == const Color(0xFF1D9E75)
        ? const Color(0xFFE1F5EE)
        : const Color(0xFFFAEEDA);
    final badgeFg = stat.color == const Color(0xFF1D9E75)
        ? const Color(0xFF0F6E56)
        : const Color(0xFF854F0B);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFD3D1C7), width: 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(stat.icon, size: 20, color: const Color(0xFF888780)),
              const Spacer(),
              _PctBadge(
                  label: stat.pctLabel, color: badgeFg, bgColor: badgeBg),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            stat.unit == 'kcal'
                ? stat.current.toInt().toString()
                : '${stat.current.toInt()} ${stat.unit}',
            style: const TextStyle(
                fontSize: 20, fontWeight: FontWeight.w500),
          ),
          Text(
            'of ${stat.goal.toInt()} ${stat.unit}',
            style:
            const TextStyle(fontSize: 12, color: Color(0xFF888780)),
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: LinearProgressIndicator(
              value: stat.pct,
              minHeight: 4,
              backgroundColor: const Color(0xFFE8E8E4),
              valueColor: AlwaysStoppedAnimation<Color>(stat.color),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Ring painter ─────────────────────────────────────────────────────────────

class _RingPainter extends CustomPainter {
  final double progress;
  const _RingPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final radius = math.min(cx, cy) - 7;
    final rect = Rect.fromCircle(center: Offset(cx, cy), radius: radius);

    final trackPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 7
      ..color = Colors.white.withOpacity(0.15);

    final progressPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 7
      ..strokeCap = StrokeCap.round
      ..color = Colors.white;

    canvas.drawCircle(Offset(cx, cy), radius, trackPaint);
    canvas.drawArc(
      rect,
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(_RingPainter old) => old.progress != progress;
}


class NutritionStat {
  final String label;
  final double current;
  final double goal;
  final String unit;
  final IconData icon;
  final Color color;

  const NutritionStat({
    required this.label,
    required this.current,
    required this.goal,
    required this.unit,
    required this.icon,
    required this.color,
  });

  double get pct => (current / goal).clamp(0, 1);
  String get pctLabel => '${(pct * 100).round()}%';
}

class Exercise {
  final String name;
  final bool done;
  const Exercise(this.name, {this.done = true});
}
