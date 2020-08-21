import 'package:flutter/material.dart';
import 'package:template/utils/global_function.dart';
class CustomTextFormFieldWidget extends StatelessWidget {
  String hintText,labelText;
  FocusNode focusNode;
  FocusNode nextFocusNode = new FocusNode();
  TextInputAction textInputAction;
  Function(String) onFieldSubmitted;
  Function(String) validator;
  Function(String) onSaved;
  bool obscureText;
  TextInputType keyboardType;
  int maxLines;
  EdgeInsetsGeometry contentPadding;
  InputBorder border;
  TextEditingController textEditingController;
  String initialValue;
  bool readOnly;
  CustomTextFormFieldWidget({
    this.hintText,
    this.labelText,
    this.textInputAction = TextInputAction.next,
    this.keyboardType = TextInputType.text,
    this.focusNode,
    this.nextFocusNode,
    this.onFieldSubmitted,
    this.obscureText = false,
    this.maxLines = 1,
    this.textEditingController,
    this.validator,
    this.onSaved,
    this.contentPadding,
    this.border,
    this.initialValue,
    this.readOnly = false
  });
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: this.readOnly,
      initialValue: this.initialValue,
      textInputAction: this.textInputAction,
      decoration: new InputDecoration(
        labelText: this.labelText,
        hintText: this.hintText,
        contentPadding: this.contentPadding,
        border: this.border,
      ),
      keyboardType: this.keyboardType,
      focusNode: this.focusNode,
      obscureText: this.obscureText,
      maxLines: this.maxLines,
      controller: this.textEditingController,
      validator: this.validator,
      onSaved: this.onSaved,
      onFieldSubmitted: (str) => this.onFieldSubmitted ?? GlobalFunction.fieldFocusChange(context,this.focusNode,this.nextFocusNode),
    );
  }
}