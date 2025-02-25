import 'package:daily_weight_logs_mobile/common/constants/colors.dart';
import 'package:daily_weight_logs_mobile/common/widgets/weight_log_app_bar.dart';
import 'package:daily_weight_logs_mobile/common/widgets/weight_log_button.dart';
import 'package:daily_weight_logs_mobile/common/widgets/weight_log_loading_dialog.dart';
import 'package:daily_weight_logs_mobile/common/widgets/weight_log_text.dart';
import 'package:daily_weight_logs_mobile/features/weight_logs/application/weight_log_controller.dart';
import 'package:daily_weight_logs_mobile/features/weight_logs/domain/weight_log.dart';
import 'package:daily_weight_logs_mobile/router/authenticated_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';

class AddWeightLogScreen extends ConsumerStatefulWidget {
  const AddWeightLogScreen({super.key});

  @override
  ConsumerState<AddWeightLogScreen> createState() => _AddWeightLogScreenState();
}

class _AddWeightLogScreenState extends ConsumerState<AddWeightLogScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController weightController = TextEditingController();

  DateTime? selectedDate = DateTime.now();
  String? selectedTimeOfDay;
  bool isLogExisting = false;

  // Current date (today)
  final DateTime today = DateTime.now();

  void checkIfLogExists(BuildContext context) {
    final weightLogs =
        ref.read(weightLogControllerProvider).asData?.value ?? [];

    if (selectedDate != null && selectedTimeOfDay != null) {
      final existingLog = weightLogs.firstWhere(
        (log) =>
            log.loggedAt != null &&
            log.loggedAt!
                .startsWith(selectedDate!.toIso8601String().substring(0, 10)) &&
            log.timeOfDay == selectedTimeOfDay,
        orElse: () => WeightLogModel(
          loggedAt: '',
          timeOfDay: '',
          weight: 0,
        ),
      );
      setState(() {
        isLogExisting = existingLog.loggedAt?.isNotEmpty ?? false;
      });

      if (isLogExisting) {
        // Show a snackbar message if the log already exists
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'You have already logged your weight for ${selectedTimeOfDay!.toLowerCase()} on this date.',
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void handleDateSelection(BuildContext context, DateTime? date) {
    if (date == null) return;

    // Check if the selected date is today
    if (date.year != today.year ||
        date.month != today.month ||
        date.day != today.day) {
      // Reset the selection and show a warning
      setState(() {
        selectedDate = today; // Reset the selected date to today
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'You can only log weight for today\'s date.',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
    } else {
      setState(() {
        selectedDate = date;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondaryColor,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: WeightLogAppBar(
          titleText: 'Add Weight Log',
          backgroundColor: secondaryColor,
          textColor: Colors.white,
          automaticallyImplyLeading: true,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  // Select Date
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: WeightLogText(
                      text: 'Select Date',
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 0),

                  CalendarDatePicker2(
                    key: const Key('calendarDatePicker'),
                    config: CalendarDatePicker2Config(
                      weekdayLabelTextStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      calendarType: CalendarDatePicker2Type.single,
                      currentDate: today,
                      dayTextStyle: const TextStyle(
                        color: grayTextColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      selectedDayHighlightColor: primaryColor.withOpacity(0.5),
                      selectedDayTextStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      disabledDayTextStyle: const TextStyle(
                        color: Colors.grey, // Gray out non-selectable dates
                      ),
                    ),
                    value: [selectedDate ?? today],
                    onValueChanged: (dates) {
                      handleDateSelection(
                          context, dates.isNotEmpty ? dates.first : null);
                    },
                  ),

                  SizedBox(height: MediaQuery.sizeOf(context).height * 0.02),

                  // Weight Input
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: WeightLogText(
                      text: 'Enter Weight (kg)',
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: weightController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      hintText: 'Enter your weight',
                    ),
                    style: const TextStyle(color: secondaryColor),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your weight.';
                      }
                      final weight = int.tryParse(value);
                      if (weight == null || weight < 30 || weight > 300) {
                        return 'Please enter a valid weight between 30 and 300 kg.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 40),

                  // Time of Day Selector
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: WeightLogText(
                      text: 'Time of Day',
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedTimeOfDay = 'Morning';
                            });
                            checkIfLogExists(context);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 20),
                            decoration: BoxDecoration(
                              color: selectedTimeOfDay == 'Morning'
                                  ? primaryColor
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: WeightLogText(
                                text: 'Morning',
                                color: selectedTimeOfDay == 'Morning'
                                    ? secondaryColor
                                    : secondaryColor,
                                fontWeight: selectedTimeOfDay == 'Morning'
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedTimeOfDay = 'Evening';
                            });
                            checkIfLogExists(context);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 20),
                            decoration: BoxDecoration(
                              color: selectedTimeOfDay == 'Evening'
                                  ? primaryColor
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: WeightLogText(
                                text: 'Evening',
                                color: selectedTimeOfDay == 'Evening'
                                    ? secondaryColor
                                    : secondaryColor,
                                fontWeight: selectedTimeOfDay == 'Evening'
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: MediaQuery.sizeOf(context).height * 0.04),

                  // Log Weight Button
                  WeightLogButton(
                    text: "Log Weight",
                    buttonBackgroundColor: primaryColor,
                    buttonTextColor: secondaryColor,
                    isEnabled: !isLogExisting,
                    onPressed: isLogExisting
                        ? null
                        : () async {
                            if (formKey.currentState?.validate() == true &&
                                selectedDate != null &&
                                selectedTimeOfDay != null) {
                              // Show loading dialog
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (context) {
                                  return const WeightLogLoadingDialog(
                                    message: 'Adding weight log...',
                                  );
                                },
                              );

                              final weight =
                                  int.parse(weightController.text.trim());

                              // Adjust the time for loggedAt based on selectedTimeOfDay
                              DateTime loggedAt = selectedDate!;
                              if (selectedTimeOfDay == 'Morning') {
                                loggedAt =
                                    loggedAt.copyWith(hour: 8, minute: 0);
                              } else if (selectedTimeOfDay == 'Evening') {
                                loggedAt =
                                    loggedAt.copyWith(hour: 19, minute: 0);
                              }

                              await ref
                                  .read(weightLogControllerProvider.notifier)
                                  .addWeightLog(
                                    weight: weight,
                                    timeOfDay: selectedTimeOfDay!,
                                    loggedAt: loggedAt.toIso8601String(),
                                  );

                              debugPrint(
                                'Weight: $weight, Time of Day: $selectedTimeOfDay, Logged At: ${loggedAt.toIso8601String()}',
                              );

                              ref.watch(weightLogControllerProvider).when(
                                data: (_) {
                                  Navigator.of(context).pop();
                                  Navigator.pushReplacementNamed(
                                    context,
                                    MainRoutes.weightLogRoute,
                                  );
                                },
                                error: (error, _) {
                                  Navigator.of(context).pop();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(error.toString())),
                                  );
                                },
                                loading: () {
                                  // Already handled by dialog
                                },
                              );

                              // Reset fields
                              setState(() {
                                weightController.clear();
                                selectedTimeOfDay = null;
                                selectedDate = DateTime.now();
                              });
                            }
                          },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
