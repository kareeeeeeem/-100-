enum Flavor { dev, stag, prod }

class F {
  static late final Flavor appFlavor;

  static String get name => appFlavor.name;

  static String get title {
    switch (appFlavor) {
      case Flavor.dev:
        return 'منصة 100 للقدرات';
      case Flavor.stag:
        return 'منصة 100 للقدرات';
      case Flavor.prod:
        return 'منصه 100 للقدرات';
    }
  }
}
