import 'dart:ui';
import 'package:wedding/repositories.dart';

enum SweetDialogType { warning, success, error, info, normal, loading }

class SweetDialog extends AlertDialog {
  final BuildContext context;
  final bool barrierDismissible;
  final dynamic dialogType;

  SweetDialog({
    Key? key,
    required this.context,
    String title = '',
    Widget? titleWidget,
    String content = '',
    Widget? contentWidget,
    this.barrierDismissible = true,
    this.dialogType = 'normal',
    String cancelText = '',
    String confirmText = 'Oke',
    String neutralText = '',
    Function()? onCancel,
    Function()? onConfirm,
    Function()? onNeutral,
  }) : super(
          key: key ?? UniqueKey(),
          insetPadding: const EdgeInsets.all(45),
          backgroundColor: Colors.white,
          actionsPadding: const EdgeInsets.all(0),
          actionsOverflowDirection: VerticalDirection.up,
          actionsAlignment: MainAxisAlignment.center,
          actionsOverflowButtonSpacing: 0,
          contentPadding: const EdgeInsets.only(
            top: 16,
            bottom: 24,
            left: 16,
            right: 16,
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16.0)),
          ),
          buttonPadding: const EdgeInsets.all(0),
          title: Column(
            children: [
              if (dialogType.toString() == SweetDialogType.success.toString())
                Lottie.asset(
                  'assets/animations/success.json',
                  width: 100,
                  height: 100,
                  repeat: false,
                ),
              if (dialogType.toString() == SweetDialogType.warning.toString())
                Lottie.asset(
                  'assets/animations/warning.json',
                  width: 100,
                  height: 100,
                  repeat: false,
                ),
              if (dialogType.toString() == SweetDialogType.error.toString())
                Lottie.asset(
                  'assets/animations/error.json',
                  width: 150,
                  height: 150,
                  repeat: false,
                ),
              titleWidget ??
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        color: IColors.neutral10,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'OpenSans'),
                  ),
            ],
          ),
          content: contentWidget ??
              Text(
                content,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                    color: IColors.neutral20,
                    fontSize: 15,
                    fontFamily: 'OpenSans'),
              ),
          actions: [
            Container(
              clipBehavior: Clip.hardEdge,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(16.0),
                  bottomRight: Radius.circular(16.0),
                ),
              ),
              child: Column(
                children: [
                  // Confirm Button
                  Container(
                    decoration: const BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          color: IColors.neutral95,
                          width: 1,
                        ),
                      ),
                    ),
                    width: double.infinity,
                    height: 50,
                    child: TextButton(
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                        ),
                        splashFactory: NoSplash.splashFactory,
                      ),
                      onPressed: () {
                        Get.back();
                        if (onConfirm == null) return;
                        onConfirm();
                      },
                      child: Text(
                        confirmText,
                        style: Theme.of(context).textTheme.bodyText2!.copyWith(
                              color: dialogType.toString() ==
                                          SweetDialogType.warning.toString() ||
                                      dialogType.toString() ==
                                          SweetDialogType.error.toString()
                                  ? Colors.red[600]
                                  : Colors.blue[500],
                              fontWeight: FontWeight.w700,
                              fontFamily: 'OpenSans',
                            ),
                      ),
                    ),
                  ),
                  // Neutral Button
                  if (neutralText.isNotEmpty)
                    Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            color: IColors.neutral95,
                            width: 1,
                          ),
                        ),
                      ),
                      width: double.infinity,
                      height: 50,
                      child: TextButton(
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            const RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero,
                            ),
                          ),
                          splashFactory: NoSplash.splashFactory,
                        ),
                        onPressed: () {
                          Get.back();
                          if (onNeutral == null) return;
                          onNeutral();
                        },
                        child: Text(
                          neutralText,
                          style:
                              Theme.of(context).textTheme.bodyText2!.copyWith(
                                    color: IColors.neutral20,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'OpenSans',
                                  ),
                        ),
                      ),
                    ),
                  // Cancel Button
                  if (cancelText.isNotEmpty)
                    Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            color: IColors.neutral95,
                            width: 1,
                          ),
                        ),
                      ),
                      width: double.infinity,
                      height: 50,
                      child: TextButton(
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            const RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero,
                            ),
                          ),
                          splashFactory: NoSplash.splashFactory,
                        ),
                        onPressed: () {
                          Get.back();
                          // check if cancel function is null
                          if (onCancel == null) return;
                          onCancel();
                        },
                        child: Text(
                          cancelText,
                          style:
                              Theme.of(context).textTheme.bodyText2!.copyWith(
                                    color: IColors.neutral20,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'OpenSans',
                                  ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        );

  Widget dialog() => Dialog(
        elevation: 0,
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.zero,
        child: Container(
          width: 150,
          height: 150,
          decoration: const BoxDecoration(
            color: Colors.transparent,
          ),
          child: Lottie.asset(
            'assets/animations/loading2.json',
            width: 150,
            height: 150,
            repeat: true,
          ),
        ),
      );

  void show() {
    showGeneralDialog(
        context: context,
        barrierLabel: 'dialog',
        barrierDismissible: barrierDismissible,
        barrierColor: Colors.black.withOpacity(0.3),
        transitionDuration: const Duration(milliseconds: 180),
        transitionBuilder: (context, anim1, anim2, child) {
          return BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 3 * anim1.value,
              sigmaY: 3 * anim1.value,
            ),
            child: Transform.scale(
              scale: anim1.value,
              child: child,
            ),
          );
        },
        pageBuilder: (context, _, __) =>
            dialogType.toString() == SweetDialogType.loading.toString()
                ? dialog()
                : this);
  }

  void dismiss() {
    Navigator.pop(context);
  }
}
