import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/model/blog_model.dart';
import '/utils/date_time_formatter.dart';

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
      borderRadius: BorderRadius.circular(12),
      onTap: () => Get.toNamed('/blog/$id'),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isNarrow = constraints.maxWidth < 400;

            // For mobile/smaller width: reduce image width and allow text to expand more
            final imageWidth = isNarrow ? 100.0 : 180.0;
            final imageHeight = 180.0;

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: imageWidth,
                  height: imageHeight,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      bottomLeft: Radius.circular(12),
                    ),
                    color: Colors.blue.shade50,
                    image: DecorationImage(
                      image: NetworkImage(blog.image),
                      fit: BoxFit.cover,
                      onError: (_, __) {},
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: imageHeight,
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          blog.title,
                          maxLines: 5,
                          overflow: TextOverflow.ellipsis,
                          style:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    height: 1.3,
                                  ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          DTFormatter.dateFormat(blog.date),
                          style:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    color: Colors.blueGrey,
                                  ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
