import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;


// ─── Theme constants ──────────────────────────────────────────────────────────

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

// ─── Models ───────────────────────────────────────────────────────────────────

class WorkoutSet {
  final int reps;
  final double weight;
  bool done;
  WorkoutSet({required this.reps, required this.weight, this.done = false});
  WorkoutSet copyWith({int? reps, double? weight, bool? done}) =>
      WorkoutSet(
          reps: reps ?? this.reps,
          weight: weight ?? this.weight,
          done: done ?? this.done);
}

class ExerciseEntry {
  final String name;
  List<WorkoutSet> sets;
  ExerciseEntry({required this.name, required this.sets});
}

class HistorySession {
  final String date;
  final double weight;
  final int reps;
  final double volume;
  const HistorySession(
      {required this.date,
        required this.weight,
        required this.reps,
        required this.volume});
}

// ─── App ─────────────────────────────────────────────────────────────────────



// ─── Workout Screen ───────────────────────────────────────────────────────────

class WorkoutScreen extends StatefulWidget {
  const WorkoutScreen({super.key});

  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  Duration _elapsed = Duration.zero;
  late final _ticker = Stream.periodic(const Duration(seconds: 1));

  final List<ExerciseEntry> _exercises = [
    ExerciseEntry(name: 'Bench Press', sets: [
      WorkoutSet(reps: 10, weight: 60),
      WorkoutSet(reps: 8, weight: 65),
      WorkoutSet(reps: 6, weight: 70),
    ]),
    ExerciseEntry(name: 'Incline DB Press', sets: [
      WorkoutSet(reps: 10, weight: 22),
      WorkoutSet(reps: 10, weight: 22),
      WorkoutSet(reps: 10, weight: 22),
    ]),
  ];

  @override
  void initState() {
    super.initState();
    _ticker.listen((_) {
      if (mounted) setState(() => _elapsed += const Duration(seconds: 1));
    });
  }

