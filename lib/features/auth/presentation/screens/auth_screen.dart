import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/di/core_providers.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/l10n/l10n_mappers.dart';
import '../../../../core/mock/demo_account.dart';
import '../../../../core/theme/app_tokens.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/responsive_body.dart';
import '../../domain/auth_rules.dart';
import '../controllers/auth_controller.dart';
import '../widgets/demo_account_card.dart';

/// Sign in and sign up share one screen; the mode only toggles the name field.
class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _isSignUp = false;
  bool _submitting = false;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    setState(() => _submitting = true);

    final auth = ref.read(authControllerProvider.notifier);
    final failure = _isSignUp
        ? await auth.signUp(name: _name.text, email: _email.text, password: _password.text)
        : await auth.signIn(email: _email.text, password: _password.text);

    if (!mounted) return;
    setState(() => _submitting = false);
    if (failure != null) context.showSnack(failure.message(context.l10n));
  }

  void _fillDemo() {
    setState(() => _isSignUp = false);
    _email.text = DemoAccount.email;
    _password.text = DemoAccount.password;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isMock = ref.watch(appConfigProvider).isMock;
    String? message(AuthFieldError? error) => error?.message(l10n);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: ResponsiveBody(
              maxWidth: 440,
              child: AutofillGroup(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Icon(Icons.savings_rounded, size: 56, color: context.colors.primary),
                      const Gap(AppSpacing.md),
                      Text(
                        l10n.authHeadline,
                        style: context.text.headlineSmall,
                        textAlign: TextAlign.center,
                      ),
                      const Gap(AppSpacing.sm),
                      Text(
                        _isSignUp ? l10n.authSignUpSubtitle : l10n.authSignInSubtitle,
                        style: context.text.bodyLarge?.copyWith(
                          color: context.colors.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const Gap(AppSpacing.xl),
                      if (isMock) ...[
                        DemoAccountCard(onUseDemo: _fillDemo),
                        const Gap(AppSpacing.lg),
                      ],
                      AnimatedSize(
                        duration: const Duration(milliseconds: 200),
                        child: _isSignUp
                            ? Padding(
                                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                                child: AppTextField(
                                  label: l10n.authName,
                                  controller: _name,
                                  prefixIcon: Icons.person_outline_rounded,
                                  textInputAction: TextInputAction.next,
                                  textCapitalization: TextCapitalization.words,
                                  autofillHints: const [AutofillHints.name],
                                  validator: (v) => message(AuthRules.name(v ?? '')),
                                ),
                              )
                            : const SizedBox(width: double.infinity),
                      ),
                      AppTextField(
                        label: l10n.authEmail,
                        controller: _email,
                        prefixIcon: Icons.alternate_email_rounded,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        autofillHints: const [AutofillHints.email],
                        validator: (v) => message(AuthRules.email(v ?? '')),
                      ),
                      const Gap(AppSpacing.md),
                      AppTextField(
                        label: l10n.authPassword,
                        controller: _password,
                        prefixIcon: Icons.lock_outline_rounded,
                        isPassword: true,
                        textInputAction: TextInputAction.done,
                        autofillHints: [
                          if (_isSignUp) AutofillHints.newPassword else AutofillHints.password,
                        ],
                        onSubmitted: (_) => _submit(),
                        validator: (v) => message(AuthRules.password(v ?? '', isSignUp: _isSignUp)),
                      ),
                      const Gap(AppSpacing.lg),
                      AppButton(
                        label: _isSignUp ? l10n.authSignUp : l10n.authSignIn,
                        onPressed: _submit,
                        isLoading: _submitting,
                        expand: true,
                      ),
                      const Gap(AppSpacing.sm),
                      AppButton(
                        label: _isSignUp ? l10n.authSwitchToSignIn : l10n.authSwitchToSignUp,
                        variant: AppButtonVariant.text,
                        onPressed: _submitting
                            ? null
                            : () => setState(() {
                                _isSignUp = !_isSignUp;
                                _formKey.currentState?.reset();
                              }),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
