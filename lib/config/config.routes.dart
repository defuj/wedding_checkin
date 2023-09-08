import 'package:wedding/repositories.dart';

var getRoutes = [
  GetPage(
    name: '/checkin',
    page: () => const Checkin(),
    transition: Transition.cupertino,
  ),
  GetPage(
    name: '/scan',
    page: () => const ScanQR(),
    transition: Transition.cupertino,
  ),
  GetPage(
    name: '/splash',
    page: () => const Splash(),
    transition: Transition.cupertino,
  ),
  GetPage(
    name: '/success',
    page: () => const Success(),
    transition: Transition.cupertino,
  ),
];
