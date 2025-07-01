import 'package:canuck_mall/app/constants/app_images.dart';

List<Store> storeInfo = [
  Store(
    shopLogo: AppImages.shopLogo,
    shopCover: AppImages.coverImage,
    shopName: "Peak",
    address: "Victoria British Columbia",
  ),
  Store(
    shopLogo: AppImages.shopLogo2,
    shopCover: AppImages.cover2,
    shopName: "Runner Room",
    address: "Toronto , Ontario",
  ),
  Store(
    shopLogo: AppImages.shopLogo3,
    shopCover: AppImages.cover3,
    shopName: "Pawlove - Pet Supplies",
    address: "Thunder Bay, Ontario",
  ),
  Store(
    shopLogo: AppImages.shopLogo4,
    shopCover: AppImages.cover4,
    shopName: "Home Decor Den",
    address: "Edmonton, Alberta",
  ),
];

class Store {
  final String shopLogo;
  final String shopCover;
  final String shopName;
  final String address;

  Store({
    required this.shopLogo,
    required this.shopCover,
    required this.shopName,
    required this.address,
  });
}
