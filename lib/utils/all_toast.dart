import 'package:flutter/cupertino.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';

class AllToast {
  static void showSuccessToast(
      BuildContext context, String title, String content) {
    MotionToast.success(
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      description: Text(
        content,
        style: const TextStyle(fontSize: 12),
      ),
      layoutOrientation: ORIENTATION.rtl,
      animationType: ANIMATION.fromRight,
      dismissable: true,
      width: 300,
    ).show(context);
  }

  static void showWarningToast(
      BuildContext context, String title, String content) {
    MotionToast.warning(
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      description: Text(
        content,
        style: const TextStyle(fontSize: 12),
      ),
      layoutOrientation: ORIENTATION.rtl,
      animationType: ANIMATION.fromRight,
      dismissable: true,
      width: 300,
    ).show(context);
  }

  static void showDangerousToast(
      BuildContext context, String title, String content) {
    MotionToast.error(
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      description: Text(
        content,
        style: const TextStyle(fontSize: 12),
      ),
      layoutOrientation: ORIENTATION.rtl,
      animationType: ANIMATION.fromRight,
      dismissable: true,
      width: 300,
    ).show(context);
  }

  static void showInfoToast(
      BuildContext context, String title, String content) {
    MotionToast.info(
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      description: Text(
        content,
        style: const TextStyle(fontSize: 12),
      ),
      layoutOrientation: ORIENTATION.rtl,
      animationType: ANIMATION.fromRight,
      dismissable: true,
      width: 300,
    ).show(context);
  }
}
