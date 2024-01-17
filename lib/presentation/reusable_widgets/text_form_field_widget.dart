import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ignore: must_be_immutable
class TextFormFieldWidget extends StatefulWidget {
  TextFormFieldWidget(
      {super.key,
      required this.inputFormatters,
      required this.hintText,
      required this.textEditingController,
      this.validator,
      this.onChanged, this.readOnly = false});

  List<TextInputFormatter> inputFormatters;
  String hintText;
  TextEditingController textEditingController;
  final String? Function(String?)? validator;
  final void Function(String?)? onChanged;
  final bool readOnly;

  @override
  TextFormFieldWidgetState createState() => TextFormFieldWidgetState();
}

class TextFormFieldWidgetState extends State<TextFormFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: widget.readOnly,
      //Change this value to custom as you like),
      controller: widget.textEditingController,
      inputFormatters: widget.inputFormatters,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onChanged: widget.onChanged,
      decoration: InputDecoration(
          border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12))),
          hintText: widget.hintText,
          errorMaxLines: 2,),
      validator: widget.validator,
    );
  }
}
