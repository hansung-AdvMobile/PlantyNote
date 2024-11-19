// emoji_selector.dart              # 이모티콘 선택 UI
import 'package:flutter/material.dart';

class EmojiSelector extends StatelessWidget {
  final List<String> emojis;
  final int selectedIndex;
  final ValueChanged<int> onEmojiSelected;

  const EmojiSelector({
    super.key,
    required this.emojis,
    required this.selectedIndex,
    required this.onEmojiSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: List.generate(
        emojis.length,
            (index) => GestureDetector(
          onTap: () => onEmojiSelected(index),
          child: Text(
            emojis[index],
            style: TextStyle(
              fontSize: 24,
              color: selectedIndex == index ? Colors.blue : Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}