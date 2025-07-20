import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_founders/models/post_model.dart';
import 'bloc/posts_bloc.dart';
import 'bloc/posts_event.dart';
import 'bloc/posts_state.dart';
import 'widgets/posts_card.dart';
import 'posts_details/post_details_page.dart';

class PostsPage extends StatefulWidget {
  const PostsPage({super.key});

  @override
  State<PostsPage> createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage> {
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<PostsBloc>().add(const LoadPostsEvent());
    scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 300) {
      context.read<PostsBloc>().add(const LoadMorePostsEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostsBloc, PostsState>(
      builder: (context, state) {
        print('🎯 Posts in state: ${state.posts.length}');

        if (state.isLoading && state.posts.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.white),
          );
        }

        if (state.posts.isEmpty) {
          return const Center(
            child: Text(
              'No posts available',
              style: TextStyle(color: Colors.white, fontFamily: 'InriaSans'),
            ),
          );
        }

        return ListView.separated(
          controller: scrollController,
          padding: const EdgeInsets.fromLTRB(16, 6, 16, 20),
          itemCount: state.posts.length + (state.hasMore ? 1 : 0),
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            if (index >= state.posts.length) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              );
            }

            final PostModel post = state.posts[index];
            return PostCard(
              post: post,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PostDetailsPage(post: post),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
