class AppConfig {
  const AppConfig._();

  static const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  static const supabasePublishableKey = String.fromEnvironment(
    'SUPABASE_PUBLISHABLE_KEY',
  );

  // Compatibilidade temporaria com o prototipo academico. Credenciais no
  // Flutter Web podem ser inspecionadas no navegador e nao sao adequadas para
  // producao. A autenticacao definitiva deve acontecer no backend.
  static const legacyAdminEmail = String.fromEnvironment('LEGACY_ADMIN_EMAIL');
  static const legacyAdminPassword = String.fromEnvironment(
    'LEGACY_ADMIN_PASSWORD',
  );

  static bool get hasSupabaseConfiguration =>
      supabaseUrl.isNotEmpty && supabasePublishableKey.isNotEmpty;

  static bool get hasLegacyAdminCredentials =>
      legacyAdminEmail.isNotEmpty && legacyAdminPassword.isNotEmpty;
}
