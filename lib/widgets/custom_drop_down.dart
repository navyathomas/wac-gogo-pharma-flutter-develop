import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo_pharma/utils/color_palette.dart';

class CustomDropdown<T> extends StatefulWidget {
  final Widget? child;
  final void Function(T)? onChange;
  final List<DropdownItem<T>>? items;
  final DropdownStyle? dropdownStyle;
  final DropdownButtonStyle? dropdownButtonStyle;
  final Icon? icon;
  final bool hideIcon;
  final bool leadingIcon;
  final bool isValidate;
  final Function? validator;

  const CustomDropdown(
      {Key? key,
      this.hideIcon = false,
      required this.child,
      required this.items,
      this.dropdownStyle,
      this.dropdownButtonStyle,
      this.icon,
      this.leadingIcon = false,
      this.onChange,
      this.isValidate = false,
      this.validator})
      : super(key: key);

  @override
  _CustomDropdownState<T> createState() => _CustomDropdownState<T>();
}

class _CustomDropdownState<T> extends State<CustomDropdown<T>>
    with TickerProviderStateMixin {
  final LayerLink _layerLink = LayerLink();
  late OverlayEntry _overlayEntry;
  bool _isOpen = false;
  int _currentIndex = -1;
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;
  late Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _rotateAnimation = Tween(begin: 0.0, end: 0.5).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var style = widget.dropdownButtonStyle!;
    return CustomForm(
      validator:
          widget.validator == null ? (val) {} : (val) => widget.validator!(val),
      context: context,
      child: CompositedTransformTarget(
        link: _layerLink,
        child: Container(
          width: style.width,
          height: style.height,
          decoration: BoxDecoration(
            border: Border.all(
                color: !widget.isValidate
                    ? HexColor("#D9E3E3")
                    : HexColor("#FC6261")),
            borderRadius: BorderRadius.all(Radius.circular(8.r)),
          ),
          child: InkWell(
            onTap: _toggleDropdown,
            child: Row(
              mainAxisAlignment:
                  style.mainAxisAlignment ?? MainAxisAlignment.start,
              textDirection:
                  widget.leadingIcon ? TextDirection.rtl : TextDirection.ltr,
              children: [
                SizedBox(width: 16.w),
                if (_currentIndex == -1) ...[
                  widget.child!,
                ] else ...[
                  widget.items![_currentIndex],
                ],
                const Spacer(),
                if (!widget.hideIcon)
                  Padding(
                    padding: EdgeInsets.only(right: 17.w),
                    child: RotationTransition(
                      turns: _rotateAnimation,
                      child: widget.icon ??
                          Icon(
                            Icons.keyboard_arrow_down,
                            color: HexColor('#8A9CAC'),
                          ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject()! as RenderBox;
    var size = renderBox.size;

    var offset = renderBox.localToGlobal(Offset.zero);
    var topOffset = offset.dy + size.height + 5;
    return OverlayEntry(
      builder: (context) => GestureDetector(
        onTap: () => _toggleDropdown(close: true),
        behavior: HitTestBehavior.translucent,
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: [
              Positioned(
                left: 0,
                top: topOffset,
                width: widget.dropdownStyle?.width ?? size.width,
                child: CompositedTransformFollower(
                  offset: widget.dropdownStyle?.offset ??
                      Offset(0, size.height + 5),
                  link: _layerLink,
                  showWhenUnlinked: false,
                  child: Material(
                    elevation: widget.dropdownStyle?.elevation ?? 0,
                    borderRadius:
                        widget.dropdownStyle?.borderRadius ?? BorderRadius.zero,
                    color: widget.dropdownStyle?.color,
                    child: SizeTransition(
                      axisAlignment: 1,
                      sizeFactor: _expandAnimation,
                      child: ConstrainedBox(
                        constraints: widget.dropdownStyle?.constraints ??
                            BoxConstraints(
                              maxHeight: MediaQuery.of(context).size.height -
                                  topOffset -
                                  15,
                            ),
                        child: ListView(
                          padding: EdgeInsets.only(
                              left: 11.w, bottom: 10.h, right: 11.w, top: 10.h),
                          shrinkWrap: true,
                          children: widget.items!.asMap().entries.map((item) {
                            return InkWell(
                              onTap: () {
                                setState(() => _currentIndex = item.key);
                                widget.onChange!(item.value.value);
                                _toggleDropdown();
                              },
                              child: item.value,
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _toggleDropdown({bool close = false}) async {
    FocusScope.of(context).unfocus();
    if (_isOpen || close) {
      await _animationController.reverse();
      _overlayEntry.remove();
      setState(() {
        _isOpen = false;
      });
    } else {
      _overlayEntry = _createOverlayEntry();
      Overlay.of(context)!.insert(_overlayEntry);
      setState(() => _isOpen = true);
      _animationController.forward();
    }
  }
}

class DropdownItem<T> extends StatelessWidget {
  final T value;
  final Widget child;

  const DropdownItem({Key? key, required this.value, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return child;
  }
}

class DropdownButtonStyle {
  final MainAxisAlignment? mainAxisAlignment;
  final OutlinedBorder? shape;
  final double? elevation;
  final Color? backgroundColor;
  final EdgeInsets? padding;
  final BoxConstraints? constraints;
  final double? width;
  final double? height;
  final Color? primaryColor;

  const DropdownButtonStyle({
    this.mainAxisAlignment,
    this.backgroundColor,
    this.primaryColor,
    this.constraints,
    this.height,
    this.width,
    this.elevation,
    this.padding,
    this.shape,
  });
}

class DropdownStyle {
  final BorderRadius? borderRadius;
  final double? elevation;
  final Color? color;
  final EdgeInsets? padding;
  final BoxConstraints? constraints;
  final Offset? offset;
  final double? width;

  const DropdownStyle({
    this.constraints,
    this.offset,
    this.width,
    this.elevation,
    this.color,
    this.padding,
    this.borderRadius,
  });
}

class CustomForm<T> extends FormField<String> {
  final Widget child;
  final BuildContext context;

  CustomForm(
      {Key? key,
      FormFieldSetter<String>? onSaved,
      FormFieldValidator<String>? validator,
      String initialValue = '',
      required this.child,
      required this.context})
      : super(
            key: key,
            onSaved: onSaved,
            validator: validator,
            initialValue: initialValue,
            autovalidateMode: AutovalidateMode.disabled,
            builder: (FormFieldState<String> state) {
              return Column(
                children: [
                  child,
                ],
              );
            });
}
