import 'package:brentwood/Screens/store_data/size_config.dart';
import 'package:brentwood/Screens/store_data/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class InputField extends StatelessWidget {
  const InputField({
    Key? key,
    required this.name,
    required this.hint,
    this.controller,
    this.widget,
    required this.enabled,
    this.onChanged,

  }) : super(key: key);

  final String name;
  final String hint;
  final TextEditingController? controller;
  final Widget? widget;
  final bool enabled;
  final onChanged;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name, style: nameStyle),
          Container(
            padding: const EdgeInsets.only(left: 14),
            margin: const EdgeInsets.only(top: 8),
            width: SizeConfig.screenWidth,
            height: 52,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.grey,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    onChanged: onChanged,
                    enabled: enabled,
                    controller: controller,
                    autofocus: false,
                    readOnly: widget != null ? true : false,
                    style: subTitleStyle,
                    cursorColor:
                    Get.isDarkMode ? Colors.grey[100] : Colors.grey[700],
                    decoration: InputDecoration(
                      hintText: hint,
                      hintStyle: subTitleStyle,
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(

                          width: 0,
                        ),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(

                          width: 0,
                        ),
                      ),
                    ),
                  ),
                ),
                widget ?? Container(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}