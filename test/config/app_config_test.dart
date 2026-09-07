import 'package:flutter_test/flutter_test.dart';
import 'package:rancho_paracatu_mobile/config/app_config.dart';

void main() {
  test('keeps external service configuration disabled by default', () {
    expect(AppConfig.supabaseUrl, isEmpty);
    expect(AppConfig.supabasePublishableKey, isEmpty);
    expect(AppConfig.hasSupabaseConfiguration, isFalse);
  });

  test('keeps legacy client-side admin access disabled by default', () {
    expect(AppConfig.legacyAdminEmail, isEmpty);
    expect(AppConfig.legacyAdminPassword, isEmpty);
    expect(AppConfig.hasLegacyAdminCredentials, isFalse);
  });
}
