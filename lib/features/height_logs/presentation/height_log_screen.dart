import 'package:daily_weight_logs_mobile/common/constants/colors.dart';
import 'package:daily_weight_logs_mobile/common/constants/images.dart';
import 'package:daily_weight_logs_mobile/common/widgets/weight_log_app_bar.dart';
import 'package:daily_weight_logs_mobile/common/widgets/weight_log_button.dart';
import 'package:daily_weight_logs_mobile/common/widgets/weight_log_text.dart';
import 'package:daily_weight_logs_mobile/features/authentication/widgets/weight_log_input_field.dart';
import 'package:daily_weight_logs_mobile/features/height_logs/application/controllers/height_log_controller.dart';
import 'package:daily_weight_logs_mobile/features/height_logs/data/repositories/height_log_repository.dart';
import 'package:daily_weight_logs_mobile/features/height_logs/presentation/widgets/weight_goal_selection_modal.dart';
import 'package:flutter/material.dart';

class HeightLogScreen extends StatefulWidget {
  const HeightLogScreen({super.key});

  @override
  State<HeightLogScreen> createState() => _HeightLogScreenState();
}

class _HeightLogScreenState extends State<HeightLogScreen> {
  final TextEditingController heightController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String? selectedWeightGoal;
  final HeightLogController controller = HeightLogController(
    repository: HeightLogRepository(),
  );

  final List<String> weightGoals = ['gain', 'lose', 'maintain'];

  // For unit selection
  String selectedUnit = 'meters'; // Default unit

  void _showWeightGoalSelection(BuildContext context) async {
    await Future.delayed(const Duration(milliseconds: 100));
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      isDismissible: true,
      isScrollControlled: true,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return WeightGoalSelectionModal(
          weightGoals: weightGoals,
          selectedWeightGoal: selectedWeightGoal,
          onSelected: (String goal) {
            setState(() {
              selectedWeightGoal = goal;
            });
          },
        );
      },
    );
  }

  void _convertHeightIfNeeded() {
    if (selectedUnit != 'meters') {
      try {
        final String input = heightController.text.trim();
        if (input.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please enter your height.')),
          );
          return;
        }

        double meters;
        if (selectedUnit == 'centimeters') {
          meters = controller.convertToMeters(input);
        } else if (selectedUnit == 'feet/inches') {
          meters = controller.convertToMeters(input, isUsingFeet: true);
        } else {
          throw const FormatException('Invalid unit selected.');
        }

        if (meters < 1.0 || meters > 2.5) {
          throw const FormatException(
              'Height in meters must be between 1.0 and 2.5.');
        }

        heightController.text = meters.toStringAsFixed(2);

        debugPrint('Converted height: $meters');
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid input: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondaryColor,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: WeightLogAppBar(
          titleText: 'Log Height Goal',
          backgroundColor: secondaryColor,
          textColor: Colors.white,
          automaticallyImplyLeading: false,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: MediaQuery.sizeOf(context).height * 0.05),
                Image.asset(
                  weightLogoWhite,
                  width: 150,
                  height: 150,
                ),
                SizedBox(height: MediaQuery.sizeOf(context).height * 0.14),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: WeightLogText(
                    text: 'Select Height Unit:',
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: RadioListTile<String>(
                        title: const WeightLogText(
                          text: 'm',
                          fontSize: 14,
                          color: Colors.white,
                        ),
                        value: 'meters',
                        groupValue: selectedUnit,
                        onChanged: (value) {
                          setState(() {
                            selectedUnit = value!;
                            heightController.clear();
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: RadioListTile<String>(
                        title: const WeightLogText(
                          text: 'cm',
                          fontSize: 14,
                          color: Colors.white,
                        ),
                        value: 'centimeters',
                        groupValue: selectedUnit,
                        onChanged: (value) {
                          setState(() {
                            selectedUnit = value!;
                            heightController.clear();
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: RadioListTile<String>(
                        title: const WeightLogText(
                          text: 'ft/in',
                          fontSize: 14,
                          color: Colors.white,
                        ),
                        value: 'feet/inches',
                        groupValue: selectedUnit,
                        onChanged: (value) {
                          setState(() {
                            selectedUnit = value!;
                            heightController.clear();
                          });
                        },
                      ),
                    ),
                  ],
                ),
                WeightLogInputField(
                  controller: heightController,
                  hintText: selectedUnit == 'meters'
                      ? 'Enter height in meters'
                      : selectedUnit == 'centimeters'
                          ? 'Enter height in centimeters'
                          : 'Enter height in feet.inches',
                  labelText:
                      'Height (${selectedUnit == "feet/inches" ? "ft.in" : selectedUnit})',
                  inputTextColor: Colors.white,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                ),
                const SizedBox(height: 20),
                DropdownButtonHideUnderline(
                  child: GestureDetector(
                    onTap: () {
                      _showWeightGoalSelection(context);
                    },
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'Weight Goal',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          WeightLogText(
                            text: selectedWeightGoal ?? 'Select Weight Goal',
                            fontSize: 16,
                            color: selectedWeightGoal == null
                                ? grayTextColor
                                : Colors.white,
                          ),
                          const Icon(
                            Icons.arrow_drop_down,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                WeightLogButton(
                  text: 'Submit Height Goal',
                  buttonTextColor: secondaryColor,
                  buttonBackgroundColor: primaryColor,
                  onPressed: () async {
                    _convertHeightIfNeeded(); // Convert height before submission
                    if (formKey.currentState?.validate() == true &&
                        selectedWeightGoal != null) {
                      final height =
                          double.tryParse(heightController.text.trim());
                      if (height == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Invalid height value.')),
                        );
                        return;
                      }
                      final weightGoal = selectedWeightGoal!;
                      await controller.submitHeightLog(height, weightGoal);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Height: $height, Weight Goal: $weightGoal',
                          ),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
