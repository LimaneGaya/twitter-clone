import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/apis/storage_api.dart';

class CarouselImage extends ConsumerStatefulWidget {
  final List<String> imageLinks;
  const CarouselImage({super.key, required this.imageLinks});

  @override
  ConsumerState<CarouselImage> createState() => _CarouselImageState();
}

class _CarouselImageState extends ConsumerState<CarouselImage> {
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
                    child: FutureBuilder(
                      future: ref.watch(storageAPIProvider).getImage(link),
                      builder: (context, snapshot) {
                        return snapshot.hasData && snapshot.data != null
                            ? Image.memory(
                                snapshot.data!,
                                fit: BoxFit.contain,
                              )
                            : const Center(
                                child: CircularProgressIndicator(),
                              );
                      },
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
