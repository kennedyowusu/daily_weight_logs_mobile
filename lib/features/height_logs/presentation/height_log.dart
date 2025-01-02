import 'package:daily_weight_logs_mobile/common/constants/images.dart';
import 'package:daily_weight_logs_mobile/common/widgets/weight_log_app_bar.dart';
import 'package:daily_weight_logs_mobile/common/widgets/weight_log_text.dart';
import 'package:flutter/material.dart';
import 'package:daily_weight_logs_mobile/common/constants/colors.dart';
import 'package:daily_weight_logs_mobile/common/widgets/weight_log_button.dart';
import 'package:daily_weight_logs_mobile/features/authentication/widgets/weight_log_input_field.dart';

class HeightLogScreen extends StatefulWidget {
  const HeightLogScreen({super.key});

  @override
  State<HeightLogScreen> createState() => _HeightLogScreenState();
}

class _HeightLogScreenState extends State<HeightLogScreen> {
  final TextEditingController heightController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String? selectedWeightGoal;

  final List<String> weightGoals = ['gain', 'lose', 'maintain'];

  void _showWeightGoalSelection(BuildContext context) async {
    // Delay the display of the modal bottom sheet
    await Future.delayed(const Duration(milliseconds: 100));

    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      transitionAnimationController: AnimationController(
        vsync: Navigator.of(context),
        duration: const Duration(milliseconds: 300),
      ),
      isDismissible: true,
      isScrollControlled: true,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.3,
          ),
          child: Column(
            children: [
              // Add the header text
              const Padding(
                padding: EdgeInsets.only(bottom: 1.0),
                child: WeightLogText(
                  text: 'What is your weight goal?',
                  fontSize: 18,
                  color: secondaryColor,
                ),
              ),
              const Divider(),
              // List of weight goals
              ListView.separated(
                shrinkWrap: true,
                itemCount: weightGoals.length,
                separatorBuilder: (BuildContext context, int index) {
                  return const Divider();
                },
                itemBuilder: (BuildContext context, int index) {
                  final isSelected = selectedWeightGoal == weightGoals[index];

                  return ListTile(
                    leading: Icon(
                      Icons.check_circle_sharp,
                      color: isSelected ? primaryColor : grayTextColor,
                      size: 24,
                    ),
                    title: WeightLogText(
                      text: weightGoals[index],
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: isSelected ? primaryColor : secondaryColor,
                    ),
                    onTap: () {
                      setState(() {
                        selectedWeightGoal = weightGoals[index];
                      });
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ],
          ),
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
                  onPressed: () {
                    if (formKey.currentState?.validate() == true) {
                      final height = heightController.text.trim();
                      final weightGoal = selectedWeightGoal;

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
