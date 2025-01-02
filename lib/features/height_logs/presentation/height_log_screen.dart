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

  void _showWeightGoalSelection(BuildContext context) async {
    // Delay the display of the modal bottom sheet
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
                WeightLogInputField(
                  controller: heightController,
                  hintText: 'Enter your height (meters)',
                  labelText: 'Height',
                  inputTextColor: Colors.white,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your height';
                    }
                    final height = double.tryParse(value);
                    if (height == null || height < 1.0 || height > 2.5) {
                      return 'Height must be between 1 and 2.5 meters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
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
                  buttonTextFontWeight: FontWeight.w600,
                  key: const Key('submit_button'),
                  isEnabled: true,
                  onPressed: () async {
                    if (formKey.currentState?.validate() == true &&
                        selectedWeightGoal != null) {
                      final height = double.parse(heightController.text.trim());
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
