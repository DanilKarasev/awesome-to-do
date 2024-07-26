import 'package:flutter/widgets.dart';

import '../app/bloc/app_bloc.dart';
import '../features/home/presentation/pages/home_page.dart';
import '../features/login/presentation/pages/login_page.dart';

List<Page<dynamic>> onGenerateAppViewPages(
  AppStatus state,
  List<Page<dynamic>> pages,
) {
  switch (state) {
    case AppStatus.authenticated:
      return [HomePage.page()];
    case AppStatus.unauthenticated:
      return [LoginPage.page()];
  }
}
