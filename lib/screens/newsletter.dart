import 'package:campuslink/models/article.dart';
import 'package:campuslink/services/network_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class NewsletterScreen extends StatefulWidget {
  const NewsletterScreen({super.key});

  @override
  State<NewsletterScreen> createState() => _NewsletterScreenState();
}

class _NewsletterScreenState extends State<NewsletterScreen> {
  late NetworkService networkService;
  List<Article> articles = [];

  @override
  void initState() {
    super.initState();
    networkService = NetworkService();
    //print(articles);
  }

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
              SliverAppBar(
                backgroundColor: Theme.of(context).colorScheme.primary,
                floating: true,
                snap: true,
                title: const Text(
                  'CampusLink',
                  style: TextStyle(
                      color: Color.fromARGB(255, 220, 238, 255),
                      fontSize: 28.0,
                      fontWeight: FontWeight.w700),
                ),
              )
            ],
        body: FutureBuilder(
            future: networkService.fetchArticles(),
            builder: (context, AsyncSnapshot<List<Article>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.connectionState == ConnectionState.done) {
                final articles = snapshot.data;
                print('THERE ARE ${articles?.length} ARTICLES');
                return ListView.builder(
                    itemCount: articles?.length,
                    itemBuilder: (context, index) {
                      final article = articles?[index];
                      print(article?.imageUrl);
                      return Container(
                        height: 120,
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 24.0),
                        child: Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Column(
                                  children: [
                                    // Row(
                                    //   children: article!.tags!
                                    //       .map((t) => tagButton(context, t))
                                    //       .toList(),
                                    // ),
                                    Text(
                                      article!.title,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineSmall,
                                      maxLines: 2,
                                      overflow: TextOverflow.fade,
                                    ),
                                    Row(
                                      textBaseline: TextBaseline.alphabetic,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.baseline,
                                      children: [
                                        Text(
                                            DateFormat('MM-dd-yyyy')
                                                .format(article.createdAt),
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelMedium),
                                        SizedBox(
                                          width: 20.0,
                                          child: Center(
                                            child: Text(
                                              '•',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelLarge,
                                            ),
                                          ),
                                        ),
                                        Text('4 Min',
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelMedium)
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Container(
                                    clipBehavior: Clip.antiAlias,
                                    decoration: BoxDecoration(
                                        color: const Color.fromARGB(
                                            255, 221, 221, 221),
                                        borderRadius:
                                            BorderRadius.circular(12.0)),
                                    child: Image.network(
                                      article.imageUrl,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return const Center(
                                            child: Icon(Icons.error));
                                      },
                                    )),
                              )
                            ],
                          ),
                        ),
                      );
                    });
              } else {
                return Text('ERROR');
              }
            }));
  }

  TextButton tagButton(BuildContext context, String text) {
    return TextButton(
      style: TextButton.styleFrom(
        minimumSize: Size.zero,
        padding: EdgeInsets.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ).copyWith(
          backgroundColor: WidgetStateProperty.all<Color>(
              const Color.fromARGB(255, 218, 218, 218))),
      onPressed: null,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
        child: Text(text, style: Theme.of(context).textTheme.labelMedium),
      ),
    );
  }
}
