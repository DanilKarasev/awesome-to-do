import 'package:awesome_to_do/core/constants/color_constants.dart';
import 'package:flutter/material.dart';

enum SnackStatus {
  error,
  success,
}

Color mapStatusToColor(SnackStatus? val) {
  switch (val) {
    case SnackStatus.error:
      return failureColor;
    case SnackStatus.success:
    default:
      return successColor;
  }
}

void showSnackBar(
  BuildContext context, {
  required String label,
  SnackStatus? status,
}) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(
          label,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: mapStatusToColor(status),
      ),
    );
}
