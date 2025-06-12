import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  @override
  List<Object> get props => [];
}

class ServerFailure extends Failure {}

class CacheFailure extends Failure {}

class NetworkFailure extends Failure {}

class AuthenticationFailure extends Failure {}

class ValidationFailure extends Failure {
  final String message;

  ValidationFailure({required this.message});

  @override
  List<Object> get props => [message];
}

class CharacterNotFoundFailure extends Failure {}

class InventoryFullFailure extends Failure {}

class InsufficientLevelFailure extends Failure {}

class InsufficientResourcesFailure extends Failure {}

class EquipmentSlotOccupiedFailure extends Failure {}
