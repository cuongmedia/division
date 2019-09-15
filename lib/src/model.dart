import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'function/hex_color.dart';

class RippleModel {
  final bool enable;
  final Color highlightColor;
  final Color splashColor;

  RippleModel({this.enable, this.highlightColor, this.splashColor});
}

class BackgroundModel with ChangeNotifier {
  Color _color;
  double _blur;
  DecorationImage _image;

  Color get exportBackgroundColor => _color;
  double get exportBackgroundBlur => _blur;
  DecorationImage get exportBackgroundImage => _image;

  /// BackgroundColor
  void color(Color color) {
    _color = color;
    notifyListeners();
  }

  /// background color in the rgba format
  void rgba(int r, int g, int b, [double opacity = 1.0]) {
    _color = Color.fromRGBO(r, g, b, opacity);
    notifyListeners();
  }

  /// Background color in the hex format
  /// ```dart
  /// background.hex('f5f5f5')
  /// ```
  void hex(String xxxxxx) {
    _color = HexColor(xxxxxx);
    notifyListeners();
  }

  /// Blurs the background
  ///
  /// Frosted glass example:
  /// ```dart
  /// ..background.blur(10)
  /// ..background.rgba(255,255,255,0.15)
  /// ```
  /// Does not work together with `rotate()`.
  void blur(double blur) {
    if (blur < 0) throw ('Blur cannot be negative: $blur');
    _blur = blur;
    notifyListeners();
  }

  /// Eighter the [url] or the [path] has to be specified.
  /// [url] is for network images and [path] is for local images.
  /// [path] trumps [url].
  ///
  /// ```dart
  /// ..backgroundImage(
  ///   url: 'path/to/image'
  ///   fit: BoxFit.cover
  /// )
  /// ```
  void image(
      {String url,
      String path,
      ImageProvider<dynamic> imageProveder,
      ColorFilter colorFilter,
      BoxFit fit,
      AlignmentGeometry alignment = Alignment.center,
      ImageRepeat repeat = ImageRepeat.noRepeat}) {
    if ((url ?? path ?? imageProveder) == null)
      throw ('Eighter the [imageProvider], [url] or the [path] has to be provided');

    ImageProvider<dynamic> image;
    if (imageProveder != null)
      image = imageProveder;
    else if (path != null)
      image = AssetImage(path);
    else
      image = NetworkImage(url);

    _image = DecorationImage(
      image: image,
      colorFilter: colorFilter,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
    );
    notifyListeners();
  }
}

class AlignmentModel with ChangeNotifier {
  AlignmentGeometry _alignment;

  AlignmentGeometry get getAlignment => _alignment;

  void topLeft() => _updateAlignment(Alignment.topLeft);
  void topCenter() => _updateAlignment(Alignment.topCenter);
  void topRight() => _updateAlignment(Alignment.topRight);

  void bottomLeft() => _updateAlignment(Alignment.bottomLeft);
  void bottomCenter() => _updateAlignment(Alignment.bottomCenter);
  void bottomRight() => _updateAlignment(Alignment.bottomRight);

  void centerLeft() => _updateAlignment(Alignment.centerLeft);
  void center() => _updateAlignment(Alignment.center);
  void centerRight() => _updateAlignment(Alignment.centerRight);

  void coordinate(double x, double y) => _updateAlignment(Alignment(x, y));

  void _updateAlignment(AlignmentGeometry alignment) {
    _alignment = alignment;
    notifyListeners();
  }
}

enum OverflowType { hidden, scroll, visible }

class OverflowModel with ChangeNotifier {
  Axis _direction;
  OverflowType _overflow;

  Axis get getDirection => _direction;
  OverflowType get getOverflow => _overflow;

  void hidden() => _updateOverflow(OverflowType.hidden);

  void scrollable([Axis direction = Axis.vertical]) =>
      _updateOverflow(OverflowType.scroll, direction);

  void visible([Axis direction = Axis.vertical]) =>
      _updateOverflow(OverflowType.visible, direction);

  void _updateOverflow(OverflowType overflow, [Axis direction]) {
    _overflow = overflow;
    if (direction != null) _direction = direction;
    notifyListeners();
  }
}

