
import 'package:flutter/material.dart';

class CustomInputWidget extends StatelessWidget {
  final String? label;
  final String? hintText;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool? readOnly;
  final Function(String)? onChanged;
  final Function()? onTap;

  const CustomInputWidget({
    super.key,
    this.label,
    this.hintText,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.readOnly = false,
    this.onChanged,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    ColorScheme color = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
          color: color.primaryContainer,
          borderRadius: const BorderRadius.all(Radius.circular(16))),
      padding: const EdgeInsets.only(top: 0, bottom: 0, left: 16, right: 8),
      height: 86,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label ?? ''),
          Container(
            color: Colors.transparent,
            child: TextFormField(
              
              textAlignVertical: TextAlignVertical.center,
              autofocus: true,
              onTap: onTap,
              onChanged: onChanged,
              readOnly: readOnly!,
              decoration: InputDecoration(
                suffixIcon: suffixIcon,
                prefixIcon: prefixIcon,
                // labelText: label,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                hintText: hintText,
                hintStyle: Theme.of(context).textTheme.bodyLarge,
                errorMaxLines: 2,
                errorStyle: const TextStyle(fontSize: 11, height: 1),
                contentPadding: EdgeInsets.only(
                  left: 0,
                  right: 0,
                  top: 0,
                  bottom: (prefixIcon == null) ? 16 : 4,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
