import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kokoro/app/models/group.dart';
import 'package:kokoro/app/models/user.dart';
import 'package:kokoro/app/screens/onboarding/step_1_welcome.dart';
import 'package:kokoro/app/screens/onboarding/step_2_partner.dart';
import 'package:kokoro/app/screens/onboarding/step_3_group.dart';
import 'package:kokoro/app/top_level_providers.dart';
import 'package:kokoro/constants.dart';

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
    AppUser appUser = ref.watch(userProvider).value!;
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
                  AppUser user = appUser;

                  Group newGroup = Group(
                      groupName: groupNameController.text,
                      members: [user.uid],
                      invitedMembers: [partnerEmailController.text],
                      createdTime: DateTime.now());
                  DocumentReference newGroupDocument =
                      await database.addGroup(newGroup);
                  user.currentGroup = newGroupDocument.id;
                  database.setUser(user);
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


