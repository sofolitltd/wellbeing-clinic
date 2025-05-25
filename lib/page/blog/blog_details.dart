import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/model/blog_model.dart';
import '/utils/date_time_formatter.dart';
import '/utils/set_tab_title.dart';

class BlogDetails extends StatefulWidget {
  const BlogDetails({super.key});

  @override
  _BlogDetailsState createState() => _BlogDetailsState();
}

class _BlogDetailsState extends State<BlogDetails> {
  late Future<BlogModel> _blogFuture;

  @override
  void initState() {
    super.initState();
    final String id = Get.parameters['id'] ?? '';
    _blogFuture = fetchBlogDetailsById(id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wellbeing Clinic'),
      ),
      body: SelectionArea(
        child: Center(
          child: Container(
            constraints: BoxConstraints(maxWidth: 700),
            child: FutureBuilder<BlogModel>(
              future: _blogFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else if (!snapshot.hasData) {
                  return const Center(child: Text('Blog not found.'));
                }

                final blog = snapshot.data!;
                setTabTitle(blog.title, context);

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.network(
                        blog.image,
                        height: 500,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        blog.title,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        DTFormatter.dateFormat(blog.date),
                        style:
                            Theme.of(context).textTheme.titleMedium!.copyWith(
                                  color: Colors.blueGrey,
                                ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        blog.content,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

Future<BlogModel> fetchBlogDetailsById(String id) async {
  try {
    // Retrieve the document by its ID
    final documentSnapshot =
        await FirebaseFirestore.instance.collection('blog').doc(id).get();

    if (documentSnapshot.exists) {
      // Parse the document into a BlogModel
      return BlogModel.fromJson(documentSnapshot.data()!);
    } else {
      throw Exception('No blog found for ID: $id');
    }
  } catch (e) {
    throw Exception('Error fetching blog details: $e');
  }
}
