import 'package:flutter/foundation.dart';

import '../../../core/services/product_api_service.dart';
import '../models/product.dart';

class ProductViewModel extends ChangeNotifier {
  ProductViewModel(this._apiService);

  final ProductApiService _apiService;

  List<Product> _products = [];
  String _query = '';
  bool _isLoading = false;

  List<Product> get products {
    if (_query.trim().isEmpty) return _products;
    final lower = _query.toLowerCase();
    return _products.where((product) {
      return product.title.toLowerCase().contains(lower) ||
          product.category.toLowerCase().contains(lower);
    }).toList();
  }

  bool get isLoading => _isLoading;
  String get query => _query;

  Future<void> loadProducts() async {
    _isLoading = true;
    notifyListeners();
    _products = await _apiService.fetchProducts();
    _isLoading = false;
    notifyListeners();
  }

  void search(String value) {
    _query = value;
    notifyListeners();
  }
}
