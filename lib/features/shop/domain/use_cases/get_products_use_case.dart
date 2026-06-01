import '../entities/product.dart';
import '../repositories/product_repository.dart';

class GetProductsUseCase {
  const GetProductsUseCase({required this.repository});

  final ProductRepository repository;

  Future<List<Product>> call() async {
    return repository.getProducts();
  }
}
