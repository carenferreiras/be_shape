import 'package:equatable/equatable.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  const ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}

class AIChatState extends Equatable {
  final bool isLoading;
  final List<ChatMessage> messages;
  final String? error;

  const AIChatState({
    this.isLoading = false,
    this.messages = const [],
    this.error,
  });

  AIChatState copyWith({
    bool? isLoading,
    List<ChatMessage>? messages,
    String? error,
  }) {
    return AIChatState(
      isLoading: isLoading ?? this.isLoading,
      messages: messages ?? this.messages,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [isLoading, messages, error];
}