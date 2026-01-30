enum Flavor { dev, stag, prod }

class F {
  static late final Flavor appFlavor;

  static String get name => appFlavor.name;

  static String get title {
    switch (appFlavor) {
      case Flavor.dev:
        return 'Rcvry App Dev';
      case Flavor.stag:
        return 'Rcvry App Stag';
      case Flavor.prod:
        return 'Rcvry App';
    }
  }
}
