import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../common/sessions.dart';
import '../../routes/routes.dart';
import '../../common/styles.dart';
import 'dots_indicator.dart';
import 'intro_item.dart';

class IntroPage extends StatefulWidget {
  final String namePage;
  const IntroPage({Key? key, required this.namePage}) : super(key: key);

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  final _pageController = PageController();
  final List<Widget> _listPage = [
    const IntroItem(
      image: 'assets/svg/wizard1.svg',
      largeText: 'Superb App Theme',
      smallText:
          'Lorem Ipsum is simply dummy text of \nthe printing and typesetting industry.',
    ),
    const IntroItem(
      image: 'assets/svg/wizard2.svg',
      largeText: 'For Developers',
      smallText:
          'Lorem Ipsum is simply dummy text of \nthe printing and typesetting industry.',
    ),
    const IntroItem(
      image: 'assets/svg/wizard3.svg',
      largeText: 'And Designers',
      smallText:
          'Lorem Ipsum is simply dummy text of \nthe printing and typesetting industry.',
    )
  ];

  int _curentPage = 0;

  @override
  void initState() {
    super.initState();
  }

  widgetSkip() {
    return Container(
      width: MediaQuery.of(context).size.width / 4,
      alignment: Alignment.center,
      child: _curentPage < _listPage.length - 1
          ? TextButton(
              onPressed: () async {
                HapticFeedback.heavyImpact();
                await Sessions.setTheFirst(false);
                Navigator.pushAndRemoveUntil(
                    context,
                    PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            Routes.loginPage),
                    (Route<dynamic> route) => false);
              },
              child: const Text('Skip',
                  style: TextStyle(
                      color: Styles.lightTextColor,
                      fontSize: Styles.f14,
                      fontWeight: Styles.lightFontWeight,
                      decoration: TextDecoration.underline,
                      fontStyle: FontStyle.italic)),
            )
          : Container(),
    );
  }

  widgetNext() {
    return Container(
      width: MediaQuery.of(context).size.width / 4,
      alignment: Alignment.center,
      child: TextButton(
        onPressed: () {
          HapticFeedback.heavyImpact();
          _pageController.animateToPage(_curentPage + 1,
              duration: const Duration(milliseconds: 300), curve: Curves.ease);
        },
        child: const Text('Next',
            style: TextStyle(
                color: Styles.lightTextColor,
                fontSize: Styles.f14,
                fontWeight: Styles.lightFontWeight,
                decoration: TextDecoration.underline,
                fontStyle: FontStyle.italic)),
      ),
    );
  }

  widgetDone() {
    return Container(
      width: MediaQuery.of(context).size.width / 4,
      alignment: Alignment.center,
      child: TextButton(
        onPressed: () async {
          HapticFeedback.heavyImpact();
          await Sessions.setTheFirst(false);
          Navigator.pushAndRemoveUntil(
              context,
              PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      Routes.loginPage),
              (Route<dynamic> route) => false);
        },
        child: const Text('Done',
            style: TextStyle(
                color: Styles.lightTextColor,
                fontSize: Styles.f14,
                fontWeight: Styles.lightFontWeight,
                decoration: TextDecoration.underline,
                fontStyle: FontStyle.italic)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: const BoxDecoration(gradient: Styles.gradient),
          ),
          Positioned.fill(
              child: PageView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            controller: _pageController,
            itemCount: _listPage.length,
            itemBuilder: (BuildContext context, int index) {
              return _listPage[index % _listPage.length];
            },
            onPageChanged: (int page) {
              _curentPage = page;
              setState(() {});
            },
          )),
          Positioned(
              bottom: 30.0,
              left: 10.0,
              right: 10.0,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  widgetSkip(),
                  Flexible(
                      child: DotsIndicator(
                          controller: _pageController,
                          itemCount: _listPage.length,
                          onPageSelected: (int page) {
                            _pageController.animateToPage(
                              page,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.ease,
                            );
                          })),
                  _curentPage == _listPage.length - 1
                      ? widgetDone()
                      : widgetNext()
                ],
              ))
        ],
      ),
    );
  }
}
