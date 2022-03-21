import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kokoro/constants.dart';


class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({Key? key}) : super(key: key);

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryAppColour,
      body: Theme(
        data: ThemeData(
            accentColor: Colors.orange,
            primarySwatch: Colors.orange,
            colorScheme: ColorScheme.light(
                primary: Colors.orange
            )
        ),
        child: Stepper(
          type: StepperType.horizontal,
          currentStep: _index,
          onStepCancel: () {
            if (_index > 0) {
              setState(() {
                _index -= 1;
              });
            }
          },
          onStepContinue: () {
            if (_index <= 1) {
              setState(() {
                _index += 1;
              });
            }
          },
          steps: <Step>[
            Step(
              isActive: _index >= 0,
              title: const Text('Welcome'),
              content: WelcomePage(),
            ),
            Step(
              isActive: _index >= 1,
              title: const Text('Partner'),
              content: Container(
                  alignment: Alignment.centerLeft,
                  child: const Text('Content for Step 2')),
            ),
            Step(
              isActive: _index >= 2,
              title: const Text('Room'),
              content: Container(
                  alignment: Alignment.centerLeft,
                  child: const Text('Content for Step 3')),
            ),
          ],
        ),
      ),
    );
  }
}

class WelcomePage extends StatelessWidget {
  const WelcomePage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.centerLeft,
        child: const Text('Content for Step 1'));
  }
}
