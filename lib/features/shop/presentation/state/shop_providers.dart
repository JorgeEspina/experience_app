import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/data_sources/card_remote_data_source.dart';
import '../../data/data_sources/cart_local_data_source.dart';
import '../../data/data_sources/payment_remote_data_source.dart';
import '../../data/data_sources/order_remote_data_source.dart';
import '../../data/data_sources/product_remote_data_source.dart';
import '../../data/repositories/card_repository_impl.dart';
import '../../data/repositories/order_repository_impl.dart';
import '../../domain/repositories/order_repository.dart';
import '../../data/repositories/cart_repository_impl.dart';
import '../../data/repositories/payment_repository_impl.dart';
import '../../data/repositories/product_repository_impl.dart';
import '../../domain/repositories/card_repository.dart';
import '../../domain/repositories/cart_repository.dart';
import '../../domain/repositories/payment_repository.dart';
import '../../domain/repositories/product_repository.dart';
import '../../domain/use_cases/add_to_cart_use_case.dart';
import '../../domain/use_cases/get_cards_use_case.dart';
import '../../domain/use_cases/get_products_use_case.dart';
import '../../domain/use_cases/process_payment_use_case.dart';
import '../../domain/use_cases/update_cart_quantity_use_case.dart';
import 'shop_controller.dart';
import 'shop_state.dart';

// Data Sources
final productRemoteDataSourceProvider = Provider<ProductRemoteDataSource>(
  (ref) => ProductRemoteDataSource(),
);

final orderRemoteDataSourceProvider = Provider<OrderRemoteDataSource>(
  (ref) => OrderRemoteDataSource(),
);

final cartLocalDataSourceProvider = Provider<CartLocalDataSource>(
  (ref) => CartLocalDataSource(),
);

final cardRemoteDataSourceProvider = Provider<CardRemoteDataSource>(
  (ref) => CardRemoteDataSource(),
);

final paymentRemoteDataSourceProvider = Provider<PaymentRemoteDataSource>(
  (ref) => PaymentRemoteDataSource(),
);

// Repositories
final productRepositoryProvider = Provider<ProductRepository>(
  (ref) => ProductRepositoryImpl(
    remoteDataSource: ref.read(productRemoteDataSourceProvider),
  ),
);

final cartRepositoryProvider = Provider<CartRepository>(
  (ref) => CartRepositoryImpl(
    localDataSource: ref.read(cartLocalDataSourceProvider),
  ),
);

final orderRepositoryProvider = Provider<OrderRepository>(
  (ref) => OrderRepositoryImpl(
    remoteDataSource: ref.read(orderRemoteDataSourceProvider),
  ),
);

final cardRepositoryProvider = Provider<CardRepository>(
  (ref) => CardRepositoryImpl(
    remoteDataSource: ref.read(cardRemoteDataSourceProvider),
  ),
);

final paymentRepositoryProvider = Provider<PaymentRepository>(
  (ref) => PaymentRepositoryImpl(
    remoteDataSource: ref.read(paymentRemoteDataSourceProvider),
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

final processPaymentUseCaseProvider = Provider<ProcessPaymentUseCase>(
  (ref) => ProcessPaymentUseCase(
    repository: ref.read(paymentRepositoryProvider),
  ),
);

// Controller
final shopControllerProvider =
    NotifierProvider<ShopController, ShopState>(ShopController.new);
