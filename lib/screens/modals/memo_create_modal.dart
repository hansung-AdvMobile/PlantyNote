import 'package:flutter/material.dart';
import '../../widgets/inputs/emoji_selector.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class MemoCreateModal extends StatefulWidget {
  const MemoCreateModal({super.key});

  @override
  State<MemoCreateModal> createState() => _MemoCreateModalState();
}

class _MemoCreateModalState extends State<MemoCreateModal> {
  XFile? _image; // 이미지 저장 변수
  final ImagePicker _picker = ImagePicker();
  final _memoController = TextEditingController();
  int selectedEmojiIndex = 0;

  // 사진 선택 함수
  void _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _image = image;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 60),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '오늘의 한줄 메모',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            EmojiSelector(
              emojis: ['😆', '😊', '😐', '😞', '😭'],
              selectedIndex: selectedEmojiIndex,
              onEmojiSelected: (index) {
                setState(() {
                  selectedEmojiIndex = index;
                });
              },
            ),
            SizedBox(height: 10),
            _inputField(), // 메모 입력
            SizedBox(height: 10),
            _imagePicker(), // 사진 선택
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () { // 완료 버튼
                if (_memoController.text.trim().isNotEmpty) {
                   context.pop();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF4B7E5B), // 배경색
                foregroundColor: Colors.white, // 글자색
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
              child: const Text('완료'),
            ),
          ],
        ),
      ),
    );
  }

  // 글 입력 textField
  Widget _inputField() {
    return TextField(
      controller: _memoController,
      maxLines: null,
      minLines: 3,
      decoration: InputDecoration(
        hintText: '오늘 나의 식물은 어땠나요?',
        hintStyle: TextStyle(
          color: Color(0xFFB3B3B3),
          fontSize: 13,
        ),
        contentPadding: EdgeInsets.fromLTRB(16, 12, 16, 12),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Color(0xFFB3B3B3),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Color(0xFF4B7E5B),
            width: 1,
          ),
        ),
      ),
      style: TextStyle(
        fontSize: 13,
        color: Colors.black,
      ),
    );
  }

  // 사진 등록 ImagePicker
  Widget _imagePicker() {
    return GestureDetector(
      onTap: _pickImage, // 새로운 사진 선택 가능
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: Colors.grey[200], // 배경색
          borderRadius: BorderRadius.circular(10),
          image: _image != null
              ? DecorationImage(
            image: FileImage(File(_image!.path)), // 이미지가 있을 때 표시
            fit: BoxFit.cover,
          )
              : null,
        ),
        child: _image == null
            ? Icon(
          Icons.add, // 이미지가 없을 때 추가 아이콘 표시
          color: Colors.grey[400],
          size: 30,
        )
            : null, // 이미지가 있으면 아이콘 표시 안함
      ),
    );
  }
}
