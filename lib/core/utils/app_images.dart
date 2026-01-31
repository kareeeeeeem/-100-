import 'package:flutter/material.dart';

enum AppImages {
  splashLogo('splash_logo.png'),
  logo('logo.png'),
  google('google.png'),
  facebook('facebook.png'),
  live('live.jpg'),
  courseVideoThumbnail('course_video_thumbnail.png'),
  masterCard('master_card.png'),
  cashBack('cash_back.png'),
  blackWhite('black_white.png'),
  parentSectionItem('parent_section_item.png'),
  paymob('paymob.png');

  static const String _imagesPath = 'assets/images';
  final String _path;

  String get fullPath => '$_imagesPath/$_path';

  const AppImages(this._path);

  Image image({Key? key, double? width, double? height, BoxFit? fit, Color? color, BlendMode? colorBlendMode}) {
    return Image.asset(
      key: key,
      fullPath,
      width: width,
      height: height,
      fit: fit,
      color: color,
      colorBlendMode: colorBlendMode,
    );
  }
}
