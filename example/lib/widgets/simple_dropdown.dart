import 'dart:developer';

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';

const List<String> _list = [
  'Developer',
  'Designer',
  'Consultant',
  'Student',
];

final _dropdownDecoration = CustomDropdownDecoration(
  closedFillColor: Colors.transparent,
  expandedFillColor: Colors.white,
  hintStyle: TextStyle(
    color: Colors.black.withOpacity(0.6),
    fontSize: 16,
  ),
  closedBorder: Border.all(width: 0.5),
  closedBorderRadius: BorderRadius.circular(4),
  closedErrorBorder: Border.all(width: 1, color: Colors.red),
  closedErrorBorderRadius: BorderRadius.circular(4),
  // expandedBorder: Border.all(width: 0.5),
  expandedBorderRadius: BorderRadius.circular(4),
);

class BorderedDropdown extends StatelessWidget {
  const BorderedDropdown({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomDropdown<String>(
      hintText: 'Select job role',
      items: _list,
      decoration: _dropdownDecoration,
      closedHeaderPadding: const EdgeInsets.only(
        top: 12,
        bottom: 12,
        left: 8,
        right: 6,
      ),
      expandedHeaderPadding: const EdgeInsets.only(
        top: 12,
        bottom: 12,
        left: 8,
        right: 6,
      ),
      listItemPadding: const EdgeInsets.only(
        top: 12,
        bottom: 12,
        left: 8,
        right: 6,
      ),
      onChanged: (value) {
        log('SimpleDropdown onChanged value: $value');
      },
    );
  }
}

class SimpleDropdown extends StatelessWidget {
  const SimpleDropdown({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomDropdown<String>(
      hintText: 'Select job role',
      items: _list,
      onChanged: (value) {
        log('SimpleDropdown onChanged value: $value');
      },
    );
  }
}

class SimpleInitializedDropdown extends StatelessWidget {
  const SimpleInitializedDropdown({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomDropdown<String>(
      hintText: 'Select job role',
      items: _list,
      initialItem: _list[0],
      excludeSelected: false,
      onChanged: (value) {
        log('SimpleInitializedDropdown onChanged value: $value');
      },
    );
  }
}
