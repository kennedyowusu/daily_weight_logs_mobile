class TimeRangeOption {
  final String label;
  final String value;

  TimeRangeOption({required this.label, required this.value});
}

final List<TimeRangeOption> timeRangeOptions = [
  TimeRangeOption(label: 'Last week', value: 'last_week'),
  TimeRangeOption(label: 'Last month', value: 'last_month'),
  TimeRangeOption(label: 'Last 6 months', value: 'last_6_months'),
];
