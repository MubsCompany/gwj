import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
class DatePickerWidget extends StatelessWidget {
  void Function(DateTime value) onChange;
  void Function(DateTime value) onSave;
  void Function(DateTime value) validator;
  TextEditingController controller;
  DateTime initialValue;
  DatePickerWidget({
    this.onChange,
    this.onSave,
    this.validator,
    this.controller,
    this.initialValue,
  });
  @override
  Widget build(BuildContext context) {
    return ListTile(
            contentPadding: EdgeInsets.zero,
            title: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: DateTimeField(
                controller: this.controller,
                format: DateFormat("yyyy/MM/dd"),
                decoration: InputDecoration(
                  hintText: "Pilih Tanggal",
                  // border: InputBorder.none,
                  prefixIcon: Icon(Icons.calendar_today)
                ),
                readOnly: true,
                textAlign: TextAlign.center,
                onChanged: this.onChange,
                onSaved: this.onSave,
                validator: this.validator,
                initialValue: this.initialValue,
                onShowPicker: (context, currentValue) {
                  return showDatePicker(
                      context: context,
                      firstDate: DateTime(1900),
                      initialDate: currentValue ?? DateTime.now(),
                      lastDate: DateTime(2100));
                },
              ),
            ),
          );
  }
}