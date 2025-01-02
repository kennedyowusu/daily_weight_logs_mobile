import 'package:daily_weight_logs_mobile/common/constants/colors.dart';
import 'package:daily_weight_logs_mobile/common/widgets/weight_log_app_bar.dart';
import 'package:daily_weight_logs_mobile/features/weight_logs/application/weight_log_controller.dart';
import 'package:daily_weight_logs_mobile/router/authenticated_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WeightLogScreen extends ConsumerWidget {
  const WeightLogScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weightLogState = ref.watch(weightLogControllerProvider);

    return Scaffold(
      backgroundColor: secondaryColor,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: WeightLogAppBar(
          titleText: 'Weight Logs',
          backgroundColor: secondaryColor,
          textColor: Colors.white,
          automaticallyImplyLeading: false,
        ),
      ),
      body: weightLogState.when(
        data: (logs) => ListView.builder(
          itemCount: logs.length,
          itemBuilder: (context, index) {
            final log = logs[index];
            return ListTile(
              title: Text('Weight: ${log.weight}'),
              subtitle: Text('Logged At: ${log.loggedAt}'),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () async {
                  await ref
                      .read(weightLogControllerProvider.notifier)
                      .deleteWeightLog(logId: log.id!);
                },
              ),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
          child: Text('Error: $err'),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'addWeightLog',
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        backgroundColor: primaryColor,
        tooltip: 'Add Weight Log',
        key: const Key('addWeightLogButton'),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        onPressed: () async {
          // await ref.read(weightLogControllerProvider.notifier).addWeightLog(
          //       weight: 70,
          //       timeOfDay: 'morning',
          //       loggedAt: DateTime.now().toIso8601String(),
          //     );

          Navigator.pushNamed(context, MainRoutes.addWeightLogRoute);
        },
        child: const Icon(Icons.add, color: secondaryColor, size: 30),
      ),
    );
  }
}
