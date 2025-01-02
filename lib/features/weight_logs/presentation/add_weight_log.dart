import 'package:daily_weight_logs_mobile/common/constants/colors.dart';
import 'package:daily_weight_logs_mobile/common/widgets/weight_log_app_bar.dart';
import 'package:daily_weight_logs_mobile/common/widgets/weight_log_button.dart';
import 'package:daily_weight_logs_mobile/common/widgets/weight_log_text.dart';
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
  DateTime? selectedDate = DateTime.now();
  final TextEditingController weightController = TextEditingController();
  String? selectedTimeOfDay;

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
                  // Calendar Picker
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: WeightLogText(
                      text: 'Select Date',
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  CalendarDatePicker2(
                    key: const Key('calendarDatePicker'),
                    config: CalendarDatePicker2Config(
                      // Customize year
                      yearTextStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      selectedYearTextStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      yearBorderRadius: BorderRadius.circular(12),

                      // Customize month
                      nextMonthIcon: const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                      ),
                      lastMonthIcon: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                      ),
                      selectedMonthTextStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      monthTextStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      monthBorderRadius: BorderRadius.circular(12),

                      // Customize the day of the week
                      weekdayLabelTextStyle: const TextStyle(
                        color: primaryColor,
                        fontSize: 16,
                      ),

                      // Customize day
                      dayTextStyle: const TextStyle(
                        color: grayTextColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      selectedDayTextStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      currentDate: DateTime.now(),
                      // selectableDayPredicate: (date) {
                      //   return date.day == DateTime.now().day &&
                      //       date.month == DateTime.now().month &&
                      //       date.year == DateTime.now().year;
                      // },
                      selectedDayHighlightColor: primaryColor.withOpacity(0.5),

                      calendarType: CalendarDatePicker2Type.single,
                    ),
                    value: selectedDate != null ? [selectedDate!] : [],
                    onValueChanged: (dates) {
                      setState(() {
                        selectedDate = dates.isNotEmpty ? dates.first : null;
                      });
                    },
                  ),

                  SizedBox(height: MediaQuery.sizeOf(context).height * 0.02),
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
                  // Time of Day
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
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Center(
                              child: WeightLogText(
                                text: 'Morning',
                                color: secondaryColor,
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
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Center(
                              child: WeightLogText(
                                text: 'Evening',
                                color: secondaryColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: MediaQuery.sizeOf(context).height * 0.04),
                  WeightLogButton(
                    text: "Log Weight",
                    buttonBackgroundColor: primaryColor,
                    buttonTextColor: secondaryColor,
                    onPressed: () {
                      if (formKey.currentState?.validate() == true &&
                          selectedDate != null &&
                          selectedTimeOfDay != null) {
                        final weight = int.parse(weightController.text.trim());
                        final loggedAt =
                            "${selectedDate!.year}-${selectedDate!.month.toString().padLeft(2, '0')}-${selectedDate!.day.toString().padLeft(2, '0')}";
                        debugPrint(
                            'Weight: $weight, Time of Day: $selectedTimeOfDay, Logged At: $loggedAt');
                        // ref
                        //     .read(weightLogControllerProvider.notifier)
                        //     .addWeightLog(
                        //       weight: weight,
                        //       timeOfDay: selectedTimeOfDay!,
                        //       loggedAt: loggedAt,
                        //     );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Weight log added successfully!')),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
