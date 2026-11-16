import 'package:flutter/material.dart';

import '../models/contact.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';

/// Avatar circular com o retrato do personagem. Grupos sem retrato próprio
/// montam um mosaico com os participantes. Sem imagem, voltam as iniciais.
class ContactAvatar extends StatelessWidget {
  const ContactAvatar({
    super.key,
    required this.contact,
    this.size = 52,
    this.dimmed = false,
  });

  final Contact contact;
  final double size;
  final bool dimmed;

  @override
  Widget build(BuildContext context) {
    final List<String> portraits = <String>[
      if (contact.avatarAsset != null) contact.avatarAsset!,
      if (contact.avatarAsset == null)
        for (final ChatParticipant participant in contact.participants)
          if (participant.avatarAsset != null) participant.avatarAsset!,
    ];

    final Color background = dimmed
        ? AppColors.paperDeep
        : contact.isGroup
        ? AppColors.terracottaWash
        : AppColors.paper;

    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: background,
        shape: BoxShape.circle,
        border: Border.all(
          color: dimmed
              ? AppColors.line
              : AppColors.line.withValues(alpha: 0.9),
          width: 1,
        ),
      ),
      child: portraits.isEmpty
          ? _Initials(contact: contact, size: size, dimmed: dimmed)
          : Opacity(
              opacity: dimmed ? 0.42 : 1,
              child: portraits.length == 1
                  ? Image.asset(
                      portraits.first,
                      width: size,
                      height: size,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => _Initials(
                        contact: contact,
                        size: size,
                        dimmed: dimmed,
                      ),
                    )
                  : _GroupPortraits(portraits: portraits),
            ),
    );
  }
}

class _Initials extends StatelessWidget {
  const _Initials({
    required this.contact,
    required this.size,
    required this.dimmed,
  });

  final Contact contact;
  final double size;
  final bool dimmed;

  @override
  Widget build(BuildContext context) {
    final Color foreground = dimmed
        ? AppColors.muted
        : contact.isGroup
        ? AppColors.terracottaDark
        : AppColors.ink;

    return Text(
      contact.avatarLabel,
      style: TextStyle(
        fontFamily: AppTheme.headingFont,
        fontSize: size * 0.33,
        height: 1,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.2,
        color: foreground,
      ),
    );
  }
}

/// Mosaico de retratos: dois lado a lado ou dois em cima e um embaixo.
class _GroupPortraits extends StatelessWidget {
  const _GroupPortraits({required this.portraits});

  final List<String> portraits;

  @override
  Widget build(BuildContext context) {
    final List<String> shown = portraits.take(3).toList(growable: false);

    if (shown.length == 2) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(child: _portrait(shown[0])),
          Container(width: 1.5, color: AppColors.paper),
          Expanded(child: _portrait(shown[1])),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(child: _portrait(shown[0])),
              Container(width: 1.5, color: AppColors.paper),
              Expanded(child: _portrait(shown[1])),
            ],
          ),
        ),
        Container(height: 1.5, color: AppColors.paper),
        Expanded(child: _portrait(shown[2])),
      ],
    );
  }

  Widget _portrait(String asset) => Image.asset(
    asset,
    fit: BoxFit.cover,
    errorBuilder: (_, _, _) => const ColoredBox(color: AppColors.paperDeep),
  );
}
