import 'package:flutter/material.dart';
import 'package:daily_weight_logs_mobile/common/constants/colors.dart';
import 'package:daily_weight_logs_mobile/common/widgets/weight_log_text.dart';

class WeightGoalSelectionModal extends StatelessWidget {
  final List<String> weightGoals;
  final String? selectedWeightGoal;
  final Function(String) onSelected;

  const WeightGoalSelectionModal({
    super.key,
    required this.weightGoals,
    required this.selectedWeightGoal,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.34,
      ),
      child: Column(
        children: [
          // Header Text
          const Padding(
            padding: EdgeInsets.only(bottom: 1.0),
            child: WeightLogText(
              text: 'What is your weight goal?',
              fontSize: 18,
              color: secondaryColor,
            ),
          ),
          const Divider(),
          // List of Weight Goals
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
                  onSelected(weightGoals[index]);
                  Navigator.pop(context);
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
