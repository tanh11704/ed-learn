import 'package:flutter_bloc/flutter_bloc.dart';
import 'scanner_event.dart';
import 'scanner_state.dart';

class ScannerBloc extends Bloc<ScannerEvent, ScannerState> {
  ScannerBloc() : super(const ScannerIdle()) {
    on<StartScanning>(_onStartScanning);
    on<UpdateScanProgress>(_onUpdateScanProgress);
    on<ReportBlurError>(_onReportBlurError);
    on<ResetScanner>(_onResetScanner);
  }

  void _onStartScanning(StartScanning event, Emitter<ScannerState> emit) {
    emit(ScannerProcessing(progress: event.progress));
  }

  void _onUpdateScanProgress(
    UpdateScanProgress event,
    Emitter<ScannerState> emit,
  ) {
    if (state is ScannerProcessing) {
      emit(ScannerProcessing(progress: event.progress));
    }
  }

  void _onReportBlurError(ReportBlurError event, Emitter<ScannerState> emit) {
    emit(ScannerBlurError(message: event.message));
  }

  void _onResetScanner(ResetScanner event, Emitter<ScannerState> emit) {
    emit(const ScannerIdle());
  }
}
