  import 'package:image_picker/image_picker.dart';

pickPhotoFromGallery() async {
  ImagePicker imagePicker = ImagePicker();
  XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);
}