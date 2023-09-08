import 'package:wedding/repositories.dart';

class Success extends StatelessWidget {
  const Success({super.key});

  @override
  Widget build(BuildContext context) {
    return MVVM<SuccessViewModel>(
      view: () => const _View(),
      viewModel: SuccessViewModel(),
    );
  }
}

class _View extends StatelessView<SuccessViewModel> {
  const _View({key}) : super(key: key, reactive: true);

  @override
  Widget render(context, viewModel) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Stack(
          children: [
            Lottie.asset(
              'assets/animations/success_wedding.json',
              width: MediaQuery.of(context).size.width,
              repeat: true,
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      viewModel.userName,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          color: IColors.pink50,
                          fontSize: 48,
                          fontWeight: FontWeight.w400),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Terimakasih telah menghadiri pernikahan kami',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          fontSize: 28,
                          color: Colors.black,
                          fontWeight: FontWeight.w400),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Best Regards,',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyText2!.copyWith(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.w400),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'M.Syauqi & Puti Kayo',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline3!.copyWith(
                          color: IColors.pink50,
                          fontSize: 32,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
