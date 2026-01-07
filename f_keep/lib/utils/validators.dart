//validator for name field
String? validateName(String? value) => (value == null || value.isEmpty) ? 'The name needs to be filled' : null;

//validator for input field
String? validateQty(String? value) {
  if (value == null || value.isEmpty) {
    return "Quantity is required";
  }

  final qty = int.tryParse(value);
  if (qty == null) {
    return "Quantity must be a number";
  }

  if (qty < 0 || qty > 20) {
    return "Quantity shall be a number between 1 and 20";
  }

  return null;
}

//date validator
String? validateDate(String? value) => (value == null || value.isEmpty) ? 'Please select an expiry date' : null;
//unit validator
String? validateUnit(String? value) => value == null ? 'Please select a unit' : null;
