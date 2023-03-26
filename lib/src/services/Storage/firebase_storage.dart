
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zona_hub/src/models/user_model.dart';
import 'package:zona_hub/src/services/Auth/auth_service.dart';
import 'package:zona_hub/src/services/user_service.dart';

class Storage {
  final Reference firebaseStorage = FirebaseStorage.instance.ref(); 
  final ImagePicker imagePicker = ImagePicker();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

   Future<String> getImageURL (ImageSource source) async {
    XFile? file = await imagePicker.pickImage(source: source);
    if (file != null){
      Reference referenceDirImages = firebaseStorage.child('profile_images'); 
      Reference referenceFile = referenceDirImages.child(file.name);
    //Upload file
      try {
        await referenceFile.putFile(File(file.path));  
        String photoURL = await referenceFile.getDownloadURL();
        return photoURL;
      } catch (e) {
        debugPrint("ERROR AL SUBIR FOTO: ${e.toString()}");
      }
    }
    return "0";
  }

  updateProfilePhoto(String photoURL) async {

    try {
      await firebaseAuth.currentUser!.updatePhotoURL(photoURL);
      
      UserModel currenUser = await AuthService().getCurrentUser();
      
      UserModel newUser = UserModel(
        id: currenUser.id,
        name: currenUser.name,
        email: currenUser.email,
        avatarUrl: photoURL,
        age: currenUser.age,
        location: currenUser.location,
        upPosts: currenUser.upPosts,
        downPosts: currenUser.downPosts,
        communities: currenUser.communities,
        createdAt: currenUser.createdAt,
      );

      await UserService().updateUser(newUser);
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}