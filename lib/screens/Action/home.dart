import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import '/screens/AccountManage/Login.dart';
import '/components/controller.dart';
import 'package:lottie/lottie.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final Gradient gradient1 = const LinearGradient(
    colors: [Colors.blueAccent, Colors.lightBlueAccent],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  final Gradient gradient2 = const LinearGradient(
    colors: [Colors.purpleAccent, Colors.deepPurpleAccent],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          LiquidSwipe(
            pages: [
              _buildPage(
                  context, gradient1, tr('home_button1'), tr('home_title5')),
              _buildPage(
                  context, gradient2, tr('home_button2'), tr('home_title6')),
            ],
            fullTransitionValue: 600,
            enableLoop: true,
            waveType: WaveType.liquidReveal,
            positionSlideIcon: 0.5,
            onPageChangeCallback: (page) {
              setState(() {
              });
            },
          ),
          const Positioned(
            top: 70, 
            left: 16,
            child: Row(
              children: [
                Icon(
                  Icons.school,
                  color: Colors.white,
                  size: 28,
                ),
                SizedBox(width: 8),
                Text(
                  'StudentHub',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPage(BuildContext context, Gradient gradient, String buttonText,
      String swipeText) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final lottieAsset = isDarkMode
        ? 'assets/animation/Lottie_black.json'
        : 'assets/animation/Lottie_white.json';

    return Container(
      decoration: BoxDecoration(
        gradient: gradient,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 50),
            _buildTextColumn(
              title: tr('home_title1'),
              subtitle: tr('home_title2'),
              textColor: Colors.white,
            ),
            const SizedBox(height: 20),
            Container(
              child: Lottie.asset(
                lottieAsset,
                height: 300,
                repeat: true,
                reverse: true,
              ),
            ),
            const SizedBox(height: 20),
            _buildElevatedButton(
              buttonText,
              () {
                moveToPage(Login(), context);
              },
            ),
            const SizedBox(height: 20),
            Text(
              swipeText,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 16.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Column _buildTextColumn(
      {required String title,
      required String subtitle,
      required Color textColor}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: textColor,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            color: textColor,
          ),
        ),
      ],
    );
  }

  ElevatedButton _buildElevatedButton(String text, VoidCallback onPressed) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16.0,
        ),
      ),
    );
  }
}
