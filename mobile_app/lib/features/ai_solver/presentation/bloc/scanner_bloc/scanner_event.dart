import 'package:equatable/equatable.dart';

abstract class ScannerEvent extends Equatable {
  const ScannerEvent();

  @override
  List<Object?> get props => [];
}

class StartScanning extends ScannerEvent {
  final double progress;

  const StartScanning({this.progress = 0.65});

  @override
  List<Object?> get props => [progress];
}

class UpdateScanProgress extends ScannerEvent {
  final double progress;

  const UpdateScanProgress(this.progress);

  @override
  List<Object?> get props => [progress];
}

class ReportBlurError extends ScannerEvent {
  final String message;

  const ReportBlurError({
    this.message = 'Ảnh hơi mờ, vui lòng quét lại!',
  });

  @override
  List<Object?> get props => [message];
}

class ResetScanner extends ScannerEvent {
  const ResetScanner();
}
