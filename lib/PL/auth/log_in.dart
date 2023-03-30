import 'package:finalmpsadmin/PL/utilites/helper/helper.dart';
import 'package:finalmpsadmin/PL/utilites/strings.dart';
import 'package:finalmpsadmin/PL/utilites/text_style/text_styles.dart';
import 'package:finalmpsadmin/PL/utilites/themes/app_colors/dark_colors.dart';
import 'package:finalmpsadmin/PL/utilites/themes/app_colors/light_colors.dart';
import 'package:finalmpsadmin/PL/utilites/widgets/app_icon.dart';
import 'package:finalmpsadmin/PL/utilites/widgets/custom_button.dart';
import 'package:finalmpsadmin/PL/utilites/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:finalmpsadmin/PL/auth/loding_screen.dart';
import 'package:finalmpsadmin/provider/user_change.dart';
import 'package:provider/provider.dart';
import 'forget_password.dart';

// ignore: must_be_immutable
class LogIn extends StatelessWidget {
  String? screenSizeDesign;
  final formKey = GlobalKey<FormState>();
  String? txtUsername;
  String? txtPassword ;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserChange>(context);
    screenSizeDesign = Helper().getDesignSize(context);
    Color backColor =
    Theme.of(context).colorScheme.background == Color(0xff90caf9)
        ? LightColors.startsBackground
        : DarkColors.startsBackground;

    return Scaffold(
       backgroundColor: backColor,
      body: user.status == Status.Authenticating
          ? LoadingScreen()
          : Form(
                    key: formKey,
                    child: AnnotatedRegion<SystemUiOverlayStyle>(
                      value: SystemUiOverlayStyle.light,
                      child: GestureDetector(
                        onTap: () => FocusScope.of(context).unfocus(),
                        child:  Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              mobileDesign(user,context),
                              vertDivider(),
                              space(),
                              leftColumnWidget(user),
                            ]),
                      ),
                    ),
                  )
    );
  }
  Expanded mobileDesign(UserChange userChange,BuildContext context) {
    return Expanded(child:
        SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
          icon(),
          title(),
          SizedBox(height: 25),
          buildEmailTextFieldWidget(),
          SizedBox(height: 10),
          buildPasswordFieldWidget(),
          SizedBox(height: 10),
          forgetPasswordWidget(context),
          SizedBox(height: 15),
          CustomButton(
          text: Strings.logIn,
          onPress: () async => await onPressLogInButton(userChange)),
          SizedBox(height: 30),
    ],
    ),
        ));
  }

  onPressLogInButton(UserChange userChange) async {
    formKey.currentState!.save();
    if (formKey.currentState!.validate())
      await userChange
          .signInWithEmailAndPassword( txtUsername!,txtPassword!);
  }

  Widget title() {
    return Text(Strings.logIn, style: TextStyles.logInLogo);
  }

  AppIcon icon() {
    Size iconSize = screenSizeDesign == Strings.largeDesign
        ? Size(250, 250)
        : Size(175, 175);
    return AppIcon(size: iconSize);
  }

  CustomTextField buildEmailTextFieldWidget() {
    return CustomTextField(
      icon: Icons.person,
      onSave: (value) => txtUsername = value,
      label: "الإيميل",
      initialValue: txtUsername,
      textInputType: TextInputType.emailAddress,
    );
  }

  CustomTextField buildPasswordFieldWidget() {
    return CustomTextField(
      label: "كلمة المرور",
      icon: Icons.lock,
      onSave: (value) => txtPassword = value,
      initialValue: txtPassword,
      textInputType: TextInputType.emailAddress,
    );
  }

  Widget leftColumnWidget(UserChange userChange) {
    return screenSizeDesign == Strings.smallDesign
        ? Container()
        : Expanded(
      child: Column(children: [
        AppIcon(size: Size(250, 250)),
     Text(Strings.logIn, style: TextStyles.logInLogo)
      ]),
    );
  }

  Widget space() {
    return screenSizeDesign == Strings.smallDesign
        ? Container()
        : SizedBox(
      width: 150,
    );
  }

  Widget vertDivider() {
    return screenSizeDesign == Strings.smallDesign
        ? Container()
        : VerticalDivider(
      color: Colors.white,
      width: 20,
      thickness: 10,
    );
  }

  forgetPasswordWidget(BuildContext context) {
    return Container(
      alignment: Alignment.centerRight,
      child:TextButton(
      child: Text(
      Strings.forgetPassword,
      style: TextStyles.title.copyWith(color: Colors.white,fontSize: 16),
    ),
    onPressed: ()=>Helper().goTo(context: context,to: ForgetPassWord())));
  }
}