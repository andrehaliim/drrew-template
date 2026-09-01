enum AppFlavor { dev, staging, prod }

class Env {
  Env._();

  static const flavorName = String.fromEnvironment('FLAVOR', defaultValue: 'dev');
  static const apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://gts-dev.infonetglobal.tech/api',
  );

  static AppFlavor get flavor {
    switch (flavorName) {
      case 'staging':
        return AppFlavor.staging;
      case 'prod':
        return AppFlavor.prod;
      default:
        return AppFlavor.dev;
    }
  }

  static bool get isDev => flavor == AppFlavor.dev;
  static bool get isStaging => flavor == AppFlavor.staging;
  static bool get isProd => flavor == AppFlavor.prod;
}