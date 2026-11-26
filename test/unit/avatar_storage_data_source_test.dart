import 'package:flutter_test/flutter_test.dart';
import 'package:tasky/data/datasources/local/avatar_storage_data_source.dart';

void main() {
  group('AvatarStorageDataSource isValidFileName', () {
    test('validates file names according to security rules', () {
      expect(AvatarStorageDataSource.isValidFileName(''), false);
      expect(AvatarStorageDataSource.isValidFileName('.'), false);
      expect(AvatarStorageDataSource.isValidFileName('..'), false);
      expect(AvatarStorageDataSource.isValidFileName('a/b'), false);
      expect(AvatarStorageDataSource.isValidFileName('../x'), false);
      expect(AvatarStorageDataSource.isValidFileName('avatar_1.jpg'), true);
    });
  });
}