  String get _timerLabel {
    final m = _elapsed.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = _elapsed.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  int get _totalSets =>
      _exercises.fold(0, (sum, e) => sum + e.sets.length);
  int get _doneSets =>
      _exercises.fold(0, (sum, e) => sum + e.sets.where((s) => s.done).length);
  double get _totalVolume => _exercises.fold(
      0,
          (sum, e) =>
      sum +
          e.sets.where((s) => s.done).fold(
              0.0, (sv, s) => sv + s.reps * s.weight));

  void _toggleSet(ExerciseEntry ex, int idx) {
    HapticFeedback.lightImpact();
    setState(() => ex.sets[idx].done = !ex.sets[idx].done);
  }

  void _addSet(ExerciseEntry ex) {
    setState(() {
      final last = ex.sets.isNotEmpty ? ex.sets.last : null;
      ex.sets.add(WorkoutSet(
          reps: last?.reps ?? 10, weight: last?.weight ?? 20));
    });
  }

  void _removeSet(ExerciseEntry ex, int idx) {
    setState(() => ex.sets.removeAt(idx));
  }

  void _addExercise() {
    setState(() => _exercises.add(
        ExerciseEntry(name: 'New Exercise', sets: [WorkoutSet(reps: 10, weight: 20)])));
  }

  void _showHistory(String exerciseName) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ExerciseHistorySheet(exerciseName: exerciseName),
    );
  }

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    return Scaffold(
      backgroundColor: kBg,
      body: Column(
        children: [
          _buildHeader(top),
          _buildStatsBar(),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
              children: [
                ..._exercises.map((ex) => _ExerciseCard(
                  exercise: ex,
                  onToggleSet: (i) => _toggleSet(ex, i),
                  onAddSet: () => _addSet(ex),
                  onRemoveSet: (i) => _removeSet(ex, i),
                  onHistoryTap: () => _showHistory(ex.name),
                )),
                const SizedBox(height: 12),
                _AddExerciseButton(onTap: _addExercise),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildFinishBar(),
    );
  }

  Widget _buildHeader(double top) {
    return Container(
      color: kCard,
      padding: EdgeInsets.only(top: top + 12, left: 16, right: 16, bottom: 14),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {},
            child: Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: kBg,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: kBorder),
              ),
              child: const Icon(Icons.arrow_back_ios_new, size: 16, color: kTextPrimary),
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Today\'s Plan',
                    style: TextStyle(
                        fontSize: 12, color: kTextSecondary, letterSpacing: 0.4)),
                Text('Chest + Triceps',
                    style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: kTextPrimary)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: kGreenLight,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const Icon(Icons.timer_outlined, size: 14, color: kGreenDark),
                const SizedBox(width: 4),
                Text(_timerLabel,
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: kGreenDark)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsBar() {
    return Container(
      color: kCard,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Container(
        decoration: BoxDecoration(
          color: kBg,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: kBorder),
        ),
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            _StatChip(
                label: 'Sets done',
                value: '$_doneSets / $_totalSets',
                icon: Icons.check_circle_outline),
            _vDivider(),
            _StatChip(
                label: 'Volume',
                value: '${_totalVolume.toStringAsFixed(0)} kg',
                icon: Icons.bar_chart_rounded),
            _vDivider(),
            _StatChip(
                label: 'Progress',
                value: _totalSets == 0
                    ? '0%'
                    : '${((_doneSets / _totalSets) * 100).round()}%',
                icon: Icons.trending_up),
          ],
        ),
      ),
    );
  }

  Widget _vDivider() => Container(
      width: 0.5, height: 28, color: kBorder, margin: const EdgeInsets.symmetric(horizontal: 4));

  Widget _buildFinishBar() {
    return Container(
      padding: EdgeInsets.only(
          left: 16,
          right: 16,
          bottom: MediaQuery.of(context).padding.bottom + 16,
          top: 12),
      decoration: const BoxDecoration(
        color: kCard,
        border: Border(top: BorderSide(color: kBorder, width: 0.5)),
      ),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: kGreen,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 15),
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 0,
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.flag_rounded, size: 18),
              SizedBox(width: 8),
              Text('Finish Workout',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Stat chip ────────────────────────────────────────────────────────────────

class _StatChip extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  const _StatChip(
      {required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 13, color: kTextSecondary),
              const SizedBox(width: 3),
              Text(label,
                  style:
                  const TextStyle(fontSize: 11, color: kTextSecondary)),
            ],
          ),
          const SizedBox(height: 3),
          Text(value,
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: kTextPrimary)),
        ],
      ),
    );
  }
}

// ─── Exercise Card ────────────────────────────────────────────────────────────

class _ExerciseCard extends StatelessWidget {
  final ExerciseEntry exercise;
  final void Function(int) onToggleSet;
  final void Function(int) onRemoveSet;
  final VoidCallback onAddSet;
  final VoidCallback onHistoryTap;

