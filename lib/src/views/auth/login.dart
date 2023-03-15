import 'package:flutter/material.dart';
// import 'package:zona_hub/src/services/Auth/auth_controller.dart';
import 'package:zona_hub/src/services/Auth/sign_in_provider.dart';
import 'package:provider/provider.dart';
import 'package:zona_hub/src/views/auth/register.dart';
import 'package:zona_hub/src/views/root.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Container(
            margin: const EdgeInsets.all(10),
            child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _emailController,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(labelText: "Email"),
              ),
              const SizedBox(height: 4,),
              TextField(
                controller: _passwordController,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(labelText: "Password"),
                obscureText: true,
              ),
              
              const SizedBox(height: 4,),

              ElevatedButton(
                onPressed: () => handleEmailSignIn(),
                child: const Text("Login"),
              ),
              
              ElevatedButton(
                onPressed: ()=>{
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const SignUpPage()))
                },
                child: const Text("Register"),
              ),
              
              Row(
                children: [
                  ElevatedButton(
                    child: Image.network("https://cdn-icons-png.flaticon.com/512/61/61045.png", width: 50,),
                    onPressed: (){
                      handleFacebookSignIn();
                    },
                  ),
                  ElevatedButton(
                    child: Image.network("https://e7.pngegg.com/pngimages/704/688/png-clipart-google-google.png", width: 50,),
                    onPressed: (){
                      handleGoogleSignIn();
                    },
                  )
                ],
              )
            ],
            ),
          ),
        )
      ),
    );
  }

  Future handleFacebookSignIn() async {
    final sp = context.read<SignInProvider>();
    await sp.signInWithFacebook().then((value){
      if (sp.hasError == true){
        debugPrint("Error de fb auth: ${sp.errorCode.toString()}");
      }else{
        sp.saveDataToSP().then((value) => sp.setSignIn().then((value){
          handleAfterSignIn();
        }));   
      }
    });
  }

  Future handleGoogleSignIn() async {
    final sp = context.read<SignInProvider>();
    await sp.signInWithGoogle().then((value){
      if(sp.hasError){
        debugPrint(sp.errorCode);
      }else{
        sp.saveDataToSP().then((value) => sp.setSignIn().then((value){
          handleAfterSignIn();
        }));       
      }
    });
  }

  Future handleEmailSignIn()async{
    final sp = context.read<SignInProvider>();
    await sp.signInWithEmail(_emailController, _passwordController).then((value){
      if(sp.hasError == true){
        debugPrint("Error Email auth:  ${sp.errorCode}");
      }else{
        sp.saveDataToSP().then((value) => sp.setSignIn().then((value){
          handleAfterSignIn();
        }));   
      }
    });
    }
  
  handleAfterSignIn(){
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Root()));
  }
}

