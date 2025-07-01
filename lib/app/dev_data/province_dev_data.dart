import 'package:canuck_mall/app/constants/app_images.dart';

List<Province> provinceList = [
  Province(image: AppImages.britishColumbia, name: "British Columbia", totalProducts: "2000"),
  Province(image: AppImages.alberta, name: "Alberta", totalProducts: "2000"),
  Province(image: AppImages.saskatchewan, name: "Saskatchewan", totalProducts: "2000"),
  Province(image: AppImages.manitoba, name: "Manitoba", totalProducts: "2000"),
  Province(image: AppImages.ontario, name: "Ontario", totalProducts: "2000"),
  Province(image: AppImages.quebec, name: "Quebec", totalProducts: "2000"),
  Province(image: AppImages.newBrunswick, name: "New Brunswick", totalProducts: "2000"),
  Province(image: AppImages.novaScotia, name: "Nova Scotia", totalProducts: "2000"),
  Province(image: AppImages.princeEdwardIsland, name: "Prince Edward Island", totalProducts: "2000"),
  Province(image: AppImages.newfoundland, name: "Newfoundland and Labrador", totalProducts: "2000"),
];

class Province{
  final String image;
  final String name;
  final String totalProducts;

  Province({required this.image, required this.name, required this.totalProducts});
}