import 'dart:ffi';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tflite/tflite.dart';
import 'package:image_picker/image_picker.dart';

class PhotoRecognition extends StatefulWidget {
  @override
  _PhotoRecognitionState createState() => _PhotoRecognitionState();
}

class _PhotoRecognitionState extends State<PhotoRecognition> {
  bool _isLoading;
  File _image;
  List _output;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _isLoading = true;

    loadModel().then((value) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Photo Grading"),
        ),
        body: Center(
          child: _isLoading
              ? Container(
              alignment: Alignment.center,
              child: CircularProgressIndicator())
              : Container(
            width: MediaQuery
                .of(context)
                .size
                .width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _image == null ? Container() : Image.file(_image),
                SizedBox(
                  height: 20,
                ),
                _output != null
                    ? Text(
                  convertLabel(_output[0]["label"]),
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                  ),
                )
                    : Container(
                  child: Center(
                    child: Text("Upload your Photo"),
                  ),
                )
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: pickImage,
          label: Text("Upload Your Photo"),
          icon: Icon(Icons.add_photo_alternate_outlined),
        ));
  }

  convertLabel(String msg) {
    if (msg == "0 motion_blur") {
      return "Your photo is too blurry!";
    }
    else if (msg == "1 defocused_blur") {
      return "Your photo is out of focus!";
    }
    else {
      return "Perfect, sharp, clean image!";
    }
  }

  pickImage() async {
    final _storage = FirebaseStorage.instance;
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    var file = File(image.path);
    if (image == null) return null;
    setState(() {
      _isLoading = true;
      _image = image;
    });

    if (image != null) {
      try{
        var snapshot = await _storage.ref()
            .child('photoGrading/${_output[0]["label"]}')
            .putFile(file);

        // var downloadURL =  await snapshot.ref.getDownloadURL();

        Fluttertoast.showToast(
            msg: "Successfully uploaded photo to Firebase!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0
        );
      }
      catch(err){
        Fluttertoast.showToast(
            msg: err,
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
        );
      }
    }

    // Classify
    classifyImage(image);
  }

  classifyImage(File image) async {
    var output = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 2,
      threshold: 0.5,
      imageMean: 127.5,
      imageStd: 127.5,
    );
    setState(() {
      _isLoading = false;
      _output = output;
    });
  }

  loadModel() async {
    await Tflite.loadModel(
      model: "assets/model_unquant.tflite",
      labels: "assets/labels.txt",
    );
  }

  uploadImage() {
    // Permission check

  }

  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }
}
