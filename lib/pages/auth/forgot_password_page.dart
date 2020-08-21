import 'package:flutter/material.dart';
import 'package:template/blocs/auth/forgot_password_bloc.dart';
import 'package:template/blocs/auth/login_bloc.dart';
import 'package:template/blocs/global_bloc.dart';
import 'package:template/utils/uidata.dart';
import 'package:template/utils/validator.dart';
import 'package:template/widgets/base_container_widget.dart';
import 'package:template/widgets/custom_text_form_field_widget.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> with ValidationMixin{
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  GlobalBloc globalBloc;
  ForgotPasswordBloc forgotPasswordBloc;
  @override
  void initState() {
    globalBloc = GlobalBloc();
    forgotPasswordBloc = ForgotPasswordBloc();
    globalBloc.generateFocusNode(3);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Forgot Password"),
      ),
      body: Form(
        key: _formKey,
        child: BaseContainerWidget(
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 20,),
                  Image(
                    image: AssetImage("assets/icon.png"),
                    width: MediaQuery.of(context).size.width / 2.5,
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.all(10),
                    color: UIData.containerColor,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        CustomTextFormFieldWidget(
                            labelText: "Email",
                            keyboardType: TextInputType.emailAddress,
                            validator: validateEmail,
                            focusNode: globalBloc.getFocusNode(0),
                            nextFocusNode: globalBloc.getFocusNode(1),
                            onSaved: forgotPasswordBloc.saveEmail,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.all(10),
                    color: UIData.containerColor,
                    child: Column(
                      children: <Widget>[
                        Text("Verify Data",textAlign: TextAlign.left,style: TextStyle(fontSize: 20),),
                        CustomTextFormFieldWidget(
                          labelText: "Name",
                          focusNode: globalBloc.getFocusNode(1),
                          nextFocusNode: globalBloc.getFocusNode(2),
                          validator: validateRequired,
                          onSaved: forgotPasswordBloc.saveName,
                        ),
                        CustomTextFormFieldWidget(
                          labelText: "Number",
                          focusNode: globalBloc.getFocusNode(2),
                          nextFocusNode: FocusNode(),
                          validator: validateRequired,
                          onSaved: forgotPasswordBloc.saveNumber,
                          keyboardType: TextInputType.number,
                        ),
                        SizedBox(height: 10,),
                        MaterialButton(
                          padding: EdgeInsets.symmetric(vertical: 15),
                          onPressed: () => forgotPasswordBloc.onNext(_formKey),
                          color: UIData.darkPrimaryColor,
                          minWidth: double.infinity,
                          child: Text("Next",textAlign: TextAlign.center,),
                        ),
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}