import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../data_sources/product_remote_data_source.dart';
import '../models/product_model.dart';

class ProductRepositoryImpl implements ProductRepository {
  const ProductRepositoryImpl({required this.remoteDataSource});

  final ProductRemoteDataSource remoteDataSource;

  @override
  Future<List<Product>> getProducts() async {
    final models = await remoteDataSource.getProducts();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<Product> getProductById(String id) async {
    final model = await remoteDataSource.getProductById(id);
    return model.toEntity();
  }

  @override
  Future<Product> createProduct(Product product) async {
    final created =
        await remoteDataSource.addProduct(ProductModel.fromEntity(product));
    return created.toEntity();
  }

  @override
  Future<void> updateProduct(Product product) async {
    await remoteDataSource.upsertProduct(ProductModel.fromEntity(product));
  }

  @override
  Future<void> deleteProduct(String id) async {
    await remoteDataSource.deleteProduct(id);
  }
}
