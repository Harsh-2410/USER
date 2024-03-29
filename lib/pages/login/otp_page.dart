import 'package:flutter/material.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';
import 'package:tagxiuser/pages/onTripPage/booking_confirmation.dart';
import 'package:tagxiuser/pages/onTripPage/invoice.dart';
import 'package:tagxiuser/pages/loadingPage/loading.dart';
import 'package:tagxiuser/pages/login/get_started.dart';
import 'package:tagxiuser/pages/login/login.dart';
import 'package:tagxiuser/pages/onTripPage/map_page.dart';
import 'package:tagxiuser/pages/noInternet/nointernet.dart';
import 'package:tagxiuser/translations/translation.dart';
import 'package:tagxiuser/widgets/widgets.dart';
import '../../styles/styles.dart';
import '../../functions/functions.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

// ignore: must_be_immutable
class Otp extends StatefulWidget {
  dynamic from;
  Otp({
    this.from,
    Key? key,
  }) : super(key: key);

  @override
  State<Otp> createState() => _OtpState();
}

String otpNumber = '';

class _OtpState extends State<Otp> {
  //otp number
  List otpText = []; //otp number as list for 6 boxes
  List otpPattern = [1, 2, 3, 4, 5, 6]; //list to create number of input box
  var resendTime = 60; //otp resend time
  late Timer timer; //timer for resend time
  String _error =
      ''; //otp error string to show if error occurs in otp validation

  OtpFieldController otpController =
  OtpFieldController(); //otp textediting controller
  OtpFieldController first = OtpFieldController();
  OtpFieldController second = OtpFieldController();
  OtpFieldController third = OtpFieldController();
  OtpFieldController fourth = OtpFieldController();
  OtpFieldController fifth = OtpFieldController();
  OtpFieldController sixth = OtpFieldController();
  bool _loading = false; //loading screen showing

  @override
  void initState() {
    _loading = false;
    timers();
    otpFalse();
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel;
    super.dispose();
  }

  //navigate
  navigate(verify) {
    if (verify == true) {
      if (userRequestData.isNotEmpty && userRequestData['is_completed'] == 1) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const Invoice()),
                (route) => false);
      } else if (userRequestData.isNotEmpty &&
          userRequestData['is_completed'] != 1) {
        Future.delayed(const Duration(seconds: 2), () {
          if (userRequestData['is_rental'] == true) {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => BookingConfirmation(
                      type: 1,
                    )),
                    (route) => false);
          } else if (userRequestData['drop_lat'] == null) {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => BookingConfirmation(
                      type: 2,
                    )),
                    (route) => false);
          } else {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => BookingConfirmation()),
                    (route) => false);
          }
        });
      } else {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const Maps()),
                (route) => false);
      }
    } else if (verify == false) {
      (value == 0)
          ? Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => GetStarted(
                from: '1',
              )))
          : Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => GetStarted()));
    } else {
      _error = verify.toString();
      setState(() {
        _loading = false;
      });
    }
  }

  //otp is false
  otpFalse() async {
    if (phoneAuthCheck == false) {
      _loading = true;

      otpNumber = otpController.toString();
      var verify = await verifyUser(phnumber);
      value = 0;
      navigate(verify);
    }
  }

  //auto verify otp
  verifyOtp() async {
    FocusManager.instance.primaryFocus?.unfocus();
    try {
      // Sign the user in (or link) with the credential
      await FirebaseAuth.instance.signInWithCredential(credentials);

      var verify = await verifyUser(phnumber);

     navigate(verify);
    } on FirebaseAuthException catch (error) {
      if (error.code == 'invalid-verification-code') {
        setState(() {
          otpController.clear();
          otpNumber = '';
          _error = languages['en']['text_otp_error'];
        });
      }
    }
  }

