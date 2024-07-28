import 'package:flutter/material.dart';

import '../widgets/generic_hold_to_perform_button.dart';

class Alert {
  /// Shows a confirmation dialog with a `YES` or `NO` option by default. Needs a [context], `String` [title], and `String` [body]
  static Future<bool?> confirmationDialog({
    required BuildContext context,
    required String title,
    required String body,
    String bodySecondary = '',
    bool isNegativeDestructive = false,
    bool dismissible = false,
    Color? positiveColor,
    Widget? widgetBody,
    Function? onPressPositive,
    Function? onPressNegative,
    Function? onPressDestructive,
    String positiveLbl = 'YES',
    String negativeLbl = 'NO',
    String destructiveLbl = 'DISCARD',
    TextStyle? titleStyle,
    TextStyle? bodyStyle,
    TextStyle? negativeLblStyle,
    TextStyle? positiveLblStyle,
    bool hidePositive = false,
    bool hideNegative = false,
  }) async {
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            title,
            style: titleStyle ??
                TextStyle(
                  fontSize: 18,
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w600,
                ),
          ),
          contentPadding:
              body.isNotEmpty || bodySecondary.isNotEmpty || widgetBody != null
                  ? null
                  : EdgeInsets.zero,
          content: body.isNotEmpty ||
                  bodySecondary.isNotEmpty ||
                  widgetBody != null
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (body.isNotEmpty) Text(body),
                    if (bodySecondary.isNotEmpty) const SizedBox(height: 24),
                    if (bodySecondary.isNotEmpty)
                      Text(
                        bodySecondary,
                        style: bodyStyle ??
                            const TextStyle(fontStyle: FontStyle.italic),
                      ),
                    if (widgetBody != null) widgetBody,
                  ],
                )
              : null,
          actions: <Widget>[
            if (onPressDestructive != null)
              GenericHoldToPerformButton(
                  label: destructiveLbl,
                  onConfirm: () {
                    Navigator.pop(context, true);
                    onPressDestructive();
                  }),
            if (!hideNegative)
              TextButton(
                style: isNegativeDestructive
                    ? TextButton.styleFrom(foregroundColor: Colors.red.shade500)
                    : null,
                child: Text(
                  negativeLbl.toUpperCase(),
                  style: negativeLblStyle ??
                      TextStyle(
                        color: isNegativeDestructive
                            ? Colors.red.shade500
                            : Colors.grey.shade800,
                        fontWeight: FontWeight.w400,
                      ),
                ),
                onPressed: () {
                  Navigator.pop(context, false);

                  if (onPressNegative != null) {
                    onPressNegative();
                  }
                },
              ),
            if (!hidePositive)
              TextButton(
                child: Text(
                  positiveLbl.toUpperCase(),
                  style: positiveLblStyle ??
                      TextStyle(
                        color: positiveColor ?? Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                onPressed: () {
                  Navigator.pop(context, true);

                  if (onPressPositive != null) {
                    onPressPositive();
                  }
                },
              ),
          ],
        );
      },
    );
  }
}
