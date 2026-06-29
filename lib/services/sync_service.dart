import '../database/app_database.dart';
import 'supabase_service.dart';

class SyncService {
  final AppDatabase database;

  SyncService(this.database);

  final supabase = SupabaseService.instance.client;
}