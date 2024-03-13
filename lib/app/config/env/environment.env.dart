class Environment {
  static const String backendPoint = String.fromEnvironment('backend_endpoint');
  static const String mixpanelToken = String.fromEnvironment('mixpanel_token');
  static const String supabaseUrl = String.fromEnvironment('supabase_url');
  static const String supabaseToken = String.fromEnvironment('supabase_token');
  static const String onesignalToken =
      String.fromEnvironment('onesignal_token');
}
