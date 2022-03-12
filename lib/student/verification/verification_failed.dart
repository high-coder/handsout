import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utils/our_text_styles.dart';


class VerificationFailedPage extends StatefulWidget {
  const VerificationFailedPage({Key? key}) : super(key: key);

  @override
  _VerificationFailedPageState createState() => _VerificationFailedPageState();
}

class _VerificationFailedPageState extends State<VerificationFailedPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left:28.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Verification", style: MyTextStyle.heading4,),
              Row(
                children: [
                  Text("Failed", style: MyTextStyle.heading4,),
                  const Icon(Icons.cancel),
                ],
              ),
              const SizedBox(height: 10,),
              Container(
                width: 69,
                color: Colors.black.withOpacity(0.4),
                height: 2,
              ),

              const SizedBox(height: 30,),
              Text("Maybe",style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),),
              const SizedBox(height: 10,),

              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(),
                  ),
                  Expanded(
                    flex: 11,
                    child:Text("- You are not eligible to register",style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w400),),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container()
                  ),
                  Expanded(
                    flex: 11,
                    child:Text("- Given invalid documents.",style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w400),),
                  ),
                ],
              ),Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container()
                  ),
                  Expanded(
                    flex: 11,
                    child:Text("- Given false information or data.",style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w400),),
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
