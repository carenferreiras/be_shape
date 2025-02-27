import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../features.dart';


class AIChatBloc extends Bloc<AIChatEvent, AIChatState> {
  final OpenAIService _aiService;

  AIChatBloc({required OpenAIService aiService})
      : _aiService = aiService,
        super(const AIChatState()) {
    on<SendMessage>(_onSendMessage);
    on<ClearChat>(_onClearChat);
  }

  Future<void> _onSendMessage(
    SendMessage event,
    Emitter<AIChatState> emit,
  ) async {
    try {
      // Adiciona a mensagem do usuário
      final userMessage = ChatMessage(
        text: event.message,
        isUser: true,
        timestamp: DateTime.now(),
      );

      emit(state.copyWith(
        messages: List.from(state.messages)..add(userMessage),
        isLoading: true,
        error: null,
      ));

      // Gera a resposta da IA
      final response = await _aiService.generateChatResponse(
        message: event.message,
        userProfile: event.userProfile,
        context: state.messages.map((m) => m.text).toList(),
      );

      // Adiciona a resposta da IA
      final aiMessage = ChatMessage(
        text: response,
        isUser: false,
        timestamp: DateTime.now(),
      );

      emit(state.copyWith(
        messages: List.from(state.messages)..add(aiMessage),
        isLoading: false,
      ));
    } catch (e) {
      print('Error in chat bloc: $e');
      emit(state.copyWith(
        isLoading: false,
        error: 'Erro ao gerar resposta. Por favor, tente novamente.',
      ));
    }
  }

  void _onClearChat(ClearChat event, Emitter<AIChatState> emit) {
    emit(const AIChatState());
  }
}