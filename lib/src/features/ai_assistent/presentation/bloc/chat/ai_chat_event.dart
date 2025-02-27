import 'package:equatable/equatable.dart';

import '../../../../features.dart';

abstract class AIChatEvent extends Equatable {
  const AIChatEvent();

  @override
  List<Object?> get props => [];
}

class SendMessage extends AIChatEvent {
  final String message;
  final UserProfile userProfile;

  const SendMessage({
    required this.message,
    required this.userProfile,
  });

  @override
  List<Object?> get props => [message, userProfile];
}

class ClearChat extends AIChatEvent {}