class StyleModel {
  AlignmentGeometry alignment;
  AlignmentGeometry alignmentContent;
  double width;
  double minWidth;
  double maxWidth;
  double height;
  double minHeight;
  double maxHeight;
  Color backgroundColor;
  double backgroundBlur;
  DecorationImage backgroundImage;
  EdgeInsetsGeometry padding;
  EdgeInsetsGeometry margin;
  Gradient gradient;
  BoxBorder border;
  BorderRadiusGeometry borderRadius;
  List<BoxShadow> boxShadow;
  double scale;
  double rotate;
  Offset offset;
  Duration duration;
  Curve curve;
  RippleModel ripple;
  double opacity;
  OverflowType overflow;
  Axis overflowDirection;

  BoxDecoration _decoration;
  BoxConstraints _constraints;
  Matrix4 _transform;

  void inject(StyleModel intruder, bool override) {
    alignment = _replace(alignment, intruder?.alignment, override);
    alignmentContent =
        _replace(alignmentContent, intruder?.alignmentContent, override);
    width = _replace(width, intruder?.width, override);
    minWidth = _replace(minWidth, intruder?.minWidth, override);
    maxWidth = _replace(maxWidth, intruder?.maxWidth, override);
    height = _replace(height, intruder?.height, override);
    minHeight = _replace(minHeight, intruder?.minHeight, override);
    maxHeight = _replace(maxHeight, intruder?.maxHeight, override);
    backgroundColor =
        _replace(backgroundColor, intruder?.backgroundColor, override);
    backgroundBlur =
        _replace(backgroundBlur, intruder?.backgroundBlur, override);
    backgroundImage =
        _replace(backgroundImage, intruder?.backgroundImage, override);
    padding = _replace(padding, intruder?.padding, override);
    margin = _replace(margin, intruder?.margin, override);
    gradient = _replace(gradient, intruder?.gradient, override);
    border = _replace(border, intruder?.border, override);
    borderRadius = _replace(borderRadius, intruder?.borderRadius, override);
    boxShadow = _replace(boxShadow, intruder?.boxShadow, override);
    scale = _replace(scale, intruder?.scale, override);
    rotate = _replace(rotate, intruder?.rotate, override);
    offset = _replace(offset, intruder?.offset, override);
    duration = _replace(duration, intruder?.duration, override);
    curve = _replace(curve, intruder?.curve, override);
    ripple = _replace(ripple, intruder?.ripple, override);
    opacity = _replace(opacity, intruder?.opacity, override);
    overflow = _replace(overflow, intruder?.overflow, override);
    overflowDirection =
        _replace(overflowDirection, intruder?.overflowDirection, override);
    // gesture = _replace(gesture, intruder?.gesture, override);
  }

  dynamic _replace(dynamic current, dynamic intruder, bool override) {
    if (override == true)
      return intruder ?? current;
    else
      return current ?? intruder;
  }

  BoxConstraints get constraints {
    if (_constraints != null) return _constraints;

    BoxConstraints boxConstraints;
    if ((minHeight ?? maxHeight ?? minWidth ?? maxWidth) != null) {
      boxConstraints = BoxConstraints(
        minWidth: minWidth ?? 0.0,
        maxWidth: maxWidth ?? double.infinity,
        minHeight: minHeight ?? 0.0,
        maxHeight: maxHeight ?? double.infinity,
      );
    }
    boxConstraints = (width != null || height != null)
        ? boxConstraints?.tighten(width: width, height: height) ??
            BoxConstraints.tightFor(width: width, height: height)
        : boxConstraints;

    return boxConstraints;
  }

  BoxDecoration get decoration {
    if (_decoration != null) return _decoration;

    if ((backgroundColor ??
            backgroundImage ??
            gradient ??
            border ??
            borderRadius ??
            boxShadow) !=
        null) {
      BoxDecoration boxDecoration = BoxDecoration(
          color: backgroundColor,
          image: backgroundImage,
          gradient: gradient,
          border: border,
          borderRadius: borderRadius,
          boxShadow: boxShadow);
      return boxDecoration;
    }
    return null;
  }

