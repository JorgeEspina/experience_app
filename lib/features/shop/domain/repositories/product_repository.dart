import '../entities/product.dart';

abstract class ProductRepository {
  Future<List<Product>> getProducts();
  Future<Product> getProductById(String id);

  /// Creates a product with an auto-generated id. Returns the created product.
  Future<Product> createProduct(Product product);

  /// Updates an existing product (matched by its id).
  Future<void> updateProduct(Product product);

  /// Deletes a product by id.
  Future<void> deleteProduct(String id);
}
