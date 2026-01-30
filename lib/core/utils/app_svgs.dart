import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum AppSvgs {
  menuSelected('menu_selected.svg'),
  menuUnselected('menu_unselected.svg'),
  book('book.svg'),
  check('check.svg'),
  coin('coin.svg'),
  courses('courses.svg'),
  correctAnswer('correct_answer.svg'),
  wrongAnswer('wrong_answer.svg'),
  share('share.svg');

  static const String _svgsPath = 'assets/svgs';
  final String _path;

  String get _fullPath => '$_svgsPath/$_path';

  const AppSvgs(this._path);

  SvgPicture svg({
    Key? key,
    double? width,
    double? height,
    BoxFit fit = BoxFit.none,
    Color? color,
  }) {
    return SvgPicture.asset(
      key: key,
      _fullPath,
      width: width,
      height: height,
      fit: fit,
      colorFilter: color != null
          ? ColorFilter.mode(color, BlendMode.srcIn)
          : null,
    );
  }
}
