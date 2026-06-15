import 'package:flutter/material.dart';
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

class DataPoint {
  final String label;
  final double value;
  const DataPoint(this.label, this.value);
}

class Measurement {
  final String name;
  final double current;
  final double previous;
  final String unit;
  final IconData icon;
  final Color color;
  const Measurement({
    required this.name,
    required this.current,
    required this.previous,
    required this.unit,
    required this.icon,
    required this.color,
  });
  double get delta => current - previous;
  bool get improved => delta < 0; // for measurements smaller = better (waist)
}

class VolumeItem {
  final String name;
  final double value;
  final double max;
  final Color color;
  const VolumeItem(
      {required this.name,
        required this.value,
        required this.max,
        required this.color});
}


// ─── Progress Screen ──────────────────────────────────────────────────────────

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _anim = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1100),
  )..forward();

  int _selectedRange = 1; // 0=1M 1=3M 2=6M 3=1Y
  final _ranges = ['1M', '3M', '6M', '1Y'];

  // ── Data ──────────────────────────────────────────────────────────────────

  final _weightData = const [
    DataPoint('Jan', 80.2),
    DataPoint('Feb', 79.1),
    DataPoint('Mar', 77.8),
    DataPoint('Apr', 76.5),
    DataPoint('May', 75.2),
    DataPoint('Jun', 72.5),
  ];

  final _benchData = const [
    DataPoint('Jan', 60),
    DataPoint('Feb', 65),
    DataPoint('Mar', 67.5),
    DataPoint('Apr', 70),
    DataPoint('May', 72.5),
    DataPoint('Jun', 75),
  ];

  final _measurements = const [
    Measurement(
        name: 'Waist',
        current: 82,
        previous: 87,
        unit: 'cm',
        icon: Icons.straighten,
        color: kAmber),
    Measurement(
        name: 'Chest',
        current: 98,
        previous: 95,
        unit: 'cm',
        icon: Icons.expand_outlined,
        color: kGreen),
    Measurement(
        name: 'Arms',
        current: 36,
        previous: 34,
        unit: 'cm',
        icon: Icons.fitness_center,
        color: kBlue),
    Measurement(
        name: 'Thigh',
        current: 58,
        previous: 56,
        unit: 'cm',
        icon: Icons.accessibility_new_outlined,
        color: kPurple),
    Measurement(
        name: 'Neck',
        current: 38,
        previous: 37,
        unit: 'cm',
        icon: Icons.face_outlined,
        color: kRed),
  ];

  final _volumes = const [
    VolumeItem(name: 'Chest', value: 8400, max: 10000, color: kGreen),
    VolumeItem(name: 'Back', value: 6200, max: 10000, color: kBlue),
    VolumeItem(name: 'Legs', value: 7100, max: 10000, color: kPurple),
    VolumeItem(name: 'Shoulders', value: 4300, max: 10000, color: kAmber),
    VolumeItem(name: 'Arms', value: 3600, max: 10000, color: kRed),
  ];

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    return Scaffold(
      backgroundColor: kBg,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(child: _buildHeader(top)),
          SliverToBoxAdapter(child: _buildSummaryStrip()),
          SliverToBoxAdapter(child: _buildRangeSelector()),
          SliverToBoxAdapter(child: _buildSectionTitle('Weight', subtitle: '−7.7 kg total', subtitleColor: kGreen)),
          SliverToBoxAdapter(child: _buildWeightCard()),
          SliverToBoxAdapter(child: _buildSectionTitle('Bench Press', subtitle: '+15 kg PR', subtitleColor: kBlue)),
          SliverToBoxAdapter(child: _buildBenchCard()),
          SliverToBoxAdapter(child: _buildSectionTitle('Body Measurements', subtitle: 'Last 30 days')),
          SliverToBoxAdapter(child: _buildMeasurements()),
          SliverToBoxAdapter(child: _buildSectionTitle('Progress Photos')),
          SliverToBoxAdapter(child: _buildPhotos()),
          SliverToBoxAdapter(child: _buildSectionTitle('Weekly Volume', subtitle: 'This week')),
          SliverToBoxAdapter(child: _buildVolume()),
          const SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
      ),
    );
  }

  // ── Header ────────────────────────────────────────────────────────────────

  Widget _buildHeader(double top) {
    return Container(
      color: kCard,
      padding: EdgeInsets.only(
          top: top + 14, left: 16, right: 16, bottom: 14),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Jun 2026',
                    style: TextStyle(fontSize: 12, color: kTextSecondary)),
                Text('Progress',
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: kTextPrimary)),
              ],
            ),
          ),
          _iconBtn(Icons.share_outlined, () {}),
          const SizedBox(width: 8),
          _iconBtn(Icons.tune_rounded, () {}),
        ],
      ),
    );
  }

  Widget _iconBtn(IconData icon, VoidCallback onTap) => GestureDetector(
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

  // ── Summary strip ──────────────────────────────────────────────────────────

  Widget _buildSummaryStrip() {
    return Container(
      color: kCard,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
      child: Row(
        children: [
          _SummaryTile(
              label: 'Start weight', value: '80.2 kg', color: kTextSecondary),
          _vDiv(),
          _SummaryTile(label: 'Current', value: '72.5 kg', color: kGreen),
          _vDiv(),
          _SummaryTile(label: 'Goal', value: '70 kg', color: kAmber),
          _vDiv(),
          _SummaryTile(label: 'To go', value: '2.5 kg', color: kBlue),
        ],
      ),
    );
  }

  Widget _vDiv() => Container(
      width: 0.5, height: 30, color: kBorder, margin: const EdgeInsets.symmetric(horizontal: 4));

  // ── Range selector ─────────────────────────────────────────────────────────

  Widget _buildRangeSelector() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 2),
      child: Container(
        decoration: BoxDecoration(
          color: kCard,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: kBorder, width: 0.5),
        ),
        padding: const EdgeInsets.all(3),
        child: Row(
          children: List.generate(_ranges.length, (i) {
            final sel = i == _selectedRange;
            return Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _selectedRange = i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.symmetric(vertical: 7),
                  decoration: BoxDecoration(
                    color: sel ? kGreen : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _ranges[i],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: sel ? Colors.white : kTextSecondary,
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  // ── Section title ──────────────────────────────────────────────────────────

  Widget _buildSectionTitle(String title,
      {String? subtitle, Color? subtitleColor}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
      child: Row(
        children: [
          Text(title.toUpperCase(),
              style: const TextStyle(
                  fontSize: 12,
                  color: kTextSecondary,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.7)),
          if (subtitle != null) ...[
            const SizedBox(width: 8),
            Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: (subtitleColor ?? kTextSecondary).withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(subtitle,
                  style: TextStyle(
                      fontSize: 11,
                      color: subtitleColor ?? kTextSecondary,
                      fontWeight: FontWeight.w500)),
            ),
          ],
        ],
      ),
    );
  }

  // ── Weight card ────────────────────────────────────────────────────────────

  Widget _buildWeightCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: kCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: kBorder, width: 0.5),
        ),
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _StatBadge(label: 'Current', value: '72.5 kg', color: kGreen),
                const SizedBox(width: 8),
                _StatBadge(label: 'Change', value: '−7.7 kg', color: kGreen),
                const SizedBox(width: 8),
                _StatBadge(label: 'Avg/week', value: '−0.5 kg', color: kAmber),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 160,
              child: AnimatedBuilder(
                animation: _anim,
                builder: (_, __) => _LineChart(
                  data: _weightData,
                  color: kGreen,
                  progress: _anim.value,
                  minY: 70,
                  maxY: 82,
                  showDots: true,
                  fillGradient: true,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Bench card ─────────────────────────────────────────────────────────────

  Widget _buildBenchCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: kCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: kBorder, width: 0.5),
        ),
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _StatBadge(label: 'Current PR', value: '75 kg', color: kBlue),
                const SizedBox(width: 8),
                _StatBadge(label: 'Start', value: '60 kg', color: kTextSecondary),
                const SizedBox(width: 8),
                _StatBadge(label: 'Gain', value: '+15 kg', color: kGreen),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 160,
              child: AnimatedBuilder(
                animation: _anim,
                builder: (_, __) => _LineChart(
                  data: _benchData,
                  color: kBlue,
                  progress: _anim.value,
                  minY: 55,
                  maxY: 80,
                  showDots: true,
                  fillGradient: true,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Measurements ──────────────────────────────────────────────────────────

  Widget _buildMeasurements() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          // top row 3
          Row(
            children: _measurements
                .take(3)
                .map((m) => Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                    right: m == _measurements[2] ? 0 : 8),
                child: _MeasurementCard(m: m, anim: _anim),
              ),
            ))
                .toList(),
          ),
          const SizedBox(height: 8),
          // bottom row 2 centered
          Row(
            children: [
              Expanded(child: _MeasurementCard(m: _measurements[3], anim: _anim)),
              const SizedBox(width: 8),
              Expanded(child: _MeasurementCard(m: _measurements[4], anim: _anim)),
            ],
          ),
        ],
      ),
    );
  }

  // ── Progress photos ────────────────────────────────────────────────────────

  Widget _buildPhotos() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: kCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: kBorder, width: 0.5),
        ),
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(child: _PhotoSlot(label: 'Before', date: 'Jan 2026')),
                const SizedBox(width: 10),
                Expanded(child: _PhotoSlot(label: 'After', date: 'Jun 2026', isAfter: true)),
              ],
            ),
            const SizedBox(height: 12),
            _ChangeRow(label: 'Weight', before: '80.2 kg', after: '72.5 kg', positive: true),
            const Divider(height: 16, color: kBorder),
            _ChangeRow(label: 'Waist', before: '87 cm', after: '82 cm', positive: true),
            const Divider(height: 16, color: kBorder),
            _ChangeRow(label: 'Bench PR', before: '60 kg', after: '75 kg', positive: true),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add_a_photo_outlined, size: 16, color: kGreen),
                label: const Text('Add progress photo',
                    style: TextStyle(color: kGreen, fontSize: 13)),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: kGreen, width: 1),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Weekly volume ──────────────────────────────────────────────────────────

  Widget _buildVolume() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: kCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: kBorder, width: 0.5),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ..._volumes.map((v) => Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: _VolumeBar(item: v, anim: _anim),
            )),
            // Mini bar chart
            const SizedBox(height: 4),
            const Divider(height: 0.5, color: kBorder),
            const SizedBox(height: 14),
            SizedBox(
              height: 100,
              child: AnimatedBuilder(
                animation: _anim,
                builder: (_, __) => _BarChart(
                  items: _volumes,
                  progress: _anim.value,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Summary tile ─────────────────────────────────────────────────────────────

class _SummaryTile extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _SummaryTile(
      {required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) => Expanded(
    child: Column(
      children: [
        Text(label,
            style:
            const TextStyle(fontSize: 10, color: kTextSecondary)),
        const SizedBox(height: 3),
        Text(value,
            style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: color)),
      ],
    ),
  );
}

// ─── Stat badge ───────────────────────────────────────────────────────────────

class _StatBadge extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _StatBadge(
      {required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 10, color: kTextSecondary)),
        Text(value,
            style: TextStyle(
                fontSize: 14, fontWeight: FontWeight.w700, color: color)),
      ],
    );
  }
}

