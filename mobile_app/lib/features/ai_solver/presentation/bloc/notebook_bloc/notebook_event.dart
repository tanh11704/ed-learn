import 'package:equatable/equatable.dart';

abstract class NotebookEvent extends Equatable {
  const NotebookEvent();

  @override
  List<Object?> get props => [];
}

class LoadNotebooks extends NotebookEvent {
  const LoadNotebooks();
}

class SelectNotebook extends NotebookEvent {
  final int index;

  const SelectNotebook(this.index);

  @override
  List<Object?> get props => [index];
}

class CreateNotebook extends NotebookEvent {
  final String name;

  const CreateNotebook(this.name);

  @override
  List<Object?> get props => [name];
}
