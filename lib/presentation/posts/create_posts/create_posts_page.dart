import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_founders/data/api/create_post_api_service.dart';
import 'package:flutter_founders/presentation/posts/create_posts/bloc/create_posts_bloc.dart';
import 'package:flutter_founders/presentation/posts/create_posts/bloc/create_posts_state.dart';
import 'package:flutter_founders/presentation/posts/create_posts/widgets/description_field.dart';
import 'package:flutter_founders/presentation/posts/create_posts/widgets/submit_button.dart';
import 'package:flutter_founders/presentation/posts/create_posts/widgets/tag_selector.dart';
import 'package:flutter_founders/presentation/posts/create_posts/widgets/title_field.dart';
import 'package:flutter_founders/presentation/posts/create_posts/widgets/additional_field.dart';
import 'package:flutter_founders/presentation/posts/bloc/posts_bloc.dart';
import 'package:flutter_founders/presentation/posts/bloc/posts_event.dart';

class CreatePostPage extends StatelessWidget {
  const CreatePostPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CreatePostBloc(apiService: CreatePostApiService()),
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'Создать запрос',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontFamily: 'InriaSans',
            ),
          ),
        ),
        body: BlocListener<CreatePostBloc, CreatePostState>(
          listener: (context, state) {
            if (state.isSuccess) {
              // ✅ عرض رسالة نجاح
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Пост успешно создан ✅"), // ← بالروسي
                ),
              );

              // ✅ إعادة تحميل البوستات
              context.read<PostsBloc>().add(const LoadPostsEvent());

              // ✅ الرجوع تلقائيًا
              Navigator.pop(context);
            }

            if (state.isFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Не удалось создать пост ❌"), // ← بالروسي
                ),
              );
            }
          },
          child: const SafeArea(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TitleField(),
                    SizedBox(height: 20),
                    DescriptionField(),
                    SizedBox(height: 20),
                    TagSelector(availableTags: []),
                    SizedBox(height: 20),
                    AdditionalField(),
                    SizedBox(height: 32),
                    SubmitButton(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