// ─── Measurement Card ─────────────────────────────────────────────────────────

class _MeasurementCard extends StatelessWidget {
  final Measurement m;
  final Animation<double> anim;
  const _MeasurementCard({required this.m, required this.anim});

  @override
  Widget build(BuildContext context) {
    final positive = m.delta > 0;
    final isGood = m.name == 'Waist' ? !positive : positive;
    final deltaColor = isGood ? kGreen : kRed;
    final prefix = m.delta > 0 ? '+' : '';

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: kCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kBorder, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: m.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(m.icon, size: 14, color: m.color),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: deltaColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '$prefix${m.delta.toStringAsFixed(1)}',
                  style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: deltaColor),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(m.name,
              style:
              const TextStyle(fontSize: 11, color: kTextSecondary)),
          Text('${m.current} ${m.unit}',
              style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: kTextPrimary)),
          const SizedBox(height: 6),
          AnimatedBuilder(
            animation: anim,
            builder: (_, __) => ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: LinearProgressIndicator(
                value: (m.current / (m.current + m.delta.abs() + 10))
                    .clamp(0.0, 1.0) *
                    anim.value,
                minHeight: 3,
                backgroundColor: const Color(0xFFF0EEE8),
                valueColor: AlwaysStoppedAnimation<Color>(m.color),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Photo slot ───────────────────────────────────────────────────────────────

class _PhotoSlot extends StatelessWidget {
  final String label;
  final String date;
  final bool isAfter;
  const _PhotoSlot(
      {required this.label, required this.date, this.isAfter = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 160,
          decoration: BoxDecoration(
            color: isAfter ? kGreenLight : const Color(0xFFF0EEE8),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isAfter ? kGreen.withOpacity(0.3) : kBorder,
              width: 0.5,
            ),
          ),
          child: isAfter
              ? Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: kGreen.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.person_outline,
                      color: kGreen, size: 28),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: kGreen,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text('Current',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          )
              : Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: kTextSecondary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.person_outline,
                      color: kTextSecondary, size: 28),
                ),
                const SizedBox(height: 8),
                const Text('Start',
                    style: TextStyle(
                        fontSize: 11, color: kTextSecondary)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(label,
            style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: kTextPrimary)),
        Text(date,
            style:
            const TextStyle(fontSize: 11, color: kTextSecondary)),
      ],
    );
  }
}

