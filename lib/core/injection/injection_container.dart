import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import '../network/network_info.dart';
import '../network/websocket_client.dart';
import '../services/game_service.dart';
import '../../data/datasources/character_remote_datasource.dart';
import '../../data/repositories/character_repository_impl.dart';
import '../../domain/repositories/character_repository.dart';

final sl = GetIt.instance;

// Server configuration
const serverHost = String.fromEnvironment(
  'SERVER_HOST',
  defaultValue: 'localhost',
);
const serverPort = String.fromEnvironment(
  'SERVER_PORT',
  defaultValue: '3000',
);
const apiBaseUrl = 'http://$serverHost:$serverPort/api';
const wsBaseUrl = 'ws://$serverHost:$serverPort';

Future<void> init() async {
  // Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl());
  sl.registerLazySingleton(() => WebSocketClient(baseUrl: wsBaseUrl));

  // Repositories
  sl.registerLazySingleton<CharacterRepository>(
    () => CharacterRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<CharacterRemoteDataSource>(
    () => CharacterRemoteDataSourceImpl(
      client: sl(),
      baseUrl: apiBaseUrl,
    ),
  );

  // Services
  sl.registerLazySingleton(
    () => GameService(
      webSocket: sl(),
      characterRepository: sl(),
    ),
  );

  // External
  sl.registerLazySingleton(() => http.Client());
}
