import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../model/blog_model.dart';
import '../utils/set_tab_title.dart';
import 'blog_card.dart';

class BlogScreen extends StatelessWidget {
  const BlogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    setTabTitle('Blog', context);

    return Scaffold(
      // floatingActionButton:
      //     FirebaseAuth.instance.currentUser!.email! != "asifreyad1@gmail.com"
      //         ? null :
      //     FloatingActionButton(
      //             onPressed: () {
      //               Navigator.push(
      //                 context,
      //                 MaterialPageRoute(
      //                   builder: (_) => const AddBlog(),
      //                 ),
      //               );
      //             },
      //             child: const Icon(Icons.add),
      //           ),
      appBar: AppBar(
        title: Text('Blog'),
      ),
      body: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: 700),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Divider(height: .5, thickness: .5),
              //
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('blog')
                      // .orderBy('date', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Center(child: Text('Something wrong'));
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.data!.size == 0) {
                      return const Center(child: Text('No blog Found!'));
                    }

                    var data = snapshot.data!.docs;
                    return ListView.separated(
                      shrinkWrap: true,
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 16),
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        BlogModel blog = BlogModel.fromJson(
                            data[index].data() as Map<String, dynamic>);
                        return BlogCard(blog: blog, id: data[index].id);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
