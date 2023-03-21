import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zona_hub/src/components/warnings/snackbar.dart';
import 'package:zona_hub/src/constants/images.dart';
import 'package:zona_hub/src/services/Auth/sign_in_provider.dart';
import 'package:provider/provider.dart';
import 'package:zona_hub/src/views/root.dart';

class PagesLogin extends StatefulWidget {
  const PagesLogin({super.key});

  @override
  State<PagesLogin> createState() => _PagesLoginState();
}

class _PagesLoginState extends State<PagesLogin> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          PageIcon(
            source: GlobalConstansImages.facebookSVG, 
            onPressed: () {
              handleFacebookSignIn();
            }),
          const SizedBox(width: 10.0),
          PageIcon(
            source: GlobalConstansImages.googleSVG, 
            onPressed: () {
              handleGoogleSignIn();
            }),
        ],
      ),
    );
  }

  
  
  void handleFacebookSignIn() {
    openDialogLoader();
    final sp = context.read<SignInProvider>();
    sp.signInWithFacebook().then((value) {
      if (sp.hasError == true) {
        Navigator.of(context).pop(); // Close loader 
        showSnackBar(context: context, text: sp.errorCode!);
      }else{
        sp.setSignIn().then((value){
          handleAfterSignIn();
        });
      }
    });
  }

  void handleGoogleSignIn() async {
    openDialogLoader();
    final sp = context.read<SignInProvider>();
    await sp.signInWithGoogle().then((value){
      if(sp.hasError){
        Navigator.of(context).pop(); // Close loader 
        showSnackBar(context: context, text: sp.errorCode!);
      }else{
        sp.setSignIn().then((value){
          handleAfterSignIn();
        });     
      }
    });
  }

  //Puede ir en utils
  openDialogLoader(){
    showDialog(
      context: context, 
      barrierDismissible: false,
      builder: (_){
        return const Center(child: CircularProgressIndicator(),);
      }
    );
  }
  handleAfterSignIn(){
    Navigator.of(context).pop(); // Close loader 
    // Go to root page
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Root()));
  }

}

  
class PageIcon extends StatelessWidget {
  final String source;
  final VoidCallback onPressed; 

  const PageIcon({super.key, required this.source, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        padding: const EdgeInsets.all(4.0),
      ),
      onPressed: onPressed,
      child: SvgPicture.asset(
        source,
        width: 40.0,
        height: 40.0,
        // color: Colors.black,
        semanticsLabel: 'Zona Hub',
        placeholderBuilder: (BuildContext context) => Container(
          padding: const EdgeInsets.all(30.0),
          child: const CircularProgressIndicator(),
        ),
      )
  
    );
  }
}