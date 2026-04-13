import 'package:equatable/equatable.dart';

abstract class MistakeBankEvent extends Equatable {
  const MistakeBankEvent();

  @override
  List<Object?> get props => [];
}

class LoadMistakeBank extends MistakeBankEvent {
  const LoadMistakeBank();
}

class FilterMistakesBySubject extends MistakeBankEvent {
  final String subject;

  const FilterMistakesBySubject(this.subject);

  @override
  List<Object?> get props => [subject];
}
