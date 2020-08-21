import 'package:flutter/material.dart';
import 'package:template/blocs/auth/forgot_code_bloc.dart';
import 'package:template/blocs/auth/login_bloc.dart';
import 'package:template/blocs/global_bloc.dart';
import 'package:template/utils/uidata.dart';
import 'package:template/utils/validator.dart';
import 'package:template/widgets/base_container_widget.dart';
import 'package:template/widgets/custom_text_form_field_widget.dart';
import 'package:template/widgets/loading_widget.dart';

import '../../bottom_wave.dart';

class ForgotCodePage extends StatefulWidget {
  @override
  _ForgotCodePageState createState() => _ForgotCodePageState();
}

class _ForgotCodePageState extends State<ForgotCodePage> with ValidationMixin{
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  ForgotCodeBloc forgotCodeBloc;
  @override
  void initState() {
    forgotCodeBloc = ForgotCodeBloc();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Scaffold(
          body: Stack(
            children: <Widget>[
              Wave(),
              Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(height: MediaQuery.of(context).size.width * 0.2,),

                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Validate by your email", style: TextStyle(color: Color.fromARGB(1000, 1, 163, 255), fontWeight: FontWeight.w900, fontSize: 40, letterSpacing: 0.7)),
                        ),

                        SizedBox(height: MediaQuery.of(context).size.width * 0.1,),

                        Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          margin: EdgeInsets.all(10),
                          color: Color.fromARGB(1000, 240, 240, 240),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 25.0, horizontal: 10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                      labelText: "Email",
                                      keyboardType: TextInputType.emailAddress,
                                      validator: validateEmail,
                                      onSaved: forgotCodeBloc.saveEmail,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 25,),
                                MaterialButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                  ),
                                  padding: EdgeInsets.symmetric(vertical: 15),
                                  onPressed: () => forgotCodeBloc.onNext(_formKey),
                                  color: UIData.accentColor,
                                  minWidth: double.infinity,
                                  child: Text("Send",textAlign: TextAlign.center, style: TextStyle(color: Color(0xffffffff)),),
                                ),
                              ],
                            ),
                          ),
                        ),],
                    )
                  ],
                ),
              ),
            ),]
          ),
        ),
        StreamBuilder(
          initialData: false,
          stream: GlobalBloc.loadingStream,
          builder: (ctxLoad,snapshot){
            return LoadingWidget(snapshot.data);
          },
        ),
      ],
    );
  }
}