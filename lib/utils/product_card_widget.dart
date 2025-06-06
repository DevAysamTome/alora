import 'package:flutter/material.dart';

/// A customizable card widget for displaying product information.
class ProductCard extends StatefulWidget {
  /// The unique identifier of the product.
  final String? id;

  /// The URL of the product image.
  final String imageUrl;

  /// A short description of the product.
  final String? shortDescription;

  /// The category name of the product.
  final String categoryName;

  /// The name of the product.
  final String productName;

  /// The price of the product.
  final double price;

  /// The currency symbol used for the price.
  final String currency;

  /// A callback function triggered when the card is tapped.
  final VoidCallback? onTap;

  /// A callback function triggered when the favorite button is pressed.
  final VoidCallback? onFavoritePressed;

  /// Indicates whether the product is available.
  final bool? isAvailable;

  /// The background color of the card.
  final Color cardColor;

  /// The text color used for labels and descriptions.
  final Color textColor;

  /// The border radius of the card.
  final double borderRadius;

  /// The rating of the product (optional).
  final double? rating;

  /// The discount percentage of the product (optional).
  final double? discountPercentage;

  /// The width of the card
  final double? width;

  /// The height of the card
  final double? height;
  final int? quantity;

  /// Creates a [ProductCard] widget.
  const ProductCard(
      {super.key,
      required this.imageUrl,
      required this.categoryName,
      required this.productName,
      required this.price,
      this.currency = '\₪',
      this.onTap,
      this.onFavoritePressed,
      this.shortDescription = '',
      this.id,
      this.isAvailable = true,
      this.cardColor = const Color(0xFFFFFFFF),
      this.textColor = const Color(0xFF000000),
      this.borderRadius = 12.0,
      this.rating,
      this.discountPercentage,
      this.width = 400,
      this.height = 400,
      this.quantity});

  @override
  ProductCardState createState() => ProductCardState();
}

class ProductCardState extends State<ProductCard> {
  bool _isAdded = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.onTap != null) {
          widget.onTap!();
        }
      },
      child: SizedBox(
        width: widget.width,
        height: widget.height,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius),
          ),
          elevation: 4,
          color: widget.cardColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product image and favorite button
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(widget.borderRadius),
                    child: Builder(
                      builder: (context) {
                        try {
                          return Image.network(
                            widget.imageUrl,
                            fit: BoxFit.cover,
                            height: 170,
                            width: double.infinity,
                          );
                        } catch (e) {
                          // Handle error
                          return const Center(
                            child: Text('Failed to load image'),
                          );
                        }
                      },
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(32),
                        onTap: () {
                          setState(() {
                            _isAdded = !_isAdded;
                          });
                          if (widget.onFavoritePressed != null) {
                            widget.onFavoritePressed!();
                          }
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: _isAdded
                                ? const Color.fromARGB(255, 245, 30, 15)
                                : Colors.black54,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            _isAdded
                                ? Icons.favorite_rounded
                                : Icons.favorite_border_rounded,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              // Product details
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.categoryName,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.productName.trim(),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: widget.textColor,
                      ),
                    ),
                    // Short description (if provided)
                    if (widget.shortDescription!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(
                          widget.shortDescription!,
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    // Product rating (if available)
                    if (widget.rating != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Row(
                          children: List.generate(
                            5,
                            (index) => Icon(
                              index < widget.rating!.round()
                                  ? Icons.star
                                  : Icons.star_border,
                              color: Colors.orange,
                              size: 16,
                            ),
                          ),
                        ),
                      ),
                    const SizedBox(height: 8),
                    // Product availability and price
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (widget.isAvailable!)
                          const Row(
                            children: [
                              Icon(
                                Icons.check_circle,
                                color: Colors.green,
                                size: 18,
                              ),
                              SizedBox(width: 4),
                              Text(
                                'متوفر',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                        if (!widget.isAvailable!)
                          const Row(
                            children: [
                              Icon(
                                Icons.do_disturb_alt_rounded,
                                color: Colors.red,
                                size: 18,
                              ),
                              SizedBox(width: 4),
                              Text(
                                'نفذت الكمية',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            // Product discount percentage (if available)
                            if (widget.discountPercentage != null)
                              Text(
                                '${widget.discountPercentage?.toStringAsFixed(0)}% OFF',
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            // Product price
                            Text(
                              '${widget.currency}${widget.price.toStringAsFixed(2)}',
                              style: TextStyle(
                                color: widget.textColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    if (widget.quantity != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          'الكمية: ${widget.quantity!.toStringAsFixed(0)}',
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            fontSize: 14,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