class _ChangeRow extends StatelessWidget {
  final String label;
  final String before;
  final String after;
  final bool positive;
  const _ChangeRow(
      {required this.label,
        required this.before,
        required this.after,
        required this.positive});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
            width: 70,
            child: Text(label,
                style: const TextStyle(
                    fontSize: 12, color: kTextSecondary))),
        Text(before,
            style: const TextStyle(
                fontSize: 13,
                color: kTextSecondary,
                decoration: TextDecoration.lineThrough)),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child:
          Icon(Icons.arrow_forward, size: 12, color: kTextSecondary),
        ),
        Text(after,
            style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: positive ? kGreen : kRed)),
      ],
    );
  }
}

// ─── Volume bar ───────────────────────────────────────────────────────────────

class _VolumeBar extends StatelessWidget {
  final VolumeItem item;
  final Animation<double> anim;
  const _VolumeBar({required this.item, required this.anim});

  @override
  Widget build(BuildContext context) {
    final pct = (item.value / item.max).clamp(0.0, 1.0);
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
                  decoration:
                  BoxDecoration(color: item.color, shape: BoxShape.circle),
                ),
                const SizedBox(width: 7),
                Text(item.name,
                    style: const TextStyle(
                        fontSize: 13, color: kTextPrimary, fontWeight: FontWeight.w500)),
              ],
            ),
            Text('${(item.value / 1000).toStringAsFixed(1)}k kg',
                style: const TextStyle(fontSize: 12, color: kTextSecondary)),
          ],
        ),
        const SizedBox(height: 6),
        AnimatedBuilder(
          animation: anim,
          builder: (_, __) => ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: pct * anim.value,
              minHeight: 8,
              backgroundColor: const Color(0xFFF0EEE8),
              valueColor: AlwaysStoppedAnimation<Color>(item.color),
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Bar Chart ────────────────────────────────────────────────────────────────

class _BarChart extends StatelessWidget {
  final List<VolumeItem> items;
  final double progress;
  const _BarChart({required this.items, required this.progress});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.infinite,
      painter: _BarChartPainter(items: items, progress: progress),
    );
  }
}

