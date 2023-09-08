import 'package:wedding/repositories.dart';

class Splash extends StatelessWidget {
  const Splash({super.key});

  @override
  Widget build(BuildContext context) {
    return MVVM<SplashViewModel>(
      view: () => const _View(),
      viewModel: SplashViewModel(),
    );
  }
}

class _View extends StatelessView<SplashViewModel> {
  const _View({key}) : super(key: key, reactive: true);

  @override
  Widget render(context, viewModel) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/favicon.png',
                width: 150,
              ),
            ],
          ),
        ));
  }
}
