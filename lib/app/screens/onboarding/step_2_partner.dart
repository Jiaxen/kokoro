import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kokoro/app/top_level_providers.dart';
import 'package:kokoro/constants.dart';

class AddPartnerStep extends ConsumerStatefulWidget {
  final Function nextStep;
  final Function previousStep;
  final TextEditingController emailController;

  const AddPartnerStep({
    Key? key,
    required this.nextStep,
    required this.previousStep,
    required this.emailController,
  }) : super(key: key);

  @override
  ConsumerState<AddPartnerStep> createState() => _AddPartnerStepState();
}

class _AddPartnerStepState extends ConsumerState<AddPartnerStep>
    with TickerProviderStateMixin {
  String? emailErrorMessage;
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
                  'Add your partner 💞 !',
                  style: mainTitleStyle(),
                ),
              ),
            ),
            SizedBox(height: 15),
            Opacity(
              opacity: _animation2.value,
              child: roundedTextBox(
                Text(
                  'We\'ll send them an invite',
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
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                      focusNode: myFocusNode,
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
                    emailErrorMessage != null
                        ? Text(
                      emailErrorMessage!,
                      style: TextStyle(
                        fontSize: 14,
                        color: kErrorTextColorLight,
                      ),
                    )
                        : SizedBox(),
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
                              child: const Text('Continue 👉'),
                              onPressed: () {
                                final user = ref.watch(userProvider).value!;
                                if (user.email!.toLowerCase() == widget.emailController.text.toLowerCase()) {
                                  setState(() {
                                    emailErrorMessage = 'Please your partner\'s email address';
                                  });
                                } else if (!EmailValidator.validate(
                                    widget.emailController.text)) {
                                  setState(() {
                                    emailErrorMessage = 'Please enter a valid email address';
                                  });
                                } else {
                                  emailErrorMessage = null;
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  widget.nextStep();
                                }
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
