part of '../custom_dropdown.dart';
/*
class _OverlayBuilder extends StatefulWidget {
  final Widget Function(Size, VoidCallback hide) overlay;
  final Widget Function(VoidCallback show) child;
  final OverlayPortalController? overlayPortalController;
  final Function(bool)? visibility;

  const _OverlayBuilder({
    super.key,
    required this.overlay,
    required this.child,
    this.overlayPortalController,
    this.visibility,
  });

  @override
  _OverlayBuilderState createState() => _OverlayBuilderState();
}

class _OverlayBuilderState extends State<_OverlayBuilder> {
  late OverlayPortalController overlayController;

  @override
  void initState() {
    super.initState();
    overlayController =
        widget.overlayPortalController ?? OverlayPortalController();
  }

  void showOverlay() {
    overlayController.show();

    if (widget.visibility != null) {
      widget.visibility!(true);
    }
  }

  void hideOverlay() {
    overlayController.hide();

    if (widget.visibility != null) {
      widget.visibility!(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return OverlayPortal(
      controller: overlayController,
      overlayChildBuilder: (_) {
        final renderBox = context.findRenderObject() as RenderBox;
        final size = renderBox.size;
        return widget.overlay(size, hideOverlay);
      },
      child: widget.child(showOverlay),
    );
  }
}
*/
class OverlayPortalController extends ValueNotifier<bool> {
  OverlayPortalController(super.value);
  
  void toggle([_]) {
    super.value = !super.value;
    notifyListeners();
  }
  
  void update(bool value) {
    if (value == super.value) return;
    super.value = value;
    notifyListeners();
  }
}

class _OverlayBuilder extends StatefulWidget {
  final Widget Function(Size, VoidCallback) overlay;
  final Widget Function(VoidCallback) child;
  final OverlayPortalController? overlayPortalController;
  final Function(bool)? visibility;

  const _OverlayBuilder({
    Key? key,
    required this.overlay,
    required this.child,
    this.overlayPortalController,
    this.visibility,
  }) : super(key: key);

  @override
  _OverlayBuilderState createState() => _OverlayBuilderState();
}

class _OverlayBuilderState extends State<_OverlayBuilder> {
  OverlayEntry? overlayEntry;

  bool get isShowingOverlay => overlayEntry != null;
  
  @override
  void initState() {
    super.initState();
    widget.overlayPortalController?.addListener(onToggle);
  }
  
  @override
  void dispose() {
    widget.overlayPortalController?.removeListener(onToggle);
    if (overlayEntry != null) {
      try {
        overlayEntry!.dispose();
      } catch (_) {
        // noop
      }
      overlayEntry = null;
    }
    super.dispose();
  }
  
  void onToggle() {
    if (!widget.overlayPortalController!.value) {
      hideOverlay();
    } else if (overlayEntry == null) {
      showOverlay();
    }
  }
  
  void showOverlay() {
    // if (kDebugMode) print('Showing overlay');
    overlayEntry = OverlayEntry(
      builder: (_) {
        if (mounted) {
          final renderBox = context.findRenderObject() as RenderBox;
          final size = renderBox.size;
          return widget.overlay(size, hideOverlay);
        }
        return const SizedBox();
      },
    );
    addToOverlay(overlayEntry!);
    if (widget.visibility != null) widget.visibility!(true);
  }

  void addToOverlay(OverlayEntry entry) => Overlay.of(context).insert(entry);

  void hideOverlay() {
    // if (kDebugMode) print('Hiding overlay');
    if (overlayEntry != null) {
      overlayEntry!.remove();
      overlayEntry = null;
    }
    if (widget.visibility != null) widget.visibility!(false);
  }

  @override
  Widget build(BuildContext context) => widget.child(showOverlay);
}

