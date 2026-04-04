import 'package:equatable/equatable.dart';

enum ScannerStatus { idle, processing, blurError }

abstract class ScannerState extends Equatable {
  final ScannerStatus status;
  final double progress;
  final String? errorMessage;

  const ScannerState({
    required this.status,
    this.progress = 0.0,
    this.errorMessage,
  });

  @override
  List<Object?> get props => [status, progress, errorMessage];
}

class ScannerIdle extends ScannerState {
  const ScannerIdle() : super(status: ScannerStatus.idle, progress: 0.0);
}

class ScannerProcessing extends ScannerState {
  const ScannerProcessing({double progress = 0.65})
      : super(status: ScannerStatus.processing, progress: progress);
}

class ScannerBlurError extends ScannerState {
  const ScannerBlurError({String message = 'Ảnh hơi mờ, vui lòng quét lại!'})
      : super(status: ScannerStatus.blurError, progress: 0.0, errorMessage: message);
}
