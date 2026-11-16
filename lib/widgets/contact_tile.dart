import 'package:flutter/material.dart';

import '../models/contact.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import 'contact_avatar.dart';

class ContactTile extends StatelessWidget {
  const ContactTile({
    super.key,
    required this.contact,
    required this.locked,
    required this.completed,
    required this.inProgress,
    required this.preview,
    required this.onTap,
  });

  final Contact contact;
  final bool locked;
  final bool completed;
  final bool inProgress;
  final String preview;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final TextStyle nameStyle = AppTheme.name.copyWith(
      color: locked ? AppColors.muted : AppColors.ink,
    );

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 14, 20, 14),
        child: Row(
          children: <Widget>[
            ContactAvatar(contact: contact, dimmed: locked),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Flexible(
                        child: Text(
                          contact.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: nameStyle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        contact.isReference
                            ? 'CONSULTA'
                            : inProgress && !locked
                            ? 'EM ANDAMENTO'
                            : 'FASE ${(contact.order + 1).toString().padLeft(2, '0')}',
                        style: AppTheme.overline.copyWith(
                          fontSize: 8.5,
                          letterSpacing: 1.4,
                          color: contact.isReference
                              ? AppColors.terracotta
                              : inProgress && !locked
                              ? AppColors.terracotta
                              : locked
                              ? AppColors.muted.withValues(alpha: 0.75)
                              : AppColors.muted,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: <Widget>[
                      if (contact.isGroup && !locked) ...<Widget>[
                        const Icon(
                          Icons.groups_2_outlined,
                          size: 13,
                          color: AppColors.muted,
                        ),
                        const SizedBox(width: 5),
                      ],
                      Expanded(
                        child: Text(
                          locked
                              ? 'Bloqueada · conclua a fase anterior'
                              : preview,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTheme.preview.copyWith(
                            color: locked
                                ? AppColors.muted.withValues(alpha: 0.8)
                                : AppColors.muted,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            if (locked)
              const Icon(
                Icons.lock_outline_rounded,
                size: 19,
                color: AppColors.muted,
              )
            else if (completed)
              const Icon(
                Icons.check_circle_outline_rounded,
                size: 19,
                color: AppColors.olive,
              )
            else
              Icon(
                Icons.chevron_right_rounded,
                size: 21,
                color: inProgress || contact.isReference
                    ? AppColors.terracotta
                    : AppColors.muted,
              ),
          ],
        ),
      ),
    );
  }
}
