import '../entities/product.dart';
import '../repositories/product_repository.dart';

class GetProductByIdUseCase {
  const GetProductByIdUseCase({required this.repository});

  final ProductRepository repository;

  Future<Product> call(String id) async {
    return repository.getProductById(id);
  }
}
