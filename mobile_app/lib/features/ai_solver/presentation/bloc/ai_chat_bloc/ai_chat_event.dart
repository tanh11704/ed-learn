import 'package:equatable/equatable.dart';
import '../../../data/models/ai_solver_solution_model.dart';

abstract class AiChatEvent extends Equatable {
  const AiChatEvent();

  @override
  List<Object?> get props => [];
}

class LoadChatHistory extends AiChatEvent {
  final AiSolverSolution? solution;

  const LoadChatHistory({this.solution});

  @override
  List<Object?> get props => [solution];
}

class SendChatMessage extends AiChatEvent {
  final String message;

  const SendChatMessage(this.message);

  @override
  List<Object?> get props => [message];
}

class ReceiveChatMessage extends AiChatEvent {
  final String message;

  const ReceiveChatMessage(this.message);

  @override
  List<Object?> get props => [message];
}
