import 'package:daily_weight_logs_mobile/common/constants/colors.dart';
import 'package:daily_weight_logs_mobile/common/constants/images.dart';
import 'package:daily_weight_logs_mobile/common/widgets/weight_log_text.dart';
import 'package:daily_weight_logs_mobile/features/weight_logs/domain/model/time_range_option.dart';
import 'package:daily_weight_logs_mobile/router/authenticated_routes.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WeightLogScreen extends ConsumerWidget {
  const WeightLogScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final weightLogState = ref.watch(weightLogControllerProvider);
    const double value = 0.0;

    return Scaffold(
      backgroundColor: secondaryColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Section: Profile Picture and Dropdown
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 20,
                      child: Image.asset(
                        weightLogoPng,
                        width: 30,
                        height: 30,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 1,
                      ),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                        border: Border(
                          bottom: BorderSide(color: grayTextColor),
                          right: BorderSide(color: grayTextColor),
                        ),
                      ),
                      child: DropdownButtonHideUnderline(
                        key: const Key('weightLogDropdown'),
                        child: DropdownButton<TimeRangeOption>(
                          value: timeRangeOptions[0],
                          key: const Key('weightLogDropdownButton'),
                          items: timeRangeOptions
                              .map(
                                (TimeRangeOption timeRangeOption) =>
                                    DropdownMenuItem<TimeRangeOption>(
                                  value: timeRangeOption,
                                  child: WeightLogText(
                                    text: timeRangeOption.label,
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (TimeRangeOption? timeRangeOption) {
                            // ref.read(weightLogControllerProvider.notifier).fetchWeightLogs(timeRangeOption!.value);

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: WeightLogText(
                                  text:
                                      'Fetching weight logs for ${timeRangeOption!.label}',
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                                backgroundColor: secondaryColor,
                              ),
                            );
                          },
                          dropdownColor: secondaryColor,
                          style: const TextStyle(color: Colors.white),
                          icon: const Icon(
                            Icons.arrow_drop_down,
                            color: Colors.white,
                          ),
                          iconSize: 24,
                          elevation: 16,
                          isExpanded: false,
                          underline: Container(
                            height: 1,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Graph Section
                Container(
                  height: 200,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: grayTextColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: LineChart(
                    curve: Curves.easeInOut,
                    LineChartData(
                      minX: value,
                      maxX: 5,
                      baselineX: 0,
                      baselineY: 50,
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: true,
                        drawHorizontalLine: true,
                        horizontalInterval: 5,
                        verticalInterval: 1,
                        getDrawingVerticalLine: (value) {
                          return FlLine(
                            color: grayTextColor.withOpacity(0.5),
                            strokeWidth: 1,
                          );
                        },
                        getDrawingHorizontalLine: (value) {
                          return FlLine(
                            color: grayTextColor.withOpacity(0.5),
                            strokeWidth: 1,
                          );
                        },
                        checkToShowVerticalLine: (value) {
                          return value % 1 == 0;
                        },
                        checkToShowHorizontalLine: (value) {
                          return value % 5 == 0;
                        },
                      ), // Disable grid lines
                      titlesData: FlTitlesData(
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: false, // Hide right Y-axis labels
                          ),
                        ),
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: false, // Hide top X-axis labels
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true, // Hide left Y-axis labels
                            getTitlesWidget: (value, meta) {
                              return WeightLogText(
                                text: '${value.toStringAsFixed(0)} kg',
                                fontSize: 10,
                                color: grayTextColor,
                              );
                            },
                            reservedSize: 40,
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          axisNameSize: 0,
                          axisNameWidget: const SizedBox.shrink(),
                          sideTitles: SideTitles(
                            showTitles: true, // bottom axis labels
                            interval: 1,
                            getTitlesWidget: (value, meta) {
                              // Show x-axis labels for months
                              switch (value.toInt()) {
                                case 0:
                                  return const WeightLogText(
                                    text: 'Jul',
                                    fontSize: 12,
                                    color: grayTextColor,
                                  );
                                case 1:
                                  return const WeightLogText(
                                    text: 'Aug',
                                    fontSize: 12,
                                    color: grayTextColor,
                                  );
                                case 2:
                                  return const WeightLogText(
                                    text: 'Sept',
                                    fontSize: 12,
                                    color: grayTextColor,
                                  );
                                case 3:
                                  return const WeightLogText(
                                    text: 'Oct',
                                    fontSize: 12,
                                    color: grayTextColor,
                                  );
                                case 4:
                                  return const WeightLogText(
                                    text: 'Nov',
                                    fontSize: 12,
                                    color: grayTextColor,
                                  );
                                case 5:
                                  return const WeightLogText(
                                    text: 'Dec',
                                    fontSize: 12,
                                    color: grayTextColor,
                                  );
                              }
                              return const SizedBox.shrink();
                            },
                          ),
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      lineBarsData: [
                        LineChartBarData(
                          spots: const [
                            FlSpot(0, 68.2), // Jul
                            FlSpot(1, 62.5), // Aug
                            FlSpot(2, 54.0), // Sept
                            FlSpot(3, 60.0), // Oct
                            FlSpot(4, 62.5), // Nov
                            FlSpot(5, 63.0), // Dec
                          ],
                          isCurved: true, // Smooth curve
                          color: primaryColor,
                          barWidth: 3,
                          isStrokeCapRound: true,
                          dotData: FlDotData(
                            show: true,
                            getDotPainter: (spot, percent, barData, index) {
                              if (index == 5) {
                                return FlDotCirclePainter(
                                  radius: 6,
                                  color: primaryColor,
                                  strokeWidth: 2,
                                  strokeColor: Colors.white,
                                ); // Highlight the last point (Dec)
                              }
                              return FlDotCirclePainter(
                                radius: 5,
                                color: primaryColor,
                                strokeWidth: 0,
                              );
                            },
                          ),
                          belowBarData: BarAreaData(
                            show: true,
                            gradient: LinearGradient(
                              colors: [
                                primaryColor.withOpacity(0.2),
                                Colors.transparent
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              stops: const [0.5, 1],
                            ),
                          ),
                        ),
                      ],
                      minY: 50,
                      maxY: 70,
                      lineTouchData: LineTouchData(
                        touchTooltipData: LineTouchTooltipData(
                          getTooltipColor: (spot) => secondaryColor,
                          getTooltipItems: (List<LineBarSpot> touchedSpots) {
                            return touchedSpots.map((spot) {
                              return LineTooltipItem(
                                '${spot.y.toStringAsFixed(1)} kg',
                                const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            }).toList();
                          },
                        ),
                        touchCallback:
                            (FlTouchEvent event, LineTouchResponse? response) {
                          // Handle touch events if needed
                        },
                        handleBuiltInTouches: true,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // Weight Overview Section
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    WeightLogText(
                      text: '72.4 kg\n17 Apr 2018',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: grayTextColor,
                    ),
                    WeightLogText(
                      text: '62.5 kg',
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    WeightLogText(
                      text: '52.0 kg\n8 Mar 2019',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: grayTextColor,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Progress Bar Section
                Container(
                  width: double.infinity,
                  height: 3,
                  decoration: BoxDecoration(
                    color: grayTextColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: const LinearProgressIndicator(
                      value: 0.2, // 20% progress
                      backgroundColor: grayTextColor,
                      valueColor: AlwaysStoppedAnimation(primaryColor),
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // BMI Calculator Section
                Container(
                  width: double.infinity,
                  height: MediaQuery.sizeOf(context).height * 0.12,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: grayTextColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          WeightLogText(
                            text: 'BMI',
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: grayTextColor.withOpacity(0.5),
                          ),
                          const WeightLogText(
                            text: 'You\'re Healthy',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: primaryColor,
                          ),
                          Icon(
                            Icons.more_horiz,
                            color: grayTextColor.withOpacity(0.5),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      // Color-Coded Range Bar

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: List.generate(40, (index) {
                          // Define color ranges for BMI
                          Color color;
                          if (index < 10) {
                            color = Colors.blue; // Underweight
                          } else if (index < 18) {
                            color = Colors.green; // Healthy
                          } else if (index < 25) {
                            color = Colors.yellow; // Overweight
                          } else {
                            color = Colors.red; // Obese
                          }

                          // Check if the current bar represents the selected BMI
                          bool isSelected = index == (value - 15).round();

                          return Column(
                            children: [
                              Container(
                                width: 6,
                                height: isSelected
                                    ? 30
                                    : 20, // Highlight selected value
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 1),
                                decoration: BoxDecoration(
                                  color: color,
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ),
                              if (index == 0 ||
                                  index == 10 ||
                                  index == 18 ||
                                  index == 25 ||
                                  index == 40)
                                Padding(
                                  padding: const EdgeInsets.only(top: 5),
                                  child: Text(
                                    _getBmiLabel(index),
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                            ],
                          );
                        }),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                // History Section
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    WeightLogText(
                      text: 'History',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: grayTextColor,
                    ),
                    WeightLogText(
                      text: 'See All',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: primaryColor,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(
                          index == 0 ? 'Today: +0.5 kg' : 'Yesterday: -0.8 kg',
                          style: TextStyle(
                            color: index == 0 ? Colors.red : Colors.green,
                          ),
                        ),
                        trailing: const Text(
                          '62.5 kg',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'addWeightLog',
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        tooltip: 'Add Weight Log',
        key: const Key('addWeightLogButton'),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        onPressed: () async {
          Navigator.pushNamed(context, MainRoutes.addWeightLogRoute);
        },
        child: const Icon(Icons.add, color: secondaryColor, size: 30),
      ),
    );
  }

  // Helper function to get BMI labels
  String _getBmiLabel(int index) {
    if (index == 0) return '15'; // Minimum BMI
    if (index == 10) return '18.5'; // Start of healthy range
    if (index == 18) return '25'; // Start of overweight range
    if (index == 25) return '30'; // Start of obese range
    if (index == 40) return '40'; // Maximum BMI
    return '';
  }
}