  const _ExerciseCard({
    required this.exercise,
    required this.onToggleSet,
    required this.onRemoveSet,
    required this.onAddSet,
    required this.onHistoryTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: kCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: kBorder, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 0),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: kGreenLight,
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: const Icon(Icons.fitness_center,
                      size: 16, color: kGreenDark),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(exercise.name,
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: kTextPrimary)),
                ),
                GestureDetector(
                  onTap: onHistoryTap,
                  child: Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: kAmberLight,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.history, size: 13, color: kAmber),
                        SizedBox(width: 3),
                        Text('History',
                            style:
                            TextStyle(fontSize: 11, color: kAmber, fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Column labels
          const Padding(
            padding: EdgeInsets.fromLTRB(14, 12, 14, 4),
            child: Row(
              children: [
                SizedBox(width: 28),
                Expanded(
                    flex: 2,
                    child: Text('SET',
                        style: TextStyle(
                            fontSize: 10,
                            color: kTextSecondary,
                            letterSpacing: 0.7))),
                Expanded(
                    flex: 3,
                    child: Text('KG',
                        style: TextStyle(
                            fontSize: 10,
                            color: kTextSecondary,
                            letterSpacing: 0.7))),
                Expanded(
                    flex: 3,
                    child: Text('REPS',
                        style: TextStyle(
                            fontSize: 10,
                            color: kTextSecondary,
                            letterSpacing: 0.7))),
                SizedBox(width: 56),
              ],
            ),
          ),

          const Divider(height: 0.5, color: kBorder, indent: 14, endIndent: 14),

          // Sets
          ...exercise.sets.asMap().entries.map(
                (e) => _SetRow(
              index: e.key,
              set: e.value,
              onToggle: () => onToggleSet(e.key),
              onRemove: () => onRemoveSet(e.key),
            ),
          ),

          // Add set
          InkWell(
            onTap: onAddSet,
            borderRadius: const BorderRadius.vertical(bottom: Radius.circular(14)),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 11),
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: kBorder, width: 0.5)),
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(14)),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add, size: 15, color: kGreen),
                  SizedBox(width: 5),
                  Text('Add Set',
                      style: TextStyle(
                          fontSize: 13,
                          color: kGreen,
                          fontWeight: FontWeight.w500)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Set Row ──────────────────────────────────────────────────────────────────

class _SetRow extends StatelessWidget {
  final int index;
  final WorkoutSet set;
  final VoidCallback onToggle;
  final VoidCallback onRemove;

  const _SetRow({
    required this.index,
    required this.set,
    required this.onToggle,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey('set_${index}_${set.weight}_${set.reps}'),
      direction: DismissDirection.endToStart,
      background: Container(
        color: const Color(0xFFFFEBEB),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        child: const Icon(Icons.delete_outline, color: Color(0xFFE03E3E)),
      ),
      onDismissed: (_) => onRemove(),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        color: set.done ? kGreenLight.withOpacity(0.5) : Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Row(
          children: [
            // Check button
            GestureDetector(
              onTap: onToggle,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: set.done ? kGreen : Colors.transparent,
                  border: Border.all(
                    color: set.done ? kGreen : kBorder,
                    width: 1.5,
                  ),
                ),
                child: set.done
                    ? const Icon(Icons.check, color: Colors.white, size: 13)
                    : null,
              ),
            ),
            const SizedBox(width: 10),

            // Set number
            Expanded(
              flex: 2,
              child: Text('${index + 1}',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: set.done ? kGreenDark : kTextPrimary)),
            ),

            // Weight
            Expanded(
              flex: 3,
              child: _EditableValue(
                value: set.weight,
                suffix: 'kg',
                done: set.done,
              ),
            ),

            // Reps
            Expanded(
              flex: 3,
              child: _EditableValue(
                value: set.reps.toDouble(),
                suffix: 'reps',
                isInt: true,
                done: set.done,
              ),
            ),

            // Delete
            GestureDetector(
              onTap: onRemove,
              child: const SizedBox(
                width: 28,
                child: Icon(Icons.remove_circle_outline,
                    size: 18, color: kTextSecondary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Editable value cell ──────────────────────────────────────────────────────

class _EditableValue extends StatefulWidget {
  final double value;
  final String suffix;
  final bool isInt;
  final bool done;

  const _EditableValue({
    required this.value,
    required this.suffix,
    this.isInt = false,
    this.done = false,
  });

  @override
  State<_EditableValue> createState() => _EditableValueState();
}

class _EditableValueState extends State<_EditableValue> {
  late final _controller =
  TextEditingController(text: widget.isInt ? widget.value.toInt().toString() : widget.value.toString());

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 42,
          child: TextField(
            controller: _controller,
            keyboardType:
            const TextInputType.numberWithOptions(decimal: true),
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: widget.done ? kGreenDark : kTextPrimary,
            ),
            decoration: const InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.zero,
              border: InputBorder.none,
            ),
          ),
        ),
        Text(widget.suffix,
            style: const TextStyle(fontSize: 12, color: kTextSecondary)),
      ],
    );
  }
}

