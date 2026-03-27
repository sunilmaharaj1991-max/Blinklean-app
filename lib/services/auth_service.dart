import 'package:flutter/foundation.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'api_service.dart';

enum UserRole { customer, partner, admin }

class AuthService {
  Future<UserRole> getUserRole() async {
    try {
      final attributes = await Amplify.Auth.fetchUserAttributes();
      for (final attribute in attributes) {
        if (attribute.userAttributeKey.toString() == 'custom:role') {
          if (attribute.value == 'admin') return UserRole.admin;
          if (attribute.value == 'partner' || attribute.value == 'provider') return UserRole.partner;
        }
      }
      return UserRole.customer; // Default
    } catch (e) {
      debugPrint('Error fetching role: $e');
      return UserRole.customer;
    }
  }

  Future<AuthUser?> get currentUser async {
    try {
      return await Amplify.Auth.getCurrentUser();
    } catch (e) {
      return null;
    }
  }

  Future<SignInResult?> signInWithPhone(
    String phoneNumber,
    String password,
  ) async {
    return await Amplify.Auth.signIn(username: phoneNumber, password: password);
  }

  Future<SignUpResult> registerWithPhone({
    required String phoneNumber,
    required String password,
    required String name,
    String? address,
  }) async {
    final userAttributes = {
      AuthUserAttributeKey.phoneNumber: phoneNumber,
      AuthUserAttributeKey.name: name,
    };

    return await Amplify.Auth.signUp(
      username: phoneNumber,
      password: password,
      options: SignUpOptions(userAttributes: userAttributes),
    );
  }


  // Google Sign-In is handled via Authenticator or separate UI if configured
  Future<SignInResult?> signInWithGoogle() async {
    return await Amplify.Auth.signInWithWebUI(provider: AuthProvider.google);
  }

  Future<void> signOut() async {
    await Amplify.Auth.signOut();
  }

  Future<void> hideResetPassword(String phoneNumber) async {
    await Amplify.Auth.resetPassword(username: phoneNumber);
  }

  Future<Map<String, dynamic>?> getUserProfile() async {
    try {
      return await apiService.getUserProfile();
    } catch (e) {
      return null;
    }
  }

  // Resend confirmation code for phone number
  Future<ResendSignUpCodeResult> resendOTP(String phoneNumber) async {
    return await Amplify.Auth.resendSignUpCode(username: phoneNumber);
  }

  // Confirm Signup using OTP for Phone Number
  Future<SignUpResult> confirmRegistrationOTP(
    String phoneNumber,
    String otp,
  ) async {
    return await Amplify.Auth.confirmSignUp(
      username: phoneNumber,
      confirmationCode: otp,
    );
  }

  // Pure OTP login without password requires Custom Auth Trigger in Cognito.
  // For standard flows, we use signIn(phone, password).
  Future<SignInResult> signInWithPhoneOTP(
    String phoneNumber,
    String password,
  ) async {
    return await Amplify.Auth.signIn(
      username: phoneNumber,
      password: password,
    );
  }
}
