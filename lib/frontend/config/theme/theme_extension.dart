//  // Custom theme extensions for app-specific styles
// class AppThemeExtensions extends ThemeExtension<AppThemeExtensions> {
//   final TextStyle priceStyle;
//   final BoxDecoration cardDecoration;

//   const AppThemeExtensions({
//     required this.priceStyle,
//     required this.cardDecoration,
//   });

//   @override
//   ThemeExtension<AppThemeExtensions> copyWith() => this;

//   @override
//   ThemeExtension<AppThemeExtensions> lerp(
//     covariant ThemeExtension<AppThemeExtensions>? other, 
//     double t
//   ) => this;
// }

// // Usage: Theme.of(context).extension<AppThemeExtensions>()!.priceStyle