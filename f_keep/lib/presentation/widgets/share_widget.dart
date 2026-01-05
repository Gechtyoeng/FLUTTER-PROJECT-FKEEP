import 'package:flutter/material.dart';

//customize widget for input filed
class InputField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final FormFieldValidator<String>? validator;

  final bool isDate;
  final DateTime? firstDate;
  final DateTime? lastDate;

  const InputField({super.key, required this.controller, required this.hintText, this.validator, this.isDate = false, this.firstDate, this.lastDate});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return TextFormField(
      controller: controller,
      validator: validator,

      //only avaliable for date picker input filed
      readOnly: isDate,

      onTap: isDate
          ? () async {
              final selectedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: firstDate ?? DateTime(2000),
                lastDate: lastDate ?? DateTime(2100),
              );

              if (selectedDate != null) {
                controller.text = "${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}";
              }
            }
          : null,

      decoration: InputDecoration(
        hintText: hintText,
        suffixIcon: isDate ? const Icon(Icons.calendar_today, size: 18) : null,

        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),

        filled: true,
        fillColor: colorScheme.surfaceContainer,

        border: _border(colorScheme.primary),
        enabledBorder: _border(colorScheme.outline),
        focusedBorder: _border(colorScheme.primary),
        errorBorder: _border(colorScheme.error),
        focusedErrorBorder: _border(colorScheme.error),
      ),
    );
  }

  OutlineInputBorder _border(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: color),
    );
  }
}

// widget for dropdown button
class AppDropdown<T> extends StatelessWidget {
  final T? value;
  final List<T> items;
  final String hintText;
  final ValueChanged<T?> onChanged;
  final String Function(T) labelBuilder;
  final FormFieldValidator<T>? validator;

  const AppDropdown({super.key, required this.value, required this.items, required this.hintText, required this.onChanged, required this.labelBuilder, this.validator});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return DropdownButtonFormField<T>(
      initialValue: value,
      validator: validator,

      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: colorScheme.primary,

        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),

        enabledBorder: _border(colorScheme.outline),
        focusedBorder: _border(colorScheme.onPrimary),
        errorBorder: _border(colorScheme.error),
        focusedErrorBorder: _border(colorScheme.error),
      ),

      dropdownColor: colorScheme.onSurfaceVariant,

      items: items.map((item) {
        return DropdownMenuItem<T>(
          value: item,
          child: Text(labelBuilder(item), style: TextStyle(color: colorScheme.onPrimary)),
        );
      }).toList(),
      onChanged: onChanged,
      iconEnabledColor: colorScheme.onPrimary,
    );
  }

  OutlineInputBorder _border(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: color),
    );
  }
}

//widget for app button
class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? textColor;

  const AppButton({super.key, required this.label, required this.onPressed, this.backgroundColor, this.textColor});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      height: 40,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? colorScheme.secondary,
          foregroundColor: textColor ?? colorScheme.onSecondary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
      ),
    );
  }
}

//widget for app filter button

class FilterButton extends StatelessWidget {
  final String buttonText;
  final bool isSelected;
  final VoidCallback onTap;
  const FilterButton({super.key, required this.buttonText, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? Theme.of(context).colorScheme.primaryContainer : Theme.of(context).colorScheme.surfaceContainer,
          foregroundColor: isSelected ? Theme.of(context).colorScheme.onPrimaryContainer : Theme.of(context).colorScheme.onSurfaceVariant,
          minimumSize: const Size.fromHeight(40),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(8),
            side: BorderSide(color: isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.outline, width: 1),
          ),
        ),
        child: Text(buttonText),
      ),
    );
  }
}
