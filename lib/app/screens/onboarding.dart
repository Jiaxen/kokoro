import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kokoro/constants.dart';
import 'package:kokoro/widgets/images.dart';

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
          colorScheme: Theme.of(context).colorScheme.copyWith(
                primary: kPrimaryAppColour,
              ),
        ),
        child: Stepper(
          controlsBuilder: (_,__){return Container();},
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
              content: WelcomeStep(
                nextStep: () {
                  setState(() {
                    _index += 1;
                  });
                },
              ),
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

class WelcomeStep extends StatelessWidget {
  final Function nextStep;

  const WelcomeStep({
    Key? key,
    required this.nextStep,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            roundedTextBox(
              Text(
                'Hi there 🤗 !',
                style: mainTitleStyle(),
              ),
            ),
            SizedBox(height: 15),
            roundedTextBox(
              Text(
                'Welcome to Kokoro!',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: kPrimaryTitleColour,
                ),
              ),
            ),
            SizedBox(height: 15),
            roundedTextBox(
              Text(
                'We hope this app will help you\nand your partner to strengthen\n your relationship.',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: kPrimaryTitleColour,
                ),
              ),
            ),
            partnersDoodle(),
            SizedBox(height: 25),
            Container(
              alignment: Alignment.bottomRight,
              child: TextButton(
                style: roundButtonStyle(kPrimaryTitleColour, kWarningBackgroundColorLight),
                  child: const Text('Get Started ->'),
                  onPressed: () {
                    nextStep();
                  }),
            ),

          ],
        ));
  }
}
class AddPartnerStep extends StatelessWidget {
  final Function nextStep;
  final Function previousStep;

  const AddPartnerStep({
    Key? key,
    required this.nextStep,
    required this.previousStep,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            roundedTextBox(
              Text(
                'Add your partner 💞 !',
                style: mainTitleStyle(),
              ),
            ),
            SizedBox(height: 15),
            roundedTextBox(
              Text(
                'We\'ll send them an invite',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: kPrimaryTitleColour,
                ),
              ),
            ),
            partnersDoodle(),
            SizedBox(height: 25),
            Container(
              alignment: Alignment.bottomRight,
              child: TextButton(
                style: roundButtonStyle(kPrimaryTitleColour, kWarningBackgroundColorLight),
                  child: const Text('Get Started ->'),
                  onPressed: () {
                    nextStep();
                  }),
            ),

          ],
        ));
  }
}
