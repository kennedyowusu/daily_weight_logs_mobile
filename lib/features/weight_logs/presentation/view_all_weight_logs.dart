import 'package:daily_weight_logs_mobile/common/constants/colors.dart';
import 'package:daily_weight_logs_mobile/common/constants/images.dart';
import 'package:daily_weight_logs_mobile/common/widgets/weight_log_app_bar.dart';
import 'package:daily_weight_logs_mobile/common/widgets/weight_log_text.dart';
import 'package:daily_weight_logs_mobile/features/weight_logs/application/weight_log_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class ViewAllWeightLogs extends ConsumerStatefulWidget {
  const ViewAllWeightLogs({super.key});

  @override
  ConsumerState<ViewAllWeightLogs> createState() => _ViewAllWeightLogsState();
}

class _ViewAllWeightLogsState extends ConsumerState<ViewAllWeightLogs> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Fetch all weight logs after the widget has been built
      ref.read(weightLogControllerProvider.notifier).fetchWeightLogs();
    });
  }

  @override
  Widget build(BuildContext context) {
    final weightLogState = ref.watch(weightLogControllerProvider);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: secondaryColor,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: WeightLogAppBar(
          fontSize: 20,
          titleText: 'Weight Logs',
          backgroundColor: secondaryColor,
          textColor: Colors.white,
          automaticallyImplyLeading: true,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: weightLogState.when(
          data: (weightLogs) {
            if (weightLogs.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      noDataSvg,
                      width: 300,
                      height: 300,
                    ),
                    const SizedBox(height: 16),
                    WeightLogText(
                      text: 'No weight logs available.'.toUpperCase(),
                      fontSize: 16,
                      color: grayTextColor,
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              itemCount: weightLogs.length,
              itemBuilder: (context, index) {
                final weightLog = weightLogs[index];
                final previousWeight = index < weightLogs.length - 1
                    ? weightLogs[index + 1].weight
                    : weightLog
                        .weight; // Default to current weight for the first log
                final weightDifference =
                    (weightLog.weight ?? 0) - (previousWeight ?? 0);
                final isPositiveChange = weightDifference > 0;

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: grayTextColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              index == 0
                                  ? 'Today'
                                  : index == 1
                                      ? 'Yesterday'
                                      : weightLog.loggedAt ?? 'Unknown date',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${isPositiveChange ? ' ↑ ' : ''}${weightDifference.toStringAsFixed(1)} kg',
                              style: TextStyle(
                                fontSize: 14,
                                color: isPositiveChange
                                    ? Colors.red
                                    : Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          '${weightLog.weight?.toStringAsFixed(1)} kg',
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
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
            child: Text(
              'Error: $error',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.red,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
