import 'package:finalmpsadmin/PL/utilites/text_style/text_styles.dart';
import 'package:finalmpsadmin/PL/utilites/widgets/custom_button.dart';
import 'package:finalmpsadmin/PL/utilites/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';

class ForgetPassWord extends StatelessWidget {

  String? txtUsername ;
  final formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
      body: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
      SizedBox(height: MediaQuery.of(context).size.height * 0.04),
    Text(
    "نسيت كلمة المرور؟",
    style: TextStyles.title.copyWith(color: Colors.white),
    ),
    Text(
    "من فضلك إدخل الإيميل \nونحن سوف نرسل لك رابط لإستعادة حسابك",
    textAlign: TextAlign.center,
    ),
    SizedBox(height: MediaQuery.of(context).size.height * 0.1),
    CustomTextField(
    icon: Icons.mail,
    onSave: (value) => txtUsername = value,
    label: "الإيميل",
    textInputType: TextInputType.emailAddress,
    ),
    SizedBox(height: MediaQuery.of(context).size.height * 0.07),
    CustomButton(
    text: "إستمرار",
    onPress: () => onPress(),
    )
    ],
    )));
  }

  onPress() {
    formKey.currentState!.save();
    if (formKey.currentState!.validate()) {}
  }
}
