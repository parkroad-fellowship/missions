import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'arb/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('en')];

  /// No description provided for @enterEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter Email'**
  String get enterEmail;

  /// No description provided for @enterPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter Password'**
  String get enterPassword;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @signingIn.
  ///
  /// In en, this message translates to:
  /// **'Signing In ...'**
  String get signingIn;

  /// No description provided for @missions.
  ///
  /// In en, this message translates to:
  /// **'Missions'**
  String get missions;

  /// No description provided for @myAccount.
  ///
  /// In en, this message translates to:
  /// **'My Account'**
  String get myAccount;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get signOut;

  /// No description provided for @myProfile.
  ///
  /// In en, this message translates to:
  /// **'My Profile'**
  String get myProfile;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @enterName.
  ///
  /// In en, this message translates to:
  /// **'Enter Name'**
  String get enterName;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @viewProfile.
  ///
  /// In en, this message translates to:
  /// **'View Profile'**
  String get viewProfile;

  /// No description provided for @viewProfileDetails.
  ///
  /// In en, this message translates to:
  /// **'Your name and email address'**
  String get viewProfileDetails;

  /// No description provided for @byUsing.
  ///
  /// In en, this message translates to:
  /// **'By using this app, you are agreeing to our\n'**
  String get byUsing;

  /// No description provided for @terms.
  ///
  /// In en, this message translates to:
  /// **' Terms'**
  String get terms;

  /// No description provided for @and.
  ///
  /// In en, this message translates to:
  /// **' and '**
  String get and;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **' Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @noMissions.
  ///
  /// In en, this message translates to:
  /// **'No missions'**
  String get noMissions;

  /// No description provided for @pleaseWait.
  ///
  /// In en, this message translates to:
  /// **'Please wait for an update from the missions desk'**
  String get pleaseWait;

  /// No description provided for @missionStart.
  ///
  /// In en, this message translates to:
  /// **'Starts on: {missionDate}, {missionTime}'**
  String missionStart(String missionDate, String missionTime);

  /// No description provided for @missionEnd.
  ///
  /// In en, this message translates to:
  /// **'Ends on: {missionDate}, {missionTime}'**
  String missionEnd(String missionDate, String missionTime);

  /// No description provided for @missionType.
  ///
  /// In en, this message translates to:
  /// **'Mission Type: {missionType}'**
  String missionType(String missionType);

  /// No description provided for @missionDetails.
  ///
  /// In en, this message translates to:
  /// **'Mission Details'**
  String get missionDetails;

  /// No description provided for @sendMe.
  ///
  /// In en, this message translates to:
  /// **'Send Me'**
  String get sendMe;

  /// No description provided for @going.
  ///
  /// In en, this message translates to:
  /// **'Missioners'**
  String get going;

  /// No description provided for @missionGround.
  ///
  /// In en, this message translates to:
  /// **'Mission Ground'**
  String get missionGround;

  /// No description provided for @noSubscribers.
  ///
  /// In en, this message translates to:
  /// **'No subscribers'**
  String get noSubscribers;

  /// No description provided for @comingFrom.
  ///
  /// In en, this message translates to:
  /// **'Coming from: {residence}'**
  String comingFrom(String residence);

  /// No description provided for @successfullySubscribed.
  ///
  /// In en, this message translates to:
  /// **'Your request to service this mission has been received. Should there be any changes, you will be notified.'**
  String get successfullySubscribed;

  /// No description provided for @myMissions.
  ///
  /// In en, this message translates to:
  /// **'My Missions'**
  String get myMissions;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address & Directions'**
  String get address;

  /// No description provided for @missionPrepNotes.
  ///
  /// In en, this message translates to:
  /// **'Preparation Notes'**
  String get missionPrepNotes;

  /// No description provided for @population.
  ///
  /// In en, this message translates to:
  /// **'Population'**
  String get population;

  /// No description provided for @upcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get upcoming;

  /// No description provided for @noUpcomingMissions.
  ///
  /// In en, this message translates to:
  /// **'No upcoming missions'**
  String get noUpcomingMissions;

  /// No description provided for @past.
  ///
  /// In en, this message translates to:
  /// **'Past'**
  String get past;

  /// No description provided for @noPastMissions.
  ///
  /// In en, this message translates to:
  /// **'No past missions'**
  String get noPastMissions;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme/Topic'**
  String get theme;

  /// No description provided for @souls.
  ///
  /// In en, this message translates to:
  /// **'Souls'**
  String get souls;

  /// No description provided for @recordSoul.
  ///
  /// In en, this message translates to:
  /// **'Record a Soul'**
  String get recordSoul;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @admissionNumber.
  ///
  /// In en, this message translates to:
  /// **'Admission Number'**
  String get admissionNumber;

  /// No description provided for @enterAdmissionNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter Admission Number'**
  String get enterAdmissionNumber;

  /// No description provided for @classGroup.
  ///
  /// In en, this message translates to:
  /// **'Class'**
  String get classGroup;

  /// No description provided for @record.
  ///
  /// In en, this message translates to:
  /// **'Record'**
  String get record;

  /// No description provided for @soulRecorded.
  ///
  /// In en, this message translates to:
  /// **'Soul recorded'**
  String get soulRecorded;

  /// No description provided for @recording.
  ///
  /// In en, this message translates to:
  /// **'Recording ...'**
  String get recording;

  /// No description provided for @selectClass.
  ///
  /// In en, this message translates to:
  /// **'Select Class'**
  String get selectClass;

  /// No description provided for @debriefNotes.
  ///
  /// In en, this message translates to:
  /// **'Debrief Notes'**
  String get debriefNotes;

  /// No description provided for @note.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get note;

  /// No description provided for @noteRecorded.
  ///
  /// In en, this message translates to:
  /// **'Note recorded'**
  String get noteRecorded;

  /// No description provided for @contactPersons.
  ///
  /// In en, this message translates to:
  /// **'Contact Persons'**
  String get contactPersons;

  /// No description provided for @successfullyWithdrawn.
  ///
  /// In en, this message translates to:
  /// **'You have successfully withdrawn from this mission'**
  String get successfullyWithdrawn;

  /// No description provided for @withdraw.
  ///
  /// In en, this message translates to:
  /// **'Withdraw'**
  String get withdraw;

  /// No description provided for @missionariesNeeded.
  ///
  /// In en, this message translates to:
  /// **'Still Needed'**
  String get missionariesNeeded;

  /// No description provided for @missionariesRequested.
  ///
  /// In en, this message translates to:
  /// **'Requested missioners'**
  String get missionariesRequested;

  /// No description provided for @learn.
  ///
  /// In en, this message translates to:
  /// **'Learn'**
  String get learn;

  /// No description provided for @progress.
  ///
  /// In en, this message translates to:
  /// **'Progress: {progress}%'**
  String progress(int progress);

  /// No description provided for @courseDetails.
  ///
  /// In en, this message translates to:
  /// **'Course Details'**
  String get courseDetails;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @percentage.
  ///
  /// In en, this message translates to:
  /// **'{progress}%'**
  String percentage(int progress);

  /// No description provided for @modules.
  ///
  /// In en, this message translates to:
  /// **'Modules'**
  String get modules;

  /// No description provided for @moduleDetails.
  ///
  /// In en, this message translates to:
  /// **'Module Details'**
  String get moduleDetails;

  /// No description provided for @lessons.
  ///
  /// In en, this message translates to:
  /// **'Lessons'**
  String get lessons;

  /// No description provided for @lessonDetails.
  ///
  /// In en, this message translates to:
  /// **'Lesson Details'**
  String get lessonDetails;

  /// No description provided for @content.
  ///
  /// In en, this message translates to:
  /// **'Content'**
  String get content;

  /// No description provided for @video.
  ///
  /// In en, this message translates to:
  /// **'Video (Tap to play)'**
  String get video;

  /// No description provided for @document.
  ///
  /// In en, this message translates to:
  /// **'Document (Tap to view)'**
  String get document;

  /// No description provided for @audio.
  ///
  /// In en, this message translates to:
  /// **'Audio (Tap to play)'**
  String get audio;

  /// No description provided for @complete.
  ///
  /// In en, this message translates to:
  /// **'Complete'**
  String get complete;

  /// No description provided for @completing.
  ///
  /// In en, this message translates to:
  /// **'Completing ...'**
  String get completing;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @noCourses.
  ///
  /// In en, this message translates to:
  /// **'No courses'**
  String get noCourses;

  /// No description provided for @yetToBeEnroled.
  ///
  /// In en, this message translates to:
  /// **'You are yet to be enroled for a course'**
  String get yetToBeEnroled;

  /// No description provided for @registerStudent.
  ///
  /// In en, this message translates to:
  /// **'Register as a new student'**
  String get registerStudent;

  /// No description provided for @registerNewStudent.
  ///
  /// In en, this message translates to:
  /// **'Register a new student account'**
  String get registerNewStudent;

  /// No description provided for @studentIntro.
  ///
  /// In en, this message translates to:
  /// **'To keep your identity private, you get random credentials that you can use to access the app. Please ensure to save them somewhere if you want to come back to the app at another time or on a different device.'**
  String get studentIntro;

  /// No description provided for @iAmReady.
  ///
  /// In en, this message translates to:
  /// **'I am ready'**
  String get iAmReady;

  /// No description provided for @registering.
  ///
  /// In en, this message translates to:
  /// **'Registering ...'**
  String get registering;

  /// No description provided for @registered.
  ///
  /// In en, this message translates to:
  /// **'You have been registered successfully. Please save your credentials somewhere safe.'**
  String get registered;

  /// No description provided for @iHaveWritten.
  ///
  /// In en, this message translates to:
  /// **'I have written them down'**
  String get iHaveWritten;

  /// No description provided for @credentials.
  ///
  /// In en, this message translates to:
  /// **'Your credentials\n\nEmail: {email}\nPassword: {password}\n\nPlease write them down, they will disappear once you log out'**
  String credentials(String email, int password);

  /// No description provided for @faq.
  ///
  /// In en, this message translates to:
  /// **'FAQs'**
  String get faq;

  /// No description provided for @noFaqs.
  ///
  /// In en, this message translates to:
  /// **'No FAQs'**
  String get noFaqs;

  /// No description provided for @myQuestions.
  ///
  /// In en, this message translates to:
  /// **'My Questions'**
  String get myQuestions;

  /// No description provided for @noQuestions.
  ///
  /// In en, this message translates to:
  /// **'No questions'**
  String get noQuestions;

  /// No description provided for @replies.
  ///
  /// In en, this message translates to:
  /// **'Replies'**
  String get replies;

  /// No description provided for @noReplies.
  ///
  /// In en, this message translates to:
  /// **'No replies yet'**
  String get noReplies;

  /// No description provided for @yourQuestion.
  ///
  /// In en, this message translates to:
  /// **'Your Question'**
  String get yourQuestion;

  /// No description provided for @createQuestion.
  ///
  /// In en, this message translates to:
  /// **'Create Question'**
  String get createQuestion;

  /// No description provided for @enquiry.
  ///
  /// In en, this message translates to:
  /// **'Enquiry'**
  String get enquiry;

  /// No description provided for @enquiryRecorded.
  ///
  /// In en, this message translates to:
  /// **'Your enquiry has been recorded. Please wait for a response'**
  String get enquiryRecorded;

  /// No description provided for @reply.
  ///
  /// In en, this message translates to:
  /// **'Reply'**
  String get reply;

  /// No description provided for @replySent.
  ///
  /// In en, this message translates to:
  /// **'Your reply has been sent'**
  String get replySent;

  /// No description provided for @replying.
  ///
  /// In en, this message translates to:
  /// **'Replying ...'**
  String get replying;

  /// No description provided for @rules.
  ///
  /// In en, this message translates to:
  /// **'Don\'t share your contact information or any personal information in your questions or replies'**
  String get rules;

  /// No description provided for @studentEnquiries.
  ///
  /// In en, this message translates to:
  /// **'Students'**
  String get studentEnquiries;

  /// No description provided for @studentQuestions.
  ///
  /// In en, this message translates to:
  /// **'Student Questions'**
  String get studentQuestions;

  /// No description provided for @askQuestion.
  ///
  /// In en, this message translates to:
  /// **'to ask a question'**
  String get askQuestion;

  /// No description provided for @announcements.
  ///
  /// In en, this message translates to:
  /// **'Announcements'**
  String get announcements;

  /// No description provided for @noAnnouncements.
  ///
  /// In en, this message translates to:
  /// **'No announcements'**
  String get noAnnouncements;

  /// No description provided for @pleaseWaitForOS.
  ///
  /// In en, this message translates to:
  /// **'Please wait for an update from the organising secretary\'s desk'**
  String get pleaseWaitForOS;

  /// No description provided for @publishedAt.
  ///
  /// In en, this message translates to:
  /// **'Date: {publishingDate}'**
  String publishedAt(String publishingDate);

  /// No description provided for @missionQuestions.
  ///
  /// In en, this message translates to:
  /// **'Mission Questions'**
  String get missionQuestions;

  /// No description provided for @missionQuestion.
  ///
  /// In en, this message translates to:
  /// **'Mission Question'**
  String get missionQuestion;

  /// No description provided for @expenseTracking.
  ///
  /// In en, this message translates to:
  /// **'Expense Tracking'**
  String get expenseTracking;

  /// No description provided for @currentBalance.
  ///
  /// In en, this message translates to:
  /// **'Current Balance'**
  String get currentBalance;

  /// No description provided for @addToken.
  ///
  /// In en, this message translates to:
  /// **'Add Token'**
  String get addToken;

  /// No description provided for @addExpense.
  ///
  /// In en, this message translates to:
  /// **'Add an expense'**
  String get addExpense;

  /// No description provided for @expenseBreakdown.
  ///
  /// In en, this message translates to:
  /// **'Expense Breakdown'**
  String get expenseBreakdown;

  /// No description provided for @addQuestion.
  ///
  /// In en, this message translates to:
  /// **'Add a question'**
  String get addQuestion;

  /// No description provided for @addQuestionSubTitle.
  ///
  /// In en, this message translates to:
  /// **'Share any questions from learners'**
  String get addQuestionSubTitle;

  /// No description provided for @addQuestionSection.
  ///
  /// In en, this message translates to:
  /// **'Question Details'**
  String get addQuestionSection;

  /// No description provided for @addQuestionDesc.
  ///
  /// In en, this message translates to:
  /// **'What did the students want to know?'**
  String get addQuestionDesc;

  /// No description provided for @questionRecorded.
  ///
  /// In en, this message translates to:
  /// **'This question has been recorded'**
  String get questionRecorded;

  /// No description provided for @recordQuestion.
  ///
  /// In en, this message translates to:
  /// **'Record question'**
  String get recordQuestion;

  /// No description provided for @noNotes.
  ///
  /// In en, this message translates to:
  /// **'No notes'**
  String get noNotes;

  /// No description provided for @hello.
  ///
  /// In en, this message translates to:
  /// **'Hello, {name}'**
  String hello(String name);

  /// No description provided for @iWantTo.
  ///
  /// In en, this message translates to:
  /// **'Right now, I want to'**
  String get iWantTo;

  /// No description provided for @goToAMission.
  ///
  /// In en, this message translates to:
  /// **'View missions'**
  String get goToAMission;

  /// No description provided for @learnSomething.
  ///
  /// In en, this message translates to:
  /// **'Learn something'**
  String get learnSomething;

  /// No description provided for @ministerToAStudent.
  ///
  /// In en, this message translates to:
  /// **'Minister to a student'**
  String get ministerToAStudent;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @subscribed.
  ///
  /// In en, this message translates to:
  /// **'Subscribed'**
  String get subscribed;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **' v{version}'**
  String version(String version);

  /// No description provided for @faqs.
  ///
  /// In en, this message translates to:
  /// **'for some answers'**
  String get faqs;

  /// No description provided for @lookingFor.
  ///
  /// In en, this message translates to:
  /// **'I am looking'**
  String get lookingFor;

  /// No description provided for @askAQuestion.
  ///
  /// In en, this message translates to:
  /// **'Ask a question'**
  String get askAQuestion;

  /// No description provided for @ask.
  ///
  /// In en, this message translates to:
  /// **'Ask'**
  String get ask;

  /// No description provided for @questions.
  ///
  /// In en, this message translates to:
  /// **'Questions'**
  String get questions;

  /// No description provided for @memberships.
  ///
  /// In en, this message translates to:
  /// **'Memberships'**
  String get memberships;

  /// No description provided for @prayerAlert.
  ///
  /// In en, this message translates to:
  /// **'Prayer watch'**
  String get prayerAlert;

  /// No description provided for @amen.
  ///
  /// In en, this message translates to:
  /// **'Weka tick ✅'**
  String get amen;

  /// No description provided for @viewCredentials.
  ///
  /// In en, this message translates to:
  /// **'for my credentials'**
  String get viewCredentials;

  /// No description provided for @expenses.
  ///
  /// In en, this message translates to:
  /// **'Expenses'**
  String get expenses;

  /// No description provided for @confirmationMessage.
  ///
  /// In en, this message translates to:
  /// **'Confirmation Message'**
  String get confirmationMessage;

  /// No description provided for @expenseCategory.
  ///
  /// In en, this message translates to:
  /// **'Expense Category'**
  String get expenseCategory;

  /// No description provided for @amountDetails.
  ///
  /// In en, this message translates to:
  /// **'Amount Details'**
  String get amountDetails;

  /// No description provided for @transactionType.
  ///
  /// In en, this message translates to:
  /// **'Transaction Type'**
  String get transactionType;

  /// No description provided for @narration.
  ///
  /// In en, this message translates to:
  /// **'Narration'**
  String get narration;

  /// No description provided for @amountSpent.
  ///
  /// In en, this message translates to:
  /// **'Amount spent'**
  String get amountSpent;

  /// No description provided for @selectExpenseCategory.
  ///
  /// In en, this message translates to:
  /// **'Select the expense category'**
  String get selectExpenseCategory;

  /// No description provided for @selectTransactionType.
  ///
  /// In en, this message translates to:
  /// **'Select the transaction Type'**
  String get selectTransactionType;

  /// No description provided for @enterAmount.
  ///
  /// In en, this message translates to:
  /// **'Enter amount'**
  String get enterAmount;

  /// No description provided for @enterQuantity.
  ///
  /// In en, this message translates to:
  /// **'Enter quantity'**
  String get enterQuantity;

  /// No description provided for @enterCharge.
  ///
  /// In en, this message translates to:
  /// **'Enter transaction cost'**
  String get enterCharge;

  /// No description provided for @enterNarration.
  ///
  /// In en, this message translates to:
  /// **'Describe what the money was used for'**
  String get enterNarration;

  /// No description provided for @enterConfirmationMessage.
  ///
  /// In en, this message translates to:
  /// **'Enter confirmation message'**
  String get enterConfirmationMessage;

  /// No description provided for @askMissionDeskToDisburseFunds.
  ///
  /// In en, this message translates to:
  /// **'Ask the missions desk to disburse funds'**
  String get askMissionDeskToDisburseFunds;

  /// No description provided for @amountReceived.
  ///
  /// In en, this message translates to:
  /// **'Amount received'**
  String get amountReceived;

  /// No description provided for @tokenAmount.
  ///
  /// In en, this message translates to:
  /// **'Token from institution'**
  String get tokenAmount;

  /// No description provided for @amountToRefund.
  ///
  /// In en, this message translates to:
  /// **'Amount to refund \n(Charge removed)'**
  String get amountToRefund;

  /// No description provided for @refundedAmount.
  ///
  /// In en, this message translates to:
  /// **'Refunded amount'**
  String get refundedAmount;

  /// No description provided for @fullyRefunded.
  ///
  /// In en, this message translates to:
  /// **'Fully refunded?'**
  String get fullyRefunded;

  /// No description provided for @balance.
  ///
  /// In en, this message translates to:
  /// **'Balance'**
  String get balance;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @unitCost.
  ///
  /// In en, this message translates to:
  /// **'Unit Cost'**
  String get unitCost;

  /// No description provided for @unitCostDesc.
  ///
  /// In en, this message translates to:
  /// **'Enter cost per item'**
  String get unitCostDesc;

  /// No description provided for @quantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get quantity;

  /// No description provided for @charge.
  ///
  /// In en, this message translates to:
  /// **'Transaction Charge'**
  String get charge;

  /// No description provided for @paymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Payment Method'**
  String get paymentMethod;

  /// No description provided for @paymentDesc.
  ///
  /// In en, this message translates to:
  /// **'Describe what the money was used for...'**
  String get paymentDesc;

  /// No description provided for @confirmationMsg.
  ///
  /// In en, this message translates to:
  /// **'Enter confirmation message (SMS)'**
  String get confirmationMsg;

  /// No description provided for @recordExpense.
  ///
  /// In en, this message translates to:
  /// **'Record Expense'**
  String get recordExpense;

  /// No description provided for @totalAmount.
  ///
  /// In en, this message translates to:
  /// **'Total Amount'**
  String get totalAmount;

  /// No description provided for @subTotal.
  ///
  /// In en, this message translates to:
  /// **'Subtotal'**
  String get subTotal;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @item.
  ///
  /// In en, this message translates to:
  /// **'Item'**
  String get item;

  /// No description provided for @unitCostAndQty.
  ///
  /// In en, this message translates to:
  /// **'Unit x Qty'**
  String get unitCostAndQty;

  /// No description provided for @summary.
  ///
  /// In en, this message translates to:
  /// **'Summary'**
  String get summary;

  /// No description provided for @breakdown.
  ///
  /// In en, this message translates to:
  /// **'Breakdown'**
  String get breakdown;

  /// No description provided for @figure.
  ///
  /// In en, this message translates to:
  /// **'Figure'**
  String get figure;

  /// No description provided for @refundCharge.
  ///
  /// In en, this message translates to:
  /// **'Cost to refund'**
  String get refundCharge;

  /// No description provided for @tokenRecorded.
  ///
  /// In en, this message translates to:
  /// **'Token recorded'**
  String get tokenRecorded;

  /// No description provided for @expenseRecorded.
  ///
  /// In en, this message translates to:
  /// **'Expense recorded'**
  String get expenseRecorded;

  /// No description provided for @studentFaqs.
  ///
  /// In en, this message translates to:
  /// **'View student FAQs'**
  String get studentFaqs;

  /// No description provided for @weather.
  ///
  /// In en, this message translates to:
  /// **'Weather'**
  String get weather;

  /// No description provided for @temperature.
  ///
  /// In en, this message translates to:
  /// **'Temperature'**
  String get temperature;

  /// No description provided for @humidity.
  ///
  /// In en, this message translates to:
  /// **'Humidity'**
  String get humidity;

  /// No description provided for @visibility.
  ///
  /// In en, this message translates to:
  /// **'Visibility: {min} - {max} ({avg})'**
  String visibility(String min, String max, String avg);

  /// No description provided for @rain.
  ///
  /// In en, this message translates to:
  /// **'Rain'**
  String get rain;

  /// No description provided for @precipitationProbability.
  ///
  /// In en, this message translates to:
  /// **'Precipitation Probability: {min} - {max} ({avg})'**
  String precipitationProbability(String min, String max, String avg);

  /// No description provided for @dressingRecommendations.
  ///
  /// In en, this message translates to:
  /// **'Dressing Recommendations'**
  String get dressingRecommendations;

  /// No description provided for @day.
  ///
  /// In en, this message translates to:
  /// **'Day {day} | {summary}'**
  String day(int day, String summary);

  /// No description provided for @depaturePlanning.
  ///
  /// In en, this message translates to:
  /// **'Depature Planning'**
  String get depaturePlanning;

  /// No description provided for @estimatedTravelTime.
  ///
  /// In en, this message translates to:
  /// **'Estimated Travel Time: {time}'**
  String estimatedTravelTime(String time);

  /// No description provided for @estimatedDistance.
  ///
  /// In en, this message translates to:
  /// **'Distance'**
  String get estimatedDistance;

  /// No description provided for @estimationDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'* This estimate is made from Tumaini House to the mission ground and may not be accurate. Please plan accordingly.'**
  String get estimationDisclaimer;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// No description provided for @upload.
  ///
  /// In en, this message translates to:
  /// **'Upload'**
  String get upload;

  /// No description provided for @willUpload.
  ///
  /// In en, this message translates to:
  /// **'Your media will be uploaded as you continue to use the app'**
  String get willUpload;

  /// No description provided for @doneUploading.
  ///
  /// In en, this message translates to:
  /// **'Your media has been uploaded, you can refresh the page to see them.'**
  String get doneUploading;

  /// No description provided for @tapToAdd.
  ///
  /// In en, this message translates to:
  /// **'Tap here to add'**
  String get tapToAdd;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @noSessions.
  ///
  /// In en, this message translates to:
  /// **'No sessions'**
  String get noSessions;

  /// No description provided for @sessions.
  ///
  /// In en, this message translates to:
  /// **'Sessions'**
  String get sessions;

  /// No description provided for @time.
  ///
  /// In en, this message translates to:
  /// **'Start Time - End Time'**
  String get time;

  /// No description provided for @facilitator.
  ///
  /// In en, this message translates to:
  /// **'Facilitator'**
  String get facilitator;

  /// No description provided for @speaker.
  ///
  /// In en, this message translates to:
  /// **'Speaker'**
  String get speaker;

  /// No description provided for @notes.
  ///
  /// In en, this message translates to:
  /// **'Preparation notes'**
  String get notes;

  /// No description provided for @selectFacilitator.
  ///
  /// In en, this message translates to:
  /// **'Select Facilitator'**
  String get selectFacilitator;

  /// No description provided for @selectSpeaker.
  ///
  /// In en, this message translates to:
  /// **'Select Speaker'**
  String get selectSpeaker;

  /// No description provided for @enterNotes.
  ///
  /// In en, this message translates to:
  /// **'Enter preparation notes'**
  String get enterNotes;

  /// No description provided for @addStartEnd.
  ///
  /// In en, this message translates to:
  /// **'Add start and end time'**
  String get addStartEnd;

  /// No description provided for @sessionRecorded.
  ///
  /// In en, this message translates to:
  /// **'Session recorded'**
  String get sessionRecorded;

  /// No description provided for @startTime.
  ///
  /// In en, this message translates to:
  /// **'Start Time'**
  String get startTime;

  /// No description provided for @endTime.
  ///
  /// In en, this message translates to:
  /// **'End Time'**
  String get endTime;

  /// No description provided for @blank.
  ///
  /// In en, this message translates to:
  /// **''**
  String get blank;

  /// No description provided for @confirmDelete.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this?'**
  String get confirmDelete;

  /// No description provided for @deleteSession.
  ///
  /// In en, this message translates to:
  /// **'Delete Session'**
  String get deleteSession;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @sessionDeleted.
  ///
  /// In en, this message translates to:
  /// **'Session deleted'**
  String get sessionDeleted;

  /// No description provided for @noPhotos.
  ///
  /// In en, this message translates to:
  /// **'No photos'**
  String get noPhotos;

  /// No description provided for @addPhotos.
  ///
  /// In en, this message translates to:
  /// **'Add Photos'**
  String get addPhotos;

  /// No description provided for @suggestAMission.
  ///
  /// In en, this message translates to:
  /// **'Suggest a mission'**
  String get suggestAMission;

  /// No description provided for @suggestMissionDescription.
  ///
  /// In en, this message translates to:
  /// **'Suggest a mission ground for PRF to consider. This is not a request to service the mission, but rather a suggestion for future missions.'**
  String get suggestMissionDescription;

  /// No description provided for @suggestMissionSubTitle.
  ///
  /// In en, this message translates to:
  /// **'Share a mission ground with us and we will take it from there'**
  String get suggestMissionSubTitle;

  /// No description provided for @noSuggestedMissionGrounds.
  ///
  /// In en, this message translates to:
  /// **'No suggested mission grounds'**
  String get noSuggestedMissionGrounds;

  /// No description provided for @missionGroundRecorded.
  ///
  /// In en, this message translates to:
  /// **'Your suggested mission to {ground} has been recorded'**
  String missionGroundRecorded(String ground);

  /// No description provided for @enterMissionGround.
  ///
  /// In en, this message translates to:
  /// **'Enter mission ground'**
  String get enterMissionGround;

  /// No description provided for @contactPerson.
  ///
  /// In en, this message translates to:
  /// **'Contact Person'**
  String get contactPerson;

  /// No description provided for @enterContactPerson.
  ///
  /// In en, this message translates to:
  /// **'Enter contact person\'s name'**
  String get enterContactPerson;

  /// No description provided for @contactNumber.
  ///
  /// In en, this message translates to:
  /// **'Contact\'s Phone Number'**
  String get contactNumber;

  /// No description provided for @enterContactNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter contact person\'s number'**
  String get enterContactNumber;

  /// No description provided for @suggest.
  ///
  /// In en, this message translates to:
  /// **'Suggest'**
  String get suggest;

  /// No description provided for @suggesting.
  ///
  /// In en, this message translates to:
  /// **'Suggesting...'**
  String get suggesting;

  /// No description provided for @editMissionSuggestion.
  ///
  /// In en, this message translates to:
  /// **'Edit Mission Suggestion'**
  String get editMissionSuggestion;

  /// No description provided for @editMissionSuggestionSubTitle.
  ///
  /// In en, this message translates to:
  /// **'You can edit your suggested mission ground details below'**
  String get editMissionSuggestionSubTitle;

  /// No description provided for @selectStatus.
  ///
  /// In en, this message translates to:
  /// **'Select status'**
  String get selectStatus;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @comments.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get comments;

  /// No description provided for @give.
  ///
  /// In en, this message translates to:
  /// **'Give'**
  String get give;

  /// No description provided for @considerGiving.
  ///
  /// In en, this message translates to:
  /// **'Consider giving'**
  String get considerGiving;

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// No description provided for @reasonForGiving.
  ///
  /// In en, this message translates to:
  /// **'Reason for giving'**
  String get reasonForGiving;

  /// No description provided for @selectReasonForGiving.
  ///
  /// In en, this message translates to:
  /// **'Select reason for giving'**
  String get selectReasonForGiving;

  /// No description provided for @categories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categories;

  /// No description provided for @whatWouldYouLikeToKnow.
  ///
  /// In en, this message translates to:
  /// **'What would you like to know?'**
  String get whatWouldYouLikeToKnow;

  /// No description provided for @sessionDetails.
  ///
  /// In en, this message translates to:
  /// **'Session Details'**
  String get sessionDetails;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @recordings.
  ///
  /// In en, this message translates to:
  /// **'Recordings'**
  String get recordings;

  /// No description provided for @noRecordings.
  ///
  /// In en, this message translates to:
  /// **'No recordings'**
  String get noRecordings;

  /// No description provided for @uploadRecording.
  ///
  /// In en, this message translates to:
  /// **'Upload recording'**
  String get uploadRecording;

  /// No description provided for @addMore.
  ///
  /// In en, this message translates to:
  /// **'Add more'**
  String get addMore;

  /// No description provided for @recordingItem.
  ///
  /// In en, this message translates to:
  /// **'Recording {index}'**
  String recordingItem(int index);

  /// No description provided for @transcript.
  ///
  /// In en, this message translates to:
  /// **'Transcript'**
  String get transcript;

  /// No description provided for @viewTranscript.
  ///
  /// In en, this message translates to:
  /// **'View transcript'**
  String get viewTranscript;

  /// No description provided for @transcriptProcessing.
  ///
  /// In en, this message translates to:
  /// **'Transcript processing. Please wait.'**
  String get transcriptProcessing;

  /// No description provided for @inTesting.
  ///
  /// In en, this message translates to:
  /// **'In testing'**
  String get inTesting;

  /// No description provided for @downloadTeaching.
  ///
  /// In en, this message translates to:
  /// **'Download teaching'**
  String get downloadTeaching;

  /// No description provided for @downloaded.
  ///
  /// In en, this message translates to:
  /// **'Your download has started. Check your download folder once it\'s complete.'**
  String get downloaded;

  /// No description provided for @enterDebriefNote.
  ///
  /// In en, this message translates to:
  /// **'Enter debrief notes'**
  String get enterDebriefNote;

  /// No description provided for @enterQuestion.
  ///
  /// In en, this message translates to:
  /// **'Enter question'**
  String get enterQuestion;

  /// No description provided for @registerForEvent.
  ///
  /// In en, this message translates to:
  /// **'Register for an event'**
  String get registerForEvent;

  /// No description provided for @events.
  ///
  /// In en, this message translates to:
  /// **'Events'**
  String get events;

  /// No description provided for @pleaseWaitOS.
  ///
  /// In en, this message translates to:
  /// **'Please wait for an update from the organising secretary\'s desk'**
  String get pleaseWaitOS;

  /// No description provided for @noEvents.
  ///
  /// In en, this message translates to:
  /// **'No events'**
  String get noEvents;

  /// No description provided for @registeredEvent.
  ///
  /// In en, this message translates to:
  /// **'Registered'**
  String get registeredEvent;

  /// No description provided for @eventDetails.
  ///
  /// In en, this message translates to:
  /// **'Event Details'**
  String get eventDetails;

  /// No description provided for @info.
  ///
  /// In en, this message translates to:
  /// **'Information'**
  String get info;

  /// No description provided for @capacity.
  ///
  /// In en, this message translates to:
  /// **'Capacity'**
  String get capacity;

  /// No description provided for @capacityDesc.
  ///
  /// In en, this message translates to:
  /// **'{count} missioners'**
  String capacityDesc(int count);

  /// No description provided for @duration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get duration;

  /// No description provided for @durationDesc.
  ///
  /// In en, this message translates to:
  /// **'{count} days'**
  String durationDesc(int count);

  /// No description provided for @subscriptionsNeeded.
  ///
  /// In en, this message translates to:
  /// **'Open registrations: {count}'**
  String subscriptionsNeeded(String count);

  /// No description provided for @tickets.
  ///
  /// In en, this message translates to:
  /// **'Tickets'**
  String get tickets;

  /// No description provided for @enterTickets.
  ///
  /// In en, this message translates to:
  /// **'Enter number of tickets'**
  String get enterTickets;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @eventRegistrationRecorded.
  ///
  /// In en, this message translates to:
  /// **'Your event subscription has been recorded'**
  String get eventRegistrationRecorded;

  /// No description provided for @cancelRegistration.
  ///
  /// In en, this message translates to:
  /// **'Cancel subscription'**
  String get cancelRegistration;

  /// No description provided for @confirmCancellation.
  ///
  /// In en, this message translates to:
  /// **'Confirm cancellation'**
  String get confirmCancellation;

  /// No description provided for @subscriptionCancelled.
  ///
  /// In en, this message translates to:
  /// **'Subscription cancelled'**
  String get subscriptionCancelled;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get next;

  /// No description provided for @unread.
  ///
  /// In en, this message translates to:
  /// **'Unread'**
  String get unread;

  /// No description provided for @replied.
  ///
  /// In en, this message translates to:
  /// **'Replied'**
  String get replied;

  /// No description provided for @noModules.
  ///
  /// In en, this message translates to:
  /// **'No modules'**
  String get noModules;

  /// No description provided for @noLessons.
  ///
  /// In en, this message translates to:
  /// **'No lessons'**
  String get noLessons;

  /// No description provided for @noSouls.
  ///
  /// In en, this message translates to:
  /// **'No souls'**
  String get noSouls;

  /// No description provided for @noSoulsDesc.
  ///
  /// In en, this message translates to:
  /// **'Please record any decisions for Jesus here'**
  String get noSoulsDesc;

  /// No description provided for @joinWhatsApp.
  ///
  /// In en, this message translates to:
  /// **'Join WhatsApp'**
  String get joinWhatsApp;

  /// No description provided for @navigate.
  ///
  /// In en, this message translates to:
  /// **'Navigate'**
  String get navigate;

  /// No description provided for @successfullyUpdated.
  ///
  /// In en, this message translates to:
  /// **'Your profile picture has been successfully updated'**
  String get successfullyUpdated;

  /// No description provided for @bio.
  ///
  /// In en, this message translates to:
  /// **'Bio'**
  String get bio;

  /// No description provided for @directed.
  ///
  /// In en, this message translates to:
  /// **'Note: You will be redirected to the payment page'**
  String get directed;

  /// No description provided for @testing.
  ///
  /// In en, this message translates to:
  /// **'This is a test. No real money will be charged.'**
  String get testing;

  /// No description provided for @expenseDetails.
  ///
  /// In en, this message translates to:
  /// **'Expense Details'**
  String get expenseDetails;

  /// No description provided for @submitPrayerRequest.
  ///
  /// In en, this message translates to:
  /// **'Share a prayer request'**
  String get submitPrayerRequest;

  /// No description provided for @submitting.
  ///
  /// In en, this message translates to:
  /// **'Submitting...'**
  String get submitting;

  /// No description provided for @prayerRequests.
  ///
  /// In en, this message translates to:
  /// **'Prayer requests'**
  String get prayerRequests;

  /// No description provided for @prayerRequest.
  ///
  /// In en, this message translates to:
  /// **'Prayer request'**
  String get prayerRequest;

  /// No description provided for @prayerRequestSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Your prayer request has been submitted.'**
  String get prayerRequestSubmitted;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @fillAllFields.
  ///
  /// In en, this message translates to:
  /// **'Please fill in all fields.'**
  String get fillAllFields;

  /// No description provided for @title.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get title;

  /// No description provided for @getNotified.
  ///
  /// In en, this message translates to:
  /// **'Get Notified!'**
  String get getNotified;

  /// No description provided for @allowNotifications.
  ///
  /// In en, this message translates to:
  /// **'Allow PRF Missions to send you prayer and mission notifications.'**
  String get allowNotifications;

  /// No description provided for @deny.
  ///
  /// In en, this message translates to:
  /// **'Deny'**
  String get deny;

  /// No description provided for @allow.
  ///
  /// In en, this message translates to:
  /// **'Allow'**
  String get allow;

  /// No description provided for @pleaseWaitForFunds.
  ///
  /// In en, this message translates to:
  /// **'Please inform the mission desk to confirm funds were issued.'**
  String get pleaseWaitForFunds;

  /// No description provided for @pleaseWaitForUpload.
  ///
  /// In en, this message translates to:
  /// **'Please wait while we upload this file.'**
  String get pleaseWaitForUpload;

  /// No description provided for @successfulUpload.
  ///
  /// In en, this message translates to:
  /// **'Your file has been successfully uploaded.'**
  String get successfulUpload;

  /// No description provided for @receipts.
  ///
  /// In en, this message translates to:
  /// **'Receipts:'**
  String get receipts;

  /// No description provided for @addedOn.
  ///
  /// In en, this message translates to:
  /// **'Added on'**
  String get addedOn;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back! Please sign in with your PRF organisation email to continue.'**
  String get welcomeBack;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome back!'**
  String get welcome;

  /// No description provided for @longPressToEdit.
  ///
  /// In en, this message translates to:
  /// **'Long press to edit'**
  String get longPressToEdit;

  /// No description provided for @pullToRefresh.
  ///
  /// In en, this message translates to:
  /// **'Pull down to refresh'**
  String get pullToRefresh;

  /// No description provided for @noPrayerRequests.
  ///
  /// In en, this message translates to:
  /// **'No prayer requests'**
  String get noPrayerRequests;

  /// No description provided for @noPrayerRequestsDesc.
  ///
  /// In en, this message translates to:
  /// **'You have not submitted any prayer requests yet. Tap the button below to submit one.'**
  String get noPrayerRequestsDesc;

  /// No description provided for @submitPrayerRequestDesc.
  ///
  /// In en, this message translates to:
  /// **'Share your prayer request with the PRF community. We will pray for you.'**
  String get submitPrayerRequestDesc;

  /// No description provided for @addMissionPhotos.
  ///
  /// In en, this message translates to:
  /// **'Add mission photos'**
  String get addMissionPhotos;

  /// No description provided for @addMissionPhotosDesc.
  ///
  /// In en, this message translates to:
  /// **'Share your mission moments with beautiful photos'**
  String get addMissionPhotosDesc;

  /// No description provided for @areGoing.
  ///
  /// In en, this message translates to:
  /// **'{number} going'**
  String areGoing(int number);

  /// No description provided for @missionIntelligence.
  ///
  /// In en, this message translates to:
  /// **'Mission Intelligence'**
  String get missionIntelligence;

  /// No description provided for @eventIntelligence.
  ///
  /// In en, this message translates to:
  /// **'Event Intelligence'**
  String get eventIntelligence;

  /// No description provided for @addEventPhotos.
  ///
  /// In en, this message translates to:
  /// **'Add photos to share memories from this event'**
  String get addEventPhotos;

  /// No description provided for @errorLoadingPhotos.
  ///
  /// In en, this message translates to:
  /// **'Error loading photos'**
  String get errorLoadingPhotos;

  /// No description provided for @addNote.
  ///
  /// In en, this message translates to:
  /// **'Add a debrief note'**
  String get addNote;

  /// No description provided for @addSoul.
  ///
  /// In en, this message translates to:
  /// **'Add a soul'**
  String get addSoul;

  /// No description provided for @addSession.
  ///
  /// In en, this message translates to:
  /// **'Add a session'**
  String get addSession;

  /// No description provided for @noNotesDesc.
  ///
  /// In en, this message translates to:
  /// **'Notes will help you remember important details from this mission'**
  String get noNotesDesc;

  /// No description provided for @sessionsWillAppearHere.
  ///
  /// In en, this message translates to:
  /// **'Please use this section to schedule speakers and facilitators'**
  String get sessionsWillAppearHere;

  /// No description provided for @questionsWillAppearHere.
  ///
  /// In en, this message translates to:
  /// **'Please add any questions asked by students'**
  String get questionsWillAppearHere;

  /// No description provided for @soulsWillAppearHere.
  ///
  /// In en, this message translates to:
  /// **'Souls will appear here when they are recorded'**
  String get soulsWillAppearHere;

  /// No description provided for @trackExpensesToStayOrganized.
  ///
  /// In en, this message translates to:
  /// **'Track expenses to stay organized and accountable'**
  String get trackExpensesToStayOrganized;

  /// No description provided for @noExpenses.
  ///
  /// In en, this message translates to:
  /// **'No expenses yet'**
  String get noExpenses;

  /// No description provided for @addDebriefNote.
  ///
  /// In en, this message translates to:
  /// **'Add debrief note'**
  String get addDebriefNote;

  /// No description provided for @addDebriefNoteSubTitle.
  ///
  /// In en, this message translates to:
  /// **'Share your thoughts and observations from the mission'**
  String get addDebriefNoteSubTitle;

  /// No description provided for @addDebriefNoteSection.
  ///
  /// In en, this message translates to:
  /// **'Note Details'**
  String get addDebriefNoteSection;

  /// No description provided for @addDebriefNoteDesc.
  ///
  /// In en, this message translates to:
  /// **'What are your thoughts so far?'**
  String get addDebriefNoteDesc;

  /// No description provided for @addSoulSubTitle.
  ///
  /// In en, this message translates to:
  /// **'Record a decision for Jesus made during this mission'**
  String get addSoulSubTitle;

  /// No description provided for @studentInformation.
  ///
  /// In en, this message translates to:
  /// **'Student Information'**
  String get studentInformation;

  /// No description provided for @updateRegistration.
  ///
  /// In en, this message translates to:
  /// **'Update Registration'**
  String get updateRegistration;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
