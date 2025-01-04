import 'package:daily_weight_logs_mobile/common/constants/colors.dart';
import 'package:daily_weight_logs_mobile/common/constants/images.dart';
import 'package:daily_weight_logs_mobile/common/widgets/weight_log_text.dart';
import 'package:daily_weight_logs_mobile/features/height_logs/application/controllers/height_log_controller.dart';
import 'package:daily_weight_logs_mobile/features/height_logs/domain/models/height_log_model.dart';
import 'package:daily_weight_logs_mobile/features/weight_logs/application/weight_log_controller.dart';
import 'package:daily_weight_logs_mobile/features/weight_logs/domain/model/time_range_option.dart';
import 'package:daily_weight_logs_mobile/router/authenticated_routes.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class WeightLogScreen extends ConsumerStatefulWidget {
  const WeightLogScreen({super.key});

  @override
  ConsumerState<WeightLogScreen> createState() => _WeightLogScreenState();
}

class _WeightLogScreenState extends ConsumerState<WeightLogScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch height logs on initialization
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(heightLogControllerProvider.notifier).fetchUserHealthData();
      ref.read(weightLogControllerProvider.notifier).fetchWeightLogs();
    });
  }

  @override
  Widget build(BuildContext context) {
    final weightLogState = ref.watch(weightLogControllerProvider);
    final heightLogState = ref.watch(heightLogControllerProvider);
    double? userHeight;

    heightLogState.when(
      data: (HeightLog? heightLog) {
        // Directly access the height property from the HeightLog object
        userHeight = heightLog?.height != null
            ? double.tryParse(heightLog!.height!
                .replaceAll(' m', '')) // Remove the unit of measurement
            : null;
      },
      loading: () => debugPrint('Loading height logs...'),
      error: (error, stack) => debugPrint('Error loading height logs: $error'),
    );

    debugPrint('User Height from UI: $userHeight and: $heightLogState');

    final dynamicBmi = (weightLogState is AsyncData &&
            (weightLogState.value?.isNotEmpty ?? false))
        ? _calculateBmi(
            weightLogState.value?.first.weight ?? 0, userHeight ?? 0)
        : null;

    const double value = 0.0;

    debugPrint('Weight Log State: ${weightLogState.asData}');
    debugPrint('Height Log State: ${heightLogState.asData}');

    weightLogState.when(
      data: (weightLogs) {
        for (final weightLog in weightLogs) {
          debugPrint('Weight Log: ${weightLog.loggedAt}');
        }
      },
      loading: () => debugPrint('Loading weight logs...'),
      error: (error, stack) => debugPrint('Error loading weight logs: $error'),
    );

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
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, MainRoutes.profileRoute);
                      },
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 20,
                        child: Image.asset(
                          weightLogoPng,
                          width: 30,
                          height: 30,
                        ),
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
                  child: weightLogState.when(
                    data: (weightLogs) {
                      // Prepare data for the graph
                      List<FlSpot> graphSpots = [];
                      List<String> logLabels = [];

                      for (int i = 0; i < weightLogs.length; i++) {
                        final log = weightLogs[i];
                        logLabels.add(
                            'Log ${i + 1}'); // Add labels like "Log 1", "Log 2", etc.

                        graphSpots.add(
                          FlSpot(
                            i.toDouble(), // X-axis based on log order
                            log.weight!.toDouble(), // Y-axis based on weight
                          ),
                        );
                      }

                      return LineChart(
                        LineChartData(
                          minX: 0, // Start of x-axis
                          maxX: weightLogs.length - 1, // End of x-axis
                          minY: 50, // Minimum y-axis value
                          maxY: 300, // Maximum y-axis value
                          gridData: FlGridData(
                            show: true,
                            drawVerticalLine: true,
                            drawHorizontalLine: true,
                            horizontalInterval: 50,
                            verticalInterval: 1,
                            getDrawingHorizontalLine: (value) {
                              return FlLine(
                                color: grayTextColor.withOpacity(0.5),
                                strokeWidth: 1,
                              );
                            },
                            getDrawingVerticalLine: (value) {
                              return FlLine(
                                color: grayTextColor.withOpacity(0.5),
                                strokeWidth: 1,
                              );
                            },
                          ),
                          titlesData: FlTitlesData(
                            rightTitles: const AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: false,
                              ),
                            ),
                            topTitles: const AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: false,
                              ),
                            ),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 40,
                                interval: 50,
                                getTitlesWidget: (value, meta) {
                                  return WeightLogText(
                                    text: '${value.toInt()} kg',
                                    fontSize: 10,
                                    color: grayTextColor,
                                  );
                                },
                              ),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                interval: 1,
                                getTitlesWidget: (value, meta) {
                                  final index = value.toInt();
                                  if (index >= 0 && index < logLabels.length) {
                                    return WeightLogText(
                                      text: logLabels[index],
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
                              spots: graphSpots,
                              isCurved: true,
                              color: primaryColor,
                              barWidth: 3,
                              isStrokeCapRound: true,
                              dotData: FlDotData(
                                show: true,
                                getDotPainter: (spot, percent, barData, index) {
                                  if (index == graphSpots.length - 1) {
                                    return FlDotCirclePainter(
                                      radius: 6,
                                      color: primaryColor,
                                      strokeWidth: 2,
                                      strokeColor: Colors.white,
                                    ); // Highlight the last point
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
                                    Colors.transparent,
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                              ),
                            ),
                          ],
                          lineTouchData: LineTouchData(
                            touchTooltipData: LineTouchTooltipData(
                              getTooltipColor: (spot) => secondaryColor,
                              getTooltipItems:
                                  (List<LineBarSpot> touchedSpots) {
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
                            touchCallback: (FlTouchEvent event,
                                LineTouchResponse? response) {
                              // Handle touch events if needed
                            },
                            handleBuiltInTouches: true,
                          ),
                        ),
                      );
                    },
                    loading: () => const Center(
                      child: CircularProgressIndicator(color: primaryColor),
                    ),
                    error: (error, _) => Center(
                      child: WeightLogText(
                        text: 'Error: $error',
                        fontSize: 14,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // Weight Overview Section
                weightLogState.when(
                  data: (weightLogs) {
                    if (weightLogs.isEmpty) {
                      return const Center(
                        child: WeightLogText(
                          text: 'No data available',
                          fontSize: 14,
                          color: grayTextColor,
                        ),
                      );
                    }

                    // Get the most recent, highest, and lowest weight logs
                    final latestLog =
                        weightLogs.first; // Most recent weight log
                    final highestLog = weightLogs.reduce((a, b) =>
                        a.weight! > b.weight! ? a : b); // Highest weight
                    final lowestLog = weightLogs.reduce((a, b) =>
                        a.weight! < b.weight! ? a : b); // Lowest weight

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Display lowest weight
                            WeightLogText(
                              text:
                                  '${lowestLog.weight!.toStringAsFixed(1)} kg\n${_formatDate(lowestLog.loggedAt)}',
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: grayTextColor,
                            ),
                            // Display latest weight
                            WeightLogText(
                              text:
                                  '${latestLog.weight!.toStringAsFixed(1)} kg',
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            // Display highest weight
                            WeightLogText(
                              text:
                                  '${highestLog.weight!.toStringAsFixed(1)} kg\n${_formatDate(highestLog.loggedAt)}',
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
                            child: LinearProgressIndicator(
                              value: _calculateProgress(lowestLog.weight!,
                                  highestLog.weight!, latestLog.weight!),
                              backgroundColor: grayTextColor,
                              valueColor:
                                  const AlwaysStoppedAnimation(primaryColor),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                      ],
                    );
                  },
                  loading: () => const Center(
                    child: CircularProgressIndicator(color: primaryColor),
                  ),
                  error: (error, _) => Center(
                    child: WeightLogText(
                      text: 'Error: $error',
                      fontSize: 14,
                      color: Colors.red,
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
                          WeightLogText(
                            text: _getBmiStatus(
                                dynamicBmi), // Use the dynamic BMI value
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: _getBmiStatusColor(
                                dynamicBmi), // Dynamically set color
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
                        children: List.generate(25, (index) {
                          // Define color ranges for BMI
                          final color = _getColorForBmiIndex(index);

                          // Check if the current bar represents the user's BMI
                          final isSelected = dynamicBmi != null &&
                              index == (dynamicBmi - 15).round();

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

                // Weight Log History
                // Weight Log History
                SizedBox(
                  height: MediaQuery.sizeOf(context).height *
                      0.4, // Adjust height as needed
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: grayTextColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: weightLogState.when(
                      data: (weightLogs) {
                        final lastFiveLogs = weightLogs.length > 5
                            ? weightLogs.sublist(
                                weightLogs.length - 5) // Get the last 5 items
                            : weightLogs; // If less than 5 items, display all

                        return ListView.builder(
                          physics:
                              const AlwaysScrollableScrollPhysics(), // Enable scrolling
                          itemCount: lastFiveLogs.length,
                          itemBuilder: (context, index) {
                            final weightLog = lastFiveLogs[index];
                            final previousWeight = index <
                                    lastFiveLogs.length - 1
                                ? lastFiveLogs[index + 1].weight
                                : weightLog
                                    .weight; // Default to current weight for the first log
                            final weightDifference =
                                (weightLog.weight ?? 0) - (previousWeight ?? 0);
                            final isPositiveChange = weightDifference > 0;

                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: secondaryColor,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        WeightLogText(
                                          text: index == 0
                                              ? 'Today'
                                              : index == 1
                                                  ? 'Yesterday'
                                                  : weightLog.loggedAt ??
                                                      'Unknown date',
                                          fontSize: 14,
                                          color: grayTextColor,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        const SizedBox(height: 4),
                                        WeightLogText(
                                          text:
                                              '${isPositiveChange ? '+' : ''}${weightDifference.toStringAsFixed(1)} kg',
                                          fontSize: 14,
                                          color: isPositiveChange
                                              ? Colors.red
                                              : Colors.green,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ],
                                    ),
                                    WeightLogText(
                                      text:
                                          '${weightLog.weight?.toStringAsFixed(1)} kg',
                                      fontSize: 20,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                      loading: () => const Center(
                        child: CircularProgressIndicator(color: primaryColor),
                      ),
                      error: (error, _) => Center(
                        child: WeightLogText(
                          text: 'Error: $error',
                          fontSize: 14,
                          color: Colors.red,
                        ),
                      ),
                    ),
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

  Color _getColorForBmiIndex(int index) {
    if (index < 10) {
      return Colors.blue; // Underweight
    } else if (index < 18) {
      return Colors.green; // Healthy
    } else if (index < 25) {
      return Colors.yellow; // Overweight
    } else {
      return Colors.red; // Obese
    }
  }

  String _getBmiStatus(double? bmi) {
    if (bmi == null) return 'No Data';
    if (bmi < 18.5) return 'Underweight';
    if (bmi < 25) return 'Healthy';
    if (bmi < 30) return 'Overweight';
    return 'Obese';
  }

  Color _getBmiStatusColor(double? bmi) {
    if (bmi == null) return grayTextColor;
    if (bmi < 18.5) return Colors.blue;
    if (bmi < 25) return Colors.green;
    if (bmi < 30) return Colors.yellow;
    return Colors.red;
  }

  double? _calculateBmi(int weight, double height) {
    if (height == 0) return null;
    return weight / (height * height);
  }

  String _formatDate(String? dateTime) {
    if (dateTime == null) return 'N/A';

    try {
      // Define the input date format
      final inputFormat = DateFormat('EEE, MMM d, yyyy h:mm a');
      final date = inputFormat.parse(dateTime);

      // Define the desired output date format
      final outputFormat = DateFormat('d MMM yyyy');
      return outputFormat.format(date);
    } catch (e) {
      // Handle any parsing errors gracefully
      return 'Invalid date';
    }
  }

  double _calculateProgress(int lowest, int highest, int latest) {
    if (highest == lowest) return 0.5; // Avoid division by zero
    return (latest - lowest) / (highest - lowest);
  }
}
