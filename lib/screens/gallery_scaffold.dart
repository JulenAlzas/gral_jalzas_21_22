import 'package:flutter/material.dart';

typedef GalleryWidgetBuilder = Widget Function();

class GalleryScaffold extends StatefulWidget {
  final String title;
  final String subtitle;
  final GalleryWidgetBuilder childBuilder;

  const GalleryScaffold({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.childBuilder,
  }) : super(key: key);

  @override
  _GalleryScaffoldState createState() => _GalleryScaffoldState();
}

class _GalleryScaffoldState extends State<GalleryScaffold> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(children: <Widget>[
            SizedBox(
                height: screenSize.height * 0.3, child: widget.childBuilder()),
          ])),
    );
  }
}
