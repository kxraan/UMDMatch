import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../services/auth.dart';

class Register extends StatefulWidget {

 // const Register({Key? key}) : super(key: key);
  final Function toggleView;
  Register({required this.toggleView});

  @override
  State<Register> createState() => _RegisterState();

}

class _RegisterState extends State<Register> {
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
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("UMD Dating App"),
          centerTitle: true,
          backgroundColor: Colors.red,
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
        body:Container(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
          child: Form(
            key: formKey,
            child: ListView(
              children: [
                SizedBox(height: 20),
                TextFormField(
                    decoration: InputDecoration(
                      labelText: "Email",
                    ),
                    validator: (val) {
                      if(val!.isEmpty) {
                        return "Enter an email address";
                      }
                      if(!val.endsWith("terpmail.umd.edu")) {
                        return "Email address must be a terpmail email address.";
                      }
                      return null;

                    },
                  onChanged: (val) {
                    setState(() => email = val);
                  },
                ),
               /* SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Password",
                  ),
                  validator: (val) => val!.length < 6 ? 'Enter a password with more than 6 characters' : null,
                  obscureText: true,
                  onChanged: (val) {
                    setState(() => password = val);
                  },
                ),*/
              /*  SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Name",
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter your name";
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() => name = value);
                  },
                ),*/
               /* SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Age",
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter your age";
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() => age = value);
                  },
                ),*/
               /* SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Sex",
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter your sex";
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() => sex = value);
                  },
                ),*/
                /*TextFormField(
                  decoration: InputDecoration(
                    labelText: "Gender Preferences",
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "This field is empty";
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() => genderpref = value);
                  },
                ),*/
               /* TextFormField(
                  decoration: InputDecoration(
                    labelText: "Major",
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter your major";
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() => major = value);
                  },
                ),*/
               /* SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Hobbies and Interests",
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "This field is empty";
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() => hobbies = value);
                  },
                ),*/
               /* TextFormField(
                  decoration: InputDecoration(
                    labelText: " Apartment/Residence Hall ",
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "This field is empty";
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() => location = value);
                  },
                )*/
             /*   SizedBox(height: 20),*/
                ElevatedButton(
                    onPressed: () async {
                      if(formKey.currentState!.validate()) {
                        dynamic result = await _auth.register(email, password);
                        if(result == null) {
                          setState(() => error = 'Please supply a valid email');
                        }
                      }
                    },
                    child:Text(//style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                      "REGISTER",
                       style: TextStyle(color: Colors.tealAccent),
                    )

                ),
               /* SizedBox(height: 20),*/
                /*Text(
                  error,
                  style: TextStyle(color: Colors.red, fontSize: 14.0),
                )*/

              ],
            ),
          ),
          /*ElevatedButton(
              onPressed: () {
              },
              child:ElevatedButton.icon(
                  onPressed: () {

                  },
                  icon: Icon(
                      Icons.account_circle
                  ),
                  label: Text("LOGIN")
                // style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
              )

          ),*/

          /*ElevatedButton(
            onPressed: () {  },
            icon: Icon(
              Icons.
            )

          )*/


        )
    );

  }
  Widget imageProfile() {
    return Stack(
      children: [
        CircleAvatar(
          radius: 80.0,
          backgroundImage: AssetImage("assets/profile_img.png"),
        ),
        Positioned(
            bottom:20,
            top:20,
            child: Icon(
              Icons.camera_alt,
              color: Colors.teal,
              size: 28.0,
            )
        )
      ],
    );
  }
}
