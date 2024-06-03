
import 'package:app/l10n/l10n.dart';
import 'package:app/services/_index.dart';
import 'package:app/utils/_index.dart';
import 'package:app/widgets/_index.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ProfilePageHandset extends StatefulWidget {
  const ProfilePageHandset({super.key});

  @override
  State<ProfilePageHandset> createState() => _ProfilePageHandsetState();
}

class _ProfilePageHandsetState extends State<ProfilePageHandset> {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: AppTheme.appTheme().kBackgroundColor,
      appBar: AppBar(
        title: Text(
          l10n.myProfile,
          style:
              CustomTextTheme.customTextTheme().displayLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: const <Widget>[
  
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<dynamic>(
         PRFSuperAppConfig.instance!.values.hiveBox,
        ).listenable(),
        builder: (context, box, _) {
          final profile = getIt<HiveService>().retrieveProfile();
          if (profile == null) {
            return const Center(
              child: SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(),
              ),
            );
          }
          final name = profile.name;
          final email = profile.email;
          return ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            children: [
              const SizedBox(height: 30),
              FormFieldLabel(
                label: l10n.name,
                color: AppTheme.appTheme().kBlackColor,
              ),
              const SizedBox(height: 10),
              InputFormField(
                hintText: l10n.enterName,
                controller: TextEditingController(text: name),
                isUnderLine: true,
                enabled: false,
              ),
              const SizedBox(height: 15),
              FormFieldLabel(
                label: l10n.email,
                color: AppTheme.appTheme().kBlackColor,
              ),
              const SizedBox(height: 10),
              InputFormField(
                hintText: l10n.enterEmail,
                controller: TextEditingController(text: email),
                isUnderLine: true,
                isEmail: true,
                enabled: false,
              ),
              const SizedBox(height: 40),
            ],
          );
        },
      ),
    );
  }
}
