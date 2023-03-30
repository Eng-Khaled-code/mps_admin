import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../provider/user_change.dart';
import '../utilites/text_style/text_styles.dart';

class ImageWidget extends StatelessWidget {
  ImageWidget({Key? key, this.userChange}) : super(key: key);
  final UserChange? userChange;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return InkWell(
        onTap: () async => onPressPhotoButton(context),
        child: networkImageWidget(width));
  }

  onPressPhotoButton(BuildContext context) {
    return showDialog(
        context: context,
        builder: (con) {
          return SimpleDialog(
            title: Text(
              "اختر صورة",
              style: TextStyles.title,
            ),
            children: [
              SimpleDialogOption(
                child: Text("الكاميرا"),
                onPressed: () => picImage(ImageSource.camera, context),
              ),
              SimpleDialogOption(
                child: Text("معرض الصور"),
                onPressed: () => picImage(ImageSource.gallery, context),
              ),
              SimpleDialogOption(
                child: Text("رجوع"),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        });
  }

  picImage(ImageSource imageSource, BuildContext context) async {
    Navigator.pop(context);
    final pickedImage = await ImagePicker().pickImage(source: imageSource);
    File image = File(pickedImage!.path);
    await userChange!.updateProfilePicture(imageFile: image);
  }

  Widget networkImageWidget(double width) {
    return ClipOval(
      child: Container(
        color: Colors.grey,
        height: width * 0.3,
        width: width * 0.3,
        child: Center(
          child: userChange!.isImageLoading
              ? CircularProgressIndicator()
              : FadeInImage.assetNetwork(
                  image: userChange!.userData!.imageUrl,
                  fit: BoxFit.cover,
                  placeholder: "assets/images/glow.gif"),
        ),
      ),
    );
  }
}
