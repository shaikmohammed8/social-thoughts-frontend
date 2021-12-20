import 'package:flutter/material.dart';
import 'dart:math' as math;

class AnimateIcons extends StatefulWidget {
  const AnimateIcons({
    @required this.startIcon,
    @required this.endIcon,
    @required this.onStartIconPress,
    @required this.onEndIconPress,
    @required this.size,
    @required this.controller,
    @required this.startIconColor,
    this.endIconColor,
    this.duration,
    this.clockwise,
    this.startTooltip,
    this.endTooltip,
  });
  final IconData startIcon, endIcon;
  final bool Function() onStartIconPress, onEndIconPress;
  final Duration duration;
  final bool clockwise;
  final double size;
  final Color startIconColor, endIconColor;
  final AnimateIconController controller;
  final String startTooltip, endTooltip;

  @override
  _AnimateIconsState createState() => _AnimateIconsState();
}

class _AnimateIconsState extends State<AnimateIcons>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    this._controller = new AnimationController(
      vsync: this,
      duration: widget.duration,
      lowerBound: 0.0,
      upperBound: 1.0,
    );
    this._controller.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
    initControllerFunctions();
    super.initState();
  }

  @override
  void dispose() {
    this._controller.dispose();
    super.dispose();
  }

  initControllerFunctions() {
    widget.controller.animateToEnd = () {
      if (mounted) {
        _controller.forward();
        return true;
      } else {
        return false;
      }
    };
    widget.controller.animateToStart = () {
      if (mounted) {
        _controller.reverse();
        return true;
      } else {
        return false;
      }
    };
    widget.controller.isStart = () => _controller.value == 0.0;
    widget.controller.isEnd = () => _controller.value == 1.0;
  }

  _onStartIconPress() {
    if (widget.onStartIconPress() && mounted) _controller.forward();
  }

  _onEndIconPress() {
    if (widget.onEndIconPress() && mounted) _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    double x = _controller.value;
    double y = 1.0 - _controller.value;
    double angleX = math.pi / 180 * (180 * x);
    double angleY = math.pi / 180 * (180 * y);

    Widget first() {
      final icon = Icon(widget.startIcon, size: widget.size);
      return Transform.rotate(
        angle: widget.clockwise == false ? angleX : -angleX,
        child: Opacity(
          opacity: y,
          child: IconButton(
            iconSize: 24.0,
            color: widget.startIconColor,
            disabledColor: Colors.grey.shade500,
            icon: widget.startTooltip == null
                ? icon
                : Tooltip(
                    message: widget.startTooltip,
                    child: icon,
                  ),
            onPressed: _onStartIconPress,
          ),
        ),
      );
    }

    Widget second() {
      final icon = Icon(widget.endIcon);
      return Transform.rotate(
        angle: widget.clockwise == false ? -angleY : angleY,
        child: Opacity(
          opacity: x,
          child: IconButton(
            iconSize: widget.size,
            color: widget.endIconColor,
            disabledColor: Colors.grey.shade500,
            icon: widget.endTooltip == null
                ? icon
                : Tooltip(
                    message: widget.endTooltip,
                    child: icon,
                  ),
            onPressed: _onEndIconPress,
          ),
        ),
      );
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        x == 1 && y == 0 ? second() : first(),
        x == 0 && y == 1 ? first() : second(),
      ],
    );
  }
}

class AnimateIconController {
  bool Function() animateToStart, animateToEnd;
  bool Function() isStart, isEnd;
}
