import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:optimize/constants/active_constants.dart';
import 'package:optimize/providers/blog_provider.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

import 'blog_detail_screen.dart';

class BlogPageScreen extends StatefulWidget {
  const BlogPageScreen({Key? key}) : super(key: key);

  @override
  _BlogPageScreenState createState() => _BlogPageScreenState();
}

class _BlogPageScreenState extends State<BlogPageScreen> {
  bool _isInit = false;
  bool _isPreloading = false;
  int page = 1;

  void loadData() async {
    setState(() {
      _isPreloading = true;
    });

    await Provider.of<BlogProvider>(context, listen: false).getAll(page);

    setState(() {
      _isPreloading = false;
    });
  }

  @override
  void didChangeDependencies() {
    if (!_isInit) {
      loadData();
      _isInit = true;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Expanded(
            child: Consumer<BlogProvider>(builder: (context, blogState, child) {

          if(blogState.blogs.isEmpty ) return Container(child: const Center(child: CircularProgressIndicator(),),);
          return ListView.builder(
            itemCount: blogState.blogs.length,
            itemBuilder: (context, index) {
              if (blogState.isExisted && index == blogState.blogs.length - 1) {
                return Column(
                  children: [
                    _isPreloading
                        ? const CircularProgressIndicator()
                        : Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: FlatButton(
                              child: const Text(
                                "Load More",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                              color: activeColors.primary,
                              onPressed: () {
                                setState(() {
                                  page += 1;
                                });
                                loadData();
                              },
                            ),
                          ),
                  ],
                );
              } else {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      const SizedBox(height: 20.0),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BlogDetailScreen(
                                  blog: blogState.blogs[index]),
                            ),
                          );
                        },
                        child: Card(
                          child: Container(
                            child: Column(
                              children: [
                                FadeInImage.memoryNetwork(
                                    placeholder: kTransparentImage,
                                    image: blogState.blogs[index].image),
                                Html(data: blogState.blogs[index].title),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      Divider(
                        height: 2.0,
                        thickness: 1.0,
                        color: activeColors.grey,
                      ),
                    ],
                  ),
                );
              }
            },
          );
        })),
      ],
    ));
  }
}
