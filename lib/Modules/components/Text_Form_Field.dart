import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget defaultFormField({
 required TextEditingController controller,
 required TextInputType type,
  Function? onSubmit(value)?,
  Function? onChanged(value)?,
  required String? Function(String? value)? validate,
  required String label,
  required IconData prefixIcon,
  Function? Function()? onTap,
}) => TextFormField(
  controller: controller,
  keyboardType: type,
  onFieldSubmitted: onSubmit,
  onChanged: onChanged,
  validator: validate,
  onTap: onTap,
  decoration: InputDecoration(
    labelText: label,
    prefixIcon: Icon(prefixIcon),
    border: OutlineInputBorder(),
  ),
);