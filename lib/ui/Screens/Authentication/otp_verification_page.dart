import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:virtual_furnish_app/main.dart';

class OtpVerificationPage extends StatefulWidget {
  const OtpVerificationPage({super.key});

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  bool isDisabledButton = true;
  TextEditingController otp1 = TextEditingController();
  TextEditingController otp2 = TextEditingController();
  TextEditingController otp3 = TextEditingController();
  TextEditingController otp4 = TextEditingController();
  TextEditingController otp5 = TextEditingController();
  TextEditingController otp6 = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        checkButtonStatus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: true,
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 25, 16, 0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Verify your phone number',
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    const Text(
                      'Please enter the 6-digit code sent to your number',
                      style: TextStyle(fontSize: 17),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    Form(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                            height: 68,
                            width: mq.width * 0.12,
                            child: TextField(
                              onChanged: (value){
                                checkButtonStatus();
                                if(value.length == 1) FocusScope.of(context).nextFocus();
                              },
                              onEditingComplete: () => FocusScope.of(context).nextFocus(),
                              controller: otp1,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(1),
                                FilteringTextInputFormatter.digitsOnly
                              ],
                            )),
                        SizedBox(
                            height: 68,
                            width: mq.width * 0.12,
                            child: TextField(
                                   onChanged: (value){
                                checkButtonStatus();
                                if(value.length == 1) FocusScope.of(context).nextFocus();
                              },
                              onEditingComplete: () => FocusScope.of(context).nextFocus(),
                              controller: otp2,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(1),
                                FilteringTextInputFormatter.digitsOnly
                              ],
                            )),
                        SizedBox(
                            height: 68,
                            width: mq.width * 0.12,
                            child: TextField(
                                 onChanged: (value){
                                checkButtonStatus();
                                if(value.length == 1) FocusScope.of(context).nextFocus();
                              },
                              onEditingComplete: () => FocusScope.of(context).nextFocus(),
                              controller: otp3,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(1),
                                FilteringTextInputFormatter.digitsOnly
                              ],
                            )),
                        SizedBox(
                            height: 68,
                            width: mq.width * 0.12,
                            child: TextField(
                              onChanged: (value){
                                checkButtonStatus();
                                if(value.length == 1) FocusScope.of(context).nextFocus();
                              },
                              onEditingComplete: () => FocusScope.of(context).nextFocus(),
                              controller: otp4,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(1),
                                FilteringTextInputFormatter.digitsOnly
                              ],
                            )),
                         SizedBox(
                            height: 68,
                            width: mq.width * 0.12,
                            child: TextField(
                              onChanged: (value){
                                checkButtonStatus();
                                if(value.length == 1) FocusScope.of(context).nextFocus();
                              },
                              onEditingComplete: () => FocusScope.of(context).nextFocus(),
                              controller: otp5,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(1),
                                FilteringTextInputFormatter.digitsOnly
                              ],
                            )),
                         SizedBox(
                            height: 68,
                            width: mq.width * 0.12,
                            child: TextField(
                              onChanged: (value){
                                checkButtonStatus();
                                if(value.length == 1) FocusScope.of(context).nextFocus();
                              },
                              onEditingComplete: () => FocusScope.of(context).nextFocus(),
                              controller: otp6,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(1),
                                FilteringTextInputFormatter.digitsOnly
                              ],
                            )),
                      ],
                    )),
                    const SizedBox(height: 50),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: (!isDisabledButton)
                                ? Colors.blue : Colors.grey,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50)),
                          fixedSize: const Size(340, 45),
                        ),
                        onPressed: () {
                           if(!isDisabledButton){
                              setState(() {
                              isDisabledButton = true;
                              });
                          Navigator.of(context)
                              .pushNamed('/home');
                          }
                        },
                        child: Text(
                          'Verify OTP',
                          style: TextStyle(
                              color: Colors.grey, fontSize: 18),
                        )),
                    const SizedBox(
                      height: 60,
                    ),
                  
                  ]),
            ),
          ),
        ),
      ),
    );
  }
  void checkButtonStatus() {
    if (otp1.text.trim().isNotEmpty && otp2.text.trim().isNotEmpty && otp3.text.trim().isNotEmpty && otp4.text.trim().isNotEmpty) {
      setState(() {
        isDisabledButton = false;
      });
    } else {
      setState(() {
        isDisabledButton = true;
      });
    }
  }
}
