class SvgAssets {
  static String get logoCircularFilled => 'logo_circular_filled'.svg;

  static String get logoCircularOutlined => 'logo_circular_outlined'.svg;

  static String get logoRectangularFilled => 'logo_rectangular_filled'.svg;

  static String get logoText => 'logo_text'.svg;

  const SvgAssets._();
}

// 默认扩展名
// 可以通过扩展名来指定图片的类型
extension on String {
  String get svg => 'assets/svgs/$this.svg';
}
