import 'package:flutter/material.dart';

class CheckboxOption extends StatelessWidget {
  final String label;
  final bool checked;
  final VoidCallback onToggle;

  const CheckboxOption({
    super.key,
    required this.label,
    required this.checked,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: Text(label),
      value: checked,


      onChanged: (value) => onToggle(),
      controlAffinity: ListTileControlAffinity.leading,
    );
  }
}
