import 'package:code_scan/code_scan.dart';
import 'package:wedding/repositories.dart';

class ScanQR extends StatelessWidget {
  const ScanQR({super.key});

  @override
  Widget build(BuildContext context) {
    return MVVM<ScanViewModel>(
      view: () => const _View(),
      viewModel: ScanViewModel(),
    );
  }
}

class _View extends StatelessView<ScanViewModel> {
  const _View({key}) : super(key: key, reactive: true);

  @override
  Widget render(context, viewModel) {
    return Scaffold(
      backgroundColor: Colors.black,
      //   body: CodeScanner(
      //     controller: viewModel.controller,
      //     direction: CameraLensDirection.front,
      //     resolution: ResolutionPreset.high,
      //     onScan: (code, details, listener) {
      //       if (!viewModel.isChecking) {
      //         viewModel.isChecking = true;
      //         viewModel.checkQR(code!);
      //       }
      //     },
      //     formats: const [BarcodeFormat.all],
      //     once: false,
      //     onCreated: (controller) {
      //       viewModel.controller = controller;
      //     },
      //     aspectRatio: MediaQuery.of(context).size.aspectRatio,
      //     onError: (object, cameraListener) {
      //       log(object.toString());
      //     },
      //     onScanAll: (codes, controller) =>
      //         log('Codes: ${codes.map((code) => code.rawValue)}'),
      //     overlay: const CodeScannerOverlay(400, 400),
      //   ),
      body: viewModel.isInitializeDone
          ? CodeScannerCameraView(
              controller: viewModel.controller,
              overlay: const CodeScannerOverlay(400, 400),
              aspectRatio: MediaQuery.of(context).size.aspectRatio,
            )
          : const Center(
              child: CircularProgressIndicator(
                color: IColors.pink50,
              ),
            ),
    );
  }
}
