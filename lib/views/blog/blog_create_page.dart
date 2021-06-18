import 'dart:io';
import 'dart:ui';
import 'package:tlog/services/static_components.dart';
import 'package:tlog/services/crud.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';
import 'package:country_picker/country_picker.dart';
import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';


class CreateBlog extends StatefulWidget {


  @override
  _CreateBlogState createState() => _CreateBlogState();
}


class _CreateBlogState extends State<CreateBlog> {
  List<String> _duration = ['1-2 days', '3-7 days', '7-20 days', '21 days and above'];
  String _selectedDuration;
  String _selectedCountry;
  String _alongwith;
  List<String> abusivewords=['fuck','piss of','Bloody hell','Bastard','Dick head','Son of a bitch'];
  bool bad=false;


String author, title, desc;
  bool _isLoading = false;
  CrudMethods crudMethods = new CrudMethods();
  File _image;
  final picker = ImagePicker();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  void showSnackBar() {
    final snackBarContent = SnackBar(
      content: Text("yay! posted"),
      duration: Duration(seconds:2),
     );
    _scaffoldKey.currentState.showSnackBar(snackBarContent);
  }


  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
        Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
          Text(
            "Write ",
            style: TextStyle(fontSize: 20, color: Colors.yellow[900]),
          ),
          Text(
            "Tlog",
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        ]),
        actions: <Widget>[],
      ),

      body: _isLoading
          ? Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      )
          : Container(
        margin:EdgeInsets.symmetric(horizontal: 10),
          child: ListView(

            children: <Widget>[
              SizedBox(
                height: 30,
              ),
              Container(
                  child: TextField(
                    decoration: InputDecoration(
                      focusColor: Colors.green,
                      hintText: "Title of Tlog",
                      fillColor: Colors.blue,
                      border: OutlineInputBorder(),
                      labelText: "Title",
                    ),
                    maxLength: 50,
                    minLines: 1,
                    maxLines: 2,
                    onChanged: (val) {
                      title = val;
                    },
                  )),
              SizedBox(
                height: 30,
              ),
              TextField(
                decoration: InputDecoration(
                    focusColor: Colors.red,
                    hintText: "Write the description",
                    fillColor: Colors.blue,
                    border: OutlineInputBorder(),
                    labelText: "Description",
                    labelStyle: TextStyle(
                        letterSpacing: 0.5, fontStyle: FontStyle.italic)),
                autocorrect: true,
                keyboardType: TextInputType.multiline,
                maxLines: 25,
                minLines: 5,
                maxLength: 750,
                onChanged: (val) {
                  desc = val;
                },
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                child: _image != null
                    ? Container(
                    height: 300,
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.file(_image, fit: BoxFit.cover)))
                    : RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: BorderSide(color: Colors.blue[900])),
                  elevation: 10,
                  child: Text("upload picture "),
                  onPressed: () {
                    getImage();
                  },
                ),
              ),

              SizedBox(height: 20,),
              Text("Duration of Trip"),
              DropdownButton(
                hint: Text('Please choose a location'),
                value: _selectedDuration,
                onChanged: (newValue) {
                  setState(() {
                    _selectedDuration = newValue;
                  });
                },
                items: _duration.map((location) {
                  return DropdownMenuItem(
                    child: new Text(location),
                    value: location,
                  );
                }).toList(),
              ),
          SizedBox(height: 20,),
        RaisedButton(
          child: Text("select country"),
            onPressed: (){
              showCountryPicker(
                context: context,
                showPhoneCode: false, // optional. Shows phone code before the country name.
                onSelect: (Country country) {
setState(() {
  _selectedCountry=country.name;
  print('Select country: ${country.name}');
});

                },
              );

        }),
              SizedBox(height: 20,),
        _selectedCountry!=null?Text('Selected country:  '+_selectedCountry,style: TextStyle(color: Colors.purple),):Container(),
      SizedBox(height: 20,),
        Text("Along with:",style: TextStyle(color: Colors.green,fontWeight:FontWeight.bold,fontSize: 16),),
              SizedBox(height: 20,),
              CustomRadioButton(
                elevation: 0,
                absoluteZeroSpacing: true,
                unSelectedColor: Theme.of(context).canvasColor,
                buttonLables: [
                  'Family',
                  'Friends'
                ],
                buttonValues: [
                  "Family",
                  "Friends",
                ],
                buttonTextStyle: ButtonTextStyle(
                    selectedColor: Colors.white,
                    unSelectedColor: Colors.black,
                    textStyle: TextStyle(fontSize: 16)),
                radioButtonValue: (value) {
                  _alongwith=value;
                  print(_alongwith);
                },
                selectedColor: Theme.of(context).accentColor,
              ),


SizedBox(height: 200,),
            ],
          )
      ),
      //DropdownButton<int>();


      floatingActionButton: FloatingActionButton.extended(

        splashColor: Colors.yellow[800],
        focusColor: Colors.red,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14.0),
            side: BorderSide(color: Colors.blue[900])),
        onPressed: () {
String text="Fill all the fields:-\n";

          if(title==null||desc==null||_selectedCountry==null||_duration==null||_alongwith==null){
            if(title==null)
            {
              text+="Title\n";
            }
            if(desc==null)
            {
              text+="Description\n";
            }
            if(_selectedCountry==null)
            {
              text+="Destination Country\n";
            }
            if(_duration==null)
            {
              text+="Duration of trips\n";
            }
            if(_alongwith==null)
            {
              text+="Along with\n";
            }
            showAlertDialog(context,text).showDialog();
            //showAlertDialog(context,"Fill all the fields \n1.Title\n2.Description\n3.Duration\n4.Country\n5.Along With").showDialog();

          }
          else if(title!=null&&desc!=null)
          {
            for (String i in abusivewords)
            {
            if(title.contains(i)||desc.contains(i)){
              bad=true;
              showAlertDialog(context,"Blog contains Abusive words \nPlease don't do that\n Try again").showDialog();
            }
            }
            //abusive words

          }

          if(!bad)
          {
            print("yes checked blog");
            uploadBlog();
          }
          else{bad=false;}

        },
        label: Text(
          'Post',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }


  Future<bool> uploadBlog() async {
    var downloadUrl;
    setState(() {
      _isLoading = true;
    });
    if (_image != null) {
      Reference firebaseStorageRef = FirebaseStorage.instance
          .ref()
          .child("tlogimages")
          .child("${randomAlphaNumeric(10)}.jpg");

      final UploadTask taskSnapshot = firebaseStorageRef.putFile(_image);
      downloadUrl = await (await taskSnapshot).ref.getDownloadURL();
    }

    else {
      downloadUrl=cUser.photoURL;
    }
    print("this is the downloadURL" + downloadUrl);
    Map<String, dynamic> blogMap = {
      "imgUrl": downloadUrl,
      "authorName": cUser.displayName,
      "title": title,
      "desc": desc,
      "liked_user_ids":[],
      "time":DateTime.now().toString(),
      "likes_count":0,
      "commentIDs":[],
      "duration":_selectedDuration,
      "country":_selectedCountry,
      "alongwith":_alongwith,
    };
    print(blogMap);
    crudMethods.addData(blogMap).then((result) {

      _isLoading=false;
      //showSnackBar();
      Navigator.pop(context);

    });
  }


 showAlertDialog(BuildContext context,String message) {

    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Error"),
      content: Text(message),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}