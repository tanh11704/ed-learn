import 'package:equatable/equatable.dart';

abstract class PerformanceEvent extends Equatable {
  const PerformanceEvent();

  @override
  List<Object?> get props => [];
}

class LoadPerformanceData extends PerformanceEvent {
  const LoadPerformanceData();
}
