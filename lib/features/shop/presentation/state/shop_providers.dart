import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/data_sources/card_remote_data_source.dart';
import '../../data/data_sources/cart_local_data_source.dart';
import '../../data/data_sources/product_local_data_source.dart';
import '../../data/repositories/card_repository_impl.dart';
import '../../data/repositories/cart_repository_impl.dart';
import '../../data/repositories/product_repository_impl.dart';
import '../../domain/repositories/card_repository.dart';
import '../../domain/repositories/cart_repository.dart';
import '../../domain/repositories/product_repository.dart';
import '../../domain/use_cases/add_to_cart_use_case.dart';
import '../../domain/use_cases/get_cards_use_case.dart';
import '../../domain/use_cases/get_products_use_case.dart';
import '../../domain/use_cases/update_cart_quantity_use_case.dart';
import 'shop_controller.dart';
import 'shop_state.dart';

// Data Sources
final productLocalDataSourceProvider = Provider<ProductLocalDataSource>(
  (ref) => ProductLocalDataSource(),
);

final cartLocalDataSourceProvider = Provider<CartLocalDataSource>(
  (ref) => CartLocalDataSource(),
);

final cardRemoteDataSourceProvider = Provider<CardRemoteDataSource>(
  (ref) => CardRemoteDataSource(),
);

// Repositories
final productRepositoryProvider = Provider<ProductRepository>(
  (ref) => ProductRepositoryImpl(
    localDataSource: ref.read(productLocalDataSourceProvider),
  ),
);

final cartRepositoryProvider = Provider<CartRepository>(
  (ref) => CartRepositoryImpl(
    localDataSource: ref.read(cartLocalDataSourceProvider),
  ),
);

final cardRepositoryProvider = Provider<CardRepository>(
  (ref) => CardRepositoryImpl(
    remoteDataSource: ref.read(cardRemoteDataSourceProvider),
  ),
);

// Use Cases
final getProductsUseCaseProvider = Provider<GetProductsUseCase>(
  (ref) => GetProductsUseCase(
    repository: ref.read(productRepositoryProvider),
  ),
);

final addToCartUseCaseProvider = Provider<AddToCartUseCase>(
  (ref) => AddToCartUseCase(
    repository: ref.read(cartRepositoryProvider),
  ),
);

final updateCartQuantityUseCaseProvider = Provider<UpdateCartQuantityUseCase>(
  (ref) => UpdateCartQuantityUseCase(
    repository: ref.read(cartRepositoryProvider),
  ),
);

final getCardsUseCaseProvider = Provider<GetCardsUseCase>(
  (ref) => GetCardsUseCase(
    repository: ref.read(cardRepositoryProvider),
  ),
);

// Controller
final shopControllerProvider =
    NotifierProvider<ShopController, ShopState>(ShopController.new);
