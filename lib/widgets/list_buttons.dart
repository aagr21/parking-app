import 'package:flutter/material.dart';

class ListButtons extends StatefulWidget {
  final List<ButtonItem> items;
  final Axis direction;
  final double spacing;

  const ListButtons({
    super.key,
    required this.items,
    this.direction = Axis.vertical,
    this.spacing = 8.0,
  });

  @override
  State<ListButtons> createState() => _ListButtonsState();
}

class _ListButtonsState extends State<ListButtons> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: widget.direction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var item in widget.items) ...[
                FloatingActionButton(
                  backgroundColor: Colors.white,
                  shape: const CircleBorder(),
                  onPressed: item.onTap,
                  child: item.child,
                ),
                SizedBox(height: widget.spacing),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class ButtonItem {
  final Widget child;
  final VoidCallback onTap;

  ButtonItem({required this.child, required this.onTap});
}
