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
  overlayBottomOffset: 48,
);

final _dropdownFocusableDecoration = CustomDropdownDecoration(
  closedFillColor: Colors.transparent,
  expandedFillColor: Colors.white,
  hintStyle: TextStyle(
    color: Colors.black.withOpacity(0.6),
    fontSize: 16,
  ),
  // closedBorder: Border.all(width: 0.5),
  closedBorderRadius: BorderRadius.circular(4),
  closedErrorBorder: Border.all(width: 1, color: Colors.red),
  closedErrorBorderRadius: BorderRadius.circular(4),
  // expandedBorder: Border.all(width: 0.5),
  expandedBorderRadius: BorderRadius.circular(4),
  overlayBottomOffset: 48,
  overlayTopOffset: -56,
);

final _dropdownFocusableWrappingDecoration = CustomDropdownDecoration(
  closedFillColor: Colors.transparent,
  expandedFillColor: Colors.white,
  hintStyle: TextStyle(
    color: Colors.black.withOpacity(0.6),
    fontSize: 16,
  ),
  // closedBorder: Border.all(width: 0.5),
  closedBorderRadius: BorderRadius.circular(4),
  closedErrorBorder: Border.all(width: 0, color: Colors.transparent),
  closedErrorBorderRadius: BorderRadius.zero,
  // expandedBorder: Border.all(width: 0.5),
  expandedBorderRadius: BorderRadius.circular(4),
  overlayBottomOffset: 48,
  overlayTopOffset: -56,
);

const _dropdownPadding = EdgeInsets.only(
  top: 12,
  bottom: 12,
  left: 8,
  right: 6,
);
const _dropdownFocusablePadding = EdgeInsets.only(
  top: 12,
  bottom: 12,
  left: 7,
  right: 5,
);


class BorderedDropdown extends StatelessWidget {
  const BorderedDropdown({
    super.key,
    this.excludeSelected = false,
    this.overlayController,
    this.visibility,
  });
  final bool excludeSelected;
  final OverlayPortalController? overlayController;
  final Toggle? visibility;

  @override
  Widget build(BuildContext context) {
    return CustomDropdown<String>(
      hintText: 'Select job role',
      overlayController: overlayController,
      visibility: visibility?.update,
      items: _list,
      hideSelectedFieldWhenExpanded: true,
      excludeSelected: excludeSelected,
      decoration: visibility == null
          ? _dropdownDecoration
          : _dropdownFocusableDecoration,
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

class Toggle extends ValueNotifier<bool> {
  Toggle(super.value);
  
  void toggle() {
    super.value = !super.value;
  }
  void update(bool value) {
    super.value = value;
  }
}

class FocusedDropdownInput extends StatefulWidget {
  const FocusedDropdownInput({
    super.key,
    required this.dropdown,
    required this.toggleFocus,
  });
  final BorderedDropdown dropdown;
  final Toggle toggleFocus;

  @override
  State<FocusedDropdownInput> createState() => _FocusedDropdownInputState();
}

class _FocusedDropdownInputState extends State<FocusedDropdownInput> {
  var focused = false;
  
  @override
  void initState() {
    super.initState();
    widget.toggleFocus.addListener(onFocus);
    widget.dropdown.visibility?.addListener(onDropdown);
  }
  
  @override
  void dispose() {
    widget.toggleFocus.removeListener(onFocus);
    widget.dropdown.visibility?.removeListener(onDropdown);
    super.dispose();
  }
  
  void onDropdown() {
    final c = widget.dropdown.visibility!;
    // if (kDebugMode) print('onOverlay: ${c.value}');
    if (!c.value) {
      if (widget.toggleFocus.value) widget.toggleFocus.toggle();
    } else if (focused) {
      if (!widget.toggleFocus.value) widget.toggleFocus.toggle();
    } else {
      setState(widget.toggleFocus.value ? setFocus : forceFocus);
    }
  }
  
  void setFocus() {
    focused = true;
  }
  
  void forceFocus() {
    focused = true;
    widget.toggleFocus.value = true;
    FocusScope.of(context).unfocus();
  }
  
  void applyFocus() {
    focused = widget.toggleFocus.value;
    if (focused) {
      if (false == widget.dropdown.overlayController?.value) {
        widget.dropdown.overlayController!.value = true;
      }
    } else if (true == widget.dropdown.overlayController?.value) {
      widget.dropdown.overlayController!.value = false;
    }
  }
  
  void onFocus() {
    if (focused != widget.toggleFocus.value) setState(applyFocus);
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: focused ? Colors.blue : Colors.grey,
          width: focused ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 0,
          horizontal: focused ? 0 : 1,
        ),
        child: widget.dropdown,
      ),
    );
  }
}

