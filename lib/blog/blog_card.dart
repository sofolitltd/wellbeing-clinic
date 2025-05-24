import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wellbeingclinic/utils/date_time_formatter.dart';

import '../model/blog_model.dart';

class BlogCard extends StatelessWidget {
  const BlogCard({
    super.key,
    required this.blog,
    required this.id,
  });

  final BlogModel blog;
  final String id;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () {
        //
        Get.toNamed(
          '/blog/$id',
        );
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black12),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          spacing: 16,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  bottomLeft: Radius.circular(8),
                ),
                color: Colors.blue.shade50,
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(blog.image),
                ),
              ),
            ),

            //
            Expanded(
              child: Container(
                height: 200,
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 12,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      blog.title,
                      maxLines: 5,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            height: 1.5,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      DTFormatter.dateFormat(
                          blog.date), // Use a formatted date if necessary
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            color: Colors.blueGrey,
                          ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
