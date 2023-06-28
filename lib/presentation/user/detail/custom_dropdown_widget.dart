import 'dart:math';
import 'package:flutter/material.dart';
import 'package:unjabbed_admin/presentation/user/detail/vinculo_model.dart';

class CustomDropDownWidget<T> extends StatefulWidget {
  final String title;
  final String? label;
  final List<Vinculo> lista;
  final GlobalKey<FormFieldState>? fieldKey;
  final Vinculo? value;
  final Function onChange;
  final bool valueVinculo;
  final bool enable;
  final double height;
  final double maxHeight;
  final double? width;
  final String? Function(String?)? validator;
  final bool border;
  final bool dark;
  final bool shadow;
  final int? maxLines;
  final TextEditingController textEditingController;
  final bool withSearch;
  final Color? primaryColor;
  final Color? seconndaryColor;
  const CustomDropDownWidget({
    Key? key,
    this.title = '',
    required this.onChange,
    required this.lista,
    required this.textEditingController,
    required this.value,
    this.enable = true,
    this.valueVinculo = false,
    this.maxLines,
    this.height = 40,
    this.width,
    this.border = true,
    this.shadow = true,
    this.primaryColor,
    this.seconndaryColor,
    this.maxHeight = 200,
    this.dark = false,
    this.label,
    this.validator,
    this.fieldKey,
    this.withSearch = false,
  }) : super(key: key);

  @override
  State<CustomDropDownWidget<T>> createState() =>
      _CustomDropDownWidgetState<T>();
}

