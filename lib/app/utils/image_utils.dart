class ImageUtils {
  /// Returns a placeholder image URL with the specified dimensions
  static String placeholderImageUrl({
    int width = 300,
    int height = 300,
    bool grayscale = true,
  }) {
    return 'https://picsum.photos/$width/$height${grayscale ? '?grayscale' : ''}';
  }

  /// Returns a placeholder image URL for products
  static String get productPlaceholder => placeholderImageUrl(width: 300, height: 300);
  
  /// Returns a placeholder image URL for shop logos
  static String get shopLogoPlaceholder => placeholderImageUrl(width: 80, height: 80);
  
  /// Returns a placeholder image URL for shop covers
  static String get shopCoverPlaceholder => placeholderImageUrl(width: 300, height: 120);
  
  /// Returns a placeholder image URL for shop icons
  static String get shopIconPlaceholder => placeholderImageUrl(width: 40, height: 40);

  /// Returns a placeholder image URL for user avatars
  static String get userAvatarPlaceholder => placeholderImageUrl(width: 100, height: 100);
}
