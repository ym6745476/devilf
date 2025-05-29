import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/character_model.dart';
import '../../core/error/exceptions.dart';

abstract class CharacterRemoteDataSource {
  Future<CharacterModel> getCharacter(String id);
  Future<List<CharacterModel>> getAllCharacters();
  Future<CharacterModel> createCharacter(CharacterModel character);
  Future<CharacterModel> updateCharacter(CharacterModel character);
  Future<bool> deleteCharacter(String id);
}

class CharacterRemoteDataSourceImpl implements CharacterRemoteDataSource {
  final http.Client client;
  final String baseUrl;

  CharacterRemoteDataSourceImpl({
    required this.client,
    required this.baseUrl,
  });

  @override
  Future<CharacterModel> getCharacter(String id) async {
    final response = await client.get(
      Uri.parse('$baseUrl/characters/$id'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return CharacterModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<CharacterModel>> getAllCharacters() async {
    final response = await client.get(
      Uri.parse('$baseUrl/characters'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => CharacterModel.fromJson(json)).toList();
    } else {
      throw ServerException();
    }
  }

  @override
  Future<CharacterModel> createCharacter(CharacterModel character) async {
    final response = await client.post(
      Uri.parse('$baseUrl/characters'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(character.toJson()),
    );

    if (response.statusCode == 201) {
      return CharacterModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }

  @override
  Future<CharacterModel> updateCharacter(CharacterModel character) async {
    final response = await client.put(
      Uri.parse('$baseUrl/characters/${character.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(character.toJson()),
    );

    if (response.statusCode == 200) {
      return CharacterModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }

  @override
  Future<bool> deleteCharacter(String id) async {
    final response = await client.delete(
      Uri.parse('$baseUrl/characters/$id'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw ServerException();
    }
  }
}
