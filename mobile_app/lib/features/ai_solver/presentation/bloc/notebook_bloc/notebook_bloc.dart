import 'package:flutter_bloc/flutter_bloc.dart';
import 'notebook_event.dart';
import 'notebook_state.dart';

class NotebookBloc extends Bloc<NotebookEvent, NotebookState> {
  NotebookBloc() : super(const NotebookInitial()) {
    on<LoadNotebooks>(_onLoadNotebooks);
    on<SelectNotebook>(_onSelectNotebook);
    on<CreateNotebook>(_onCreateNotebook);
  }

  void _onLoadNotebooks(LoadNotebooks event, Emitter<NotebookState> emit) {
    emit(
      const NotebookLoaded(
        notebooks: ['Toán Hình 12', 'Hóa Vô Cơ', 'Lưu ý'],
        selectedIndex: 0,
        saved: true,
      ),
    );
  }

  void _onSelectNotebook(SelectNotebook event, Emitter<NotebookState> emit) {
    if (state is NotebookLoaded) {
      final currentState = state as NotebookLoaded;
      emit(currentState.copyWith(selectedIndex: event.index, saved: true));
    }
  }

  void _onCreateNotebook(CreateNotebook event, Emitter<NotebookState> emit) {
    if (state is NotebookLoaded) {
      final currentState = state as NotebookLoaded;
      final updated = List<String>.from(currentState.notebooks)..add(event.name);
      emit(currentState.copyWith(notebooks: updated, selectedIndex: updated.length - 1, saved: true));
    }
  }
}
