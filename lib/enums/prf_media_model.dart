enum PRFMediaModel {
  missionPhotos,
  missionFitChecks;

  String get collection {
    switch (this) {
      case PRFMediaModel.missionPhotos:
        return 'mission-photos';
      case PRFMediaModel.missionFitChecks:
        return 'mission-fit-checks';
    }
  }
}
