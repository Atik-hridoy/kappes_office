import 'package:canuck_mall/app/widgets/app_text.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class CustomDropdownButton extends StatefulWidget {
  final String? hintText;
  final String type; // Can be "deliveryOptions" or "paymentMethod"

  const CustomDropdownButton({
    super.key,
    this.hintText,
    required this.type,
    required onChanged,
    required List<String> items,
    required String value,
  });

  @override
  State<CustomDropdownButton> createState() => _CustomDropdownButtonState();
}

class _CustomDropdownButtonState extends State<CustomDropdownButton> {
  // Example options, you can replace these with actual options
  List<String> deliveryOptions = ["Standard", "Express", "Overnight"];
  List<String> paymentMethods = ["Cod", "Card", "Online"];

  // Selected values for both dropdowns
  String? selectedOption;

  @override
  Widget build(BuildContext context) {
    // Determine which options list to use based on the type passed to the widget
    List<String> items =
        widget.type == "deliveryOptions" ? deliveryOptions : paymentMethods;

    return DropdownButtonFormField2<String>(
      isExpanded: true,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      hint:
          widget.hintText != null
              ? AppText(title: widget.hintText!, style: TextStyle(fontSize: 14))
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
          selectedOption = value; // Update selected option state
        });

        // Do something when selected item is changed.
        if (widget.type == "deliveryOptions") {
          // You can pass this value to the controller or model.
          print("Selected Delivery Option: $selectedOption");
        } else if (widget.type == "paymentMethod") {
          // Handle payment method selection
          print("Selected Payment Method: $selectedOption");
        }
      },
      onSaved: (value) {
        selectedOption = value?.toString();
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
