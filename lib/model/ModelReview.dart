class Review {
  final int id;
  final int productId;
  final String review;
  final int rating;

  Review({
    required this.id,
    required this.productId,
    required this.review,
    required this.rating,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'] as int? ?? 0,
      productId: json['product_id'] as int? ?? 0,
      review: json['review'] as String? ?? '',
      rating: json['rating'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'review': review,
      'rating': rating,
    };
  }
}
