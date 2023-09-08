import 'package:wedding/repositories.dart';

class Checkin extends StatelessWidget {
  const Checkin({super.key});

  @override
  Widget build(BuildContext context) {
    return MVVM<CheckinViewModel>(
      view: () => const _View(),
      viewModel: CheckinViewModel(),
    );
  }
}

class _View extends StatelessView<CheckinViewModel> {
  const _View({key}) : super(key: key, reactive: true);

  @override
  Widget render(context, viewModel) {
    return Scaffold(
      backgroundColor: IColors.pinkBackground,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SpGrid(
              width: MediaQuery.of(context).size.width,
              children: [
                SpGridItem(
                  xs: 0,
                  sm: 3,
                  md: 3,
                  lg: 3,
                  child: Image.asset('assets/images/left.png'),
                ),
                SpGridItem(
                  padding: EdgeInsets.symmetric(
                    horizontal: edgeByWidth(
                      context: context,
                      xs: 65,
                      sm: 65,
                      md: 30,
                      lg: 20,
                      xl: 20,
                    ),
                  ),
                  xs: 12,
                  sm: 6,
                  md: 6,
                  lg: 6,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 20,
                              bottom: 40,
                              left: 10,
                              right: 10,
                            ),
                            child: ClipOval(
                              child: Image.asset(
                                'assets/images/client.png',
                                fit: BoxFit.cover,
                                width: 150,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Image.asset(
                              'assets/images/component-9.png',
                              fit: BoxFit.fitWidth,
                              width: 340,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        'Muhammad Syauqi Alsunni, S.Sos.',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headline3!.copyWith(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w400),
                      ),
                      Text(
                        '&',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headline3!.copyWith(
                            color: IColors.pink50,
                            fontSize: 24,
                            fontWeight: FontWeight.w400),
                      ),
                      Text(
                        'Puti Kayo Gebriecya, B.Sc.',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headline3!.copyWith(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ),
                SpGridItem(
                  xs: 0,
                  sm: 3,
                  md: 3,
                  lg: 3,
                  child: Image.asset('assets/images/right.png'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            SpGrid(
              alignment: WrapAlignment.center,
              width: MediaQuery.of(context).size.width,
              children: [
                SpGridItem(
                  xs: 12,
                  sm: 6,
                  md: 6,
                  lg: 6,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Siapa saja yang hadir?',
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            color: Colors.black,
                            fontSize: 28,
                            fontWeight: FontWeight.w400),
                      ),
                      Wrap(
                        children: [
                          for (var i = 0; i < viewModel.members.length; i++)
                            Padding(
                              padding: const EdgeInsets.only(right: 16, top: 8),
                              child: Chip(
                                label: Text(
                                    '${viewModel.members[i].memberNickname} ${viewModel.members[i].memberName}'),
                                onDeleted: () {
                                  viewModel
                                      .deleteFromMember(viewModel.members[i]);
                                },
                                deleteIcon: const Icon(
                                  Icons.close_rounded,
                                  size: 16,
                                ),
                                deleteIconColor: Colors.black,
                                backgroundColor: IColors.pink50_,
                                labelStyle: Theme.of(context)
                                    .textTheme
                                    .bodyText2!
                                    .copyWith(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w400),
                              ),
                            ),
                        ],
                      ),
                      Visibility(
                          visible: viewModel.memberAbsent.isNotEmpty,
                          child: const SizedBox(height: 24)),
                      Visibility(
                        visible: viewModel.memberAbsent.isNotEmpty,
                        child: Text(
                          'Tidak Hadir',
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(
                                  color: Colors.black,
                                  fontSize: 28,
                                  fontWeight: FontWeight.w400),
                        ),
                      ),
                      Visibility(
                        visible: viewModel.memberAbsent.isNotEmpty,
                        child: Wrap(
                          children: [
                            for (var i = 0;
                                i < viewModel.memberAbsent.length;
                                i++)
                              Padding(
                                padding:
                                    const EdgeInsets.only(right: 16, top: 8),
                                child: Chip(
                                  label: Text(
                                      '${viewModel.memberAbsent[i].memberNickname} ${viewModel.memberAbsent[i].memberName}'),
                                  onDeleted: () {
                                    viewModel.deleteFromAbsent(
                                        viewModel.memberAbsent[i]);
                                  },
                                  deleteIcon: const Icon(
                                    Icons.add_rounded,
                                    size: 16,
                                  ),
                                  deleteIconColor: Colors.black,
                                  backgroundColor: IColors.pink50_,
                                  labelStyle: Theme.of(context)
                                      .textTheme
                                      .bodyText2!
                                      .copyWith(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w400),
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                        height: 50,
                        child: ButtonPrimary(
                          text: 'Simpan Presensi',
                          onPressed: () => viewModel.savePresensi(),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Selanjutnya foto selfi, harap bersiap setelah 5 detik',
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                      ),
                      const SizedBox(height: 56),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
