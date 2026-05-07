import 'dart:io';
import '../api/disease_api_service.dart';

class DiseaseRepository {
  final DiseaseApiService api;

  DiseaseRepository(this.api);

  Future<List> detectDisease(File image) {
    return api.predictDisease(image);
  }
}