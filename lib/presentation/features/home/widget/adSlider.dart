import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:insta_food/core/theme/app_colors.dart';
import 'package:insta_food/presentation/features/home/widget/home_advertismentCard.dart';
import 'package:insta_food/presentation/features/items/data/model/item_model.dart';

class AdSlider extends StatefulWidget {
  final List<ItemModel> featuredItems;
  const AdSlider({super.key, required this.featuredItems});

  @override
  State<AdSlider> createState() => _AdSliderState();
}

class _AdSliderState extends State<AdSlider> {
  int _currentIndex = 0;
  final CarouselSliderController _carouselController =
      CarouselSliderController();
  @override
  Widget build(BuildContext context) {
    final List<Widget> featuredWidgets = (widget.featuredItems.map(
      (e) => AdvertismentCard(item: e),
    )).toList().cast<Widget>();
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CarouselSlider(
          carouselController: _carouselController,
          options: CarouselOptions(
            height: 128,
            viewportFraction: 1.0,
            autoPlay: true,
            autoPlayInterval: Duration(seconds: 10),
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
          items: featuredWidgets,
        ),
        SizedBox(height: 12),
        Row(
          //Indicator
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.featuredItems.asMap().entries.map((entry) {
            return GestureDetector(
              onTap: () => _carouselController.animateToPage(entry.key),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 300),
                width: _currentIndex == entry.key ? 24 : 16, //  Animated width
                height: 4,
                margin: EdgeInsets.symmetric(horizontal: 4.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  color: _currentIndex == entry.key
                      ? AppColors.primary
                      : AppColors.lightYellow,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
