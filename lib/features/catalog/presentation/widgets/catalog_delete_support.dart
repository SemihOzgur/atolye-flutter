import 'package:flutter/material.dart';

import '../../../../core/network/api_exception.dart';

/// Standard "Sil?" confirmation dialog shared by every catalog tab.
///
/// Frontend never knows in advance whether the backend will allow the
/// delete (children / usage in past work orders), so the copy stays
/// neutral — no promise that the record can definitely be removed.
Future<bool> confirmCatalogDelete(
  BuildContext context, {
  required String title,
  required String message,
}) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(false),
          child: const Text('Vazgeç'),
        ),
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(true),
          child: const Text('Sil'),
        ),
      ],
    ),
  );
  return confirmed == true;
}

/// Maps a DELETE failure's `errorCode` to a Turkish, user-facing message
/// and — when the backend rejected the delete because the record is in
/// use (`*_IN_USE`) — offers a one-tap alternative: soft-delete via the
/// existing `PUT .../{id}` `isActive=false` path.
///
/// `deactivate` must be non-null only when the given error is a genuine
/// "in use" conflict for which a deactivate alternative makes sense
/// (e.g. not `CATEGORY_HAS_CHILDREN`, where the fix is to the children).
Future<void> handleCatalogDeleteConflict({
  required BuildContext context,
  required ApiException error,
  required Map<String, String> messages,
  Future<void> Function()? deactivate,
  String deactivateSuccessMessage = 'Kayıt pasif hale getirildi.',
}) async {
  final code = error.errorCode;
  final message = (code != null ? messages[code] : null) ?? error.detail ?? error.message;

  if (deactivate != null) {
    final choice = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Silinemedi'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Vazgeç'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Pasif Hale Getir'),
          ),
        ],
      ),
    );

    if (choice == true && context.mounted) {
      try {
        await deactivate();
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(deactivateSuccessMessage)),
          );
        }
      } on ApiException catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.detail ?? e.message)),
          );
        }
      }
    }
    return;
  }

  if (context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}
