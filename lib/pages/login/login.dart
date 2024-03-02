import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tagxiuser/pages/loadingPage/loading.dart';
import 'package:tagxiuser/pages/login/otp_page.dart';
import 'package:tagxiuser/pages/login/signinwithemail.dart';
import 'package:tagxiuser/pages/noInternet/nointernet.dart';
import 'package:tagxiuser/translations/translation.dart';
import '../../styles/styles.dart';
import '../../functions/functions.dart';
import '../../widgets/widgets.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

var value = 0;

//code as int for getting phone dial code of choosen country
String phnumber = ''; // phone number as string entered in input field
// String phone = '';

class _LoginState extends State<Login> {
  TextEditingController controller = TextEditingController();

  bool terms = true; //terms and conditions true or false
  bool _isLoading = true;

  @override
  void initState() {
    countryCode();
    super.initState();
  }

  countryCode() async {
    await getCountryCode();
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  //navigate
  navigate() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Otp(
                  from: '1',
                )));
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return Material(

      child: Directionality(
        textDirection: (languageDirection == 'rtl')
            ? TextDirection.rtl
            : TextDirection.ltr,
        child: Stack(
          children: [
            (countries.isNotEmpty)
                ? Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black,Colors.black87,Colors.black87, Colors.black,],
                ),
              ),
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).padding.top,
                        left: media.width * 0.08,
                        right: media.width * 0.08),
                    height: media.height * 1,
                    width: media.width * 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center
                      ,
                      children: [
                        SizedBox(height: 50),
                        Container(
                          alignment: Alignment.center,
                          child: Text(
                            "WELCOME TO",
                            style: GoogleFonts.poppins(
                                fontSize: media.width * twenty,
                                fontWeight: FontWeight.normal,
                                color: textColor),

                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(media.width * 0.01),
                          width: media.width * 0.95,
                          height: media.width * 0.4,
                          decoration: const BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage('assets/images/logo2.png'),
                                  fit: BoxFit.contain)),
                        ),
                        Container(
                          alignment: Alignment.center,
                            child: Text(
                              "Book Rides Like a Pro",
                              style: GoogleFonts.poppins(
                                  fontSize: media.width * twenty,
                                  fontWeight: FontWeight.normal,
                                  color: textColor),

                            ),
                        ),
                        SizedBox(

                          height: 30,
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Enter Your Phone Number:",
                            style: GoogleFonts.poppins(
                                fontSize: media.width * sixteen,
                                fontWeight: FontWeight.normal,
                                color: textColor),

                          ),
                        ),
                        SizedBox(

                          height: 8,
                        ),
                        Container(
                          padding: const EdgeInsets.only(bottom: 5),
                          height: 55,
                          width: media.width * 1 - (media.width * 0.08 * 2),

                          child: Row(
                            children: [

                              InkWell(
                                /*onTap: () async {
                                  if (countries.isNotEmpty) {
                                    //dialod box for select country for dial code
                                    await showDialog(
                                        context: context,
                                        barrierColor: (isDarkTheme == true)
                                            ? textColor.withOpacity(0.3)
                                            : Colors.black.withOpacity(0.5),
                                        builder: (context) {
                                          var searchVal = '';
                                          return AlertDialog(
                                            backgroundColor: page,
                                            insetPadding:
                                                const EdgeInsets.all(10),
                                            content: StatefulBuilder(
                                                builder: (context, setState) {
                                              return Container(
                                                width: media.width * 0.9,
                                                color: page,
                                                child: Directionality(
                                                  textDirection:
                                                      (languageDirection ==
                                                              'rtl')
                                                          ? TextDirection.rtl
                                                          : TextDirection.ltr,
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 20,
                                                                right: 20),
                                                        height: 40,
                                                        width:
                                                            media.width * 0.9,
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20),
                                                            border: Border.all(
                                                                color:
                                                                    Colors.grey,
                                                                width: 1.5)),
                                                        child: TextField(
                                                          decoration: InputDecoration(
                                                              contentPadding: (languageDirection == 'rtl')
                                                                  ? EdgeInsets.only(
                                                                      bottom: media.width *
                                                                          0.035)
                                                                  : EdgeInsets.only(
                                                                      bottom: media.width *
                                                                          0.04),
                                                              border: InputBorder
                                                                  .none,
                                                              hintText: languages['en'][
                                                                  'text_search'],
                                                              hintStyle: GoogleFonts.roboto(
                                                                  color: textColor
                                                                      .withOpacity(
                                                                          0.4),
                                                                  fontSize: media.width *
                                                                      sixteen)),
                                                          style: GoogleFonts
                                                              .roboto(
                                                                  color:
                                                                      textColor),
                                                          onChanged: (val) {
                                                            setState(() {
                                                              searchVal = val;
                                                            });
                                                          },
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                          height: 20),
                                                      Expanded(
                                                        child:
                                                            SingleChildScrollView(
                                                          child: Column(
                                                            children: countries
                                                                .asMap()
                                                                .map(
                                                                    (i, value) {
                                                                  return MapEntry(
                                                                      i,
                                                                      SizedBox(
                                                                        width: media.width *
                                                                            0.9,
                                                                        child: (searchVal == '' &&
                                                                                countries[i]['flag'] != null)
                                                                            ? InkWell(
                                                                                onTap: () {
                                                                                  setState(() {
                                                                                    phcode = i;
                                                                                  });
                                                                                  Navigator.pop(context);
                                                                                },
                                                                                child: Container(
                                                                                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                                                                                  color: page,
                                                                                  child: Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                    children: [
                                                                                      Row(
                                                                                        children: [
                                                                                          Image.network(countries[i]['flag']),
                                                                                          SizedBox(
                                                                                            width: media.width * 0.02,
                                                                                          ),
                                                                                          SizedBox(
                                                                                              width: media.width * 0.4,
                                                                                              child: Text(
                                                                                                countries[i]['name'],
                                                                                                style: GoogleFonts.roboto(fontSize: media.width * sixteen, color: textColor),
                                                                                              )),
                                                                                        ],
                                                                                      ),
                                                                                      Text(
                                                                                        countries[i]['dial_code'],
                                                                                        style: GoogleFonts.roboto(fontSize: media.width * sixteen, color: textColor),
                                                                                      )
                                                                                    ],
                                                                                  ),
                                                                                ))
                                                                            : (countries[i]['flag'] != null && countries[i]['name'].toLowerCase().contains(searchVal.toLowerCase()))
                                                                                ? InkWell(
                                                                                    onTap: () {
                                                                                      setState(() {
                                                                                        phcode = i;
                                                                                      });
                                                                                      Navigator.pop(context);
                                                                                    },
                                                                                    child: Container(
                                                                                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                                                                                      color: page,
                                                                                      child: Row(
                                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                        children: [
                                                                                          Row(
                                                                                            children: [
                                                                                              Image.network(countries[i]['flag']),
                                                                                              SizedBox(
                                                                                                width: media.width * 0.02,
                                                                                              ),
                                                                                              SizedBox(
                                                                                                  width: media.width * 0.4,
                                                                                                  child: Text(
                                                                                                    countries[i]['name'],
                                                                                                    style: GoogleFonts.roboto(fontSize: media.width * sixteen, color: textColor),
                                                                                                  )),
                                                                                            ],
                                                                                          ),
                                                                                          Text(
                                                                                            countries[i]['dial_code'],
                                                                                            style: GoogleFonts.roboto(fontSize: media.width * sixteen, color: textColor),
                                                                                          )
                                                                                        ],
                                                                                      ),
                                                                                    ))
                                                                                : Container(),
                                                                      ));
                                                                })
                                                                .values
                                                                .toList(),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            }),
                                          );
                                        });
                                  } else {
                                    getCountryCode();
                                  }
                                  setState(() {});
                                },*/

                                //input field
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(

                                      ),
                                      borderRadius: BorderRadius.all(Radius.circular(20)),
                                  ),

                                  height: 50,
                                  alignment: Alignment.center,
                                  child: Row(

                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [

                                      SizedBox(

                                        width: media.width * 0.02,
                                      ),

                                      Text(
                                          style: TextStyle(
                                            background: Paint()
                                              ..color = Colors.black26
                                              ..strokeWidth = 0
                                              ..strokeJoin = StrokeJoin.round
                                              ..strokeCap = StrokeCap.round
                                              ..style = PaintingStyle.stroke,
                                            color: Colors.white,
                                          ),
                                        "IN "+countries[phcode]['dial_code']
                                            .toString(),

                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),

                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 4),

                              const SizedBox(width: 10),
                              Container(
                                height: 50,
                                alignment: Alignment.center,
                                width: media.width * 0.64,

                                child: TextFormField(
                                  controller: controller,
                                  textAlign: TextAlign.center,
                                  onChanged: (val) {
                                    setState(() {
                                      phnumber = controller.text;
                                    });
                                    if (controller.text.length ==
                                        countries[phcode]['dial_max_length']) {
                                      FocusManager.instance.primaryFocus
                                          ?.unfocus();
                                    }
                                  },
                                  maxLength: countries[phcode]
                                      ['dial_max_length'],
                                  style: GoogleFonts.roboto(
                                      fontSize: media.width * sixteen,
                                      color: Colors.white,
                                      letterSpacing: 1),
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    hintText: "X X X X X X X X X X",
                                    alignLabelWithHint: true,

                                    counterText: '',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                    filled: true,
                                    hintStyle: TextStyle(color: Colors.white54),
                                    fillColor: Colors.black26,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: media.height * 0.05),
                      /*  Row(
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  if (terms == true) {
                                    terms = false;
                                  } else {
                                    terms = true;
                                  }
                                });
                              },
                              child: Container(
                                  height: media.width * 0.08,
                                  width: media.width * 0.08,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: buttonColor, width: 2),
                                      shape: BoxShape.circle,
                                      color:
                                          (terms == true) ? buttonColor : page),
                                  child: Icon(Icons.done,
                                      color: (isDarkTheme == true)
                                          ? Colors.black
                                          : Colors.white)),
                            ),
                            SizedBox(
                              width: media.width * 0.02,
                            ),

                            //terms and condition and privacy policy url
                            SizedBox(
                              width: media.width * 0.7,
                              child: Wrap(
                                direction: Axis.horizontal,
                                children: [
                                  Text(
                                    languages['en']['text_agree'] +
                                        ' ',
                                    style: GoogleFonts.roboto(
                                        fontSize: media.width * sixteen,
                                        color: textColor.withOpacity(0.7)),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      openBrowser('https://tuffygo.jhund.fun/terms');
                                    },
                                    child: Text(
                                      languages['en']['text_terms'],
                                      style: GoogleFonts.roboto(
                                          fontSize: media.width * sixteen,
                                          color: buttonColor),
                                    ),
                                  ),
                                  Text(
                                    ' ${languages['en']['text_and']} ',
                                    style: GoogleFonts.roboto(
                                        fontSize: media.width * sixteen,
                                        color: textColor.withOpacity(0.7)),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      openBrowser('https://tuffygo.jhund.fun/privacy');
                                    },
                                    child: Text(
                                      languages['en']
                                          ['text_privacy'],
                                      style: GoogleFonts.roboto(
                                          fontSize: media.width * sixteen,
                                          color: buttonColor),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),*/
                        SizedBox(
                          height: media.height * 0.03,
                        ),
                        /*Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.email,
                                size: media.width * eighteen,
                                color: textColor.withOpacity(0.7)),
                            SizedBox(width: media.width * 0.02),
                            Text(
                              languages['en']['text_continue_with'],
                              style: GoogleFonts.roboto(
                                color: textColor.withOpacity(0.7),
                                fontSize: media.width * sixteen,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            SizedBox(
                              width: media.width * 0.01,
                            ),
                            InkWell(
                              onTap: () {
                                controller.clear();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const SignInwithEmail()));
                              },
                              child: Text(
                                languages['en']['text_email'],
                                style: GoogleFonts.roboto(
                                    fontSize: media.width * sixteen,
                                    fontWeight: FontWeight.w400,
                                    color: buttonColor),
                              ),
                            )
                          ],
                        ),*/
                        SizedBox(
                          height: media.height * 0.1,
                        ),
                        SizedBox(
                          width: 400, // <-- Your width
                          height: 48, // <-


                                child:  ElevatedButton(

                                    style: ButtonStyle(

                                        backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
                                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(18.0),
                                                side: BorderSide(width: 2.0,color: Colors.black12),

                                            )
                                        )
                                    ),
                                  onPressed: () async {
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();
                                    setState(() {
                                      _isLoading = true;
                                    });
                                    var val = await otpCall();
                                    if (val.value == true) {
                                      phoneAuthCheck = true;
                                      await phoneAuth(countries[phcode]
                                              ['dial_code'] +
                                          phnumber);
                                      value = 0;
                                      navigate();
                                    } else {
                                      phoneAuthCheck = false;
                                      navigate();
                                    }
                                    setState(() {
                                      _isLoading = false;
                                    });
                                  },
                                  child: Text("SEND OTP",style: TextStyle(
                                    color: Colors.white70,fontSize: 16
                                  ),),
                                ),
                              )

                      ],
                    ),
                  )
                : Container(
                    height: media.height * 1,
                    width: media.width * 1,
                    color: page,
                  ),

            //No internet
            (internet == false)
                ? Positioned(
                    top: 0,
                    child: NoInternet(onTap: () {
                      setState(() {
                        _isLoading = true;
                        internet = true;
                        countryCode();
                      });
                    }))
                : Container(),

            //loader
            (_isLoading == true)
                ? const Positioned(top: 0, child: Loading())
                : Container()
          ],
        ),
      ),
    );
  }
}