class _CustomDropDownWidgetState<T> extends State<CustomDropDownWidget<T>>
    with TickerProviderStateMixin {
  late ScrollController _controller;
  late FocusNode _focusNode;
  final LayerLink _layerLink = LayerLink();
  late OverlayEntry _overlayEntry;
  bool _isOpen = false;
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;
  late Animation<double> _rotateAnimation;
  late Animation<Color?> _animationColor;
  late Animation<Color?> _animationColorShadow;
  late Animation<Color?> _animationColorBorder;
  int? index;

  @override
  void initState() {
    super.initState();
    filter.value = widget.lista;
    _focusNode = FocusNode()..addListener(_listener);
    // widget.textEditingController = TextEditingController(text: widget.title);
    if (widget.value != null) {
      index = widget.lista.indexOf(widget.value!);
      _value = widget.value;
      widget.textEditingController.text = widget.value!.label;
    }
    _controller = ScrollController(initialScrollOffset: (index ?? 0.0) * 36);
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));
    _expandAnimation = CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInBack);
    _rotateAnimation = Tween(begin: 0.0, end: 0.5).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _animationColor = ColorTween(
            begin: widget.primaryColor ?? Colors.white,
            end: widget.seconndaryColor ?? Colors.white)
        .animate(_animationController);
    _animationColorShadow =
        ColorTween(begin: Colors.transparent, end: Colors.blue.withOpacity(0.3))
            .animate(_animationController);
    _animationColorBorder = ColorTween(begin: Colors.grey, end: Colors.blue)
        .animate(_animationController);
    for (var i = 0; i < widget.lista.length; i++) {
      _listKey[i] = GlobalKey();
    }
  }

  void _listener() {
    if (widget.enable && _focusNode.hasFocus && !_isOpen) {
      _toggleDropdown();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  final Map<int, GlobalKey> _listKey = {};
  Vinculo? _value;
  ValueNotifier<List<Vinculo>> filter = ValueNotifier([]);
  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: InkWell(
        onTap: widget.enable ? _toggleDropdown : null,
        child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, Widget? child) {
              return Container(
                margin: widget.border == false
                    ? const EdgeInsets.fromLTRB(0, 0, 16, 0)
                    : null,
                padding:
                    const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                // height: widget.height,
                width: widget.width ?? double.infinity,
                decoration: BoxDecoration(
                    boxShadow: [
                      if (_isOpen && widget.shadow)
                        BoxShadow(
                            color: _animationColorShadow.value ??
                                Colors.transparent,
                            spreadRadius: 3,
                            blurRadius: 0.1)
                    ],
                    color: _animationColor.value,
                    border: widget.border
                        ? Border.all(
                            color: _animationColorBorder.value ??
                                Colors.transparent)
                        : null,
                    borderRadius: widget.border
                        ? BorderRadius.circular(8)
                        : const BorderRadius.only(
                            topLeft: Radius.circular(8),
                            bottomLeft: Radius.circular(8))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  textDirection: TextDirection.ltr,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: TextFormField(
                        key: widget.fieldKey,
                        maxLines: widget.maxLines,
                        focusNode: _focusNode,
                        scrollPadding: const EdgeInsets.only(bottom: 250),
                        enabled: !widget.withSearch ? false : widget.enable,
                        keyboardAppearance: Brightness.dark,
                        decoration: const InputDecoration(
                          fillColor: Colors.transparent,
                          contentPadding: EdgeInsets.only(right: 16),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedErrorBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                        ),
                        onFieldSubmitted: (value) async {
                          if (value.isEmpty) {
                            _value = null;
                            index = null;
                            widget.textEditingController.text = widget.title;
                            filter.value = widget.lista;
                            await _toggleDropdown();
                            return;
                          }
                          try {
                            final currentIndex =
                                widget.lista.indexOf(filter.value[0]);
                            index = currentIndex;
                            widget.onChange(filter.value[0]);
                            _value = filter.value[0];
                            widget.textEditingController.text =
                                filter.value[0].label;
                            filter.value = widget.lista;
                            await _toggleDropdown();
                          } catch (e) {
                            _value = null;
                            index = null;
                            widget.textEditingController.text = widget.title;
                            filter.value = widget.lista;
                            await _toggleDropdown();
                          }
                        },
                        onChanged: (value) {
                          if (value.isEmpty) {
                            filter.value = widget.lista;
                            _value = null;
                            index = null;
                          }
                          filter.value = widget.lista
                              .where((e) => e.label
                                  .toLowerCase()
                                  .contains(value.toLowerCase()))
                              .toList();
                          setState(() {});
                        },
                        controller: widget.textEditingController,
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              _value == null) {
                            return '';
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                    // Text(_value?.label??widget.title,
                    //     maxLines: 1,
                    //     overflow: TextOverflow.ellipsis,
                    //     style: Theme.of(context).textTheme.titleMedium!.copyWith(color:!widget.enable? BtgCustomColors.smokeyGrey:null)
                    //   )
                    RotationTransition(
                      turns: _rotateAnimation,
                      child: Icon(
                        Icons.more_vert,
                        size: 13,
                        color: !widget.enable ? Colors.black : Colors.white,
                      ),
                    ),
                    //  SizedBox(
                    //   width: 0,
                    //   height: 0,
                    //   child: TextFormField(
                    //     key: widget.fieldKey,
                    //     controller: widget.textEditingController,
                    //         validator: (value){
                    //           if(value==null || value.isEmpty){
                    //             return '';
                    //           }else{
                    //             return null;
                    //           }
                    //         },
                    //       ),
                    // )
                  ],
                ),
              );
            }),
      ),
    );
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final heightScreen = MediaQuery.of(context).size.height;
    final offset = renderBox.localToGlobal(Offset.zero);
    final topOffset = offset.dy + size.height + 5;

    return OverlayEntry(
      builder: (context) => GestureDetector(
        onHorizontalDragStart: (value) => _toggleDropdown(close: true),
        onVerticalDragStart: (value) => _toggleDropdown(close: true),
        onTap: () => _toggleDropdown(close: true),
        behavior: HitTestBehavior.translucent,
        child: ValueListenableBuilder<List<Vinculo>>(
            valueListenable: filter,
            builder: (context, value, _) {
              final height = 36 * (value.length > 5 ? 5 : value.length);
              bool isNegative = widget.withSearch
                  ? false
                  : (heightScreen - (offset.dy + 100 + height)).isNegative;
              return SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).padding.bottom),
                  child: Stack(
                    children: [
                      Positioned(
                        left: offset.dx,
                        top: topOffset,
                        width: size.width,
                        child: CompositedTransformFollower(
                          offset: Offset(0,
                              isNegative ? size.height - 45 : size.height + 5),
                          link: _layerLink,
                          showWhenUnlinked: false,
                          child: Transform.rotate(
                            alignment: Alignment.topCenter,
                            angle: isNegative ? pi : 0.0,
                            child: Material(
                              elevation: 0,
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.white,
                              child: SizeTransition(
                                axisAlignment: 1,
                                sizeFactor: _expandAnimation,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 4),
                                    constraints: BoxConstraints(
                                        maxHeight: widget.maxHeight),
                                    child: value.isEmpty
                                        ? SizedBox()
                                        : Transform.rotate(
                                            angle: isNegative ? -pi : 0.0,
                                            child: ListView.builder(
                                                controller: _controller,
                                                physics:
                                                    const AlwaysScrollableScrollPhysics(),
                                                padding: EdgeInsets.zero,
                                                itemCount: value.length,
                                                shrinkWrap: true,
                                                itemBuilder: (_, i) {
                                                  final item = value[i];

                                                  return InkWell(
                                                    onTap: () {
                                                      index = i;
                                                      widget.onChange(item);
                                                      _value = item;
                                                      if (widget.valueVinculo) {
                                                        widget
                                                            .textEditingController
                                                            .text = item.value;
                                                      } else {
                                                        widget
                                                            .textEditingController
                                                            .text = item.label;
                                                      }
                                                      _toggleDropdown();
                                                      setState(() {});
                                                    },
                                                    child: Container(
                                                      key: _listKey[i],
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 16,
                                                          vertical: 10),
                                                      width: double.infinity,
                                                      color: item == _value
                                                          ? widget.dark
                                                              ? Colors
                                                                  .blueAccent
                                                              : Colors.white
                                                          : null,
                                                      child: Text(
                                                          item.label.trim(),
                                                          style: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .titleMedium!
                                                              .copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  color: item ==
                                                                          _value
                                                                      ? Colors
                                                                          .blue
                                                                      : Colors
                                                                          .blueGrey)),
                                                    ),
                                                  );
                                                }),
                                          ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }

  Future<void> _toggleDropdown({bool close = false}) async {
    if (_isOpen || close) {
      if (widget.textEditingController.text == '') {
        widget.textEditingController.text = widget.title;
      }
      await _animationController.reverse();
      _focusNode.unfocus();
      _controller.dispose();
      _overlayEntry.remove();
      setState(() {
        _isOpen = false;
      });
    } else {
      if (widget.textEditingController.text == widget.title) {
        widget.textEditingController.text = '';
      }
      _focusNode.requestFocus();
      if (filter.value.length <= 5) {
        _controller = ScrollController(initialScrollOffset: 0.0);
      } else {
        _controller = ScrollController(
            initialScrollOffset: ((index ?? 0.0) * 36 + ((index ?? 0.0) * 3)));
      }

      _overlayEntry = _createOverlayEntry();
      Overlay.of(context)?.insert(_overlayEntry);
      setState(() => _isOpen = true);
      await _animationController.forward();
      final targetContext = _listKey[index ?? 0]?.currentContext;
      if (targetContext != null) {
        if (!mounted) return;
        Scrollable.ensureVisible(targetContext,
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            alignment: 0,
            alignmentPolicy: ScrollPositionAlignmentPolicy.explicit);
      }
    }
  }
}