// running resend otp timer
  timers() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (resendTime != 0) {
        if (mounted) {
          setState(() {
            resendTime--;
          });
        }
      } else {
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return Material(
      child: Directionality(
        textDirection: (languageDirection == 'rtl')
            ? TextDirection.rtl
            : TextDirection.ltr,
        child: ValueListenableBuilder(
            valueListenable: valueNotifierHome.value,
            builder: (context, value, child) {
              if (credentials != null) {
                _loading = true;
                verifyOtp();
              }

              return Stack(
                children: [
                  Container(

                    padding: EdgeInsets.only(
                        left: media.width * 0.08, right: media.width * 0.08),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.black,Colors.black87,Colors.black87, Colors.black,],
                      ),
                    ),
                    height: media.height * 1,
                    width: media.width * 1,
                    child: Column(
                      children: [
                        Container(

                            height: media.height * 0.12,
                            width: media.width * 1,

                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                InkWell(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Icon(Icons.arrow_back,
                                        color: textColor)),
                              ],
                            )),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.all(media.width * 0.01),
                                width: media.width * 0.95,
                                height: media.width * 0.4,
                                decoration: const BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage('assets/images/logo2.png'),
                                        fit: BoxFit.contain)),
                              ),
                              SizedBox(
                                height: media.height * 0.04,
                              ),
                              (widget.from == '1')
                                  ? SizedBox(
                                width: media.width * 1,
                                child: Text(
                                  languages['en']
                                  ['text_phone_verify'],
                                  style: GoogleFonts.roboto(
                                      fontSize: media.width * twentyeight,
                                      fontWeight: FontWeight.bold,
                                      color: textColor),
                                ),
                              )
                                  : SizedBox(
                                width: media.width * 1,
                                child: Text(
                                  languages['en']
                                  ['text_email_verify'],
                                  style: GoogleFonts.roboto(
                                      fontSize: media.width * twentyeight,
                                      fontWeight: FontWeight.bold,
                                      color: textColor),
                                ),
                              ),

                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                languages['en']['text_enter_otp'],
                                style: GoogleFonts.roboto(
                                    fontSize: media.width * sixteen,
                                    color: textColor.withOpacity(0.3)),
                              ),
                              const SizedBox(height: 10),
                              (widget.from == '1')
                                  ? Text(
                                countries[phcode]['dial_code'] + phnumber,
                                style: GoogleFonts.roboto(
                                    fontSize: media.width * sixteen,
                                    color: textColor,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1),
                              )
                                  : Text(
                                email,
                                style: GoogleFonts.roboto(
                                    fontSize: media.width * sixteen,
                                    color: textColor,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1),
                              ),

                              SizedBox(height: media.height * 0.1),

                              //otp text box
                              Container(
                                height: media.width * 0.15,
                                width: media.width * 0.9,

                                child:  OTPTextField(
                                  length: 6,
                                  width: MediaQuery.of(context).size.width,

                                  fieldWidth: 40,

                                  otpFieldStyle: OtpFieldStyle(
                                    backgroundColor: Colors.white10,

                                      ),

                                  style: TextStyle(
                                      fontSize: 17,
                                    color:Colors.white,
                                  ),
                                  textFieldAlignment: MainAxisAlignment.spaceAround,
                                  fieldStyle: FieldStyle.box,

                                  controller: otpController,

                                  onChanged: (val) {
                                    setState(() {
                                      otpNumber = val;
                                    });
                                    if (val.length == 6) {
                                      FocusManager.instance.primaryFocus
                                          ?.unfocus();
                                    }
                                  },

                                  keyboardType: TextInputType.number,
                                ),
                              ),

                              //otp error
                              (_error != '')
                                  ? Container(
                                alignment: Alignment.center,
                                margin: EdgeInsets.only(
                                    top: media.height * 0.02),
                                child: Text(
                                  _error,
                                  style: GoogleFonts.roboto(
                                      fontSize: media.width * sixteen,
                                      color: Colors.red),
                                ),
                              )
                                  : Container(),
                              SizedBox(
                                height: media.height * 0.05,
                              ),
                              (widget.from == '1')
                                  ? Container(
                                alignment: Alignment.center,
                                child: Button(
                                  onTap: () async {
                                    if (otpNumber.length == 6) {
                                      setState(() {
                                        _loading = true;
                                        _error = '';
                                      });
                                      //firebase code send false
                                      if (phoneAuthCheck == false) {
                                        var verify =
                                        await verifyUser(phnumber);
                                        value = 0;
                                        navigate(verify);
                                      } else {
                                        // firebase code send true
                                        try {
                                          PhoneAuthCredential credential =
                                          PhoneAuthProvider
                                              .credential(
                                              verificationId:
                                              verId,
                                              smsCode: otpNumber);

                                          // Sign the user in (or link) with the credential
                                          await FirebaseAuth.instance
                                              .signInWithCredential(
                                              credential);
                                         // showDialog(
                                       //       context: context,
                                       //       builder: (_) => AlertDialog(
                                         //       title: Text('OT Verified'),
                                          //      content: Text('Test Success'),
                                          //    )
                                        //  );
                                          var verify =
                                          await verifyUser(phnumber);
                                          navigate(verify);

                                          value = 0;
                                        } on FirebaseAuthException catch (error) {
                                          if (error.code ==
                                              'invalid-verification-code') {
                                            setState(() {
                                              otpController.clear();
                                              otpNumber = '';
                                              _error = languages[
                                              'en']
                                              ['text_otp_error'];
                                            });
                                          }
                                        }
                                      }
                                      setState(() {
                                        _loading = false;
                                      });
                                    } else if (phoneAuthCheck == true &&
                                        resendTime == 0 &&
                                        otpNumber.length != 6) {
                                      setState(() {
                                        setState(() {
                                          resendTime = 60;
                                        });
                                        timers();
                                      });
                                      phoneAuth(countries[phcode]
                                      ['dial_code'] +
                                          phnumber);
                                    }
                                  },
                                  text: (otpNumber.length == 6)
                                      ? languages['en']
                                  ['text_verify']
                                      : (resendTime == 0)
                                      ? languages['en']
                                  ['text_resend_code']
                                      : languages['en']
                                  ['text_resend_code'] +
                                      ' ' +
                                      resendTime.toString(),
                                  color: (resendTime != 0 &&
                                      otpNumber.length != 6)
                                      ? (isDarkTheme == true)
                                      ? textColor.withOpacity(0.3)
                                      : underline
                                      : null,
                                  borcolor: (resendTime != 0 &&
                                      otpNumber.length != 6)
                                      ? underline
                                      : null,
                                ),
                              )
                                  : Container(
                                alignment: Alignment.center,
                                child: Button(
                                  onTap: () async {
                                    if (otpNumber.length == 6) {
                                      setState(() {
                                        _loading = true;
                                        _error = '';
                                      });

                                      var result = await emailVerify(
                                          email, otpNumber);

                                      if (result == 'success') {
                                        setState(() {
                                          _error = '';
                                          _loading = true;
                                        });

                                        var verify =
                                        await verifyUser(email);
                                        value = 1;
                                        navigate(verify);

                                        setState(() {
                                          _loading = false;
                                        });
                                      } else {
                                        setState(() {
                                          otpController.clear();
                                          otpNumber = '';
                                          _error =
                                          languages['en']
                                          ['text_otp_error'];
                                        });
                                      }

                                      setState(() {
                                        _loading = false;
                                      });
                                    } else if (phoneAuthCheck == true &&
                                        resendTime == 0 &&
                                        otpNumber.length != 6) {
                                      setState(() {
                                        setState(() {
                                          resendTime = 60;
                                        });
                                        timers();
                                      });
                                      value = 1;
                                      sendOTPtoEmail(email);
                                    }
                                  },
                                  text: (otpNumber.length == 6)
                                      ? languages['en']
                                  ['text_verify']
                                      : (resendTime == 0)
                                      ? languages['en']
                                  ['text_resend_code']
                                      : languages['en']
                                  ['text_resend_code'] +
                                      ' ' +
                                      resendTime.toString(),
                                  color: (resendTime != 0 &&
                                      otpNumber.length != 6)
                                      ? (isDarkTheme == true)
                                      ? textColor.withOpacity(0.3)
                                      : underline
                                      : null,
                                  borcolor: (resendTime != 0 &&
                                      otpNumber.length != 6)
                                      ? underline
                                      : null,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),

                  //no internet
                  (internet == false)
                      ? Positioned(
                      top: 0,
                      child: NoInternet(onTap: () {
                        setState(() {
                          internetTrue();
                        });
                      }))
                      : Container(),

                  //loader
                  (_loading == true)
                      ? Positioned(
                      top: 0,
                      child: SizedBox(
                        height: media.height * 1,
                        width: media.width * 1,
                        child: const Loading(),
                      ))
                      : Container()
                ],
              );
            }),
      ),
    );
  }
}
