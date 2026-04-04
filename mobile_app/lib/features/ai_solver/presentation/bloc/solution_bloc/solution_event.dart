import 'package:equatable/equatable.dart';

abstract class SolutionEvent extends Equatable {
  const SolutionEvent();

  @override
  List<Object?> get props => [];
}

class LoadSolution extends SolutionEvent {
  const LoadSolution();
}
