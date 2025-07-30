abstract class ProfileEvent {}

class LoadCurrentProfile extends ProfileEvent {}

class LoadUserProfile extends ProfileEvent {
  final int userId;

  LoadUserProfile(this.userId);
}
