import 'package:cupizz_app/src/base/base.dart';

import 'post_page.controller.dart';

class PostPageModel extends MomentumModel<PostPageController> {
  PostPageModel(
    PostPageController controller, {
    this.posts,
    this.isLastPage,
    this.selectedCategory,
    this.currentPage,
    this.isMyPost = false,
    this.isIncognitoComment = true,
    this.isLoading = false,
    this.keyword,
  }) : super(controller);

  final List<Post>? posts;
  final bool? isLastPage;
  final PostCategory? selectedCategory;
  final int? currentPage;
  final String? keyword;
  final bool? isMyPost;
  final bool? isIncognitoComment;

  final bool isLoading;

  @override
  void update({
    List<Post>? posts,
    bool? isLastPage,
    PostCategory? selectedCategory,
    int? currentPage,
    bool? isMyPost,
    bool? isLoading,
    String? keyword,
    bool? isIncognitoComment,
  }) {
    PostPageModel(
      controller,
      posts: posts ?? this.posts,
      isLastPage: isLastPage ?? this.isLastPage,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      currentPage: currentPage ?? this.currentPage,
      isMyPost: isMyPost ?? this.isMyPost ?? false,
      isLoading: isLoading ?? this.isLoading,
      keyword: keyword ?? this.keyword,
      isIncognitoComment: isIncognitoComment ?? this.isIncognitoComment ?? true,
    ).updateMomentum();
  }

  @override
  MomentumModel<MomentumController> fromJson(Map<String, dynamic>? json) {
    return PostPageModel(
      controller,
      isLastPage: json!['isLastPage'] ?? false,
      posts: (json['posts'] as List?)
              ?.map((e) => Mapper.fromJson(e).toObject<Post>())
              .toList() ??
          [],
      selectedCategory: json['selectedCategory'] != null
          ? Mapper.fromJson(json['selectedCategory']).toObject<PostCategory>()
          : null,
      currentPage: json['currentPage'],
      isMyPost: json['isMyPost'],
      keyword: json['keyword'],
      isIncognitoComment: json['isIncognitoComment'],
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'posts': posts?.map((e) => e.toJson()).toList() ?? [],
        'isLastPage': isLastPage,
        'selectedCategory': selectedCategory?.toJson(),
        'currentPage': currentPage ?? 1,
        'isMyPost': isMyPost,
        'keyword': keyword,
        'isIncognitoComment': isIncognitoComment,
      };
}
