import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:pfe_app/consts/colors.dart';
import 'package:pfe_app/consts/images.dart';
import 'package:flutter/services.dart';
import 'package:pfe_app/views/auth_screen/login_screen.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  double scrollerPosition = 0;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    //final locationData = Provider.of<LocationProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: whiteColor,
      body: Stack(
        children: [
          PageView(
            onPageChanged: (val) {
              setState(() {
                scrollerPosition = val.toDouble();
              });
            },
            children: [
              OnBoardPage(
                boardColumn: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Welcome \n To Shop App',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: whiteColor,
                          fontSize: 32),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      '+10 Million Products\n+100 Categories\n+20 Brands',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: golden,
                          fontSize: 28),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                        height: 300, width: 300, child: Image.asset(onboard1)),
                  ],
                ),
              ),
              OnBoardPage(
                boardColumn: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      '7 - 14 Days Return',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: whiteColor,
                          fontSize: 32),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      'Satisfaction Guaranteed',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: whiteColor,
                          fontSize: 24),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                        height: 300, width: 300, child: Image.asset(onboard6)),
                  ],
                ),
              ),
              OnBoardPage(
                boardColumn: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Find your Favourite Products',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: whiteColor,
                          fontSize: 32),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                        height: 300, width: 300, child: Image.asset(onboard2)),
                  ],
                ),
              ),
              OnBoardPage(
                boardColumn: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Experience Smart Shopping',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: whiteColor,
                          fontSize: 32),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                        height: 300, width: 300, child: Image.asset(onboard3)),
                  ],
                ),
              ),
              // OnBoardPage(
              //   boardColumn: Column(
              //     mainAxisSize: MainAxisSize.min,
              //     children: [
              //       const Text(
              //         'Safe & Secure\nPayments',
              //         textAlign: TextAlign.center,
              //         style: TextStyle(
              //             fontWeight: FontWeight.bold,
              //             color: whiteColor,
              //             fontSize: 32),
              //       ),
              //       const SizedBox(
              //         height: 20,
              //       ),
              //       SizedBox(
              //           height: 300, width: 300, child: Image.asset(onboard5)),
              //     ],
              //   ),
              // ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DotsIndicator(
                  dotsCount: 4,
                  position: scrollerPosition,
                  decorator: const DotsDecorator(
                    activeColor: whiteColor,
                  ),
                ),
                scrollerPosition == 3
                    ? Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(redColor),
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginScreen(),
                                ));
                          },
                          child: const Text('Start Shopping'),
                        ),
                      )
                    : TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
                              ));
                        },
                        child: const Text(
                          'SKIP TO THE APP >',
                          style: TextStyle(
                            fontSize: 20,
                            color: whiteColor,
                          ),
                        ),
                      ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class OnBoardPage extends StatelessWidget {
  //const OnBoardPage({Key? key}) : super(key: key);
  //final Image? boardImage;
  final Column? boardColumn;
  const OnBoardPage({Key? key, this.boardColumn}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: redColor,
          child: Center(child: boardColumn),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 120,
            decoration: const BoxDecoration(
              color: fontGrey,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(100),
                topRight: Radius.circular(100),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
