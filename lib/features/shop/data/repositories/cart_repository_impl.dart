import '../../domain/entities/cart_item.dart';
import '../../domain/repositories/cart_repository.dart';
import '../data_sources/cart_local_data_source.dart';

class CartRepositoryImpl implements CartRepository {
  const CartRepositoryImpl({required this.localDataSource});

  final CartLocalDataSource localDataSource;

  @override
  Future<List<CartItem>> getCartItems() => localDataSource.getItems();

  @override
  Future<void> addItem(CartItem item) => localDataSource.addItem(item);

  @override
  Future<void> updateItemQuantity(int index, int quantity) =>
      localDataSource.updateItemQuantity(index, quantity);

  @override
  Future<void> removeItem(int index) => localDataSource.removeItem(index);

  @override
  Future<void> clearCart() => localDataSource.clear();
}
