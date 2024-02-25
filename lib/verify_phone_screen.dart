import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mscpl/custom_button.dart';
import 'package:mscpl/generated/assets.dart';

class VerifyPhoneScreen extends StatefulWidget {
  final String number;
  const VerifyPhoneScreen({super.key, required this.number});

  @override
  State<VerifyPhoneScreen> createState() => _VerifyPhoneScreenState();
}

class _VerifyPhoneScreenState extends State<VerifyPhoneScreen> {
  String otp = "";
  Timer? timer;
  int seconds = 170;

  sendOtp() {
    seconds = 170;
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (seconds == 0) {
        timer.cancel();
      } else {
        seconds--;
      }

      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    Timer.run(() {
      sendOtp();
    });
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
    timer = null;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Image.asset(Assets.imagesBack),
        ),
      ),
      body: SizedBox(
        width: size.width,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 46, horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Verify your phone",
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 24),
              RichText(
                text: TextSpan(
                  style: Theme.of(context).textTheme.labelLarge!.copyWith(
                        fontWeight: FontWeight.w400,
                        color: const Color(0XFF3D4E66),
                      ),
                  children: [
                    const TextSpan(
                      text: "Enter the verification code sent to\n",
                    ),
                    TextSpan(
                      text: '${getMaskedNumber(widget.number)}.',
                      style: Theme.of(context).textTheme.labelLarge!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: const Color(0XFF0D1D33),
                          ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Container(
                padding: otp.length == 6 ? const EdgeInsets.all(16) : null,
                decoration: BoxDecoration(
                  color: otp.length == 6
                      ? otp == '934477'
                          ? Colors.green
                          : Colors.red
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Column(
                      children: [
                        OTPTextField(
                          length: 6,
                          onChanged: (String otp) {
                            this.otp = otp;
                            log(otp, name: 'OTP');
                            setState(() {});
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    if (otp.length == 6)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (otp == '934477') const Icon(Icons.check, color: Colors.white) else const Icon(Icons.close, color: Colors.white),
                          const SizedBox(width: 10),
                          Text(
                            otp == '934477' ? "Verified" : "Invalid OTP",
                            style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Text(
                  "Verification code expires in ${DateTime.now().copyWith(hour: 1, minute: 0, second: seconds).ms}",
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                        fontWeight: FontWeight.w300,
                        fontSize: 16,
                        color: const Color(0XFF69788C),
                      ),
                ),
              ),
              const Spacer(flex: 2),
              CustomButton(
                type: ButtonType.secondary,
                title: "Resend OTP",
                onTap: seconds == 0
                    ? () {
                        sendOtp();
                      }
                    : null,
              ),
              const SizedBox(height: 16),
              CustomButton(
                type: ButtonType.secondary,
                title: "Change Number",
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  String getMaskedNumber(String number) {
    return "(${number[0]}**) ***-**${number.substring(number.length - 2, number.length)}";
  }
}

class OTPTextField extends StatefulWidget {
  final int length;
  final Function(String otp) onChanged;

  const OTPTextField({super.key, required this.length, required this.onChanged});

  @override
  State<OTPTextField> createState() => _OTPTextFieldState();
}

class _OTPTextFieldState extends State<OTPTextField> {
  late List<FocusNode> _focusNodes;

  late List<TextEditingController> _controllers;

  int currentIndex = 0;

  int previousIndex = 0;

  @override
  void initState() {
    super.initState();
    _focusNodes = List.generate(widget.length, (index) => FocusNode());
    _controllers = List.generate(widget.length, (index) => TextEditingController());

    for (int i = 0; i < widget.length; i++) {
      _controllers[i].addListener(() {
        if (_controllers[i].text.length == 1 && previousIndex <= currentIndex) {
          currentIndex = i + 1;
          if (i < widget.length - 1) {
            previousIndex = i;
            _focusNodes[i].unfocus();
            FocusScope.of(context).requestFocus(_focusNodes[i + 1]);
          } else {
            previousIndex = i + 1;
            _focusNodes[i].unfocus();
          }
        } else if (i > 0 && _controllers[i].text.isEmpty && previousIndex >= currentIndex) {
          currentIndex = i - 1;
          previousIndex = i;
          _focusNodes[i].unfocus();
          FocusScope.of(context).requestFocus(_focusNodes[i - 1]);
        } else {
          currentIndex = 0;
          previousIndex = 0;
        }

        final otp = _controllers.map((controller) => controller.text).join('');
        widget.onChanged(otp);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(
        widget.length,
        (index) => SizedBox(
          width: 45,
          child: TextField(
            controller: _controllers[index],
            focusNode: _focusNodes[index],
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            maxLength: 1,
            decoration: InputDecoration(
              fillColor: const Color(0XFFF2F4F7),
              filled: true,
              counterText: '',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.transparent),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.transparent),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    for (int i = 0; i < widget.length; i++) {
      _focusNodes[i].dispose();
      _controllers[i].dispose();
    }
    super.dispose();
  }
}

extension DateTimeExtension on DateTime {
  String get ms => DateFormatters().ms.format(this);
}

class DateFormatters {
  DateFormat ms = DateFormat('mm:ss');
}
