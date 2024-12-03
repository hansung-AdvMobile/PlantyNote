import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:plant/widgets/components/bottom_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'my_page_edit_screen.dart';


class MyPageScreen extends StatefulWidget {
  const MyPageScreen({super.key});

  @override
  MyPageScreenState createState() => MyPageScreenState();
}

class MyPageScreenState extends State<MyPageScreen> {
  int _selectedIndex = 2; // 네비게이션 인덱스

  // 사용자 정보 변수
  String _nickname = ''; // 이름 (닉네임)
  String _bio = '';      // 소개문
  String? _profileImageUrl; // 프로필 이미지 URL 추가

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final int plantCount = 1;

  // 이미지 경로 리스트
  final List<String> imagePaths = [
    'assets/images/plant1.png',
    'assets/images/plant1.png',
    'assets/images/plant1.png',
    'assets/images/plant1.png',
    'assets/images/plant1.png',
  ];

  Future<void> _fetchUserData() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          setState(() {
            _nickname = userDoc.get('nickname') ?? '';
            _bio = userDoc.get('bio') ?? '';
            _profileImageUrl = userDoc.get('profileImage') as String?;
          });
        }
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchUserData(); // 사용자 데이터 가져오기
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(), // 상단 바
      body: Padding(
        padding: const EdgeInsets.only(right: 18.0, left: 18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container( // 프로필 박스
              height: 150,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Color(0xFFC9DDD0),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Stack(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _profileImage(), // 프로필 이미지
                      SizedBox(width: 16),
                      _profileInfo(), // 닉네임, 소개글
                    ],
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Row(
                      children: [
                        _editProfileButton(), // 프로필 수정 버튼
                        SizedBox(width: 10),
                        _plantsNumber(), // 내식물모음페이지에 있는 식물 개수
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Divider( // 구분선
              color: Color(0xFF4B7E5B),
              thickness: 0.7,
              indent: 5,
              endIndent: 5,
            ),
            _myPostsNumber(),
            SizedBox(height: 12),
            _myPosts(), // 나의 게시물들
          ],
        ),
      ),
      bottomNavigationBar: MyBottomNavigationBar( // 하단 네비게이션바
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  // 상단 바
  AppBar _buildAppBar() {
    return AppBar(
      scrolledUnderElevation: 0,
      backgroundColor: Colors.white,
      title: Text(
        'MY 프로필',
        style: TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [ // 오른쪽 끝 배치
        Padding(
          padding: const EdgeInsets.only(right: 18.0),
          child: InkWell( // 로그아웃 버튼
            onTap: () {
              _showLogoutDialog(context);
            },
            child: Text(
              '로그아웃',
              style: TextStyle(
                color: Color(0xFFB3B3B3),
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // 로그아웃 확인 팝업
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("로그아웃"),
          content: Text("로그아웃 하시겠습니까?"),
          actions: [
            TextButton(
              onPressed: () {
                context.pop(); // 팝업 닫기
              },
              child: Text("아니오"),
            ),
            TextButton(
              onPressed: () {
                context.go('/start/login'); // 로그인페이지로 이동
                // 로그인 기능 구현
              },
              child: Text("예"),
            ),
          ],
        );
      },
    );
  }

  // 프로필 사진
  Widget _profileImage() {
    return Padding(
      padding: EdgeInsets.only(left: 8.0),
      child: CircleAvatar(
        radius: 50,
        backgroundColor: Colors.grey[200],
        backgroundImage: _profileImageUrl != null && _profileImageUrl!.startsWith('http')
            ? NetworkImage(_profileImageUrl!)
            : AssetImage('assets/images/basic_profile.png') as ImageProvider,
      ),
    );
  }


// 닉네임, 소개글
  Widget _profileInfo() {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0, top: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text( // 닉네임
            _nickname.isNotEmpty ? _nickname : '이름 없음',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4B7E5B),
            ),
          ),
          SizedBox(height: 4),
          Text( // 소개 글
            _bio.isNotEmpty ? _bio : '소개문을 입력해주세요.',
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF4B7E5B),
            ),
          ),
        ],
      ),
    );
  }

  // 프로필 수정 버튼
  Widget _editProfileButton() {
    return ElevatedButton(
      onPressed: () {
        Navigator.push<bool>(
          context,
          MaterialPageRoute(builder: (context) => MyPageEditScreen()),
        ).then((isUpdated) {
          if (isUpdated == true) {
            _fetchUserData(); // 데이터 다시 가져오기
          }
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF4B7E5B),
        foregroundColor: Colors.white,
      ),
      child: Text('프로필 수정'),
    );
  }


  // 내식물모음페이지에 있는 식물 개수
  Widget _plantsNumber() {
    return Container(
      padding:
      EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(50),
      ),
      child: Row(
        children: [
          Icon(Icons.eco, color: Color(0xFF4B7E5B),),
          SizedBox(width: 4),
          Text(
            '$plantCount',
            style: TextStyle(color: Color(0xFF4B7E5B),),
          ),
        ],
      ),
    );
  }

  // 나의 게시물 개수
  Widget _myPostsNumber() {
    return Padding(
      padding: const EdgeInsets.only(left: 6.0),
      child: Text(
        '나의 게시물 : ${imagePaths.length}개',
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey),
      ),
    );
  }

  // 나의 게시물들
  Widget _myPosts() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: imagePaths.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                context.push('/community/detail'); // 클릭 시 화면 이동
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  imagePaths[index],
                  fit: BoxFit.cover,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
