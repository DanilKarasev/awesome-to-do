import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GenericHoldToPerformButton extends StatefulWidget {
  final String label;
  final double fontSize;
  final Color? color;
  final int holdDuration;
  final double horizontalPadding;
  final double verticalPadding;
  final Function onConfirm;

  const GenericHoldToPerformButton({
    super.key,
    required this.label,
    this.fontSize = 14.0,
    this.holdDuration = 1000,
    this.horizontalPadding = 12.0,
    this.verticalPadding = 12.0,
    this.color,
    required this.onConfirm,
  });

  @override
  State<GenericHoldToPerformButton> createState() =>
      _GenericHoldToPerformButtonState();
}

class _GenericHoldToPerformButtonState extends State<GenericHoldToPerformButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  AnimationStatus? _animationStatus;
  double containerWidth = 0;
  double containerHeight = 0;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.holdDuration),
    )..addStatusListener(
        (status) {
          _animationStatus = status;
          if (_animationStatus == AnimationStatus.completed) {
            widget.onConfirm.call();
          }
        },
      );

    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPressDown: (details) async {
        HapticFeedback.heavyImpact();
        _animationController.value = 0;
        _animationController.forward(from: 0);
      },
      onLongPressCancel: () {
        HapticFeedback.mediumImpact();
        if (_animationStatus != AnimationStatus.completed) {
          _animationController.reset();
        }
      },
      onLongPressUp: () {
        HapticFeedback.mediumImpact();
        if (_animationStatus != AnimationStatus.completed) {
          _animationController.reset();
        }
      },
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (BuildContext context, Widget? child) {
          containerWidth = getContainerWidth();
          containerHeight = getContainerHeight();
          final double width = _animation.value * containerWidth;
          return Container(
            width: containerWidth,
            height: containerHeight,
            decoration: BoxDecoration(
              color: widget.color == null
                  ? Colors.transparent
                  : widget.color!.withOpacity(0.05),
            ),
            child: Stack(
              children: [
                AnimatedContainer(
                    curve: Curves.linear,
                    duration: const Duration(milliseconds: 100),
                    width: width >= containerWidth ? containerWidth : width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4.0),
                      color: (widget.color ?? Colors.red.shade600)
                          .withOpacity(0.2),
                    )),
                Center(
                  child: Text(
                    widget.label,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: widget.color ?? Colors.red.shade600,
                      fontSize: widget.fontSize,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  double getContainerHeight() {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: widget.label,
        style: TextStyle(
          fontSize: widget.fontSize,
        ),
      ),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout(minWidth: 0, maxWidth: double.infinity);
    // getting the height of text
    final double textHeight = textPainter.size.height;

    // adding padding to top and bottom
    double verticalPadding = widget.verticalPadding * 2;

    // getting the height of container
    containerHeight = textHeight + verticalPadding;

    return containerHeight;
  }

  double getContainerWidth() {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: widget.label,
        style: TextStyle(
          fontSize: widget.fontSize,
        ),
      ),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout(minWidth: 0, maxWidth: double.infinity);
    // getting the width of text
    final double textWidth = textPainter.size.width;

    // adding padding to left and right
    double horizontalPadding = widget.horizontalPadding * 2;

    // getting the width of container
    containerWidth = textWidth + horizontalPadding;

    return containerWidth;
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
