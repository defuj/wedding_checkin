import 'dart:io';
import 'dart:math' as math;
import 'package:camera/camera.dart';
import 'package:wedding/repositories.dart';

class CameraView extends StatelessWidget {
  final List<CameraDescription> cameras;
  const CameraView({super.key, required this.cameras});

  @override
  Widget build(BuildContext context) {
    return MVVM<CameraViewModel>(
      view: () => const _View(),
      viewModel: CameraViewModel(cameras),
    );
  }
}

class _View extends StatelessView<CameraViewModel> {
  const _View({key}) : super(key: key, reactive: true);

  @override
  Widget render(context, viewModel) {
    return Scaffold(
      //   backgroundColor: const Color(0xff1E1E1E),
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          viewModel.imagePath == null
              ? viewModel.isCameraReady
                  ? CameraScreen(viewModel: viewModel)
                  : const Center(
                      child: CircularProgressIndicator(
                        color: IColors.pink50,
                      ),
                    )
              : Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.rotationY(math.pi),
                  child: Image.file(File(viewModel.imagePath!.path),
                      fit: BoxFit.cover, width: double.infinity),
                ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Visibility(
                  visible: !viewModel.isCapturing,
                  child: Text(
                    viewModel.capturing,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(color: Colors.white),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  margin: const EdgeInsets.only(bottom: 24),
                  width: 62,
                  height: 62,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xff1E1E1E),
                    border: Border.fromBorderSide(
                      BorderSide(color: Colors.white, width: 4),
                    ),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      backgroundColor: Colors.white,
                    ),
                    onPressed:
                        viewModel.isCapturing ? () {} : viewModel.takePicture,
                    child: Container(),
                  ),
                ),
              ],
            ),
          ),
          Visibility(
            visible: viewModel.isCapturing,
            child: Center(
              child: Text(
                viewModel.capturing,
                style: Theme.of(context).textTheme.headline2!.copyWith(
                    color: Colors.white,
                    fontSize: 120,
                    fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
