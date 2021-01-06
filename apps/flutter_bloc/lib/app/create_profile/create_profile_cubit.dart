import 'package:core/models/profile/profile.dart';
import 'package:core/persistence/local_db.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/models/app_state/create_profile_state.dart';
import 'package:uuid/uuid.dart';

class CreateProfileCubit extends Cubit<CreateProfileState> {
  CreateProfileCubit({@required this.localDB})
      : super(const CreateProfileState.notSubmitted());
  final LocalDB localDB;

  Future<bool> createProfile(String name) async {
    if (name.isEmpty) {
      emit(const CreateProfileState.error('Name can\'t be empty'));
      return false;
    }
    final nameExists = await localDB.profileExistsWithName(name);
    if (nameExists) {
      emit(const CreateProfileState.error('Name already taken'));
      return false;
    }
    final id = Uuid().v1();
    emit(const CreateProfileState.loading());
    try {
      await localDB.createProfile(Profile(name: name, id: id));
      emit(const CreateProfileState.success());
    } catch (e) {
      emit(CreateProfileState.error(e.toString()));
    }
    return true;
  }
}