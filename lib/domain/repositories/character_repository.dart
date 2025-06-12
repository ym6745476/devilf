import 'package:dartz/dartz.dart';
import '../entities/character.dart';
import '../../core/error/failures.dart';

abstract class CharacterRepository {
  Future<Either<Failure, Character>> getCharacter(String id);
  Future<Either<Failure, List<Character>>> getAllCharacters();
  Future<Either<Failure, Character>> createCharacter(Character character);
  Future<Either<Failure, Character>> updateCharacter(Character character);
  Future<Either<Failure, bool>> deleteCharacter(String id);
  Future<Either<Failure, Character>> levelUp(String id);
  Future<Either<Failure, Character>> addExperience(String id, double amount);
  Future<Either<Failure, Character>> equipItem(String characterId, String itemId);
  Future<Either<Failure, Character>> unequipItem(String characterId, String itemId);
}
