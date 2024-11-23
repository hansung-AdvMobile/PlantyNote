import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/services.dart';
import '../../widgets/profile/change_password_modal.dart';
import 'package:plant/widgets/components/bottom_navigation_bar.dart';

class MyPageEditScreen extends StatefulWidget {
  @override
  _MyPageScreenState createState() => _MyPageScreenState();
}

class _MyPageScreenState extends State<MyPageEditScreen> {
  int _selectedIndex = 2;
  late TextEditingController _nameController;
  late TextEditingController _introController;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: '마이클'); // 초기 값 설정
    _introController = TextEditingController(text: '안녕하세요, 초보 식집사입니다.'); // 초기 값 설정
  }

  final int plantCount = 2;

  // PW변경 모달창 호출 함수
  void _showPasswordChangeModal() {
    showDialog(
      context: context,
      builder: (context) => PasswordChangeModal(),
    );
  }

  // 이미지 경로 리스트
  final List<String> imagePaths = [
    'assets/images/plant1.png',
    'assets/images/plant1.png',
    'assets/images/plant1.png',
    'assets/images/plant1.png',
    'assets/images/plant1.png'
  ];

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
                      Expanded(
                        child: _editProfileInfo(), // 닉네임, 소개글 편집
                      ),
                    ],
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Row(
                      children: [
                        _editCompleteButton(), // 수정 완료 버튼
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
            Align( // 계정탈퇴 버튼
              alignment: Alignment.center,
              child: InkWell(
                onTap: () {
                  // 계정 탈퇴 로직
                  context.go('/onboarding'); // 온보딩페이지로 이동
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Text(
                    '계정 탈퇴',
                    style: TextStyle(
                      color: Color(0xFFDA2525),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
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
      automaticallyImplyLeading: false, // 뒤로가기버튼 숨기기
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
          child: InkWell( // PW변경 버튼
            onTap: () {
              _showPasswordChangeModal();
            },
            child: Text(
              'PW변경',
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

  // 프로필 사진
  Widget _profileImage() {
    return Padding(
      padding: EdgeInsets.only(left: 8.0),
      child: CircleAvatar(
        radius: 50,
        backgroundImage: AssetImage('assets/profile_image.png'),
      ),
    );
  }

  // 닉네임, 소개글 편집
  Widget _editProfileInfo() {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0, top: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container( // 닉네임 TextField
            padding: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Color(0xFF4B7E5B),
                width: 1.0,
              ),
            ),
            child: TextField(
              controller: _nameController,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4B7E5B),
              ),
              inputFormatters: [
                LengthLimitingTextInputFormatter(10), // 글자 수 제한 10자
              ],
              decoration: InputDecoration(
                border: InputBorder.none,
                isCollapsed: true,
              ),
            ),
          ),
          SizedBox(height: 4),
          Container( // 소개글 TextField
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Color(0xFF4B7E5B),
                width: 1.0,
              ),
            ),
            child: TextField(
              controller: _introController,
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF4B7E5B),
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                isCollapsed: true,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 수정 완료 버튼
  Widget _editCompleteButton() {
    return ElevatedButton(
      onPressed: () {
        context.pop(); // 마이페이지로 이동
      },
      child: Text('수정 완료'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF4B7E5B),
        foregroundColor: Colors.white,
      ),
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
            return ClipRRect( // 클릭 이벤트 없음
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                imagePaths[index],
                fit: BoxFit.cover,
              ),
            );
          },
        ),
      ),
    );
  }
}
