import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/ModelReview.dart';
import '../config/api.dart';

class ReviewService {
  static final ReviewService _instance = ReviewService._internal();
  factory ReviewService() => _instance;
  ReviewService._internal();

  // ================= GET ALL REVIEWS =================
  Future<List<Review>> fetchAllReviews() async {
    final url = ApiConfig.reviews; // ✅ GET /reviews
    print("GET ALL REVIEWS: $url");

    final response = await http.get(Uri.parse(url));

    print("STATUS: ${response.statusCode}");
    print("BODY: ${response.body}");

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => Review.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load reviews");
    }
  }

  // ================= GET REVIEWS BY PRODUCT =================
  Future<List<Review>> fetchReviewsByProductId(int productId) async {
    final url = "${ApiConfig.reviews}/$productId";
    print("GET REVIEWS BY PRODUCT ID: $url");

    final response = await http.get(Uri.parse(url));

    print("STATUS: ${response.statusCode}");
    print("BODY: ${response.body}");

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);

      // ✅ kalau backend kirim array langsung
      if (decoded is List) {
        return decoded.map((e) => Review.fromJson(e)).toList();
      }

      // ✅ kalau backend kirim { data: [...] }
      if (decoded is Map && decoded['data'] is List) {
        return (decoded['data'] as List)
            .map((e) => Review.fromJson(e))
            .toList();
      }

      // ❌ kalau bukan list
      throw Exception("Invalid review response format");
    } else {
      throw Exception("Failed to fetch reviews");
    }
  }

  // ================= ADD REVIEW =================
  Future<Review> addReview(int productId, String review, int rating) async {
    final url = "${ApiConfig.baseUrl}/review"; // ✅ POST /review
    print("POST ADD REVIEW: $url");

    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "product_id": productId,
        "review": review,
        "rating": rating,
      }),
    );

    print("STATUS: ${response.statusCode}");
    print("BODY: ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Review.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to add review");
    }
  }
}
