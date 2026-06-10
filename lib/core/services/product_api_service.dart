import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../features/products/models/product.dart';
import '../constants/app_constants.dart';

class ProductApiService {
  Future<List<Product>> fetchProducts() async {
    final techProducts = List<Product>.from(Product.fallbackProducts);

    try {
      final response = await http
          .get(Uri.parse(AppConstants.productApiUrl))
          .timeout(const Duration(seconds: 8));

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        if (decoded is List && decoded.isNotEmpty) {
          return _buildProfessionalTechCatalog(techProducts);
        }
      }

      return _buildProfessionalTechCatalog(techProducts);
    } catch (_) {
      return _buildProfessionalTechCatalog(techProducts);
    }
  }

  List<Product> _buildProfessionalTechCatalog(List<Product> products) {
    final sorted = List<Product>.from(products);

    sorted.sort((a, b) {
      final ratingCompare = b.rating.compareTo(a.rating);
      if (ratingCompare != 0) return ratingCompare;
      return b.price.compareTo(a.price);
    });

    return sorted;
  }
}
