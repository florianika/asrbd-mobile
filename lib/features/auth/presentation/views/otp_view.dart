import 'dart:async';
import 'package:asrdb/features/auth/presentation/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:asrdb/core/widgets/loading_indicator.dart';
import 'package:asrdb/localization/keys.dart';
import 'package:asrdb/localization/localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OtpView extends StatefulWidget {
  final String userId;
  const OtpView({super.key, required this.userId});

  @override
  State<OtpView> createState() => _OtpViewState();
}

class _OtpViewState extends State<OtpView> {
  final TextEditingController otpController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isLoading = false;

  int resendCooldown = 0;
  Timer? cooldownTimer;

  void _startCooldown() {
    setState(() => resendCooldown = 30);

    cooldownTimer?.cancel();
    cooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (resendCooldown == 0) {
        timer.cancel();
      } else {
        setState(() => resendCooldown--);
      }
    });
  }

  void _onVerify(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);
      // Handle OTP verification success or error here
      if (mounted) {
        context.read<AuthCubit>().verifyOtp(
              widget.userId,
              otpController.text.trim(),
            );

        setState(() => isLoading = false);
      }
    }
  }

  void _onResend() {
    if (resendCooldown == 0) {
      _startCooldown();
      // Trigger resend logic here
    }
  }

  @override
  void dispose() {
    cooldownTimer?.cancel();
    otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color.fromARGB(255, 58, 64, 90);

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: LoadingIndicator(
                isLoading: isLoading,
                child: Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: Text(
                              AppLocalizations.of(context)
                                  .translate(Keys.enterOtp),
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                          TextFormField(
                            controller: otpController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: AppLocalizations.of(context)
                                  .translate(Keys.otp),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            validator: (value) => value!.isEmpty
                                ? AppLocalizations.of(context)
                                    .translate(Keys.enterOtp)
                                : null,
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                child: SizedBox(
                                  height: 48,
                                  child: OutlinedButton(
                                    onPressed:
                                        resendCooldown == 0 ? _onResend : null,
                                    child: resendCooldown == 0
                                        ? Text(AppLocalizations.of(context)
                                            .translate(Keys.resend))
                                        : Text(
                                            '${AppLocalizations.of(context).translate(Keys.resendIn)} $resendCooldown s',
                                            style: const TextStyle(
                                              color: primaryColor,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: SizedBox(
                                  height: 48,
                                  child: ElevatedButton(
                                    onPressed: () => _onVerify(context),
                                    child: Text(AppLocalizations.of(context)
                                        .translate(Keys.verify)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
