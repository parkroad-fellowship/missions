enum PRFMediaModel {
  missionPhotos,
  missionFitChecks,
  missionSessionAudios;

  String get collection {
    switch (this) {
      case PRFMediaModel.missionPhotos:
        return 'mission-photos';
      case PRFMediaModel.missionFitChecks:
        return 'mission-fit-checks';
        case PRFMediaModel.missionSessionAudios:
        return 'session-audios';
    }
  }
}
