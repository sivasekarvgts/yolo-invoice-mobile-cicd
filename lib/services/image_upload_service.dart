// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter_styled_toast/flutter_styled_toast.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:image_cropper/image_cropper.dart';
// import 'package:flutter_image_compress/flutter_image_compress.dart';
// import '../../app/styles/colors.dart';
// import '../../locator.dart';
//
// class ProfilePictureService {
//   final ImagePicker _picker = ImagePicker();
//
//   // List of allowed file extensions
//   final List<String> _allowedExtensions = ['jpg', 'jpeg', 'png', 'gif'];
//
//   // Pick an image from gallery or camera
//   Future<File?> pickImage(ImageSource source) async {
//     final pickedFile = await _picker.pickImage(source: source);
//     if (pickedFile == null) {
//       return null;
//     }
//
//     // Validate file extension
//     final extension = pickedFile.path.split('.').last.toLowerCase();
//     if (!_allowedExtensions.contains(extension)) {
//       showToast("Invalid file format", context: navigationService.navigatorKey.currentContext);
//
//       throw Exception("Invalid file format. Only JPG, JPEG, PNG, and GIF are allowed.");
//     }
//
//     return File(pickedFile.path);
//   }
//
//   // Crop the selected image
//   Future<File?> cropImage(File imageFile) async {
//     CroppedFile? croppedFile = await ImageCropper.platform.cropImage(
//       sourcePath: imageFile.path,
//       uiSettings: [
//         IOSUiSettings(
//           minimumAspectRatio: 1.0,
//           aspectRatioPresets: [
//             CropAspectRatioPreset.square,
//             CropAspectRatioPreset.ratio3x2,
//             CropAspectRatioPreset.original,
//             CropAspectRatioPreset.ratio4x3,
//             CropAspectRatioPreset.ratio16x9,
//           ],
//         ),
//         AndroidUiSettings(
//           toolbarTitle: 'Crop Image',
//           toolbarColor: AppColors.primary,
//           toolbarWidgetColor: Colors.white,
//           initAspectRatio: CropAspectRatioPreset.original,
//           lockAspectRatio: false,
//           aspectRatioPresets: [
//             CropAspectRatioPreset.square,
//             CropAspectRatioPreset.ratio3x2,
//             CropAspectRatioPreset.original,
//             CropAspectRatioPreset.ratio4x3,
//             CropAspectRatioPreset.ratio16x9,
//           ],
//         ),
//       ],
//     );
//     return croppedFile != null ? File(croppedFile.path) : null;
//   }
//
//   // Compress the image if it's larger than 500MB
//   Future<File> compressImage(File file) async {
//     final fileLength = await file.length();
//     if (fileLength <= 500 * 1024 * 1024) {
//       return file;
//     }
//
//     final compressedFile = await FlutterImageCompress.compressAndGetFile(
//       file.absolute.path,
//       file.absolute.path.replaceFirst('.jpg', '_compressed.jpg'),
//       quality: 50,
//     );
//
//     return compressedFile != null ? File(compressedFile.path) : file;
//   }
//
//   // Main function to handle the entire process
//   Future<File?> pickCropAndCompressImage(ImageSource source) async {
//     try {
//       File? selectedFile = await pickImage(source);
//       if (selectedFile == null) {
//         return null;
//       }
//
//       File? croppedFile = await cropImage(selectedFile);
//       if (croppedFile == null) {
//         return null;
//       }
//
//       File compressedFile = await compressImage(croppedFile);
//
//       return compressedFile;
//     } catch (e) {
//       print("Error: $e");
//       return null;
//     }
//   }
// }
