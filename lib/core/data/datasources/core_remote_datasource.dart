import 'package:injectable/injectable.dart';

abstract class CoreRemoteDatasource {}

@LazySingleton(as: CoreRemoteDatasource)
class CoreRemoteDatasourceImpl implements CoreRemoteDatasource {}