class _BarChartPainter extends CustomPainter {
  final List<VolumeItem> items;
  final double progress;
  const _BarChartPainter({required this.items, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final maxVal = items.map((e) => e.value).reduce(math.max);
    final n = items.length;
    const labelH = 18.0;
    final chartH = size.height - labelH;
    const barW = 32.0;
    final spacing = (size.width - barW * n) / (n + 1);

    for (int i = 0; i < n; i++) {
      final x = spacing + i * (barW + spacing);
      final pct = (items[i].value / maxVal).clamp(0.0, 1.0);
      final barH = chartH * 0.85 * pct * progress;
      final top = chartH - barH;

      // bar
      final rrect = RRect.fromRectAndCorners(
        Rect.fromLTWH(x, top, barW, barH),
        topLeft: const Radius.circular(5),
        topRight: const Radius.circular(5),
      );
      canvas.drawRRect(
          rrect, Paint()..color = items[i].color.withOpacity(0.85));

      // label
      final tp = TextPainter(
        text: TextSpan(
          text: items[i].name,
          style: const TextStyle(fontSize: 10, color: kTextSecondary),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas,
          Offset(x + barW / 2 - tp.width / 2, chartH + 4));
    }

    // baseline
    canvas.drawLine(
      Offset(0, chartH),
      Offset(size.width, chartH),
      Paint()..color = kBorder..strokeWidth = 0.5,
    );
  }

  @override
  bool shouldRepaint(_BarChartPainter old) => old.progress != progress;
}

// ─── Line Chart ───────────────────────────────────────────────────────────────

class _LineChart extends StatelessWidget {
  final List<DataPoint> data;
  final Color color;
  final double progress;
  final double minY;
  final double maxY;
  final bool showDots;
  final bool fillGradient;

  const _LineChart({
    required this.data,
    required this.color,
    required this.progress,
    required this.minY,
    required this.maxY,
    this.showDots = false,
    this.fillGradient = false,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.infinite,
      painter: _LineChartPainter(
        data: data,
        color: color,
        progress: progress,
        minY: minY,
        maxY: maxY,
        showDots: showDots,
        fillGradient: fillGradient,
      ),
    );
  }
}

class _LineChartPainter extends CustomPainter {
  final List<DataPoint> data;
  final Color color;
  final double progress;
  final double minY;
  final double maxY;
  final bool showDots;
  final bool fillGradient;

  const _LineChartPainter({
    required this.data,
    required this.color,
    required this.progress,
    required this.minY,
    required this.maxY,
    required this.showDots,
    required this.fillGradient,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const bottomPad = 22.0;
    const leftPad = 38.0;
    const rightPad = 10.0;
    const topPad = 20.0;
    final w = size.width - leftPad - rightPad;
    final h = size.height - bottomPad - topPad;
    final n = data.length;

    // Y-axis gridlines & labels
    const gridLines = 4;
    final gridPaint = Paint()
      ..color = kBorder.withOpacity(0.6)
      ..strokeWidth = 0.5;

    for (int i = 0; i <= gridLines; i++) {
      final yFrac = i / gridLines;
      final y = topPad + h * yFrac;
      canvas.drawLine(
          Offset(leftPad, y), Offset(leftPad + w, y), gridPaint);
      final val = maxY - (maxY - minY) * yFrac;
      final tp = TextPainter(
        text: TextSpan(
          text: val.toStringAsFixed(0),
          style: const TextStyle(fontSize: 9, color: kTextSecondary),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(0, y - 5));
    }

    // Compute points up to progress
    final visibleCount = math.max(2, (n * progress).ceil().clamp(2, n));
    List<Offset> pts = [];
    for (int i = 0; i < visibleCount; i++) {
      final x = leftPad + (w / (n - 1)) * i;
      final norm = (data[i].value - minY) / (maxY - minY);
      final y = topPad + h * (1 - norm);
      pts.add(Offset(x, y));
    }

    // Interpolate the last partial segment
    if (progress < 1.0 && pts.length >= 2) {
      final segProgress = (n * progress) - (visibleCount - 1);
      final last = pts.last;
      final i = visibleCount - 1;
      if (i < n - 1) {
        final nextX = leftPad + (w / (n - 1)) * i;
        final nextNorm = (data[i].value - minY) / (maxY - minY);
        final nextY = topPad + h * (1 - nextNorm);
        pts[pts.length - 1] = Offset(
          last.dx + (nextX - last.dx) * segProgress,
          last.dy + (nextY - last.dy) * segProgress,
        );
      }
    }

    // Gradient fill
    if (fillGradient && pts.length >= 2) {
      final fillPath = Path()..moveTo(pts.first.dx, topPad + h);
      for (int i = 0; i < pts.length; i++) {
        if (i == 0) {
          fillPath.lineTo(pts[0].dx, pts[0].dy);
        } else {
          final cp1 = Offset(
              (pts[i - 1].dx + pts[i].dx) / 2, pts[i - 1].dy);
          final cp2 =
          Offset((pts[i - 1].dx + pts[i].dx) / 2, pts[i].dy);
          fillPath.cubicTo(
              cp1.dx, cp1.dy, cp2.dx, cp2.dy, pts[i].dx, pts[i].dy);
        }
      }
      fillPath.lineTo(pts.last.dx, topPad + h);
      fillPath.close();
      canvas.drawPath(
        fillPath,
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              color.withOpacity(0.18),
              color.withOpacity(0.0),
            ],
          ).createShader(Rect.fromLTWH(0, topPad, size.width, h)),
      );
    }

    // Line
    if (pts.length >= 2) {
      final linePath = Path()..moveTo(pts[0].dx, pts[0].dy);
      for (int i = 1; i < pts.length; i++) {
        final cp1 =
        Offset((pts[i - 1].dx + pts[i].dx) / 2, pts[i - 1].dy);
        final cp2 =
        Offset((pts[i - 1].dx + pts[i].dx) / 2, pts[i].dy);
        linePath.cubicTo(
            cp1.dx, cp1.dy, cp2.dx, cp2.dy, pts[i].dx, pts[i].dy);
      }
      canvas.drawPath(
        linePath,
        Paint()
          ..color = color
          ..strokeWidth = 2.2
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round,
      );
    }

    // Dots & x-labels
    for (int i = 0; i < pts.length; i++) {
      if (showDots) {
        canvas.drawCircle(pts[i], 4, Paint()..color = kCard);
        canvas.drawCircle(
            pts[i],
            4,
            Paint()
              ..color = color
              ..style = PaintingStyle.stroke
              ..strokeWidth = 2);
      }

      // Value label on last visible dot
      if (i == pts.length - 1) {
        final tp = TextPainter(
          text: TextSpan(
            text: data[i].value.toStringAsFixed(1),
            style: TextStyle(
                fontSize: 10,
                color: color,
                fontWeight: FontWeight.w700),
          ),
          textDirection: TextDirection.ltr,
        )..layout();
        tp.paint(canvas,
            Offset(pts[i].dx - tp.width / 2, pts[i].dy - 18));
      }
    }

    // X-axis labels (all)
    for (int i = 0; i < n; i++) {
      final x = leftPad + (w / (n - 1)) * i;
      final tp = TextPainter(
        text: TextSpan(
          text: data[i].label,
          style: const TextStyle(fontSize: 10, color: kTextSecondary),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas,
          Offset(x - tp.width / 2, topPad + h + 6));
    }
  }

  @override
  bool shouldRepaint(_LineChartPainter old) =>
      old.progress != progress || old.data != data;
}