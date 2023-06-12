// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../../model/user_details.dart';

// **************************************************************************
// CustomWidgetGenerator
// **************************************************************************

class UserDetailsWidget extends StatelessWidget {
  UserDetailsWidget(
    this.firstName,
    this.lastName,
    this.isActive,
    this.userId,
    this.uniqueHash,
    this.userType,
    this.imagePath,
    this.lastLogin,
  );
  final String firstName;
  final String? lastName;
  final bool isActive;
  final int? userId;
  final double uniqueHash;
  final UserType userType;
  final String? imagePath;
  final DateTime? lastLogin;
  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Text("firstName = $firstName"),
              Text("lastName = $lastName"),
              Text("isActive = $isActive"),
              Text("userId = $userId"),
              Text("uniqueHash = $uniqueHash"),
              Text("userType = $userType"),
              Text("imagePath = $imagePath"),
              Text("lastLogin = $lastLogin"),
            ],
          ),
        ),
      );
}
