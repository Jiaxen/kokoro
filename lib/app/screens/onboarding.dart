import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kokoro/app/models/group.dart';
import 'package:kokoro/app/top_level_providers.dart';
import 'package:kokoro/constants.dart';
import 'package:email_validator/email_validator.dart';

class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({Key? key}) : super(key: key);

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  int _index = 0;
  final partnerEmailController = TextEditingController();
  final groupNameController = TextEditingController();

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
          controlsBuilder: (_, __) {
            return Container();
          },
          type: StepperType.horizontal,
          currentStep: _index,
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
              content: AddPartnerStep(
                emailController: partnerEmailController,
                nextStep: () {
                  setState(() {
                    _index += 1;
                  });
                },
                previousStep: () {
                  setState(() {
                    _index -= 1;
                  });
                },
              ),
            ),
            Step(
              isActive: _index >= 2,
              title: const Text('Room'),
              content: AddGroupStep(
                groupController: groupNameController,
                nextStep: () async {
                  final database = ref.watch(databaseProvider)!;
                  final user = ref.watch(userProvider).value!;

                  Group newGroup = Group(
                      groupName: groupNameController.text,
                      members: [user.uid],
                      invitedMembers: [partnerEmailController.text],
                      createdTime: DateTime.now());
                  DocumentReference newGroupDocument =
                      await database.addGroup(newGroup);
                  user.currentGroup = newGroupDocument.id;
                  database.setUser(user);
                  setState(() {});
                },
                previousStep: () {
                  setState(() {
                    _index -= 1;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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

class AddPartnerStep extends StatefulWidget {
  final Function nextStep;
  final Function previousStep;
  final TextEditingController emailController;

  AddPartnerStep({
    Key? key,
    required this.nextStep,
    required this.previousStep,
    required this.emailController,
  }) : super(key: key);

  @override
  State<AddPartnerStep> createState() => _AddPartnerStepState();
}

class _AddPartnerStepState extends State<AddPartnerStep> {
  bool emailError = false;

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
            SizedBox(height: 15),
            Text(
              'Partner\'s email',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: kPrimaryTitleColour,
              ),
            ),
            SizedBox(height: 10),
            TextField(
                controller: widget.emailController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: kTextBackgroundColour,
                  focusColor: kTextBackgroundColour,
                  focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: kTextBackgroundColour, width: 0.0),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(20))),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  hintText: 'booboo@mail.com',
                ),
                keyboardType: TextInputType.emailAddress,
                textCapitalization: TextCapitalization.sentences,
                minLines: 1),
            SizedBox(height: 12),
            emailError
                ? Text(
                    'Please enter a valid email',
                    style: TextStyle(
                      fontSize: 14,
                      color: kErrorTextColorLight,
                    ),
                  )
                : SizedBox(),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  alignment: Alignment.bottomRight,
                  child: TextButton(
                      style: roundButtonStyle(
                          kPrimaryTitleColour, kSecondaryBackgroundColour),
                      child: const Text('Back'),
                      onPressed: () {
                        widget.previousStep();
                      }),
                ),
                Container(
                  alignment: Alignment.bottomRight,
                  child: TextButton(
                      style: roundButtonStyle(
                          kPrimaryTitleColour, kWarningBackgroundColorLight),
                      child: const Text('Continue 👉'),
                      onPressed: () {
                        if (EmailValidator.validate(
                            widget.emailController.text)) {
                          widget.nextStep();
                        } else {
                          setState(() {
                            emailError = true;
                          });
                        }
                      }),
                ),
              ],
            ),
          ],
        ));
  }
}

class AddGroupStep extends StatelessWidget {
  final Function nextStep;
  final Function previousStep;
  final TextEditingController groupController;

  const AddGroupStep({
    Key? key,
    required this.nextStep,
    required this.previousStep,
    required this.groupController,
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
                'Get a room 😉 !',
                style: mainTitleStyle(),
              ),
            ),
            SizedBox(height: 15),
            roundedTextBox(
              Text(
                'Finally, pick a name for your\nroom for you and your partner',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: kPrimaryTitleColour,
                ),
              ),
            ),
            SizedBox(height: 25),
            TextField(
                controller: groupController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: kTextBackgroundColour,
                  focusColor: kTextBackgroundColour,
                  focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: kTextBackgroundColour, width: 0.0),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(20))),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  hintText: 'Tom and Rita\'s room',
                ),
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.sentences,
                minLines: 1),
            SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  alignment: Alignment.bottomRight,
                  child: TextButton(
                      style: roundButtonStyle(
                          kPrimaryTitleColour, kSecondaryBackgroundColour),
                      child: const Text('Back'),
                      onPressed: () {
                        FocusManager.instance.primaryFocus?.unfocus();
                        previousStep();
                      }),
                ),
                Container(
                  alignment: Alignment.bottomRight,
                  child: TextButton(
                      style: roundButtonStyle(
                          kPrimaryTitleColour, kWarningBackgroundColorLight),
                      child: const Text('Finish 👉'),
                      onPressed: () {
                        nextStep();
                      }),
                ),
              ],
            ),
          ],
        ));
  }
}
