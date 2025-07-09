// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get enterEmail => 'Enter Email';

  @override
  String get enterPassword => 'Enter Password';

  @override
  String get signIn => 'Sign In';

  @override
  String get signingIn => 'Signing In ...';

  @override
  String get missions => 'Missions';

  @override
  String get myAccount => 'My Account';

  @override
  String get signOut => 'Sign Out';

  @override
  String get myProfile => 'My Profile';

  @override
  String get name => 'Name';

  @override
  String get enterName => 'Enter Name';

  @override
  String get email => 'Email';

  @override
  String get viewProfile => 'View Profile';

  @override
  String get viewProfileDetails => 'Your name and email address';

  @override
  String get byUsing => 'By using this app, you are agreeing to our\n';

  @override
  String get terms => ' Terms';

  @override
  String get and => ' and ';

  @override
  String get privacyPolicy => ' Privacy Policy';

  @override
  String get noMissions => 'No missions';

  @override
  String get pleaseWait => 'Please wait for an update from the missions desk';

  @override
  String missionStart(String missionDate, String missionTime) {
    return 'Starts on: $missionDate, $missionTime';
  }

  @override
  String missionEnd(String missionDate, String missionTime) {
    return 'Ends on: $missionDate, $missionTime';
  }

  @override
  String missionType(String missionType) {
    return 'Mission Type: $missionType';
  }

  @override
  String get missionDetails => 'Mission Details';

  @override
  String get sendMe => 'Send Me';

  @override
  String get going => 'Missioners';

  @override
  String get missionGround => 'Mission Ground';

  @override
  String get noSubscribers => 'No subscribers';

  @override
  String comingFrom(String residence) {
    return 'Coming from: $residence';
  }

  @override
  String get successfullySubscribed =>
      'Your request to service this mission has been received. Should there be any changes, you will be notified.';

  @override
  String get myMissions => 'My Missions';

  @override
  String get address => 'Address & Directions';

  @override
  String get missionPrepNotes => 'Preparation Notes';

  @override
  String get population => 'Population';

  @override
  String get upcoming => 'Upcoming';

  @override
  String get noUpcomingMissions => 'No upcoming missions';

  @override
  String get past => 'Past';

  @override
  String get noPastMissions => 'No past missions';

  @override
  String get theme => 'Theme/Topic';

  @override
  String get souls => 'Souls';

  @override
  String get recordSoul => 'Record a Soul';

  @override
  String get fullName => 'Full Name';

  @override
  String get admissionNumber => 'Admission Number';

  @override
  String get enterAdmissionNumber => 'Enter Admission Number';

  @override
  String get classGroup => 'Class';

  @override
  String get record => 'Record';

  @override
  String get soulRecorded => 'Soul recorded';

  @override
  String get recording => 'Recording ...';

  @override
  String get selectClass => 'Select Class';

  @override
  String get debriefNotes => 'Debrief Notes';

  @override
  String get note => 'Note';

  @override
  String get noteRecorded => 'Note recorded';

  @override
  String get contactPersons => 'Contact Persons';

  @override
  String get successfullyWithdrawn =>
      'You have successfully withdrawn from this mission';

  @override
  String get withdraw => 'Withdraw';

  @override
  String get missionariesNeeded => 'Still Needed';

  @override
  String get missionariesRequested => 'Requested missioners';

  @override
  String get learn => 'Learn';

  @override
  String progress(int progress) {
    return 'Progress: $progress%';
  }

  @override
  String get courseDetails => 'Course Details';

  @override
  String get description => 'Description';

  @override
  String percentage(int progress) {
    return '$progress%';
  }

  @override
  String get modules => 'Modules';

  @override
  String get moduleDetails => 'Module Details';

  @override
  String get lessons => 'Lessons';

  @override
  String get lessonDetails => 'Lesson Details';

  @override
  String get content => 'Content';

  @override
  String get video => 'Video (Tap to play)';

  @override
  String get document => 'Document (Tap to view)';

  @override
  String get audio => 'Audio (Tap to play)';

  @override
  String get complete => 'Complete';

  @override
  String get completing => 'Completing ...';

  @override
  String get completed => 'Completed';

  @override
  String get noCourses => 'No courses';

  @override
  String get yetToBeEnroled => 'You are yet to be enroled for a course';

  @override
  String get registerStudent => 'Register as a new student';

  @override
  String get registerNewStudent => 'Register a new student account';

  @override
  String get studentIntro =>
      'To keep your identity private, you get random credentials that you can use to access the app. Please ensure to save them somewhere if you want to come back to the app at another time or on a different device.';

  @override
  String get iAmReady => 'I am ready';

  @override
  String get registering => 'Registering ...';

  @override
  String get registered =>
      'You have been registered successfully. Please save your credentials somewhere safe.';

  @override
  String get iHaveWritten => 'I have written them down';

  @override
  String credentials(String email, int password) {
    return 'Your credentials\n\nEmail: $email\nPassword: $password\n\nPlease write them down, they will disappear once you log out';
  }

  @override
  String get faq => 'FAQs';

  @override
  String get noFaqs => 'No FAQs';

  @override
  String get myQuestions => 'My Questions';

  @override
  String get noQuestions => 'No questions';

  @override
  String get replies => 'Replies';

  @override
  String get noReplies => 'No replies yet';

  @override
  String get yourQuestion => 'Your Question';

  @override
  String get createQuestion => 'Create Question';

  @override
  String get enquiry => 'Enquiry';

  @override
  String get enquiryRecorded =>
      'Your enquiry has been recorded. Please wait for a response';

  @override
  String get reply => 'Reply';

  @override
  String get replySent => 'Your reply has been sent';

  @override
  String get replying => 'Replying ...';

  @override
  String get rules =>
      'Don\'t share your contact information or any personal information in your questions or replies';

  @override
  String get studentEnquiries => 'Students';

  @override
  String get studentQuestions => 'Student Questions';

  @override
  String get askQuestion => 'to ask a question';

  @override
  String get announcements => 'Announcements';

  @override
  String get noAnnouncements => 'No announcements';

  @override
  String get pleaseWaitForOS =>
      'Please wait for an update from the organising secretary\'s desk';

  @override
  String publishedAt(String publishingDate) {
    return 'Date: $publishingDate';
  }

  @override
  String get missionQuestions => 'Mission Questions';

  @override
  String get missionQuestion => 'Mission Question';

  @override
  String get expenseTracking => 'Expense Tracking';

  @override
  String get currentBalance => 'Current Balance';

  @override
  String get addToken => 'Add Token';

  @override
  String get addExpense => 'Add an expense';

  @override
  String get expenseBreakdown => 'Expense Breakdown';

  @override
  String get addQuestion => 'Add a question';

  @override
  String get questionRecorded => 'This question has been recorded';

  @override
  String get recordQuestion => 'Record question';

  @override
  String get noNotes => 'No notes';

  @override
  String hello(String name) {
    return 'Hello, $name';
  }

  @override
  String get iWantTo => 'Right now, I want to';

  @override
  String get goToAMission => 'View missions';

  @override
  String get learnSomething => 'Learn something';

  @override
  String get ministerToAStudent => 'Minister to a student';

  @override
  String get all => 'All';

  @override
  String get subscribed => 'Subscribed';

  @override
  String version(String version) {
    return ' v$version';
  }

  @override
  String get faqs => 'for some answers';

  @override
  String get lookingFor => 'I am looking';

  @override
  String get askAQuestion => 'Ask a question';

  @override
  String get ask => 'Ask';

  @override
  String get questions => 'Questions';

  @override
  String get memberships => 'Memberships';

  @override
  String get prayerAlert => 'Prayer watch';

  @override
  String get amen => 'Weka tick ✅';

  @override
  String get viewCredentials => 'for my credentials';

  @override
  String get expenses => 'Expenses';

  @override
  String get confirmationMessage => 'Confirmation Message';

  @override
  String get expenseCategory => 'Expense Category';

  @override
  String get amountDetails => 'Amount Details';

  @override
  String get transactionType => 'Transaction Type';

  @override
  String get narration => 'Narration';

  @override
  String get amountSpent => 'Amount spent';

  @override
  String get selectExpenseCategory => 'Select the expense category';

  @override
  String get selectTransactionType => 'Select the transaction Type';

  @override
  String get enterAmount => 'Enter amount';

  @override
  String get enterQuantity => 'Enter quantity';

  @override
  String get enterCharge => 'Enter transaction cost';

  @override
  String get enterNarration => 'Describe what the money was used for';

  @override
  String get enterConfirmationMessage => 'Enter confirmation message';

  @override
  String get askMissionDeskToDisburseFunds =>
      'Ask the missions desk to disburse funds';

  @override
  String get amountReceived => 'Amount received';

  @override
  String get tokenAmount => 'Token from institution';

  @override
  String get amountToRefund => 'Amount to refund \n(Charge removed)';

  @override
  String get refundedAmount => 'Refunded amount';

  @override
  String get fullyRefunded => 'Fully refunded?';

  @override
  String get balance => 'Balance';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get unitCost => 'Unit Cost';

  @override
  String get unitCostDesc => 'Enter cost per item';

  @override
  String get quantity => 'Quantity';

  @override
  String get charge => 'Transaction Charge';

  @override
  String get paymentMethod => 'Payment Method';

  @override
  String get paymentDesc => 'Describe what the money was used for...';

  @override
  String get confirmationMsg => 'Enter confirmation message (SMS)';

  @override
  String get recordExpense => 'Record Expense';

  @override
  String get totalAmount => 'Total Amount';

  @override
  String get subTotal => 'Subtotal';

  @override
  String get total => 'Total';

  @override
  String get item => 'Item';

  @override
  String get unitCostAndQty => 'Unit x Qty';

  @override
  String get summary => 'Summary';

  @override
  String get breakdown => 'Breakdown';

  @override
  String get figure => 'Figure';

  @override
  String get refundCharge => 'Cost to refund';

  @override
  String get tokenRecorded => 'Token recorded';

  @override
  String get expenseRecorded => 'Expense recorded';

  @override
  String get studentFaqs => 'View student FAQs';

  @override
  String get weather => 'Weather';

  @override
  String get temperature => 'Temperature';

  @override
  String get humidity => 'Humidity';

  @override
  String visibility(String min, String max, String avg) {
    return 'Visibility: $min - $max ($avg)';
  }

  @override
  String get rain => 'Rain';

  @override
  String precipitationProbability(String min, String max, String avg) {
    return 'Precipitation Probability: $min - $max ($avg)';
  }

  @override
  String get dressingRecommendations => 'Dressing Recommendations';

  @override
  String day(int day, String summary) {
    return 'Day $day | $summary';
  }

  @override
  String get depaturePlanning => 'Depature Planning';

  @override
  String estimatedTravelTime(String time) {
    return 'Estimated Travel Time: $time';
  }

  @override
  String get estimatedDistance => 'Distance';

  @override
  String get estimationDisclaimer =>
      '* This estimate is made from Tumaini House to the mission ground and may not be accurate. Please plan accordingly.';

  @override
  String get gallery => 'Gallery';

  @override
  String get upload => 'Upload';

  @override
  String get willUpload =>
      'Your media will be uploaded as you continue to use the app';

  @override
  String get doneUploading =>
      'Your media has been uploaded, you can refresh the page to see them.';

  @override
  String get tapToAdd => 'Tap here to add';

  @override
  String get cancel => 'Cancel';

  @override
  String get noSessions => 'No sessions';

  @override
  String get sessions => 'Sessions';

  @override
  String get time => 'Start Time - End Time';

  @override
  String get facilitator => 'Facilitator';

  @override
  String get speaker => 'Speaker';

  @override
  String get notes => 'Preparation notes';

  @override
  String get selectFacilitator => 'Select Facilitator';

  @override
  String get selectSpeaker => 'Select Speaker';

  @override
  String get enterNotes => 'Enter preparation notes';

  @override
  String get addStartEnd => 'Add start and end time';

  @override
  String get sessionRecorded => 'Session recorded';

  @override
  String get startTime => 'Start Time';

  @override
  String get endTime => 'End Time';

  @override
  String get blank => '';

  @override
  String get confirmDelete => 'Are you sure you want to delete this?';

  @override
  String get deleteSession => 'Delete Session';

  @override
  String get delete => 'Delete';

  @override
  String get sessionDeleted => 'Session deleted';

  @override
  String get noPhotos => 'No photos';

  @override
  String get addPhotos => 'Add Photos';

  @override
  String get suggestAMission => 'Suggest a mission';

  @override
  String get suggestMissionDescription =>
      'Suggest a mission ground for PRF to consider. This is not a request to service the mission, but rather a suggestion for future missions.';

  @override
  String get suggestMissionSubTitle =>
      'Share a mission ground with us and we will take it from there';

  @override
  String get noSuggestedMissionGrounds => 'No suggested mission grounds';

  @override
  String missionGroundRecorded(String ground) {
    return 'Your suggested mission to $ground has been recorded';
  }

  @override
  String get enterMissionGround => 'Enter mission ground';

  @override
  String get contactPerson => 'Contact Person';

  @override
  String get enterContactPerson => 'Enter contact person\'s name';

  @override
  String get contactNumber => 'Contact\'s Phone Number';

  @override
  String get enterContactNumber => 'Enter contact person\'s number';

  @override
  String get suggest => 'Suggest';

  @override
  String get suggesting => 'Suggesting...';

  @override
  String get editMissionSuggestion => 'Edit Mission Suggestion';

  @override
  String get editMissionSuggestionSubTitle =>
      'You can edit your suggested mission ground details below';

  @override
  String get selectStatus => 'Select status';

  @override
  String get status => 'Status';

  @override
  String get comments => 'Notes';

  @override
  String get give => 'Give';

  @override
  String get considerGiving => 'Consider giving';

  @override
  String get amount => 'Amount';

  @override
  String get reasonForGiving => 'Reason for giving';

  @override
  String get selectReasonForGiving => 'Select reason for giving';

  @override
  String get categories => 'Categories';

  @override
  String get whatWouldYouLikeToKnow => 'What would you like to know?';

  @override
  String get sessionDetails => 'Session Details';

  @override
  String get edit => 'Edit';

  @override
  String get recordings => 'Recordings';

  @override
  String get noRecordings => 'No recordings';

  @override
  String get uploadRecording => 'Upload recording';

  @override
  String get addMore => 'Add more';

  @override
  String recordingItem(int index) {
    return 'Recording $index';
  }

  @override
  String get transcript => 'Transcript';

  @override
  String get viewTranscript => 'View transcript';

  @override
  String get transcriptProcessing => 'Transcript processing. Please wait.';

  @override
  String get inTesting => 'In testing';

  @override
  String get downloadTeaching => 'Download teaching';

  @override
  String get downloaded =>
      'Your download has started. Check your download folder once it\'s complete.';

  @override
  String get enterDebriefNote => 'Enter debrief notes';

  @override
  String get enterQuestion => 'Enter question';

  @override
  String get registerForEvent => 'Register for an event';

  @override
  String get events => 'Events';

  @override
  String get pleaseWaitOS =>
      'Please wait for an update from the organising secretary\'s desk';

  @override
  String get noEvents => 'No events';

  @override
  String get registeredEvent => 'Registered';

  @override
  String get eventDetails => 'Event Details';

  @override
  String get info => 'Information';

  @override
  String get capacity => 'Capacity';

  @override
  String capacityDesc(int count) {
    return '$count missioners';
  }

  @override
  String get duration => 'Duration';

  @override
  String durationDesc(int count) {
    return '$count days';
  }

  @override
  String subscriptionsNeeded(String count) {
    return 'Open registrations: $count';
  }

  @override
  String get tickets => 'Tickets';

  @override
  String get enterTickets => 'Enter number of tickets';

  @override
  String get register => 'Register';

  @override
  String get eventRegistrationRecorded =>
      'Your event subscription has been recorded';

  @override
  String get cancelRegistration => 'Cancel subscription';

  @override
  String get confirmCancellation => 'Confirm cancellation';

  @override
  String get subscriptionCancelled => 'Subscription cancelled';

  @override
  String get next => 'Confirm';

  @override
  String get unread => 'Unread';

  @override
  String get replied => 'Replied';

  @override
  String get noModules => 'No modules';

  @override
  String get noLessons => 'No lessons';

  @override
  String get noSouls => 'No souls';

  @override
  String get noSoulsDesc => 'Please record any decisions for Jesus here';

  @override
  String get joinWhatsApp => 'Join WhatsApp';

  @override
  String get navigate => 'Navigate';

  @override
  String get successfullyUpdated =>
      'Your profile picture has been successfully updated';

  @override
  String get bio => 'Bio';

  @override
  String get directed => 'Note: You will be redirected to the payment page';

  @override
  String get testing => 'This is a test. No real money will be charged.';

  @override
  String get expenseDetails => 'Expense Details';

  @override
  String get submitPrayerRequest => 'Share a prayer request';

  @override
  String get submitting => 'Submitting...';

  @override
  String get prayerRequests => 'Prayer requests';

  @override
  String get prayerRequest => 'Prayer request';

  @override
  String get prayerRequestSubmitted =>
      'Your prayer request has been submitted.';

  @override
  String get submit => 'Submit';

  @override
  String get fillAllFields => 'Please fill in all fields.';

  @override
  String get title => 'Title';

  @override
  String get getNotified => 'Get Notified!';

  @override
  String get allowNotifications =>
      'Allow PRF Missions to send you prayer and mission notifications.';

  @override
  String get deny => 'Deny';

  @override
  String get allow => 'Allow';

  @override
  String get pleaseWaitForFunds =>
      'Please inform the mission desk to confirm funds were issued.';

  @override
  String get pleaseWaitForUpload => 'Please wait while we upload this file.';

  @override
  String get successfulUpload => 'Your file has been successfully uploaded.';

  @override
  String get receipts => 'Receipts:';

  @override
  String get addedOn => 'Added on';

  @override
  String get welcomeBack =>
      'Welcome back! Please sign in with your PRF organisation email to continue.';

  @override
  String get welcome => 'Welcome back!';

  @override
  String get longPressToEdit => 'Long press to edit';

  @override
  String get pullToRefresh => 'Pull down to refresh';

  @override
  String get noPrayerRequests => 'No prayer requests';

  @override
  String get noPrayerRequestsDesc =>
      'You have not submitted any prayer requests yet. Tap the button below to submit one.';

  @override
  String get submitPrayerRequestDesc =>
      'Share your prayer request with the PRF community. We will pray for you.';

  @override
  String get addMissionPhotos => 'Add mission photos';

  @override
  String get addMissionPhotosDesc =>
      'Share your mission moments with beautiful photos';

  @override
  String areGoing(int number) {
    return '$number going';
  }

  @override
  String get missionIntelligence => 'Mission Intelligence';

  @override
  String get eventIntelligence => 'Event Intelligence';

  @override
  String get addEventPhotos => 'Add photos to share memories from this event';

  @override
  String get errorLoadingPhotos => 'Error loading photos';

  @override
  String get addNote => 'Add a debrief note';

  @override
  String get addSoul => 'Add a soul';

  @override
  String get addSession => 'Add a session';

  @override
  String get noNotesDesc =>
      'Notes will help you remember important details from this mission';

  @override
  String get sessionsWillAppearHere =>
      'Please use this section to schedule speakers and facilitators';

  @override
  String get questionsWillAppearHere =>
      'Please add any questions asked by students';

  @override
  String get soulsWillAppearHere =>
      'Souls will appear here when they are recorded';

  @override
  String get trackExpensesToStayOrganized =>
      'Track expenses to stay organized and accountable';

  @override
  String get noExpenses => 'No expenses yet';
}
