import 'package:canuck_mall/app/constants/app_images.dart';

List<Product> productList = [
  Product(image: AppImages.product1, name: "Adventure Ready Backpack", price: "\$89.99"),
  Product(image: AppImages.banner3, name: "Hiking Traveler Backpack", price: "\$149.99"),
  Product(image: AppImages.product2, name: "Trailblazer Hiking Boots", price: "\$29.99"),
  Product(image: AppImages.product3, name: "Outdoor Explorer Hat", price: "\$89.99"),
  Product(image: AppImages.product4, name: "Hiking Expedition Jacket", price: "\$139.99"),
  Product(image: AppImages.product5, name: "Alpine Comfort Cashmere Vest", price: "\$139.99"),
  Product(image: AppImages.product6, name: "Adventure Ready Backpack", price: "\$89.99"),
];

class Product{
  final String image;
  final String name;
  final String price;

  Product({required this.image, required this.name, required this.price});
}