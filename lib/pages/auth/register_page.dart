import 'dart:io';

import 'package:flutter/material.dart';
import 'package:template/blocs/auth/register_bloc.dart';
import 'package:template/blocs/global_bloc.dart';
import 'package:template/utils/global_function.dart';
import 'package:template/utils/uidata.dart';
import 'package:template/utils/validator.dart';
import 'package:template/widgets/base_container_widget.dart';
import 'package:template/widgets/custom_text_form_field_widget.dart';
class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> with ValidationMixin{
  GlobalBloc globalBloc = GlobalBloc();
  RegisterBloc registerBloc = RegisterBloc();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final FocusNode _nameFocus = FocusNode();
  final FocusNode _addressFocus = FocusNode();
  final FocusNode _numberFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  TextEditingController _roleCodeController = TextEditingController();
  Map<String,String> listRole = {
    "1":"Direktur",
    "2":"General manager",
    "3":"Sekretaris",
    "4":"General Affair",
    "5":"Staff",
    "6":"Admin",
  };
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register"),
      ),
      body: Form(
        key: _formKey,
        child: BaseContainerWidget(
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.all(10),
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(10),
                    color: UIData.containerColor,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        StreamBuilder(
                          stream: globalBloc.uploadedFileStream,
                          builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
                            Widget child;
                            if(snapshot.hasData){
                              child = ClipRRect(
                                borderRadius: BorderRadius.circular(120),
                                child: Image(image: FileImage(snapshot.data),fit: BoxFit.cover,)
                              );
                            }else{
                              child = Icon(Icons.person,color: Colors.white,size: 120,);
                            }
                            return InkWell(
                              onTap: () => globalBloc.uploadFile(),
                              child: Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black, width: 1),
                                  borderRadius: BorderRadius.circular(120)
                                ),
                                child: child,
                              ),
                            );
                          },
                        ),
                        CustomTextFormFieldWidget(
                          labelText: "Name",
                          focusNode: _nameFocus,
                          nextFocusNode: _addressFocus,
                          validator: validateRequired,
                          onSaved: registerBloc.saveName,
                        ),
                        CustomTextFormFieldWidget(
                          textInputAction: TextInputAction.newline,
                          labelText: "Address",
                          focusNode: _addressFocus,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          validator: validateRequired,
                          onSaved: registerBloc.saveAddress,
                        ),
                        CustomTextFormFieldWidget(
                          labelText: "Number",
                          focusNode: _numberFocus,
                          keyboardType: TextInputType.number,
                          nextFocusNode: _emailFocus,
                          validator: validateRequiredNumber,
                          onSaved: registerBloc.saveNumber,
                        ),

                        CustomTextFormFieldWidget(
                          labelText: "Email",
                          focusNode: _emailFocus,
                          keyboardType: TextInputType.emailAddress,
                          nextFocusNode: _passwordFocus,
                          validator: validateEmail,
                          onSaved: registerBloc.saveEmail,
                        ),
                        StreamBuilder(
                          initialData: true,
                          stream: registerBloc.showPasswordStream,
                          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                            return TextFormField(
                              decoration: new InputDecoration(
                                labelText: "Password",
                                suffixIcon: InkWell(
                                  onTap: ()=> registerBloc.changeVisibility(snapshot.data),
                                  child: Icon(snapshot.data ? Icons.visibility_off : Icons.visibility),
                                )
                              ),
                              obscureText: snapshot.data,
                              focusNode: _passwordFocus,
                              validator: validatePassword,
                              onSaved: registerBloc.savePassword,
                            );
                          },
                        ),
                        StreamBuilder(
                          initialData: null,
                          stream: registerBloc.roleStream,
                          builder: (BuildContext ctx, AsyncSnapshot<String> snapshot){
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: DropdownButton(
                                isExpanded: true,
                                hint: Text('Please choose your role'),
                                value: snapshot.data,
                                onChanged: registerBloc.saveRole,
                                items: listRole.keys.map((index) {
                                  return DropdownMenuItem(
                                    child: new Text(listRole[index]),
                                    value: index,
                                  );
                                }).toList(),
                              ),
                            );
                          },
                        )
                      ],
                    ),
                  ),
                  MaterialButton(
                    onPressed: (){
                      showDialog(context: context,
                        builder: (BuildContext ctxDialog) {
                          return AlertDialog(
                            title: Text("Verify Role"),
                            content: CustomTextFormFieldWidget(
                              labelText: "Role Code",
                              textEditingController: _roleCodeController,
                            ),
                            actions: <Widget>[
                              FlatButton(
                                child: Text("NO"),
                                onPressed: () {
                                  Navigator.of(ctxDialog).pop();
                                },
                              ),
                              FlatButton(
                                child: Text("YES"),
                                onPressed: ()async{
                                  if(await GlobalBloc.verifyRole(_formKey, registerBloc.getRole, _roleCodeController.text)){
                                    registerBloc.doRegister(_formKey, globalBloc);
                                  }
                                  // mailBloc.setFileName(ctxDialog,_fileNameController.text);
                                },
                              ),
                            ],
                          );
                        }
                      );
                    },
                    color: UIData.darkPrimaryColor,
                    child: Text("REGISTER",style: TextStyle(color: Colors.white),),
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