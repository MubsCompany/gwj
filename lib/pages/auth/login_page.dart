import 'package:flutter/material.dart';
import 'package:template/blocs/auth/login_bloc.dart';
import 'package:template/blocs/global_bloc.dart';
import 'package:template/utils/uidata.dart';
import 'package:template/utils/validator.dart';
import 'package:template/bottom_wave.dart';
import 'package:template/widgets/base_container_widget.dart';
import 'package:template/widgets/custom_text_form_field_widget.dart';
import 'package:template/widgets/loading_widget.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with ValidationMixin {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  LoginBloc loginBloc = LoginBloc();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Scaffold(
          body: Stack(
            children:<Widget>[
              Wave(),
              Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView(
                    shrinkWrap: true,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            height: MediaQuery.of(context).size.width * 0.2,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Let's sign in",
                                style: TextStyle(
                                    color: Color.fromARGB(1000, 1, 163, 255),
                                    fontWeight: FontWeight.w900,
                                    fontSize: 40)),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.width * 0.1,
                          ),
                          Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            margin: EdgeInsets.all(10),
                            color: Color(0xf0f0f0f0),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Color(0xffffffff),
                                        border: Border.all(
                                            color: Color(0x9f9f9f9f), width: 1),
                                        borderRadius:
                                        BorderRadius.all(Radius.circular(15))),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                      child: CustomTextFormFieldWidget(
                                        border: InputBorder.none,
                                        labelText: "User Code",
                                        validator: validateRequired,
                                        onSaved: loginBloc.saveCode,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  MaterialButton(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                    ),
                                    padding: EdgeInsets.symmetric(vertical: 15),
                                    onPressed: () => loginBloc.doLogin(_formKey),
                                    color: UIData.accentColor,
                                    minWidth: double.infinity,
                                    child: Text(
                                      "Sign In",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Color(0xffffffff)),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  MaterialButton(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                    ),
                                    padding: EdgeInsets.symmetric(vertical: 15),
                                    onPressed: () => Navigator.of(context)
                                        .pushNamed("/forgot_code"),
                                    color: UIData.darkPrimaryColor,
                                    minWidth: double.infinity,
                                    child: Text(
                                      "Forgot Code",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Color(0xffffffff)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ]
          ),
        ),
        StreamBuilder(
          initialData: false,
          stream: GlobalBloc.loadingStream,
          builder: (ctxLoad, snapshot) => LoadingWidget(snapshot.data),
        ),
      ],
    );
  }
}
