import '../models/product_model.dart';

class ProductLocalDataSource {
  Future<List<ProductModel>> getProducts() async {
    // Simulates local/remote data fetch
    return _mockProductModels;
  }

  Future<ProductModel> getProductById(String id) async {
    return _mockProductModels.firstWhere((p) => p.id == id);
  }
}

final _mockProductModels = [
  const ProductModel(
    id: '1',
    name: 'Amazing T-Shirt',
    price: 12.00,
    description:
        'The perfect T-shirt for when you want to feel comfortable but still stylish. Amazing for all occasions. Made of 100% cotton fabric in four colours. Its modern style gives a lighter look to the outfit. Perfect for the warmest days.',
    sizes: ['XS', 'S', 'M', 'L', 'XL'],
    colorHexValues: [0xFF000000, 0xFF3D3D3D, 0xFF7EB6D9, 0xFFD9D9D9],
    imageUrl: 'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=400',
  ),
  const ProductModel(
    id: '2',
    name: 'Faboulous Pants',
    price: 15.00,
    description: 'Comfortable pants for everyday wear.',
    sizes: ['S', 'M', 'L', 'XL'],
    colorHexValues: [0xFF000000, 0xFF3D3D3D, 0xFF7EB6D9],
    imageUrl: 'https://images.unsplash.com/photo-1624378439575-d8705ad7ae80?w=400',
  ),
  const ProductModel(
    id: '3',
    name: 'Spectacular Dress',
    price: 20.00,
    description: 'A spectacular dress for special occasions.',
    sizes: ['XS', 'S', 'M', 'L'],
    colorHexValues: [0xFFD4AF37, 0xFF000000, 0xFF7EB6D9],
    imageUrl: 'https://images.unsplash.com/photo-1595777457583-95e059d581b8?w=400',
  ),
  const ProductModel(
    id: '4',
    name: 'Stunning Jacket',
    price: 18.00,
    description: 'A stunning jacket for cold days.',
    sizes: ['S', 'M', 'L', 'XL'],
    colorHexValues: [0xFF1E6EF2, 0xFF000000, 0xFF3D3D3D],
    imageUrl: 'https://images.unsplash.com/photo-1551028719-00167b16eac5?w=400',
  ),
  const ProductModel(
    id: '5',
    name: 'Wonderful Shoes',
    price: 18.00,
    description: 'Wonderful shoes for any occasion.',
    sizes: ['38', '39', '40', '41', '42'],
    colorHexValues: [0xFF2E7D32, 0xFF000000, 0xFF3D3D3D],
    imageUrl: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=400',
  ),
];
