import 'package:flutter/material.dart';
import 'package:template/blocs/auth/login_bloc.dart';
import 'package:template/blocs/auth/new_password_bloc.dart';
import 'package:template/utils/uidata.dart';
import 'package:template/utils/validator.dart';
import 'package:template/models/User.dart';
import 'package:template/widgets/base_container_widget.dart';
import 'package:template/widgets/custom_text_form_field_widget.dart';

class NewPasswordPage extends StatefulWidget {
  User user;
  NewPasswordPage({this.user});
  @override
  _NewPasswordPageState createState() => _NewPasswordPageState();
}

class _NewPasswordPageState extends State<NewPasswordPage> with ValidationMixin{
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  NewPasswordBloc newPasswordBloc = NewPasswordBloc();
  TextEditingController _passwordController,_confirmPasswordController;
  @override
  void initState() {
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New Password"),
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
                      children: <Widget>[
                        StreamBuilder(
                          initialData: true,
                          stream: newPasswordBloc.showPasswordStream,
                          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                            return TextFormField(
                              decoration: new InputDecoration(
                                labelText: "New Password",
                                suffixIcon: InkWell(
                                  onTap: ()=> newPasswordBloc.changeVisibility(snapshot.data),
                                  child: Icon(snapshot.data ? Icons.visibility_off : Icons.visibility),
                                )
                              ),
                              obscureText: snapshot.data,
                              validator: validatePassword,
                              onSaved: newPasswordBloc.savePassword,
                              controller: _passwordController,
                            );
                          },
                        ),
                        StreamBuilder(
                          initialData: true,
                          stream: newPasswordBloc.showConfirmPasswordStream,
                          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                            return TextFormField(
                              decoration: new InputDecoration(
                                labelText: "Confirm New Password",
                                suffixIcon: InkWell(
                                  onTap: ()=> newPasswordBloc.changeConfirmVisibility(snapshot.data),
                                  child: Icon(snapshot.data ? Icons.visibility_off : Icons.visibility),
                                )
                              ),
                              obscureText: snapshot.data,
                              validator:(data) => validatePasswordConfirm(data, _passwordController.text),
                              onSaved: newPasswordBloc.saveConfirmPassword,
                              controller: _confirmPasswordController,
                            );
                          },
                        ),
                        SizedBox(height: 10,),
                        MaterialButton(
                          padding: EdgeInsets.symmetric(vertical: 15),
                          onPressed: () => newPasswordBloc.onSave(_formKey,widget.user),
                          color: UIData.darkPrimaryColor,
                          minWidth: double.infinity,
                          child: Text("Save",textAlign: TextAlign.center,),
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