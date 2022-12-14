import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_rick_and_morty_catalog/models/character_model.dart';
import 'package:flutter_rick_and_morty_catalog/services/repository.dart';
import 'package:equatable/equatable.dart';

part 'characters_event.dart';
part 'characters_state.dart';

class CharactersBloc extends Bloc<CharactersEvent, CharactersState> {
  final Repository repository;
  List<CharacterModel> characterList = [];
  bool isFetching = false;
  int page = 1;

  CharactersBloc({required this.repository}) : super(InitialState()) {
    on<LoadCharactersEvent>((event, emit) async {
      emit(LoadingState());
      isFetching = true;
      print('loading');

      try {
        characterList = await repository.getCharacters(page: page);
        isFetching = false;
        emit(SuccessState(characters: characterList));
        page++;
      } catch (e) {
        isFetching = false;
        emit(ErrorState(e.toString()));
      }
    });
  }
}
