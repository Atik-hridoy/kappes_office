import 'package:canuck_mall/app/constants/app_images.dart';

List<Territory> territoryList = [
  Territory(image: AppImages.yukon, name: "Yukon", totalProducts: "2000"),
  Territory(image: AppImages.northwestTerritories, name: "Northwest Territories", totalProducts: "2000"),
  Territory(image: AppImages.nunavut, name: "Nunavut", totalProducts: "2000"),
];

class Territory{
  final String image;
  final String name;
  final String totalProducts;

  Territory({required this.image, required this.name, required this.totalProducts});
}