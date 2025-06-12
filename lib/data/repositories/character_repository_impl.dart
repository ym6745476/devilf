import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../../core/error/exceptions.dart';
import '../../core/network/network_info.dart';
import '../../domain/entities/character.dart';
import '../../domain/repositories/character_repository.dart';
import '../datasources/character_remote_datasource.dart';
import '../models/character_model.dart';

class CharacterRepositoryImpl implements CharacterRepository {
  final CharacterRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  CharacterRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, Character>> getCharacter(String id) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteCharacter = await remoteDataSource.getCharacter(id);
        return Right(remoteCharacter);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, List<Character>>> getAllCharacters() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteCharacters = await remoteDataSource.getAllCharacters();
        return Right(remoteCharacters);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, Character>> createCharacter(Character character) async {
    if (await networkInfo.isConnected) {
      try {
        final characterModel = CharacterModel(
          id: character.id,
          playerId: '', // This will be set by the server
          name: character.name,
          characterClass: character.characterClass,
          level: character.level,
          experience: character.experience,
          stats: {
            'health': character.health,
            'mana': character.mana,
            'attack': character.attributes['attack'] ?? 10,
            'defense': character.attributes['defense'] ?? 5,
            'speed': character.attributes['speed'] ?? 5,
          },
          equipment: character.equipment,
          skills: character.skills,
          position: character.position,
        );
        final newCharacter = await remoteDataSource.createCharacter(characterModel);
        return Right(newCharacter);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, Character>> updateCharacter(Character character) async {
    if (await networkInfo.isConnected) {
      try {
        final characterModel = CharacterModel(
          id: character.id,
          playerId: '', // This should be preserved from the original model
          name: character.name,
          characterClass: character.characterClass,
          level: character.level,
          experience: character.experience,
          stats: {
            'health': character.health,
            'mana': character.mana,
            'attack': character.attributes['attack'] ?? 10,
            'defense': character.attributes['defense'] ?? 5,
            'speed': character.attributes['speed'] ?? 5,
          },
          equipment: character.equipment,
          skills: character.skills,
          position: character.position,
        );
        final updatedCharacter = await remoteDataSource.updateCharacter(characterModel);
        return Right(updatedCharacter);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> deleteCharacter(String id) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.deleteCharacter(id);
        return Right(result);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, Character>> levelUp(String id) async {
    if (await networkInfo.isConnected) {
      try {
        final character = await remoteDataSource.getCharacter(id);
        // Server handles the level up logic
        final updatedCharacter = await remoteDataSource.updateCharacter(character);
        return Right(updatedCharacter);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, Character>> addExperience(String id, double amount) async {
    if (await networkInfo.isConnected) {
      try {
        final character = await remoteDataSource.getCharacter(id);
        final updatedCharacter = await remoteDataSource.updateCharacter(
          CharacterModel(
            id: character.id,
            playerId: '', // preserve or fetch as needed
            name: character.name,
            characterClass: character.characterClass,
            level: character.level,
            experience: character.experience + amount,
            stats: {
              'health': character.health,
              'mana': character.mana,
              'attack': character.attributes['attack'] ?? 10,
              'defense': character.attributes['defense'] ?? 5,
              'speed': character.attributes['speed'] ?? 5,
            },
            equipment: character.equipment,
            skills: character.skills,
            position: character.position,
          ),
        );
        return Right(updatedCharacter);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, Character>> equipItem(String characterId, String itemId) async {
    if (await networkInfo.isConnected) {
      try {
        final character = await remoteDataSource.getCharacter(characterId);
        // TODO: Implement equipment slot logic based on item type
        character.equipment['weapon'] = itemId;
        final updatedCharacter = await remoteDataSource.updateCharacter(character);
        return Right(updatedCharacter);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, Character>> unequipItem(String characterId, String itemId) async {
    if (await networkInfo.isConnected) {
      try {
        final character = await remoteDataSource.getCharacter(characterId);
        character.equipment.remove(itemId);
        final updatedCharacter = await remoteDataSource.updateCharacter(character);
        return Right(updatedCharacter);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }
}
