/// Outcome of a validation: the [valid] flag is `false` whenever [error]
/// holds a (preferably localized) message.
class ValidationResult {
  const ValidationResult(this.error);

  final String? error;

  bool get valid => error == null;

  bool get hasError => error != null;
}

/// A single validation rule: [validate]/[call] returns a (preferably localized)
/// error message when the value is invalid, or `null` when it is valid.
///
/// All rules are `const`-constructible and composable via [PRFCompose],
/// mirroring `package:phone_form_field`'s `PhoneValidator.Required()` API.
abstract class PRFValidationRule {
  const PRFValidationRule();

  String? validate(String? value);

  String? call(String? value) => validate(value);

  /// Quick boolean check; returns `true` when [validate] returns `null`.
  bool isValid(String? value) => validate(value) == null;

  /// One-call result carrying both a validity flag and the error message.
  ValidationResult validateResult(String? value) =>
      ValidationResult(validate(value));
}

/// Chains [rules] in order, short-circuiting on the first non-empty error.
class PRFCompose extends PRFValidationRule {
  const PRFCompose(this.rules);

  final List<PRFValidationRule> rules;

  @override
  String? validate(String? value) {
    for (final rule in rules) {
      final error = rule.validate(value);
      if (error != null && error.isNotEmpty) return error;
    }
    return null;
  }
}

/// Requires a non-empty value. Pass a localized [message] in app UI.
class PRFRequired extends PRFValidationRule {
  const PRFRequired([this.message]);

  final String? message;

  @override
  String? validate(String? value) => (value == null || value.trim().isEmpty)
      ? (message ?? 'This field is required')
      : null;
}

/// Validates an email address against a basic pattern. Pass a localized
/// [message] in app UI.
class PRFEmail extends PRFValidationRule {
  const PRFEmail([this.message]);

  final String? message;

  static final RegExp _email = RegExp(r'^[\w.+-]+@[\w.-]+\.\w+$');

  @override
  String? validate(String? value) {
    if (value == null || value.trim().isEmpty) {
      return message ?? 'Enter an email';
    }
    final trimmed = value.trim();
    return _email.hasMatch(trimmed) ? null : (message ?? 'Invalid email');
  }
}

/// Requires a minimum length. Pass a localized [message] in app UI.
class PRFMinLength extends PRFValidationRule {
  const PRFMinLength(this.min, [this.message]);

  final int min;
  final String? message;

  @override
  String? validate(String? value) {
    if (value == null) return message ?? 'This field is required';
    if (value.length < min) {
      return message ?? 'Must be at least $min characters';
    }
    return null;
  }
}

/// Validates a well-formed URL. Pass a localized [message] in app UI.
class PRFUrl extends PRFValidationRule {
  const PRFUrl([this.message]);

  final String? message;

  @override
  String? validate(String? value) {
    if (value == null || value.trim().isEmpty) return message ?? 'Enter a URL';
    final uri = Uri.tryParse(value.trim());
    if (uri == null) return message ?? 'Invalid URL';
    if (!uri.hasScheme || !uri.hasAuthority || uri.host.isEmpty) {
      return message ?? 'Invalid URL';
    }
    return null;
  }
}
