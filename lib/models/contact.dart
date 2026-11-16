enum ChatKind { direct, group }

class ChatParticipant {
  const ChatParticipant({
    required this.name,
    required this.initials,
    this.avatarAsset,
  });

  final String name;
  final String initials;

  /// Retrato usado nos avatares de grupo.
  final String? avatarAsset;

  String get firstName {
    final List<String> parts = name.split(' ');
    const Set<String> honorifics = <String>{
      'tia',
      'tio',
      'seu',
      'dona',
      'sr.',
      'sra.',
      'dr.',
      'dra.',
      'prof.',
      'profa.',
    };
    if (parts.length > 1 && honorifics.contains(parts.first.toLowerCase())) {
      return parts[1];
    }
    return parts.first;
  }
}

/// Uma fase do jogo: conversa individual ou grupo.
class Contact {
  const Contact({
    required this.id,
    required this.name,
    required this.kind,
    required this.order,
    required this.preview,
    required this.avatarLabel,
    this.avatarAsset,
    this.participants = const <ChatParticipant>[],
    this.unlocksAfter,
    this.isReference = false,
  });

  final String id;
  final String name;
  final ChatKind kind;

  /// Posição da fase, começando em zero.
  final int order;

  /// Prévia exibida na lista de conversas.
  final String preview;

  /// Iniciais usadas no avatar.
  final String avatarLabel;

  /// Retrato do personagem. Grupos sem retrato próprio montam um mosaico
  /// com os retratos dos participantes.
  final String? avatarAsset;

  final List<ChatParticipant> participants;

  /// Id da fase que precisa ser concluída para liberar esta.
  final String? unlocksAfter;

  /// Consulta permanente: acessível desde o início, não conta como fase e
  /// não desbloqueia nada.
  final bool isReference;

  bool get isGroup => kind == ChatKind.group;

  String get kindLabel =>
      isGroup ? '${participants.length} participantes' : 'conversa individual';

  String get participantNames =>
      participants.map((ChatParticipant p) => p.firstName).join(', ');

  /// Retrato de quem enviou a mensagem, usado nos grupos.
  String? avatarAssetFor(String? senderName) {
    if (senderName == null) return avatarAsset;
    for (final ChatParticipant participant in participants) {
      if (participant.name == senderName) return participant.avatarAsset;
    }
    return avatarAsset;
  }
}
