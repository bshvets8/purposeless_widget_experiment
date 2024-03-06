import 'package:flutter/widgets.dart';

abstract class PurposelessWidget extends StatelessWidget {
  const PurposelessWidget({super.key});

  @override
  StatelessElement createElement() => PurposelessElement(this);

  @override
  Widget build(BuildContext context) => throw 'You have no power here';

  NotState createNotState();
}

class PurposelessElement extends StatelessElement {
  PurposelessElement(this._widget) : super(_widget);

  PurposelessWidget _widget;
  NotState? _notState;

  // Hook into the first build call to perform necessary state initialization.
  bool _isFirstBuild = true;

  @override
  Widget build() {
    if (_isFirstBuild) {
      _notState!.initState();
      _notState!.didChangeDependencies();
      _isFirstBuild = false;
    }

    return _notState!.build(this);
  }

  @override
  void mount(Element? parent, Object? newSlot) {
    _notState = _widget.createNotState();
    _notState!._element = this;
    _notState!._widget = _widget;

    super.mount(parent, newSlot);
  }

  @override
  void unmount() {
    super.unmount();
    _notState!.dispose();
    _notState!._element = null;
    _notState = null;
  }

  @override
  void didChangeDependencies() {
    _notState!.didChangeDependencies();
    super.didChangeDependencies();
  }

  @override
  void update(covariant PurposelessWidget newWidget) {
    final oldWidget = _widget;
    _notState!._widget = newWidget;
    _notState!.didUpdateWidget(oldWidget, newWidget);
    _widget = newWidget;
    super.update(newWidget);
  }
}

abstract class NotState<T extends PurposelessWidget> {
  PurposelessElement? _element;

  T get widget => _widget as T;
  Widget? _widget;

  Widget build(BuildContext context);

  void initState() {}

  void didUpdateWidget(Widget oldWidget, Widget newWidget) {}

  void didChangeDependencies() {}

  void dispose() {}

  void setState(VoidCallback fn) {
    fn();
    _element?.markNeedsBuild();
  }
}
