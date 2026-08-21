icons:
		dart run flutter_launcher_icons:main && dart run icons_launcher:create

splash:
		dart run flutter_native_splash:create

gen:
		dart run build_runner build

fmt:
		dart fix --apply && dart format lib test

arch-check:
		bash scripts/architecture_guardrails.sh

arch-edges:
		bash scripts/feature_import_edges.sh

l10n:
		flutter gen-l10n

apk:
		flutter build apk  --flavor production --target lib/main_production.dart -vv

clean:
		flutter clean && flutter pub get -v && make pods

aab:
		flutter build appbundle  --flavor production --target lib/main_debug.dart --release --obfuscate --split-debug-info=debug-symbols

run:
		flutter run --release  --flavor production --target lib/main_production.dart
	
build: 	# Run the app on a new computer with Flutter 2.3 installed
		flutter pub get && make gen && make run

ipa:
		flutter build ipa  --flavor production --target lib/main_production.dart -vv

build_web_dev:
		flutter build web --target lib/main_development.dart

run_web:
		flutter run  --flavor production --target lib/main_production.dart -d chrome

staging_web:
		flutter run  --flavor staging --target lib/main_staging.dart -d chrome

deploy-staging:
		firebase deploy --only hosting:onspace-staging

deploy-prod:
		firebase deploy

web:
		flutter build web --target lib/main_production.dart

base64:
		cat path/to/file.png | openssl base64 | tr -d '\n' | pbcopy

sha1:
		keytool -list -v -keystore ~/.android/debug.keystore

pods:
		cd ios && pod install --repo-update --verbose && cd ..

gallery:
		keytool -export -rfc -keystore upload-keystore.jks -alias [alias] -file upload_certificate.pem

aab-shore:
		shorebird release android  --flavor production --target lib/main_production.dart --split-debug-info=debug-symbols -v

ios-shore:
		shorebird release ios  --flavor production --target lib/main_production.dart --split-debug-info=debug-symbols

screenshots:
		patrol test --target integration_test/screenshot_test.dart --flavor development --dart-define=FLUTTER_TEST=true --dart-define=PROJECT_DIR=$(CURDIR)

patrol-dev:
		patrol develop --target integration_test/screenshot_test.dart --flavor development

pub:
	# 1. Get the latest from the public world
	git fetch public
	# 2. Create/Reset the local branch to match the public main EXACTLY
	git checkout -B public-deploy public/main
	# 3. Overwrite the files with your private main's state
	git checkout main -- .
	# 4. Commit and push
	git add .
	git commit -m "Automated sync from private repo"
	git push public public-deploy:main
	# 5. Back to main
	git checkout main