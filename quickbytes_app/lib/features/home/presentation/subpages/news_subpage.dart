import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:news_repository/news_repository.dart';
import 'package:quickbytes_app/core/widgets/cached_image.dart';
import 'package:quickbytes_app/features/news/state/news_bloc.dart';

class NewsSubpage extends StatelessWidget {
  const NewsSubpage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<NewsBloc, NewsState>(
        builder: (context, state) {
          if (state.articles.isEmpty) {
            return const Center(child: Text('You are all caught up!'));
          }

          return CardSwiper(
            cardsCount: state.articles.length,
            padding: EdgeInsets.zero,
            allowedSwipeDirection:
                const AllowedSwipeDirection.symmetric(vertical: true),
            onSwipe: (previousIndex, currentIndex, direction) {
              if (currentIndex != null) {
                // setState(() {
                //   _selectedNewsArticle = articleList[currentIndex];
                // });
              }

              return true;
            },
            cardBuilder: (context, index, percentThresholdX,
                    percentThresholdY) =>
                state.articles.map((e) => NewsCard(article: e)).toList()[index],
          );
        },
      ),
    );
  }
}
// class NewsSubpage extends StatefulWidget {
//   const NewsSubpage({super.key});

//   @override
//   State<NewsSubpage> createState() => _NewsSubpageState();
// }

// class _NewsSubpageState extends State<NewsSubpage> {
//   late NewsArticle _selectedNewsArticle;

//   @override
//   void initState() {
//     super.initState();
//     _selectedNewsArticle = articleList[0];
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           BlurView(
//             height: MediaQuery.of(context).size.height,
//             width: MediaQuery.of(context).size.width,
//             sigmaX: 2,
//             sigmaY: 2,
//             color: Colors.black54,
//             child: SizedBox(
//               child: CachedImage(
//                 _selectedNewsArticle.image,
//                 fit: BoxFit.cover,
//                 useOldImageOnUrlChange: true,
//                 placeholder: Container(
//                   decoration: const BoxDecoration(
//                     color: Color(0xff191818),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           CardSwiper(
//             cardsCount: articleList.length,
//             padding: EdgeInsets.zero,
//             allowedSwipeDirection:
//                 const AllowedSwipeDirection.symmetric(vertical: true),
//             onSwipe: (previousIndex, currentIndex, direction) {
//               if (currentIndex != null) {
//                 setState(() {
//                   _selectedNewsArticle = articleList[currentIndex];
//                 });
//               }

//               return true;
//             },
//             cardBuilder: (context, index, percentThresholdX,
//                     percentThresholdY) =>
//                 articleList.map((e) => NewsCard(article: e)).toList()[index],
//           ),
//         ],
//       ),
//     );
//   }
// }

class NewsCard extends StatelessWidget {
  final Article article;

  const NewsCard({
    Key? key,
    required this.article,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16),
      margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child: Column(
        children: [
          Expanded(
            flex: 2,
            child: Transform.translate(
              offset: const Offset(0, 15),
              child: Container(
                decoration: const BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white30,
                      offset: Offset.zero,
                      blurRadius: 2,
                      spreadRadius: 0,
                    )
                  ],
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                ),
                child: ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(16)),
                  child: CachedImage(
                    article.image,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: Container(
                      decoration: const BoxDecoration(
                        color: Color(0xff191818),
                      ),
                      child: const AdaptiveProgressIndicator(),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Flexible(
            flex: 3,
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xff191818),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white30,
                      width: .2,
                    ),
                  ),
                ),
                Opacity(
                  opacity: .05,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: const DecorationImage(
                        image:
                            AssetImage("assets/images/article_bg_pattern.png"),
                        repeat: ImageRepeat.repeat,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(22),
                  child: Column(
                    children: [
                      Text(
                        article.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 24,
                          color: Colors.white,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        article.content,
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.white70,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}