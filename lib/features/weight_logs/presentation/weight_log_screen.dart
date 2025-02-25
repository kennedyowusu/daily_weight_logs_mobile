import 'package:daily_weight_logs_mobile/common/constants/colors.dart';
import 'package:daily_weight_logs_mobile/common/constants/images.dart';
import 'package:daily_weight_logs_mobile/common/widgets/weight_log_text.dart';
import 'package:daily_weight_logs_mobile/features/authentication/widgets/weight_log_button_text.dart';
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
  // Track the selected time range
  TimeRangeOption selectedTimeRange = timeRangeOptions[0];

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
    const int totalBmiBars = 30;

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
                          value: selectedTimeRange,
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
                            setState(() {
                              selectedTimeRange = timeRangeOption!;
                            });
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
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: grayTextColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: weightLogState.when(
                    data: (weightLogs) {
                      // Prepare graph data
                      List<FlSpot> graphSpots = [];
                      List<String> logLabels = [];
                      final now = DateTime.now();
                      final DateFormat inputDateFormat =
                          DateFormat('EEE, MMM d, yyyy h:mm a');

                      final filteredLogs = weightLogs.where((log) {
                        try {
                          final logDate = inputDateFormat.parse(log.loggedAt!);

                          if (selectedTimeRange.value == 'today') {
                            return logDate
                                .isAfter(now.subtract(const Duration(days: 1)));
                          } else if (selectedTimeRange.value == 'last_week') {
                            return logDate
                                .isAfter(now.subtract(const Duration(days: 7)));
                          }
                        } catch (e) {
                          debugPrint(
                              'Error parsing date: ${log.loggedAt} - $e');
                          return false;
                        }
                        return false;
                      }).toList();

                      for (int i = 0; i < filteredLogs.length; i++) {
                        final log = filteredLogs[i];
                        try {
                          final parsedDate =
                              inputDateFormat.parse(log.loggedAt!);
                          logLabels.add(DateFormat('MMM d').format(parsedDate));
                          graphSpots.add(
                            FlSpot(
                              i.toDouble(),
                              log.weight!.toDouble(),
                            ),
                          );
                        } catch (e) {
                          debugPrint(
                              'Error parsing date for log ${log.loggedAt}: $e');
                        }
                      }

                      final containerHeight = graphSpots.isEmpty ? 40.0 : 150.0;

                      return SizedBox(
                        height: containerHeight,
                        child: graphSpots.isEmpty
                            ? Center(
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: secondaryColor,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const WeightLogText(
                                    text: 'No data available for this period',
                                    fontSize: 14,
                                    color: grayTextColor,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              )
                            : LineChart(
                                LineChartData(
                                  minX: 0,
                                  maxX: graphSpots.isNotEmpty
                                      ? graphSpots.length - 1
                                      : 1,
                                  minY: graphSpots.isNotEmpty
                                      ? graphSpots
                                              .map((spot) => spot.y)
                                              .reduce((a, b) => a < b ? a : b) -
                                          5
                                      : 50,
                                  maxY: graphSpots.isNotEmpty
                                      ? graphSpots
                                              .map((spot) => spot.y)
                                              .reduce((a, b) => a > b ? a : b) +
                                          5
                                      : 300,
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
                                          if (index >= 0 &&
                                              index < logLabels.length) {
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
                                      dotData: const FlDotData(show: true),
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
                                        LineTouchResponse? response) {},
                                    handleBuiltInTouches: true,
                                  ),
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
                  height: 125,
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
                      // Define the static number of bars for the BMI scale

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: List.generate(totalBmiBars, (index) {
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
                    WeightLogButtonText(
                      mainText: 'See All',
                      actionText: 'All Logs',
                      route: MainRoutes.viewAllWeightLogsRoute,
                      actionTextStyle: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: primaryColor,
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 10),

                // Weight Log History
                SizedBox(
                  height: weightLogState.when(
                    data: (weightLogs) {
                      if (weightLogs.isEmpty) {
                        return MediaQuery.sizeOf(context).height * 0.08;
                      }
                      if (weightLogs.length == 1) {
                        return MediaQuery.sizeOf(context).height * 0.13;
                      }
                      if (weightLogs.length == 2) {
                        return MediaQuery.sizeOf(context).height * 0.2;
                      }
                      if (weightLogs.length == 3) {
                        return MediaQuery.sizeOf(context).height * 0.35;
                      }
                      if (weightLogs.length == 4) {
                        return MediaQuery.sizeOf(context).height * 0.4;
                      }
                      return MediaQuery.sizeOf(context).height *
                          0.5; // Default height for 5+ logs
                    },
                    loading: () => MediaQuery.sizeOf(context).height * 0.2,
                    error: (_, __) => MediaQuery.sizeOf(context).height * 0.2,
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: grayTextColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: weightLogState.when(
                      data: (weightLogs) {
                        if (weightLogs.isEmpty) {
                          return const Center(
                            child: WeightLogText(
                              text: 'No weight logs available.',
                              fontSize: 16,
                              color: grayTextColor,
                            ),
                          );
                        }

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
                                              '${isPositiveChange ? ' ↑ ' : ''}${weightDifference.toStringAsFixed(1)} kg',
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
