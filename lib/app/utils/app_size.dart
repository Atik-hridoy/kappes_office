abstract class AppSize {
  static late double screenHeight;
  static late double screenWidth;

  static double height({required num height}) {
    return screenHeight * (height / 100);
  }

  static double width({required num width}) {
    return screenWidth * (width / 100);
  }
}
