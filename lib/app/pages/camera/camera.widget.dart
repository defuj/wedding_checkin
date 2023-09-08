import 'package:camera/camera.dart';
import 'package:wedding/repositories.dart';

class CameraScreen extends StatelessWidget {
  final CameraViewModel? viewModel;
  const CameraScreen({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: 1.5,
      child: OverflowBox(
        alignment: Alignment.center,
        child: FittedBox(
          fit: BoxFit.cover,
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: [
                CameraPreview(viewModel!.controller!),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
