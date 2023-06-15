import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'auth.dart';
import 'email_verification_page.dart';

class Register extends StatefulWidget {

 // const Register({Key? key}) : super(key: key);
  final Function toggleView;
  Register({required this.toggleView});

  @override
  State<Register> createState() => _RegisterState();

}

class _RegisterState extends State<Register> {
  bool _isLoading = false;
  final picker = ImagePicker();
  PickedFile image = PickedFile("");
  Future getimage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      image = pickedFile as PickedFile;
    }
    );
  }
  final AuthService _auth = AuthService();
  final formKey = GlobalKey<FormState>();
  String email = '';
  String password = 'begbeb1';
  String error = '';
  String name = '';
  String age = '';
  String major = '';
  String sex = '';
  String genderpref = '';
  String hobbies = '';
  String location = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold( /*TODO validate scaffold */
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("UMD Dating App"),
        centerTitle: true,
        backgroundColor: Colors.red.shade800,
        actions: [
          TextButton.icon(
            onPressed:(){
              widget.toggleView();
            } ,
            icon: Icon(Icons.person),
            label: Text("Sign In"),
          )
        ],
      ),
      body: Center(
      child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 18),
          child: Form(
            key: formKey,

          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TextFormField(
                //controller: _emailController,

                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                    const BorderSide(color: Colors.grey, width: 1),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                    const BorderSide(color: Colors.grey, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                    const BorderSide(color: Colors.grey, width: 1),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Enter Email',
                  // hintStyle: AppTextStyle.lightGreyText,
                  isDense: true,
                  contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
                ),
                validator: (val) {
                  if(val!.isEmpty) {
                    return "Enter an email address";
                  }
                  if(!val.endsWith("terpmail.umd.edu")) {
                    return "Email address must be a terpmail email address.";
                  }
                  return null;

                },onChanged: (val) {
                  setState(() => email = val);
                },
              ),
              const SizedBox(height: 20,),
              TextFormField(
                //controller: _passwordController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                    const BorderSide(color: Colors.grey, width: 1),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                    const BorderSide(color: Colors.grey, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                    const BorderSide(color: Colors.grey, width: 1),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Enter Password',
                  // hintStyle: AppTextStyle.lightGreyText,
                  isDense: true,
                  contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
                ),
                obscureText: true,
                validator: (val) => val!.length < 6 ? 'Enter a password with more than 6 characters' : null,
                onChanged: (val) {
                  setState(() => password = val);
                },
              ),
              const SizedBox(height: 20,),
              _isLoading ? const CircularProgressIndicator() : ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red, // Background color
                  ),
                  onPressed: ()async{
                if(formKey.currentState!.validate()) {
                  setState(() {
                    _isLoading = true;
                  });
                }
                //if(formKey.currentState!.validate()) {
                  /*dynamic result = */ /*await _auth.signUp(email, password, context);*/

                  //if(result == null) {
                  //  setState(() => error = 'Please supply a valid email');
                  //}
                //}
                if( FirebaseAuth.instance.currentUser != null){
                  Navigator.push(context, MaterialPageRoute(builder: (ctx)=>const EmailVerificationScreen()));
                }
                setState(() {
                  _isLoading = false;
                });
              }, child: const Text('Sign Up'))
            ],
          ),
       ),
     ),
      ),
    );
  }




}