// ─── Add Exercise button ──────────────────────────────────────────────────────

class _AddExerciseButton extends StatelessWidget {
  final VoidCallback onTap;
  const _AddExerciseButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          border: Border.all(color: kGreen, width: 1.2),
          borderRadius: BorderRadius.circular(14),
          color: kGreenLight.withOpacity(0.4),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_circle_outline, color: kGreen, size: 18),
            SizedBox(width: 7),
            Text('Add Exercise',
                style: TextStyle(
                    fontSize: 14,
                    color: kGreen,
                    fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

// ─── Exercise History Bottom Sheet ───────────────────────────────────────────

class ExerciseHistorySheet extends StatelessWidget {
  final String exerciseName;

  const ExerciseHistorySheet({super.key, required this.exerciseName});

  static const _benchHistory = [
    HistorySession(date: 'Jun 14', weight: 70, reps: 5, volume: 350),
    HistorySession(date: 'Jun 10', weight: 67.5, reps: 7, volume: 472.5),
    HistorySession(date: 'Jun 6', weight: 65, reps: 8, volume: 520),
    HistorySession(date: 'Jun 2', weight: 62.5, reps: 10, volume: 625),
    HistorySession(date: 'May 28', weight: 60, reps: 10, volume: 600),
  ];

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.88,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (_, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: kCard,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Handle
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 6),
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: kBorder,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              // Title bar
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(exerciseName,
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: kTextPrimary)),
                          const Text('Exercise history',
                              style: TextStyle(
                                  fontSize: 12, color: kTextSecondary)),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: kTextSecondary),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),

              // PR badge
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFFF3D9), Color(0xFFFAECB8)],
                    ),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFE8C64B), width: 0.5),
                  ),
                  child: const Row(
                    children: [
                      Text('🏆', style: TextStyle(fontSize: 20)),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Personal Record',
                              style: TextStyle(
                                  fontSize: 11,
                                  color: kAmber,
                                  fontWeight: FontWeight.w500)),
                          Text('75 kg × 5 reps',
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF633806))),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).padding.bottom + 16),
                  children: [
                    // Volume chart
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Volume per session',
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: kTextPrimary)),
                          const SizedBox(height: 12),
                          SizedBox(
                            height: 130,
                            child: _VolumeChart(sessions: _benchHistory),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text('Last 5 sessions',
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: kTextPrimary)),
                    ),
                    const SizedBox(height: 10),

                    ..._benchHistory.asMap().entries.map(
                          (e) => _HistorySessionRow(
                        session: e.value,
                        index: e.key,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ─── History session row ──────────────────────────────────────────────────────

class _HistorySessionRow extends StatelessWidget {
  final HistorySession session;
  final int index;

  const _HistorySessionRow({required this.session, required this.index});

  @override
  Widget build(BuildContext context) {
    final isFirst = index == 0;
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: isFirst ? kGreenLight : kBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isFirst ? kGreen.withOpacity(0.3) : kBorder,
          width: 0.5,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: isFirst ? kGreen : kBorder,
              borderRadius: BorderRadius.circular(9),
            ),
            child: Center(
              child: Text('${index + 1}',
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: isFirst ? Colors.white : kTextSecondary)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(session.date,
                    style: const TextStyle(
                        fontSize: 12, color: kTextSecondary)),
                const SizedBox(height: 2),
                Text(
                  '${session.weight} kg × ${session.reps} reps',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: isFirst ? kGreenDark : kTextPrimary),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text('Volume',
                  style: TextStyle(fontSize: 11, color: kTextSecondary)),
              Text('${session.volume} kg',
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isFirst ? kGreenDark : kTextPrimary)),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Volume Chart ─────────────────────────────────────────────────────────────

class _VolumeChart extends StatelessWidget {
  final List<HistorySession> sessions;
  const _VolumeChart({required this.sessions});

  @override
  Widget build(BuildContext context) {
    final volumes = sessions.map((s) => s.volume).toList().reversed.toList();
    final dates = sessions.map((s) => s.date).toList().reversed.toList();
    final maxVol = volumes.reduce(math.max);
    final minVol = volumes.reduce(math.min) * 0.9;

    return CustomPaint(
      size: const Size(double.infinity, 130),
      painter: _ChartPainter(
        volumes: volumes,
        dates: dates,
        maxVol: maxVol,
        minVol: minVol,
      ),
    );
  }
}

class _ChartPainter extends CustomPainter {
  final List<double> volumes;
  final List<String> dates;
  final double maxVol;
  final double minVol;

  const _ChartPainter({
    required this.volumes,
    required this.dates,
    required this.maxVol,
    required this.minVol,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const bottomPad = 24.0;
    final chartH = size.height - bottomPad;
    final n = volumes.length;
    final step = size.width / (n - 1);

    List<Offset> pts = List.generate(n, (i) {
      final x = i * step;
      final norm = (volumes[i] - minVol) / (maxVol - minVol);
      final y = chartH - norm * chartH * 0.85 - 8;
      return Offset(x, y);
    });

    // Gradient fill
    final path = Path()..moveTo(pts.first.dx, chartH);
    for (final p in pts) {
      path.lineTo(p.dx, p.dy);
    }
    path.lineTo(pts.last.dx, chartH);
    path.close();

    canvas.drawPath(
      path,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [kGreen.withOpacity(0.18), kGreen.withOpacity(0.0)],
        ).createShader(Rect.fromLTWH(0, 0, size.width, chartH)),
    );

    // Line
    final linePaint = Paint()
      ..color = kGreen
      ..strokeWidth = 2.2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final linePath = Path()..moveTo(pts.first.dx, pts.first.dy);
    for (int i = 1; i < pts.length; i++) {
      final cp1 = Offset((pts[i - 1].dx + pts[i].dx) / 2, pts[i - 1].dy);
      final cp2 = Offset((pts[i - 1].dx + pts[i].dx) / 2, pts[i].dy);
      linePath.cubicTo(cp1.dx, cp1.dy, cp2.dx, cp2.dy, pts[i].dx, pts[i].dy);
    }
    canvas.drawPath(linePath, linePaint);

    // Dots + labels
    for (int i = 0; i < pts.length; i++) {
      canvas.drawCircle(pts[i], 4.5, Paint()..color = kCard);
      canvas.drawCircle(pts[i], 4.5,
          Paint()..color = kGreen..style = PaintingStyle.stroke..strokeWidth = 2);

      // Volume label above last dot
      if (i == pts.length - 1) {
        final tp = TextPainter(
          text: TextSpan(
            text: '${volumes[i].toInt()} kg',
            style: const TextStyle(
                fontSize: 10, color: kGreen, fontWeight: FontWeight.w600),
          ),
          textDirection: TextDirection.ltr,
        )..layout();
        tp.paint(canvas, Offset(pts[i].dx - tp.width / 2, pts[i].dy - 18));
      }

      // Date label below
      final dp = TextPainter(
        text: TextSpan(
            text: dates[i],
            style: const TextStyle(fontSize: 10, color: kTextSecondary)),
        textDirection: TextDirection.ltr,
      )..layout();
      dp.paint(canvas,
          Offset(pts[i].dx - dp.width / 2, chartH + 6));
    }

    // Baseline
    canvas.drawLine(
      Offset(0, chartH),
      Offset(size.width, chartH),
      Paint()..color = kBorder..strokeWidth = 0.5,
    );
  }

  @override
  bool shouldRepaint(_ChartPainter old) =>
      old.volumes != volumes || old.maxVol != maxVol;
}