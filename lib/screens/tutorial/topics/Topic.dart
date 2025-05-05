import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Topic extends StatefulWidget {
  const Topic({super.key, required this.images, required this.identifier});

  final int identifier;
  final List<String> images;

  @override
  State<Topic> createState() => _TopicState();
}

class _TopicState extends State<Topic> {
  final List<Resource> resources = [
    Resource(
      title: '1. Hopcroft–Karp Algorithm | Brilliant',
      url: 'https://brilliant.org/wiki/hopcroft-karp-algorithm/',
    ),
    Resource(
      title: '2. Understanding Hopcroft-Karp Algorithm for Maximum Matching | Punem Nithin',
      url: 'https://www.geeksforgeeks.org/hopcroft-karp-algorithm-for-maximum-matching-set-1-introduction/',
    ),
    Resource(
      title: "3. Kuhn's Algorithm for Maximum Bipartite Matching | CP Algorithms",
      url: 'https://cp-algorithms.com/graph/kuhn_maximum_bipartite_matching.html',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height * 0.5;

    return Scaffold(
      body: Column(
        children: [
          // Carrusel de imágenes
          SizedBox(
            height: height,
            width: double.infinity,
            child: PageView.builder(
              itemCount: widget.images.length,
              controller: PageController(viewportFraction: 1.0),
              itemBuilder: (context, index) {
                return Image.asset(
                  widget.images[index],
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: height,
                );
              },
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Resources',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: ListView.builder(
                      itemCount: resources.length,
                      itemBuilder: (context, index) {
                        final res = resources[index];
                        return InkWell(
                          onTap: () async {
                            final uri = Uri.parse(res.url);
                            if (await canLaunchUrl(uri)) {
                              await launchUrl(uri, mode: LaunchMode.externalApplication);
                              setState(() => res.visited = true);
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Text(
                              res.title,
                              style: TextStyle(
                                color: res.visited ? Colors.purple : Colors.blue,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Resource {
  final String title;
  final String url;
  bool visited;

  Resource({
    required this.title,
    required this.url,
    this.visited = false,
  });
}
