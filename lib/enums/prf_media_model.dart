enum PRFMediaModel {
  missionPhotos('mission-photos'),
  missionVideos('mission-videos'),
  missionFitChecks('mission-fit-checks'),
  missionSessionAudios('session-audios'),
  missionSessionLiveRecordings('session-live-recordings'),
  eventPhotos('event-photos'),
  eventAudios('event-audios'),
  memberProfilePictures('profile-pictures'),
  allocationEntryReceipts('allocation-entry-receipts'),
  missionQuestions('question-answers'),
  ;

  const PRFMediaModel(this.collection);
  final String collection;
}
