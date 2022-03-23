import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kokoro/app/models/room.dart';
import 'package:kokoro/app/top_level_providers.dart';
import 'package:kokoro/constants.dart';

class InvitedStep extends ConsumerStatefulWidget {
  final List<Room> invitedRooms;

  const InvitedStep({
    Key? key,
    required this.invitedRooms,
  }) : super(key: key);

  @override
  ConsumerState<InvitedStep> createState() => _InvitedStepState();
}

class _InvitedStepState extends ConsumerState<InvitedStep>
    with TickerProviderStateMixin {
  late FocusNode myFocusNode;

  @override
  void initState() {
    super.initState();
    myFocusNode = FocusNode();
  }

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
        0.050,
        0.150,
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
        0.250,
        0.400,
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
        0.500,
        0.650,
        curve: Curves.ease,
      ),
    ),
  );

  @override
  void dispose() {
    myFocusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  Widget _buildAnimation(BuildContext context, Widget? child) {
    return Container(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Opacity(
            opacity: _animation1.value,
            child: roundedTextBox(
              Text(
                'Your partner awaits 💞 !',
                style: mainTitleStyle(),
              ),
            ),
          ),
          SizedBox(height: 15),
          Opacity(
            opacity: _animation2.value,
            child: roundedTextBox(
              Text(
                'You have been invited to the room...',
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
            child: Column(
              children: widget.invitedRooms
                  .map((room) => Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: kPrimaryBackgroundColour,
                          borderRadius: BorderRadius.all(
                            Radius.circular(25),
                          ),
                        ),
                        child: Column(
                          children: [
                            Container(
                              alignment: Alignment.topLeft,
                              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                              child: Text(room.roomName ?? 'Unnamed',
                                  style: TextStyle(
                                      fontSize: 24,
                                      color: kPrimaryTextColour)),
                            ),
                            SizedBox(height: 5),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                    style: roundButtonStyle(kPrimaryTextColour,
                                        kSecondaryBackgroundColour),
                                    child: Text('Reject'),
                                    onPressed: () {
                                      final user = ref.watch(userProvider).value!;
                                      final database = ref.watch(databaseProvider)!;
                                      room.invitedMembers!.remove(user.email);
                                      database.setRoom(room);
                                    },
                                  ),
                                  SizedBox(width: 10),
                                  TextButton(
                                    style: roundButtonStyle(kPrimaryTitleColour,
                                        kWarningBackgroundColorLight),
                                    child: Text('Accept'),
                                    onPressed: () {
                                      final user = ref.watch(userProvider).value!;
                                      final database = ref.watch(databaseProvider)!;
                                      user.currentRoom = room.roomId;
                                      database.setUser(user);
                                      room.invitedMembers!.remove(user.email);
                                      database.setRoom(room);
                                    },
                                  ),
                                ]),
                          ],
                        ),
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
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
