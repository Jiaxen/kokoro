import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kokoro/app/models/room.dart';
import 'package:kokoro/app/models/user.dart';
import 'package:kokoro/app/screens/empty_content.dart';
import 'package:kokoro/app/screens/onboarding/step_1_welcome.dart';
import 'package:kokoro/app/screens/onboarding/step_2_partner.dart';
import 'package:kokoro/app/screens/onboarding/step_2b_invited.dart';
import 'package:kokoro/app/screens/onboarding/step_3_room.dart';
import 'package:kokoro/app/top_level_providers.dart';
import 'package:kokoro/constants.dart';

class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({Key? key}) : super(key: key);

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  @override
  Widget build(BuildContext context) {
    final invitedRoomsAsyncValue = ref.watch(invitedRoomsProvider);
    return invitedRoomsAsyncValue.when(
      data: (invitedRooms) {
        if (invitedRooms.isNotEmpty) {
          return InvitedOnboardingStepper(invitedRooms: invitedRooms);
        } else {
          return OnboardingStepper();
        }
      },
      error: (_, __) => EmptyContent(
        title: 'Oops',
        message: 'Something went wrong',
      ),
      loading: () => EmptyContent(),
    );
  }
}

class InvitedOnboardingStepper extends ConsumerStatefulWidget {
  final List<Room> invitedRooms;
  int _index = 0;

  InvitedOnboardingStepper({Key? key, required this.invitedRooms})
      : super(key: key);

  @override
  ConsumerState<InvitedOnboardingStepper> createState() =>
      _InvitedOnboardingStepperState();
}

class _InvitedOnboardingStepperState extends ConsumerState<InvitedOnboardingStepper> {
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
          currentStep: widget._index,
          steps: <Step>[
            Step(
              isActive: widget._index >= 0,
              title: const Text('Welcome'),
              content: WelcomeStep(
                nextStep: () {
                  setState(() {
                    widget._index += 1;
                  });
                },
              ),
            ),
            Step(
              isActive: widget._index >= 1,
              title: const Text('Invitation'),
              content: InvitedStep(
                invitedRooms: widget.invitedRooms,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OnboardingStepper extends ConsumerStatefulWidget {
  int _index = 0;
  final partnerEmailController = TextEditingController();
  final roomNameController = TextEditingController();

  OnboardingStepper(
      {Key? key})
      : super(key: key);

  @override
  ConsumerState<OnboardingStepper> createState() => _OnboardingStepperState();
}

class _OnboardingStepperState extends ConsumerState<OnboardingStepper> {
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
          currentStep: widget._index,
          steps: <Step>[
            Step(
              isActive: widget._index >= 0,
              title: const Text('Welcome'),
              content: WelcomeStep(
                nextStep: () {
                  setState(() {
                    widget._index += 1;
                  });
                },
              ),
            ),
            Step(
              isActive: widget._index >= 1,
              title: const Text('Partner'),
              content: AddPartnerStep(
                emailController: widget.partnerEmailController,
                nextStep: () {
                  setState(() {
                    widget._index += 1;
                  });
                },
                previousStep: () {
                  setState(() {
                    widget._index -= 1;
                  });
                },
              ),
            ),
            Step(
              isActive: widget._index >= 2,
              title: const Text('Room'),
              content: AddRoomStep(
                roomController: widget.roomNameController,
                nextStep: () async {
                  final database = ref.watch(databaseProvider)!;
                  final user = ref.watch(userProvider).value!;
                  Room newRoom = Room(
                      roomName: widget.roomNameController.text,
                      members: [user.uid],
                      invitedMembers: [
                        widget.partnerEmailController.text.toLowerCase()
                      ],
                      createdTime: DateTime.now());
                  DocumentReference newRoomDocument =
                      await database.addRoom(newRoom);
                  user.currentRoom = newRoomDocument.id;
                  database.setUser(user);
                },
                previousStep: () {
                  setState(() {
                    widget._index -= 1;
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
