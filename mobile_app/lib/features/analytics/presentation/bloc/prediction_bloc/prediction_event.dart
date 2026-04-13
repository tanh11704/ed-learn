import 'package:equatable/equatable.dart';

abstract class PredictionEvent extends Equatable {
  const PredictionEvent();

  @override
  List<Object?> get props => [];
}

class LoadPredictionData extends PredictionEvent {
  const LoadPredictionData();
}
