import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:twitter_clone/constants/constants.dart';

class CarouselImage extends StatefulWidget {
  final List<String> imageLinks;
  const CarouselImage({super.key, required this.imageLinks});

  @override
  State<CarouselImage> createState() => _CarouselImageState();
}

class _CarouselImageState extends State<CarouselImage> {
  int _currIdx = 0;
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Column(
          children: [
            CarouselSlider(
              items: widget.imageLinks.map(
                (link) {
                  return Container(
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(25)),
                    margin: const EdgeInsets.all(10),
                    child: Image.network(
                      AppwriteConstants.imageUrl(link),
                      fit: BoxFit.contain,
                    ),
                  );
                },
              ).toList(),
              options: CarouselOptions(
                onPageChanged: (index, reason) => setState(
                  () {
                    _currIdx = index;
                  },
                ),
                viewportFraction: 1,
                height: 400,
                enableInfiniteScroll: false,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: widget.imageLinks
                  .asMap()
                  .entries
                  .map(
                    (e) => Container(
                      width: 4,
                      height: 4,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(
                          _currIdx == e.key ? 0.9 : 0.4,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        )
      ],
    );
  }
}
