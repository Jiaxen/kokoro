import 'package:flutter/material.dart';
import 'package:kokoro/constants.dart';

class WelcomeStep extends StatefulWidget {
  final Function nextStep;

  const WelcomeStep({
    Key? key,
    required this.nextStep,
  }) : super(key: key);

  @override
  State<WelcomeStep> createState() => _WelcomeStepState();
}

class _WelcomeStepState extends State<WelcomeStep>
    with TickerProviderStateMixin {

  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 4),
    vsync: this,
  );

  late final Animation<double> _animation1 = Tween<double>(
    begin: 0,
    end: 1,
  ).animate(
    CurvedAnimation(
      parent: _controller,
      curve: Interval(
        0.050, 0.150,
        curve: Curves.ease,
      ),
    ),
  );

  late final Animation<double> _animation2 = Tween<double>(
    begin: 0,
    end: 1,
  ).animate(
    CurvedAnimation(
      parent: _controller,
      curve: Interval(
        0.250, 0.400,
        curve: Curves.ease,
      ),
    ),
  );

  late final Animation<double> _animation3 = Tween<double>(
    begin: 0,
    end: 1,
  ).animate(
    CurvedAnimation(
      parent: _controller,
      curve: Interval(
        0.500, 0.650,
        curve: Curves.ease,
      ),
    ),
  );

  late final Animation<double> _animation4 = Tween<double>(
    begin: 0,
    end: 1,
  ).animate(
    CurvedAnimation(
      parent: _controller,
      curve: Interval(
        0.800, 1.000,
        curve: Curves.ease,
      ),
    ),
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildAnimation(BuildContext context, Widget? child){
    return Container(
        alignment: Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Opacity(
              opacity: _animation1.value,
              child: roundedTextBox(
                Text(
                  'Hi there 🤗 !',
                  style: mainTitleStyle(),
                ),
              ),
            ),
            SizedBox(height: 15),
            Opacity(
              opacity: _animation2.value,
              child:             roundedTextBox(
                Text(
                  'Welcome to Kokoro!',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: kPrimaryTitleColour,
                  ),
                ),
              ),
            ),
            SizedBox(height: 15),
            Opacity(
              opacity: _animation3.value,
              child: roundedTextBox(
                Text(
                  'We hope this app will help you\nand your partner to strengthen\n your relationship.',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: kPrimaryTitleColour,
                  ),
                ),
              ),
            ),
            SizedBox(height: 25),
            Opacity(
              opacity: _animation4.value,
              child: Column(
                children: [
                  Center(
                    child: Image(
                      image: AssetImage('images/ReadingCouple.png'),
                      height: 180,
                    ),
                  ),
                  SizedBox(height: 25),
                  Container(
                    alignment: Alignment.bottomRight,
                    child: TextButton(
                        style: roundButtonStyle(
                            kPrimaryTitleColour, kWarningBackgroundColorLight),
                        child: const Text('Get Started 👉'),
                        onPressed: () {
                          widget.nextStep();
                        }),
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    FocusManager.instance.primaryFocus?.unfocus();
    _controller.forward();
    return AnimatedBuilder(
      animation: _controller,
      builder: _buildAnimation,
    );
  }

}