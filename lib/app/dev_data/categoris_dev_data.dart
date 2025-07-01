import 'package:canuck_mall/app/constants/app_icons.dart';

List<Category> categories = [
  Category(image: AppIcons.category1, name: "Footwear"),
  Category(image: AppIcons.category2, name: "Food Products"),
  Category(image: AppIcons.category3, name: "Beauty Products"),
  Category(image: AppIcons.category4, name: "Self Care"),
  Category(image: AppIcons.category5, name: "Furniture"),
  Category(image: AppIcons.category6, name: "Electronics"),
  Category(image: AppIcons.category7, name: "Books & Media"),
  Category(image: AppIcons.category8, name: "Wellness"),
  Category(image: AppIcons.category9, name: "Toys & Games"),
  Category(image: AppIcons.category10, name: "Pet Supplies"),
  Category(image: AppIcons.category11, name: "Sports"),
  Category(image: AppIcons.category12, name: "Outdoors"),
  Category(image: AppIcons.category13, name: "Clothing"),
];

class Category{
  final String image;
  final String name;

  Category({required this.image, required this.name});
}