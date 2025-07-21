import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_founders/presentation/chat/chat_list_page.dart';
import 'package:flutter_founders/presentation/investment/bloc/investment_bloc.dart';
import 'package:flutter_founders/presentation/investment/bloc/investment_event.dart';
import 'package:flutter_founders/presentation/profile/profile_screen.dart';
import 'package:flutter_founders/presentation/posts/bloc/posts_bloc.dart';
import 'package:flutter_founders/presentation/posts/bloc/posts_event.dart';
import 'package:flutter_founders/presentation/search/search_page.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_founders/data/api/posts_api_service.dart';
import 'package:flutter_founders/data/api/investment_api_service.dart';
import 'home_tab_bar_page.dart';

class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({super.key});

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int _currentIndex = 0;
  final ValueNotifier<int> _tabIndexNotifier = ValueNotifier(0);

  final List<Widget> _pages = [
    HomeTabBarPage(tabIndexNotifier: ValueNotifier(0)),
    const SearchPage(),
    const ChatListPage(),
    const ProfileScreen(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      if (index == 0) _tabIndexNotifier.value = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: const FlutterSecureStorage().read(key: 'auth_token'),
      builder: (context, snapshot) {
        final token = snapshot.data;

        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            backgroundColor: Colors.black,
            body: Center(child: CircularProgressIndicator(color: Colors.white)),
          );
        }

        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) =>
                  InvestmentBloc(investmentApiService: InvestmentApiService())
                    ..add(const LoadInvestments()),
            ),
            BlocProvider(
              create: (_) =>
                  PostsBloc(PostsApiService())..add(const LoadPostsEvent()),
            ),
          ],
          child: Scaffold(
            backgroundColor: Colors.black,
            body: _pages[_currentIndex],
            bottomNavigationBar: BottomNavigationBar(
              backgroundColor: Colors.black,
              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.grey,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              type: BottomNavigationBarType.fixed,
              elevation: 0,
              currentIndex: _currentIndex,
              onTap: _onTabTapped,
              items: [
                _navItem('home.png', 0),
                _navItem('search.png', 1),
                _navItem('chat.png', 2),
                _navItem('profile.png', 3),
              ],
            ),
          ),
        );
      },
    );
  }

  BottomNavigationBarItem _navItem(String asset, int index) =>
      BottomNavigationBarItem(
        icon: Image.asset(
          'assets/pngs/$asset',
          width: 30,
          height: 30,
          color: _currentIndex == index ? Colors.white : Colors.grey,
        ),
        label: '',
      );
}
