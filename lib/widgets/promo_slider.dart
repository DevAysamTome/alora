import 'package:flutter/material.dart';

class PromoSlider extends StatefulWidget {
  final List<String> images;

  const PromoSlider({Key? key, required this.images}) : super(key: key);

  @override
  State<PromoSlider> createState() => _PromoSliderState();
}

class _PromoSliderState extends State<PromoSlider> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Column(
        children: [
          // PageView لعرض الصور
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.images.length,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemBuilder: (context, index) {
                final imageUrl = widget.images[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
                );
              },
            ),
          ),
          // المؤشر (Dots Indicator)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(widget.images.length, (index) {
              final isActive = index == _currentPage;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                width: isActive ? 12 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: isActive ? Colors.blue : Colors.grey,
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
