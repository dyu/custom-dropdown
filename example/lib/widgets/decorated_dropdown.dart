// import 'dart:developer';

import 'package:animated_custom_dropdown/custom_dropdown.dart'
    show
        CustomDropdown,
        CustomDropdownDecoration,
        ListItemDecoration,
        SearchFieldDecoration;
import 'package:animated_custom_dropdown_example/models/job.dart'
    show Job, jobItems;
import 'package:flutter/foundation.dart' show Key, kDebugMode;
import 'package:flutter/material.dart';

class DecoratedDropdown extends StatelessWidget {
  const DecoratedDropdown({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomDropdown<Job>.search(
      items: jobItems,
      initialItem: jobItems[2],
      hintText: 'Select job role',
      searchHintText: 'Search job role',
      excludeSelected: false,
      hideSelectedFieldWhenExpanded: true,
      closedHeaderPadding: const EdgeInsets.all(20),
      onChanged: (value) {
        if (kDebugMode) print('DecoratedDropdown onChanged value: $value');
      },
      headerBuilder: (context, selectedItem, enabled) {
        return Text(
          selectedItem.toString(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        );
      },
      listItemBuilder: (context, item, isSelected, onItemSelect) {
        return Text(
          item.toString(),
          style: const TextStyle(color: Colors.white, fontSize: 16),
        );
      },
      noResultFoundBuilder: (context, text) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              text,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        );
      },
      decoration: CustomDropdownDecoration(
        closedFillColor: Colors.black,
        expandedFillColor: Colors.black,
        closedSuffixIcon: const Icon(
          Icons.keyboard_arrow_down,
          color: Colors.white,
        ),
        expandedSuffixIcon: const Icon(
          Icons.keyboard_arrow_up,
          color: Colors.grey,
        ),
        closedShadow: [
          const BoxShadow(
            offset: Offset(0, 4),
            color: Colors.blue,
            blurRadius: 8,
          ),
        ],
        searchFieldDecoration: SearchFieldDecoration(
          fillColor: Colors.grey[700],
          prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
          hintStyle: TextStyle(color: Colors.grey[400]),
          textStyle: const TextStyle(color: Colors.white),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(24)),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(24)),
          ),
          suffixIcon: (onClear) {
            return GestureDetector(
              onTap: onClear,
              child: Icon(Icons.close, color: Colors.grey[400]),
            );
          },
        ),
        listItemDecoration: ListItemDecoration(
          selectedColor: Colors.grey[900],
          highlightColor: Colors.grey[800],
        ),
      ),
    );
  }
}

class CheckboxRow extends StatefulWidget {
  const CheckboxRow({
    super.key,
    required this.item,
    required this.isSelected,
    required this.onItemSelect,
  });
  final Job item;
  final bool isSelected;
  final void Function() onItemSelect;

  @override
  State<CheckboxRow> createState() => _CheckboxRowState();
}

class _CheckboxRowState extends State<CheckboxRow> {
  var selected = false;
  
  @override
  void initState() {
    super.initState();
    selected = widget.isSelected;
  }
  void onChanged(bool? selected) {
    setState(() {
      this.selected = selected == true;
      widget.onItemSelect();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            widget.item.toString(),
            style: const TextStyle(color: Colors.green, fontSize: 16),
          ),
        ),
        Checkbox(
          value: selected,
          onChanged: onChanged,
        ),
      ],
    );
  }
}

// const BG_COLOR = Colors.black;
// const FG_COLOR = Colors.yellow;
// final HINT_COLOR = Colors.yellow[200];
final BG_COLOR = Colors.blue[50];
const FG_COLOR = Colors.black12;
final HINT_COLOR = Colors.blue[200];

class MultiSelectDecoratedDropdown extends StatelessWidget {
  const MultiSelectDecoratedDropdown({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomDropdown<Job>.multiSelectSearch(
      items: jobItems,
      hintText: 'Select job role',
      searchHintText: 'Search job role',
      closedHeaderPadding: const EdgeInsets.all(20),
      onListChanged: (value) {
        if (kDebugMode) print('MultiSelectDecoratedDropdown onChanged value: $value');
      },
      maxlines: 2,
      listItemBuilder: (context, item, isSelected, onItemSelect) {
        /*
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              item.toString(),
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
            Checkbox(
              value: isSelected,
              onChanged: (_) => onItemSelect(),
            ),
          ],
        );
        */
        return CheckboxRow(
          item: item,
          isSelected: isSelected,
          onItemSelect: onItemSelect,
        );
      },
      decoration: CustomDropdownDecoration(
        closedFillColor: BG_COLOR,
        expandedFillColor: BG_COLOR,
        hintStyle: TextStyle(
          color: HINT_COLOR,
          fontSize: 16,
        ),
        headerStyle: const TextStyle(
          color: FG_COLOR,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
        noResultFoundStyle: const TextStyle(
          color: FG_COLOR,
          fontSize: 16,
        ),
        prefixIcon: const Icon(Icons.person, color: FG_COLOR),
        closedSuffixIcon: const Icon(
          Icons.keyboard_arrow_down,
          color: FG_COLOR,
        ),
        expandedSuffixIcon: const Icon(
          Icons.keyboard_arrow_up,
          color: FG_COLOR,
        ),
        closedShadow: [
          const BoxShadow(
            offset: Offset(0, 4),
            color: Colors.blue,
            blurRadius: 8,
          ),
        ],
        searchFieldDecoration: SearchFieldDecoration(
          fillColor: Colors.grey[700],
          prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
          hintStyle: TextStyle(color: Colors.grey[400]),
          textStyle: const TextStyle(color: Colors.white),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(24)),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(24)),
          ),
          suffixIcon: (onClear) {
            return GestureDetector(
              onTap: onClear,
              child: Icon(Icons.close, color: Colors.grey[400]),
            );
          },
        ),
        listItemDecoration: ListItemDecoration(
          selectedColor: Colors.grey[900],
          highlightColor: Colors.grey[800],
        ),
      ),
    );
  }
}
