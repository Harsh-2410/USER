// import 'dart:async';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tagxiuser/pages/loadingPage/loading.dart';
import 'package:tagxiuser/pages/onTripPage/booking_confirmation.dart';
import 'package:tagxiuser/pages/onTripPage/invoice.dart';
import 'package:tagxiuser/pages/language/languages.dart';
import 'package:tagxiuser/pages/login/login.dart';
import 'package:tagxiuser/pages/onTripPage/map_page.dart';
import 'package:tagxiuser/pages/noInternet/nointernet.dart';
import 'package:tagxiuser/widgets/widgets.dart';
import '../../styles/styles.dart';
import '../../functions/functions.dart';
import 'package:http/http.dart' as http;

class LoadingPage extends StatefulWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  String dot = '.';
  bool updateAvailable = false;

  bool _isLoading = false;
  late Timer _timer;
  @override
  void initState() {

    getLanguageDone();

    super.initState();
  }

  //navigate
  navigate() {
    if (userRequestData.isNotEmpty && userRequestData['is_completed'] == 1) {
      //invoice page of ride
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const Invoice()),
          (route) => false);
    } else if (userRequestData.isNotEmpty &&
        userRequestData['is_completed'] != 1) {
      //searching ride page
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
    } else {
      //home page
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const Maps()),
          (route) => false);
    }
  }

//get language json and data saved in local (bearer token , choosen language) and find users current status
  getLanguageDone() async {
    await getDetailsOfDevice();
    if (internet == true) {
      var val = await getLocalData();

      if (val == '3') {
        navigate();
      } else if (val == '2') {
        Future.delayed(const Duration(seconds: 5,milliseconds: 10), () {
          //login page
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => const Login()));
        });
      } else {
        Future.delayed(const Duration(seconds: 5,milliseconds: 10), () {
          //choose language page
          Navigator.pushReplacement(context,//MaterialPageRoute(builder: (context) => const Login()));
             MaterialPageRoute(builder: (context) => const Languages()));
        });
      }
    } else {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return Material(
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              height: media.height * 1,
              width: media.width * 1,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black,Colors.black87,Colors.black87, Colors.black,],
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,

                children: [
                  Container(
                    padding: EdgeInsets.all(media.width * 0),
                    width: media.width *1.55,
                    height: media.width * 2.0,

                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/images/loading.gif'),
                            fit: BoxFit.contain)),
                  ),
                ],
              ),
            ),

            //update available

            (updateAvailable == true)
                ? Positioned(
                    top: 0,
                    child: Container(
                      height: media.height * 1,
                      width: media.width * 1,
                      color: Colors.transparent.withOpacity(0.6),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                              width: media.width * 0.9,
                              padding: EdgeInsets.all(media.width * 0.05),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: page,
                              ),
                              child: Column(
                                children: [
                                  SizedBox(
                                      width: media.width * 0.8,
                                      child: Text(
                                        'New version of this app is available in store, please update the app for continue using',
                                        style: GoogleFonts.roboto(
                                            fontSize: media.width * sixteen,
                                            fontWeight: FontWeight.w600),
                                      )),
                                  SizedBox(
                                    height: media.width * 0.05,
                                  ),
                                  Button(
                                      onTap: () async {
                                        if (platform ==
                                            TargetPlatform.android) {
                                          openBrowser(
                                              'https://play.google.com/store/apps/details?id=${package.packageName}');
                                        } else {
                                          setState(() {
                                            _isLoading = true;
                                          });
                                          var response = await http.get(Uri.parse(
                                              'http://itunes.apple.com/lookup?bundleId=${package.packageName}'));
                                          if (response.statusCode == 200) {
                                            openBrowser(jsonDecode(
                                                    response.body)['results'][0]
                                                ['trackViewUrl']);
                                          }

                                          setState(() {
                                            _isLoading = false;
                                          });
                                        }
                                      },
                                      text: 'Update')
                                ],
                              ))
                        ],
                      ),
                    ))
                : Container(),

            //loader
            (_isLoading == true && internet == true)
                ? const Positioned(top: 0, child: Loading())
                : Container(),

            //no internet
            (internet == false)
                ? Positioned(
                    top: 0,
                    child: NoInternet(
                      onTap: () {
                        setState(() {
                          internetTrue();
                          getLanguageDone();
                        });
                      },
                    ))
                : Container(),
          ],
        ),
      ),
    );
  }
}
