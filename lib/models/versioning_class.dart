class Versioning {
  final String latestVersion;
  final String minVersion;
  Versioning({
    this.latestVersion,
    this.minVersion,
  });

  static const version = '1.0.0';

  factory Versioning.fromJson(Map data) {
    final Versioning defaultValues = Versioning();
    data = data ?? {};
    return Versioning(
      latestVersion: data['latestVersion'] ?? defaultValues.latestVersion,
      minVersion: data['minVersion'] ?? defaultValues.minVersion,
    );
  }
}
