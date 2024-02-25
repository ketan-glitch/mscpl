import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mscpl/custom_button.dart';
import 'package:mscpl/generated/assets.dart';

import 'verify_phone_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController number = TextEditingController();

  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {},
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
                "Enter your mobile no",
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                "We need to verity your number",
                style: Theme.of(context).textTheme.labelLarge!.copyWith(
                      fontWeight: FontWeight.w400,
                      color: const Color(0XFF667085),
                    ),
              ),
              const SizedBox(height: 32),
              RichText(
                text: TextSpan(
                  style: Theme.of(context).textTheme.labelLarge!.copyWith(
                        fontWeight: FontWeight.w400,
                        color: const Color(0XFF667085),
                      ),
                  children: [
                    const TextSpan(
                      text: "Mobile Number ",
                    ),
                    TextSpan(
                      text: "*",
                      style: Theme.of(context).textTheme.labelLarge!.copyWith(
                            fontWeight: FontWeight.w400,
                            color: Colors.red,
                          ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: number,
                onChanged: (value) {
                  if (value.length == 10) {
                    FocusScope.of(context).unfocus();
                  }
                  setState(() {});
                },
                keyboardType: TextInputType.number,
                inputFormatters: [LengthLimitingTextInputFormatter(10), FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  label: const Text("Enter mobile no"),
                  labelStyle: const TextStyle(color: Color(0XFF667085)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                ),
              ),
              const Spacer(flex: 2),
              CustomButton(
                type: ButtonType.primary,
                title: "Get OTP",
                onTap: isChecked && number.text.length == 10
                    ? () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => VerifyPhoneScreen(number: number.text)));
                      }
                    : null,
              ),
              const Spacer(flex: 5),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isChecked = !isChecked;
                      });
                    },
                    child: Stack(
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 400),
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                            border: Border.all(color: isChecked ? Colors.green : Colors.red, width: 4),
                            shape: BoxShape.circle,
                          ),
                        ),
                        if (isChecked)
                          Positioned(
                            width: 30,
                            height: 30,
                            child: Center(
                              child: Image.asset(
                                Assets.imagesCheck,
                                height: 25,
                                width: 25,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "Allow fydaa to send financial knowledge and critical alerts on your WhatsApp.",
                      style: Theme.of(context).textTheme.labelLarge!.copyWith(
                            fontWeight: FontWeight.w400,
                            color: const Color(0XFF667085),
                          ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