  Matrix4 get transform {
    if (_transform != null) return _transform;

    if ((scale ?? rotate ?? offset) != null) {
      return Matrix4.rotationZ(rotate ?? 0.0)
        ..scale(scale ?? 1.0)
        ..translate(
          offset?.dx ?? 0.0,
          offset?.dy ?? 0.0,
        );
    }
    return null;
  }

  set setBoxDecoration(BoxDecoration boxDecoration) =>
      _decoration = boxDecoration;
  set setBoxConstraints(BoxConstraints boxConstraints) =>
      _constraints = boxConstraints;
  set setTransform(Matrix4 transform) => _transform = transform;
}

class GestureModel {
  GestureModel({
    @required this.behavior,
    @required this.excludeFromSemantics,
    @required this.dragStartBehavior,
  });

  GestureTapDownCallback onTapDown;
  GestureTapUpCallback onTapUp;
  GestureTapCallback onTap;
  GestureTapCancelCallback onTapCancel;
  GestureTapDownCallback onSecondaryTapDown;
  GestureTapUpCallback onSecondaryTapUp;
  GestureTapCancelCallback onSecondaryTapCancel;
  GestureTapCallback onDoubleTap;
  GestureLongPressCallback onLongPress;
  GestureLongPressStartCallback onLongPressStart;
  GestureLongPressMoveUpdateCallback onLongPressMoveUpdate;
  GestureLongPressUpCallback onLongPressUp;
  GestureLongPressEndCallback onLongPressEnd;
  GestureDragDownCallback onVerticalDragDown;
  GestureDragStartCallback onVerticalDragStart;
  GestureDragUpdateCallback onVerticalDragUpdate;
  GestureDragEndCallback onVerticalDragEnd;
  GestureDragCancelCallback onVerticalDragCancel;
  GestureDragDownCallback onHorizontalDragDown;
  GestureDragStartCallback onHorizontalDragStart;
  GestureDragUpdateCallback onHorizontalDragUpdate;
  GestureDragEndCallback onHorizontalDragEnd;
  GestureDragCancelCallback onHorizontalDragCancel;
  GestureDragDownCallback onPanDown;
  GestureDragStartCallback onPanStart;
  GestureDragUpdateCallback onPanUpdate;
  GestureDragEndCallback onPanEnd;
  GestureDragCancelCallback onPanCancel;
  GestureScaleStartCallback onScaleStart;
  GestureScaleUpdateCallback onScaleUpdate;
  GestureScaleEndCallback onScaleEnd;
  GestureForcePressStartCallback onForcePressStart;
  GestureForcePressPeakCallback onForcePressPeak;
  GestureForcePressUpdateCallback onForcePressUpdate;
  GestureForcePressEndCallback onForcePressEnd;
  final HitTestBehavior behavior;
  final bool excludeFromSemantics;
  final DragStartBehavior dragStartBehavior;

  // void inject(GestureModel intruder, bool override) {
  //   onTapDown = _replace(onTapDown, intruder?.onTapDown, override);
  // onTapUp;
  // onTap;
  // onTapCancel;
  // onSecondaryTapDown;
  // onSecondaryTapUp;
  // onSecondaryTapCancel;
  // onDoubleTap;
  // onLongPress;
  // onLongPressStart;
  // onLongPressMoveUpdate;
  // onLongPressUp;
  // onLongPressEnd;
  // onVerticalDragDown;
  // final GestureDragStartCallback onVerticalDragStart;
  // final GestureDragUpdateCallback onVerticalDragUpdate;
  // final GestureDragEndCallback onVerticalDragEnd;
  // final GestureDragCancelCallback onVerticalDragCancel;
  // final GestureDragDownCallback onHorizontalDragDown;
  // final GestureDragStartCallback onHorizontalDragStart;
  // final GestureDragUpdateCallback onHorizontalDragUpdate;
  // final GestureDragEndCallback onHorizontalDragEnd;
  // final GestureDragCancelCallback onHorizontalDragCancel;
  // final GestureDragDownCallback onPanDown;
  // final GestureDragStartCallback onPanStart;
  // final GestureDragUpdateCallback onPanUpdate;
  // final GestureDragEndCallback onPanEnd;
  // final GestureDragCancelCallback onPanCancel;
  // final GestureScaleStartCallback onScaleStart;
  // final GestureScaleUpdateCallback onScaleUpdate;
  // final GestureScaleEndCallback onScaleEnd;
  // final GestureForcePressStartCallback onForcePressStart;
  // final GestureForcePressPeakCallback onForcePressPeak;
  // final GestureForcePressUpdateCallback onForcePressUpdate;
  // final GestureForcePressEndCallback onForcePressEnd;
  // final HitTestBehavior behavior;
  // final bool excludeFromSemantics;
  // final DragStartBehavior dragStartBehavior;
  // }

