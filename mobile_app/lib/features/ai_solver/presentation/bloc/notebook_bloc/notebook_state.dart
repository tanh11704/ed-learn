import 'package:equatable/equatable.dart';

abstract class NotebookState extends Equatable {
  const NotebookState();

  @override
  List<Object?> get props => [];
}

class NotebookInitial extends NotebookState {
  const NotebookInitial();
}

class NotebookLoaded extends NotebookState {
  final List<String> notebooks;
  final int selectedIndex;
  final bool saved;

  const NotebookLoaded({
    required this.notebooks,
    this.selectedIndex = 0,
    this.saved = false,
  });

  NotebookLoaded copyWith({
    List<String>? notebooks,
    int? selectedIndex,
    bool? saved,
  }) {
    return NotebookLoaded(
      notebooks: notebooks ?? this.notebooks,
      selectedIndex: selectedIndex ?? this.selectedIndex,
      saved: saved ?? this.saved,
    );
  }

  @override
  List<Object?> get props => [notebooks, selectedIndex, saved];
}
