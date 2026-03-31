import 'package:flutter/foundation.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'api_service.dart';

enum UserRole { customer, partner, admin }

class AuthService extends ChangeNotifier {
  static UserRole? _debugRole = kDebugMode ? UserRole.customer : null;
  
  bool _isOTPRequired = false;
  bool get isOTPRequired => _isOTPRequired;

  Future<UserRole> getUserRole() async {
    if (kDebugMode && _debugRole != null) return _debugRole!;
    
    try {
      final session = await Amplify.Auth.fetchAuthSession() as CognitoAuthSession;
      final groups = session.userPoolTokensResult.value.idToken.groups;
      
      if (groups.contains('Admins')) return UserRole.admin;
      if (groups.contains('Providers')) return UserRole.partner;
      
      return UserRole.customer; // Default
    } catch (e) {
      debugPrint('Error fetching role: $e');
      return UserRole.customer;
    }
  }

  static void setDebugRole(UserRole? role) {
    _debugRole = role;
  }

  static bool get debugRoleSet => _debugRole != null;

  Future<AuthUser?> get currentUser async {
    try {
      return await Amplify.Auth.getCurrentUser();
    } catch (e) {
      return null;
    }
  }

  /// Standard Sign-In (Email/Password for Providers/Admins)
  Future<SignInResult?> signInProvider(String email, String password) async {
    return await Amplify.Auth.signIn(username: email, password: password);
  }

  /// Phone Sign-In (Trigger SMS OTP for Customers)
  /// Using Custom Auth Flow - Password is not required from user but provided as a fixed secret
  Future<SignInResult?> signInCustomer(String phoneNumber) async {
    final formattedPhone = phoneNumber.startsWith('+') ? phoneNumber : '+91$phoneNumber';
    try {
      final result = await Amplify.Auth.signIn(
        username: formattedPhone, 
        password: 'BlinkLeanCustomerAuth123!',
      );
      
      if (result.nextStep.signInStep == AuthSignInStep.confirmSignInWithCustomChallenge) {
        _isOTPRequired = true;
        notifyListeners();
      }
      
      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<SignUpResult> registerWithPhone({
    required String phoneNumber,
  }) async {
    final formattedPhone = phoneNumber.startsWith('+') ? phoneNumber : '+91$phoneNumber';
    // Satisfy required schema attributes with placeholders
    final userAttributes = {
      AuthUserAttributeKey.phoneNumber: formattedPhone,
      AuthUserAttributeKey.address: "Mumbai, India", 
      AuthUserAttributeKey.name: "New BlinKlean User",
      // Specifically addressing the names from the error message using Cognito-specific keys
      const CognitoUserAttributeKey.custom("addresses"): "Mumbai, India",
      const CognitoUserAttributeKey.custom("name.formatted"): "New BlinKlean User",
    };

    return await Amplify.Auth.signUp(
      username: formattedPhone,
      password: 'BlinkLeanCustomerAuth123!', 
      options: SignUpOptions(userAttributes: userAttributes),
    );
  }

  /// Updates user profile attributes like Name and Email
  Future<void> updateUserProfile({required String name, required String email}) async {
    try {
      final attributes = [
        AuthUserAttribute(
          userAttributeKey: AuthUserAttributeKey.name,
          value: name,
        ),
        if (email.isNotEmpty)
          AuthUserAttribute(
            userAttributeKey: AuthUserAttributeKey.email,
            value: email,
          ),
      ];

      final result = await Amplify.Auth.updateUserAttributes(attributes: attributes);

      result.forEach((key, value) {
        if (value.isUpdated) {
          safePrint('Attribute $key was updated successfully');
        } else {
          safePrint('Attribute $key update is pending: ${value.nextStep}');
        }
      });
    } on AuthException catch (e) {
      safePrint('Error updating attributes: ${e.message}');
      rethrow;
    }
  }

  Future<SignInResult?> signInWithGoogle() async {
    return await Amplify.Auth.signInWithWebUI(provider: AuthProvider.google);
  }

  Future<void> signOut() async {
    await Amplify.Auth.signOut();
  }

  Future<void> resetPassword(String phoneNumber) async {
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

  // Handle Custom Challenge (OTP) during Sign In
  Future<SignInResult> confirmSignInOTP(String otp) async {
    return await Amplify.Auth.confirmSignIn(confirmationValue: otp);
  }
}
