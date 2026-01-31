import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'package:lms/core/utils/app_colors.dart';

class ProfileChart extends StatefulWidget {
  final List<int>? data;
  const ProfileChart({super.key, this.data});

  @override
  State<ProfileChart> createState() => _ProfileChartState();
}

class _ProfileChartState extends State<ProfileChart> {
  final Duration animDuration = const Duration(milliseconds: 250);

  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            getTooltipColor: (_) => Colors.black,
            tooltipHorizontalAlignment: FLHorizontalAlignment.right,
            tooltipMargin: -10,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              String weekDay = switch (group.x) {
                0 => '${((60 + 80) / 2).toStringAsFixed(0)}%',
                1 => '60%',
                2 => '60%',
                3 => '80%',
                4 => '60%',
                5 => '${((60 + 80) / 2).toStringAsFixed(0)}%',
                6 => '${((80 + 100) / 2).toStringAsFixed(0)}%',
                _ => '',
              };
              return BarTooltipItem(
                '$weekDay\n',
                const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              );
            },
          ),
          touchCallback: (FlTouchEvent event, barTouchResponse) {
            setState(() {
              if (!event.isInterestedForInteractions ||
                  barTouchResponse == null ||
                  barTouchResponse.spot == null) {
                touchedIndex = -1;
                return;
              }
              touchedIndex = barTouchResponse.spot!.touchedBarGroupIndex;
            });
          },
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: bottomTitles,
              reservedSize: 20,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: leftTitles,
              reservedSize: 24,
              interval: 1,
            ),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: const Border(
            left: BorderSide(width: 1, color: AppColors.cD9D9D9),
            bottom: BorderSide(width: 1, color: AppColors.cD9D9D9),
          ),
        ),
        barGroups: showingGroups(),
        gridData: const FlGridData(show: false),
        maxY: 5.0,
      ),
      duration: animDuration,
    );
  }

  BarChartGroupData makeGroupData(
    int x,
    double y, {
    bool isTouched = false,
    double width = 20,
    List<int> showTooltips = const [],
  }) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: isTouched ? y + 0.1 : y,
          width: width,
          color: AppColors.primary,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(3),
            topRight: Radius.circular(3),
          ),
          borderSide: BorderSide.none,
          backDrawRodData: BackgroundBarChartRodData(show: false),
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }

  List<BarChartGroupData> showingGroups() {
    final data = widget.data ?? [0, 0, 0, 0, 0, 0, 0];
    return List.generate(
      7,
      (i) {
        final val = (data.length > i ? data[i] : 0).toDouble();
        // Scale it so that 100 becomes 5.0 (since maxY is 5.0 and each unit is 20)
        return makeGroupData(i, val / 20.0, isTouched: i == touchedIndex);
      },
    );
  }

  Widget bottomTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 8,
      color: Colors.black,
    );
    String text = switch (value.toInt()) {
      0 => 'S',
      1 => 'S',
      2 => 'M',
      3 => 'T',
      4 => 'W',
      5 => 'T',
      _ => 'F',
    };
    return SideTitleWidget(
      meta: meta,
      space: 4,
      child: Text(text, style: style),
    );
  }

  Widget leftTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 8,
      color: Colors.black,
    );

    String text = switch (value.toInt()) {
      1 => '20',
      2 => '40',
      3 => '60',
      4 => '80',
      5 => '100',
      _ => '',
    };

    return SideTitleWidget(
      meta: meta,
      space: 8,
      child: Text(text, style: style),
    );
  }
}
