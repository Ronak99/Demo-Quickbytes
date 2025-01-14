import 'package:api_repository/api_repository.dart';
import 'package:cache_repository/cache_repository.dart';
import 'package:news_repository/src/exceptions/category_exceptions.dart';
import 'package:news_repository/src/exceptions/news_exceptions.dart';
import 'package:news_repository/src/models/models.dart';

class NewsRepository {
  late ApiRepository _apiRepository;
  late CacheRepository _cacheRepository;

  Future<void> init() async {
    _cacheRepository = CacheRepository.instance;
    await _cacheRepository.init();

    _apiRepository = ApiRepository.instance;
  }

  Future<List<Article>> queryAllArticles({
    List<String>? categoryIdList,
    String? cursorId,
    int? limit,
  }) async {
    try {
      List<dynamic> articleList = await _apiRepository.articles.queryArticles(
        categoryIdList: categoryIdList,
        cursorId: cursorId,
        limit: limit,
      );
      // _cacheRepository.articles.saveArticles(
      //   articleList.map((e) => e as Map<String, dynamic>).toList(),
      // );

      return articleList.map((e) => Article.fromJson(e)).toList();
    } catch (e) {
      if (e is ApiException) {
        //   List<dynamic> articleList =
        //       await _cacheRepository.articles.queryArticles();

        //   if (articleList.isEmpty) {
        //     throw const QueryArticleNewsException(
        //         message: "No articles found even in cache");
        //   }
        //   return articleList.map((e) => Article.fromJson(e)).toList();
        // } else if (e is QueryArticleCacheException) {
        throw QueryArticleNewsException(message: e.message);
      }
      throw const QueryArticleNewsException(
        message: "An unknown exception occurred!",
      );
    }
  }

  Future<List<NewsCategory>> queryAllCategories() async {
    try {
      List<dynamic> categoryList =
          await _apiRepository.categories.queryCategories();

      return categoryList.map((e) => NewsCategory.fromJson(e)).toList();
    } catch (e) {
      if (e is ApiException) {
        throw QueryNewsCategoryException(message: e.message);
      }
      return [];
    }
  }

  Future<List<NewsCategory>> queryUserCategories({
    required List<NewsCategory> allCategories,
  }) async {
    try {
      List<dynamic> categoryList =
          await _cacheRepository.categories.queryCategories();

      // new logic:
      List<NewsCategory> existingCategories =
          categoryList.map((e) => NewsCategory.fromJson(e)).toList();

      // look for new categories, if any
      List<NewsCategory> newCategories = allCategories
          .where(
            (category) => !existingCategories
                .any((existingCategory) => existingCategory.id == category.id),
          )
          .toList();

      // Create a list of NewsCategories from categoryList, which are not present in allCategories

      // Then loop over them to save them in cache repository was done by the old logic
      await _cacheRepository.categories.saveCategories(
        newCategories.map((e) => e.toJson()).toList(),
      );

      // return the existing and newly added category list instead of just category list
      return [...existingCategories, ...newCategories];
    } catch (e) {
      if (e is ApiException) {
        throw QueryNewsCategoryException(message: e.message);
      }
      return [];
    }
  }

  Future<void> saveCategories(List<NewsCategory> categoryList) async {
    try {
      _cacheRepository.categories.saveCategories(
        categoryList.map((e) => e.toJson()).toList(),
      );
    } catch (e) {
      throw SaveNewsCategoryException(message: e.toString());
    }
  }
}
