import 'package:decal/providers/products_provider.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';

List<String> imgList = [];
final List<Widget> imageSliders = imgList
    .map(
      (item) => Container(
        margin: const EdgeInsets.all(5.0),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(5.0)),
          child: Stack(
            children: <Widget>[
              Image.network(item, fit: BoxFit.contain, width: 1000.0),
              Positioned(
                bottom: 0.0,
                left: 0.0,
                right: 0.0,
                child: Container(
                  // color: Colors.amber,
                  decoration: const BoxDecoration(
                      // gradient: LinearGradient(
                      //   colors: [
                      //     Color.fromARGB(200, 0, 0, 0),
                      //     Color.fromARGB(0, 0, 0, 0)
                      //   ],
                      //   begin: Alignment.bottomCenter,
                      //   end: Alignment.topCenter,
                      // ),
                      ),
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 10.0),
                  // child: Text(
                  //   'No. ${imgList.indexOf(item)} image',
                  //   style: const TextStyle(
                  //     color: Colors.white,
                  //     fontSize: 20.0,
                  //     fontWeight: FontWeight.bold,
                  //   ),
                  // ),
                ),
              ),
            ],
          ),
        ),
      ),
    )
    .toList();

class ImageSlider extends StatefulWidget {
  const ImageSlider(this.id, {super.key});
  final String id;

  @override
  State<StatefulWidget> createState() {
    return _CarouselWithIndicatorState();
  }
}

class _CarouselWithIndicatorState extends State<ImageSlider> {
  int _current = 0;
  final CarouselController _controller = CarouselController();
  @override
  void initState() {
    final foundProduct =
        Provider.of<ProductProviderModel>(context, listen: false)
            .getProductById(widget.id);
    imgList = List<String>.from(foundProduct.images['reduced']!);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Expanded(
        child: CarouselSlider(
          items: imageSliders,
          carouselController: _controller,
          options: CarouselOptions(
              autoPlay: true,
              enlargeCenterPage: true,
              aspectRatio: 2.0,
              onPageChanged: (index, reason) {
                setState(() {
                  _current = index;
                });
              }),
        ),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: imgList.asMap().entries.map((entry) {
          return GestureDetector(
            onTap: () => _controller.animateToPage(entry.key),
            child: Container(
              width: 12.0,
              height: 12.0,
              margin:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: (Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black)
                      .withOpacity(_current == entry.key ? 0.9 : 0.4)),
            ),
          );
        }).toList(),
      ),
    ]);
  }
}
