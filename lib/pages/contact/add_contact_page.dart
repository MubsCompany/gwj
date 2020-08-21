import 'dart:io';

import 'package:flutter/material.dart';
import 'package:template/blocs/contact/contact_bloc.dart';
import 'package:template/blocs/global_bloc.dart';
import 'package:template/models/Contact.dart';
import 'package:template/utils/global_function.dart';
import 'package:template/utils/uidata.dart';
import 'package:template/utils/validator.dart';
import 'package:template/widgets/base_container_widget.dart';
import 'package:template/widgets/custom_text_form_field_widget.dart';
import 'package:template/widgets/loading_widget.dart';
class AddContactPage extends StatefulWidget {
  Contact contact = Contact();
  ContactBloc contactBloc;
  bool isValid;
  AddContactPage({this.contact,this.contactBloc,this.isValid});
  @override
  _AddContactPageState createState() => _AddContactPageState();
}

class _AddContactPageState extends State<AddContactPage> with ValidationMixin{
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  FocusNode _nameFocusNode = FocusNode();
  FocusNode _companyFocusNode = FocusNode();
  FocusNode _positionFocusNode = FocusNode();
  FocusNode _addressFocusNode = FocusNode();
  FocusNode _phoneFocusNode = FocusNode();
  FocusNode _emailFocusNode = FocusNode();

  TextEditingController _nameController;
  TextEditingController _companyController;
  TextEditingController _positionController;
  TextEditingController _addressController;
  TextEditingController _phoneController;
  TextEditingController _emailController;

  ContactBloc contactBloc;

  @override
  void initState() {
    _nameController = TextEditingController(text: widget.contact?.contactName);
    _companyController = TextEditingController(text: widget.contact?.contactCompany);
    _positionController = TextEditingController(text: widget.contact?.contactDivision);
    _addressController = TextEditingController(text: widget.contact?.contactAddress);
    _phoneController = TextEditingController(text: widget.contact?.contactNumber);
    _emailController = TextEditingController(text: widget.contact?.contactEmail);

    contactBloc = widget.contactBloc;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Scaffold(
          body: Form(
            key: _formKey,
            child: ListView(
              children: <Widget>[

                Row(
                  children: <Widget>[
                    IconButton(icon: Icon(
                  Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back,
                  color: Colors.black,
                ), onPressed: () => Navigator.pop(context)),
                    Text('Contact Detail', style: TextStyle(fontFamily: 'futura', fontWeight: FontWeight.bold, fontSize: 20),),
                  ],
                ),

                SizedBox(height: MediaQuery.of(context).size.width * 0.01,),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color(0x2f9f9f9f),
                    ),
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: <Widget>[

                        Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0)),
                          elevation: 2,
                          child: Container(
                            height:60,
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
                                readOnly: !widget.isValid,
                                labelText: "Name",
                                focusNode: _nameFocusNode,
                                nextFocusNode: _companyFocusNode,
                                textEditingController: _nameController,
                                validator: validateRequired,
                                onSaved: contactBloc.saveName,
                              ),
                            ),
                          ),
                        ),

                        Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0)),
                          elevation: 2,
                          child: Container(
                            height:60,
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
                                readOnly: !widget.isValid,
                                labelText: "Company",
                                focusNode: _companyFocusNode,
                                nextFocusNode: _positionFocusNode,
                                textEditingController: _companyController,
                                validator: validateRequired,
                                onSaved: contactBloc.saveCompany,
                              ),
                            ),
                          ),
                        ),

                        Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0)),
                          elevation: 2,
                          child: Container(
                            height:60,
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
                                readOnly: !widget.isValid,
                                labelText: "Position",
                                focusNode: _positionFocusNode,
                                nextFocusNode: _addressFocusNode,
                                textEditingController: _positionController,
                                validator: validateRequired,
                                onSaved: contactBloc.savePosition,
                              ),
                            ),
                          ),
                        ),

                        Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0)),
                          elevation: 2,
                          child: Container(
                            height:60,
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
                                readOnly: !widget.isValid,
                                labelText: "Company's Address",
                                focusNode: _addressFocusNode,
                                nextFocusNode: _phoneFocusNode,
                                maxLines: null,
                                textInputAction: TextInputAction.newline,
                                keyboardType: TextInputType.multiline,
                                textEditingController: _addressController,
                                validator: validateRequired,
                                onSaved: contactBloc.saveAddress,
                              ),
                            ),
                          ),
                        ),

                        Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0)),
                          elevation: 2,
                          child: Container(
                            height:60,
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
                                readOnly: !widget.isValid,
                                labelText: "Phone Number",
                                focusNode: _phoneFocusNode,
                                nextFocusNode: _emailFocusNode,
                                textEditingController: _phoneController,
                                validator: validateRequiredNumber,
                                keyboardType: TextInputType.number,
                                onSaved: contactBloc.savePhone,
                              ),
                            ),
                          ),
                        ),

                        Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0)),
                          elevation: 2,
                          child: Container(
                            height:60,
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
                                readOnly: !widget.isValid,
                                labelText: "Email",
                                focusNode: _emailFocusNode,
                                nextFocusNode: new FocusNode(),
                                textInputAction: TextInputAction.done,
                                textEditingController: _emailController,
                                validator: validateEmail,
                                onSaved: contactBloc.saveEmail,
                              ),
                            ),
                          ),
                        ),

                      ],
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 16.0, left: 10, right: 10),
                  child: MaterialButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 15),
                    onPressed: ()=> contactBloc.onSave(_formKey, widget.contact),
                    color: Color(0xff3bc60b),
                    minWidth: double.infinity,
                    child: Text(
                      "Save",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Color(0xffffffff), fontFamily: 'futura', fontSize: 17),
                    ),
                  ),
                ),

              ],
            ),
          ),
        ),
        StreamBuilder(
          initialData: false,
          stream: GlobalBloc.loadingStream,
          builder: (BuildContext ctxLoading, AsyncSnapshot<bool> snapshot){
            return LoadingWidget(snapshot.data);
          },
        )
      ],
    );
  }
}