import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/product_model.dart';

/// Remote data source for the product catalog, backed by Cloud Firestore.
///
/// Products live in the `products` collection. Each document id matches the
/// product's [ProductModel.id].
class ProductRemoteDataSource {
  ProductRemoteDataSource({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  static const String _collection = 'products';

  CollectionReference<Map<String, dynamic>> get _products =>
      _firestore.collection(_collection);

  Future<List<ProductModel>> getProducts() async {
    final snapshot = await _products.get();
    return snapshot.docs
        .map((doc) => ProductModel.fromJson({...doc.data(), 'id': doc.id}))
        .toList();
  }

  Future<ProductModel> getProductById(String id) async {
    final doc = await _products.doc(id).get();
    final data = doc.data();
    if (!doc.exists || data == null) {
      throw Exception('Product not found: $id');
    }
    return ProductModel.fromJson({...data, 'id': doc.id});
  }

  /// Creates or overwrites a single product document.
  /// Used later by the "add product" screen.
  Future<void> upsertProduct(ProductModel product) async {
    await _products.doc(product.id).set(product.toJson());
  }

  /// Adds a new product with an auto-generated document id and returns it.
  Future<ProductModel> addProduct(ProductModel product) async {
    final docRef = _products.doc();
    final withId = ProductModel(
      id: docRef.id,
      name: product.name,
      price: product.price,
      description: product.description,
      sizes: product.sizes,
      colorHexValues: product.colorHexValues,
      imageUrl: product.imageUrl,
    );
    await docRef.set(withId.toJson());
    return withId;
  }

  /// Uploads a list of products in a single batch. The document id is the
  /// product id, so running it again just overwrites (idempotent seed).
  Future<void> seedProducts(List<ProductModel> products) async {
    final batch = _firestore.batch();
    for (final product in products) {
      batch.set(_products.doc(product.id), product.toJson());
    }
    await batch.commit();
  }

  /// Deletes a product document by id.
  Future<void> deleteProduct(String id) async {
    await _products.doc(id).delete();
  }

  /// Returns true if the catalog already has at least one product.
  Future<bool> hasProducts() async {
    final snapshot = await _products.limit(1).get();
    return snapshot.docs.isNotEmpty;
  }
}
