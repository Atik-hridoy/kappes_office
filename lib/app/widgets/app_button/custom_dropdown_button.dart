import 'package:canuck_mall/app/widgets/app_text.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class CustomDropdownButton extends StatefulWidget {
  final String? hintText;
  final String type; // Can be "deliveryOptions" or "paymentMethod"
  final Function(String?)? onChanged;
  final List<String> items;
  final String? value;

  const CustomDropdownButton({
    super.key,
    this.hintText,
    required this.type,
    required this.onChanged,
    required this.items,
    this.value,
  });

  @override
  State<CustomDropdownButton> createState() => _CustomDropdownButtonState();
}

class _CustomDropdownButtonState extends State<CustomDropdownButton> {
  String? selectedOption;

  @override
  void initState() {
    super.initState();
    selectedOption = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    List<String> items =
        widget.type == "deliveryOptions"
            ? ["Standard", "Express", "Overnight"]
            : ["Cod", "Card", "Online"];
    return DropdownButtonFormField2<String>(
      value: selectedOption,
      isExpanded: true,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
      ),
      hint:
          widget.hintText != null
              ? AppText(
                title: widget.hintText!,
                style: const TextStyle(fontSize: 14),
              )
              : null,
      items:
          items
              .map(
                (item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(item, style: const TextStyle(fontSize: 14)),
                ),
              )
              .toList(),
      validator: (value) {
        if (value == null) {
          return 'Please select an option.';
        }
        return null;
      },
      onChanged: (value) {
        setState(() {
          selectedOption = value;
        });
        if (widget.onChanged != null) {
          widget.onChanged!(value);
        }
        if (widget.type == "deliveryOptions") {
          print("Selected Delivery Option: $selectedOption");
        } else if (widget.type == "paymentMethod") {
          print("Selected Payment Method: $selectedOption");
        }
      },
      onSaved: (value) {
        selectedOption = value;
      },
      buttonStyleData: const ButtonStyleData(
        padding: EdgeInsets.only(right: 8),
      ),
      iconStyleData: const IconStyleData(
        icon: Icon(Icons.arrow_drop_down, color: Colors.black45),
        iconSize: 24,
      ),
      dropdownStyleData: DropdownStyleData(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
      ),
      menuItemStyleData: const MenuItemStyleData(
        padding: EdgeInsets.symmetric(horizontal: 16),
      ),
    );
  }
}
