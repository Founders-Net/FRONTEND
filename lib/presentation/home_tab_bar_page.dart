import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_founders/data/api/investment_api_service.dart';
import 'package:flutter_founders/presentation/investment/investment_page.dart';
import 'package:flutter_founders/presentation/posts/posts_page.dart';
import 'package:flutter_founders/presentation/posts/create_posts/create_posts_page.dart';
import 'package:flutter_founders/presentation/investment/create_investment/create_investment_page.dart';
import 'package:flutter_founders/presentation/investment/create_investment/bloc/create_investment_bloc.dart';
import 'package:flutter_founders/presentation/posts/bloc/posts_bloc.dart';
import 'package:flutter_founders/presentation/posts/bloc/posts_event.dart';
import 'package:flutter_founders/presentation/shared_widgets/shared_app_bar.dart';

class HomeTabBarPage extends StatelessWidget {
  final ValueNotifier<int> tabIndexNotifier;

  const HomeTabBarPage({super.key, required this.tabIndexNotifier});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Builder(
        builder: (context) {
          final TabController tabController = DefaultTabController.of(context);

          tabController.addListener(() {
            if (!tabController.indexIsChanging) {
              tabIndexNotifier.value = tabController.index;
            }
          });

          return Column(
            children: [
              SharedAppBar(
                onCreatePressed: () async {
                  final tabIndex = tabIndexNotifier.value;
                  if (tabIndex == 0) {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const CreatePostPage()),
                    );
                    if (result == 'refresh') {
                      context.read<PostsBloc>().add(const LoadPostsEvent());
                    }
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BlocProvider(
                          create: (_) => CreateInvestmentBloc(  investmentApiService: InvestmentApiService(),
),
                          child: const CreateInvestmentPage(),
                        ),
                      ),
                    );
                  }
                },
              ),
              const TabBar(
                indicator: UnderlineTabIndicator(
                  borderSide: BorderSide(width: 2, color: Colors.white),
                  insets: EdgeInsets.symmetric(horizontal: 130),
                ),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.grey,
                labelStyle: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontFamily: 'InriaSans',
                ),
                tabs: [
                  Tab(text: 'Запросы'),
                  Tab(text: 'Инвестиции'),
                ],
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 32,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 79, 76, 76),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.search, color: Color(0xFFE7E2E2)),
                            SizedBox(width: 8),
                            Expanded(
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: 'Поиск',
                                  border: InputBorder.none,
                                  hintStyle: TextStyle(
                                    color: Color.fromARGB(255, 236, 229, 229),
                                  ),
                                ),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'InriaSans',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(
                        Icons.tune,
                        color: Color.fromARGB(255, 236, 229, 229),
                      ),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
              const Expanded(
                child: TabBarView(
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    Column(
                      children: [
                        SizedBox(height: 12), 
                        Expanded(child: PostsPage()),
                      ],
                    ),

                    Column(
                      children: [
                        SizedBox(height: 12), 
                        Expanded(child: InvestmentPage()),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