  // dynamic _replace(dynamic current, dynamic intruder, bool override) {
  //   if (override == true)
  //     return intruder ?? current;
  //   else
  //     return current ?? intruder;
  // }
}

class TextModel {
  FontWeight fontWeight;
  TextAlign textAlign;
  FontStyle fontStyle;
  String fontFamily;
  List<String> fontFamilyFallback;
  double fontSize;
  Color textColor;
  int maxLines;
  double letterSpacing;
  double wordSpacing;

  //editable
  bool editable;
  TextInputType keyboardType;
  String placeholder;
  bool obscureText;

  void Function(String) onChange;
  void Function(bool focus) onFocusChange;
  void Function(TextSelection, SelectionChangedCause)
      onSelectionChanged;
  FocusNode focusNode;

  void inject(TextModel textModel, bool override) {
    fontWeight = _replace(fontWeight, textModel?.fontWeight, override);
    textAlign = _replace(textAlign, textModel?.textAlign, override);
    fontStyle = _replace(fontStyle, textModel?.fontStyle, override);
    fontFamily = _replace(fontFamily, textModel?.fontFamily, override);
    fontFamilyFallback =
        _replace(fontFamilyFallback, textModel?.fontFamilyFallback, override);
    fontSize = _replace(fontSize, textModel?.fontSize, override);
    textColor = _replace(textColor, textModel?.textColor, override);
    maxLines = _replace(maxLines, textModel?.maxLines, override);
    letterSpacing = _replace(letterSpacing, textModel?.letterSpacing, override);
    wordSpacing = _replace(wordSpacing, textModel?.wordSpacing, override);

    editable = _replace(editable, textModel?.editable, override);
    keyboardType = _replace(keyboardType, textModel?.keyboardType, override);
    onChange = _replace(onChange, textModel?.onChange, override);
    onFocusChange = _replace(onFocusChange, textModel?.onFocusChange, override);
    onSelectionChanged =
        _replace(onSelectionChanged, textModel?.onSelectionChanged, override);
    focusNode = _replace(focusNode, textModel?.focusNode, override);
  }

  dynamic _replace(dynamic current, dynamic intruder, bool override) {
    if (override == true)
      return intruder ?? current;
    else
      return current ?? intruder;
  }

  TextStyle get textStyle {
    return TextStyle(
      fontWeight: fontWeight,
      fontSize: fontSize,
      color: textColor ?? Colors.black,
      fontStyle: fontStyle ?? FontStyle.normal,
      fontFamily: fontFamily,
      fontFamilyFallback: fontFamilyFallback,
      letterSpacing: letterSpacing,
      wordSpacing: wordSpacing,
    );
  }
}

class TextAlignModel with ChangeNotifier {
  TextAlign _textAlign;

  TextAlign get exportTextAlign => _textAlign;

  void left() => _updateAlignment(TextAlign.left);
  void right() => _updateAlignment(TextAlign.right);
  void center() => _updateAlignment(TextAlign.center);
  void justify() => _updateAlignment(TextAlign.justify);
  void start() => _updateAlignment(TextAlign.start);
  void end() => _updateAlignment(TextAlign.end);

  _updateAlignment(TextAlign textAlign) {
    _textAlign = textAlign;
    notifyListeners();
  }
}
