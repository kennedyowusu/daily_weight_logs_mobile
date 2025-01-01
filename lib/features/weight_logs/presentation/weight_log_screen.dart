import 'package:daily_weight_logs_mobile/features/weight_logs/application/weight_log_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WeightLogScreen extends ConsumerWidget {
  const WeightLogScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weightLogState = ref.watch(weightLogControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Weight Logs')),
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
        onPressed: () async {
          await ref.read(weightLogControllerProvider.notifier).addWeightLog(
                weight: 70,
                timeOfDay: 'morning',
                loggedAt: DateTime.now().toIso8601String(),
              );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
