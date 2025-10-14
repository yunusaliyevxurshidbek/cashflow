import 'package:equatable/equatable.dart';

/// Base UseCase with optional Params
abstract class UseCase<Type, Params> {
  Future<Type> call(Params params);
}

/// No params marker
class NoParams extends Equatable {
  @override
  List<Object?> get props => [];
}

