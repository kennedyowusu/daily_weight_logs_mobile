class TimeRangeOption {
  final String label;
  final String value;

  TimeRangeOption({required this.label, required this.value});
}

final List<TimeRangeOption> timeRangeOptions = [
  TimeRangeOption(label: 'Today', value: 'today'),
  TimeRangeOption(label: 'Last week', value: 'last_week'),
];
