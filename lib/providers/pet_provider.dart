import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/pet.dart';
import '../utils/constants.dart';

class PetProvider with ChangeNotifier {
  final Box<Pet> _petBox = Hive.box<Pet>(AppConstants.petBox);
  List<Pet> _pets = [];

  List<Pet> get pets => _pets;
  int get petCount => _pets.length;

  PetProvider() {
    loadPets();
  }

  void loadPets() {
    _pets = _petBox.values.toList();
    notifyListeners();
  }

  Future<void> addPet(Pet pet) async {
    await _petBox.put(pet.id, pet);
    loadPets();
  }

  Future<void> updatePet(Pet pet) async {
    await pet.save();
    loadPets();
  }

  Future<void> deletePet(String id) async {
    await _petBox.delete(id);
    loadPets();
  }

  Pet? getPetById(String id) {
    return _pets.firstWhere((pet) => pet.id == id);
  }
}