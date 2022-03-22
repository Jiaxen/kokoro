import 'package:kokoro/constants.dart';
import 'package:flutter/material.dart';

class AddGroupStep extends StatefulWidget {
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
  State<AddGroupStep> createState() => _AddGroupStepState();
}

class _AddGroupStepState extends State<AddGroupStep> with TickerProviderStateMixin {
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


  @override
  void dispose() {
    myFocusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  Widget _buildAnimation(BuildContext context, Widget? child){
    if (_animation3.value > 0.9) {
      myFocusNode.requestFocus();
    }
    return Container(
        alignment: Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Opacity(
              opacity: _animation1.value,
              child: roundedTextBox(
                Text(
                  'Get a room 😉 !',
                  style: mainTitleStyle(),
                ),
              ),
            ),
            SizedBox(height: 15),
            Opacity(
              opacity: _animation2.value,
              child: roundedTextBox(
                Text(
                  'Finally, pick a name for your\nroom for you and your partner',
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
              opacity: _animation3.value,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                        focusNode: myFocusNode,
                        controller: widget.groupController,
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
                                FocusManager.instance.primaryFocus?.unfocus();
                                widget.previousStep();
                              }),
                        ),
                        Container(
                          alignment: Alignment.bottomRight,
                          child: TextButton(
                              style: roundButtonStyle(
                                  kPrimaryTitleColour, kWarningBackgroundColorLight),
                              child: const Text('Finish 👉'),
                              onPressed: () {
                                FocusManager.instance.primaryFocus?.unfocus();
                                widget.nextStep();
                              }),
                        ),
                      ],
                    ),
                  ],
                ),
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