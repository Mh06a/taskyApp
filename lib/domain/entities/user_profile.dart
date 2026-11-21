import 'package:equatable/equatable.dart';

class UserProfile extends Equatable {
  const UserProfile({required this.name, this.quote = '', this.avatarPath});

  final String name;
  final String quote;

  final String? avatarPath;

  static const _unset = Object();

  UserProfile copyWith({
    String? name,
    String? quote,
    Object? avatarPath = _unset,
  }) {
    return UserProfile(
      name: name ?? this.name,
      quote: quote ?? this.quote,
      avatarPath: identical(avatarPath, _unset)
          ? this.avatarPath
          : avatarPath as String?,
    );
  }


  @override
  List<Object?> get props => [name, quote, avatarPath];
}
