import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zona_hub/src/services/user_service.dart';

class Storage {
  final Reference firebaseStorage = FirebaseStorage.instance.ref();
  final ImagePicker imagePicker = ImagePicker();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  bool _hasError = false;
  bool get hasError => _hasError;

  String? _errorCode;
  String? get errorCode => _errorCode;

  Future<String> getImageURL(ImageSource source) async {
    XFile? file = await imagePicker.pickImage(source: source);
    if (file != null) {
      Reference referenceDirImages = firebaseStorage.child('profile_images');
      Reference referenceFile =
          referenceDirImages.child(firebaseAuth.currentUser!.uid);
      //Upload file
      try {
        await referenceFile.putFile(File(file.path));
        String photoURL = await referenceFile.getDownloadURL();
        return photoURL;
      } catch (e) {
        _hasError = true;
        _errorCode = e.toString();
      }
    }
    return "0";
  }

  updateProfilePhoto(String photoURL) async {
    try {
      await UserService().updateUserAvatar(photoURL);
    } catch (e) {
      _hasError = true;
      _errorCode = e.toString();
    }
  }

  uploadPostImage(File file) async {
    Reference referenceDirImages = firebaseStorage.child('profile_images');
    Reference referenceFile =
        referenceDirImages.child(file.uri.pathSegments.last);
    try {
      await referenceFile.putFile(file);
      String photoURL = await referenceFile.getDownloadURL();
      return photoURL;
    } catch (e) {
      _hasError = true;
      _errorCode = e.toString();
    }
  }
}
