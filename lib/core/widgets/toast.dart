import 'package:bot_toast/bot_toast.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:universal_io/io.dart';

import '../constants/color_constants.dart';

enum ToastStatus { success, info, alert, error }

class Toast {
  static void show({
    required ToastStatus status,
    required String message,
    IconData? customIcon,
    Color? customBackgroundColor,
    Color? customTextColor,
    Color? customIconColor,
    Alignment? align,
    Function()? onTap,
  }) {
    final Color bgColor = buildBackgroundColor(status, customBackgroundColor);
    final Color textColor = customTextColor ?? Colors.white;
    final Color iconColor = customIconColor ?? Colors.white;
    final IconData icon = buildIcon(status, customIcon);

    BotToast.showCustomNotification(
      toastBuilder: (cancelFunc) => toastBuilder(
        status: status,
        message: message,
        bgColor: bgColor,
        icon: icon,
        iconColor: iconColor,
        textColor: textColor,
        onTap: onTap,
      ),
      animationDuration: const Duration(milliseconds: 200),
      animationReverseDuration: const Duration(milliseconds: 200),
      duration: const Duration(seconds: 3),
      crossPage: true,
      enableSlideOff: true,
      backButtonBehavior: BackButtonBehavior.close,
      align: align ?? Alignment.bottomCenter,
      onlyOne: true,
    );
  }

  static GestureDetector toastBuilder({
    required status,
    required message,
    required bgColor,
    required icon,
    required iconColor,
    required textColor,
    Function()? onTap,
  }) {
    return GestureDetector(
      onTap: onTap ??
          () {
            if (status == ToastStatus.error || status == ToastStatus.alert) {
              Clipboard.setData(ClipboardData(text: message));
              clipboardCopy();
            }
          },
      child: Container(
        margin: const EdgeInsets.all(16),
        constraints: const BoxConstraints(maxWidth: 700),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12.0),
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, color: iconColor, size: 24),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: TextStyle(color: textColor, fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static void textToast(String message) {
    BotToast.showText(text: message);
  }

  static Future<void> clipboardCopy() async {
    final shouldRemoveCopyToast = await isAndroidSdkAbove32();
    if (shouldRemoveCopyToast) {
      return;
    } else {
      BotToast.showText(text: 'Copied to Clipboard');
    }
  }

  static Future<bool> isAndroidSdkAbove32() async {
    if (!kIsWeb && Platform.isAndroid) {
      final AndroidDeviceInfo androidInfo =
          await DeviceInfoPlugin().androidInfo;
      final int androidSdkVersion = androidInfo.version.sdkInt;
      return androidSdkVersion > 32;
    }
    return false;
  }

  static Color buildBackgroundColor(
      ToastStatus status, Color? customBackgroundColor) {
    if (customBackgroundColor != null) {
      return customBackgroundColor;
    }
    switch (status) {
      case ToastStatus.success:
        return successColor;
      case ToastStatus.info:
        return infoColor;
      case ToastStatus.alert:
        return alertColor;
      case ToastStatus.error:
        return failureColor;
    }
  }

  static IconData buildIcon(ToastStatus status, IconData? customIcon) {
    if (customIcon != null) {
      return customIcon;
    }
    switch (status) {
      case ToastStatus.success:
        return MdiIcons.checkCircle;
      case ToastStatus.info:
        return MdiIcons.information;
      case ToastStatus.alert:
        return MdiIcons.alertCircle;
      case ToastStatus.error:
        return MdiIcons.closeCircle;
    }
  }
}
