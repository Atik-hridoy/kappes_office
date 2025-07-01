import 'package:canuck_mall/app/constants/app_images.dart';

List<Trades> tradesList = [
  Trades(
    image: AppImages.trades1,
    name: "Fresh Painting",
    service: "Home Service",
    address: "Edmonton, Alberta, Canada",
    phone: "1-(780) 555-1234",
  ),
  Trades(
    image: AppImages.trades2,
    name: "Fresh Painting",
    service: "Home Service",
    address: "Edmonton, Alberta, Canada",
    phone: "1-(780) 555-1234",
  ),
  Trades(
    image: AppImages.trades3,
    name: "Fresh Painting",
    service: "Home Service",
    address: "Edmonton, Alberta, Canada",
    phone: "1-(780) 555-1234",
  ),
  Trades(
    image: AppImages.trades4,
    name: "Fresh Painting",
    service: "Home Service",
    address: "Edmonton, Alberta, Canada",
    phone: "1-(780) 555-1234",
  ),
  Trades(
    image: AppImages.trades5,
    name: "Fresh Painting",
    service: "Home Service",
    address: "Edmonton, Alberta, Canada",
    phone: "1-(780) 555-1234",
  ),
  Trades(
    image: AppImages.trades6,
    name: "Fresh Painting",
    service: "Home Service",
    address: "Edmonton, Alberta, Canada",
    phone: "1-(780) 555-1234",
  ),

];

class Trades {
  final String image;
  final String name;
  final String service;
  final String address;
  final String phone;

  Trades({
    required this.image,
    required this.name,
    required this.service,
    required this.address,
    required this.phone,
  });
}