class FocusableDropdownInput<T> extends StatefulWidget {
  const FocusableDropdownInput({
    super.key,
    required this.hintText,
    required this.overlayController,
    required this.controller,
    required this.items,
    required this.visibility,
    required this.toggleFocus,
    this.onChanged,
    this.itemsScrollController,
    this.validator,
  });
  final String hintText;
  final OverlayPortalController overlayController;
  final SingleSelectController<T> controller;
  final ScrollController? itemsScrollController;
  final List<T> items;
  final void Function(T?)? onChanged;
  final String? Function(T? value)? validator;
  final Toggle visibility;
  final Toggle toggleFocus;
  
  void disposeControllers() {
    overlayController.dispose();
    controller.dispose();
    itemsScrollController?.dispose();
    toggleFocus.dispose();
  }
  
  void _onChanged(T? value) {
    controller.value = value;
  }

  @override
  State<FocusableDropdownInput<T>> createState() => _FocusableDropdownInputState<T>();
}

class _FocusableDropdownInputState<T> extends State<FocusableDropdownInput<T>> {
  late final CustomDropdown<T> dropdown;
  var focused = false;
  var hasError = false;
  // var wasError = false;
  
  @override
  void initState() {
    super.initState();
    dropdown = CustomDropdown<T>(
      hintText: widget.hintText,
      validator: widget.validator,
      visibility: widget.visibility.update,
      wrapFn: wrapDropdown,
      overlayController: widget.overlayController,
      controller: widget.controller,
      itemsScrollController: widget.itemsScrollController,
      items: widget.items,
      hideSelectedFieldWhenExpanded: true,
      excludeSelected: false,
      decoration: _dropdownFocusableWrappingDecoration,
      closedHeaderPadding: _dropdownFocusablePadding,
      expandedHeaderPadding: _dropdownFocusablePadding,
      listItemPadding: _dropdownFocusablePadding,
      onChanged: widget.onChanged ?? widget._onChanged,
    );
    widget.toggleFocus.addListener(onFocus);
    widget.visibility.addListener(onDropdown);
  }
  
  @override
  void dispose() {
    widget.toggleFocus.removeListener(onFocus);
    widget.visibility.removeListener(onDropdown);
    super.dispose();
  }
  
  Widget wrapDropdown(Widget w, String? errorText) {
    final withError = errorText != null;
    if (hasError != withError) {
      Future.delayed(Duration.zero, onErrorChanged);
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: !withError ? Colors.transparent : Colors.red,
              width: !withError ? 0 : 1,
            ),
            borderRadius: !withError ? BorderRadius.zero : BorderRadius.circular(4),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: 0,
              horizontal: !withError ? 0 : 1,
            ),
            child: w,
          ),
        ),
        if (errorText != null && errorText.isNotEmpty)
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: 4,
              horizontal: 8,
            ),
            child: Text(
              errorText,
              style: TextStyle(
                color: Colors.red,
              ),
            ),
          ),
      ],
    );
  }
  
  void toggleError() {
    final wasError = hasError;
    hasError = !wasError;
    if (wasError && focused) focused = false;
  }
  
  void onErrorChanged() {
    setState(toggleError);
  }
  
  void onDropdown() {
    final c = widget.visibility;
    if (!c.value) {
      if (widget.toggleFocus.value) widget.toggleFocus.toggle();
    } else if (focused) {
      if (!widget.toggleFocus.value) widget.toggleFocus.toggle();
    } else {
      setState(widget.toggleFocus.value ? setFocus : forceFocus);
    }
  }
  
  void setFocus() {
    focused = true;
  }
  
  void forceFocus() {
    focused = true;
    widget.toggleFocus.value = true;
    FocusScope.of(context).unfocus();
  }
  
  void applyFocus() {
    focused = widget.toggleFocus.value;
    if (focused) {
      if (!widget.overlayController.value) {
        widget.overlayController.value = true;
      }
    } else if (widget.overlayController.value) {
      widget.overlayController.value = false;
    }
  }
  
  void onFocus() {
    if (focused != widget.toggleFocus.value) setState(applyFocus);
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: hasError ? Colors.transparent : (focused ? Colors.blue : Colors.grey),
          width: hasError ? 0 : (focused ? 2 : 1),
        ),
        borderRadius: hasError ? BorderRadius.zero : BorderRadius.circular(4),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 0,
          horizontal: hasError || focused ? 0 : 1,
        ),
        child: dropdown,
      ),
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
