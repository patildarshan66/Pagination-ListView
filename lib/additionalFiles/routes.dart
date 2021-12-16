import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pagination_list_view/additionalFiles/screen_arguments.dart';
import 'package:pagination_list_view/authentication/view/authentication.dart';
import 'package:pagination_list_view/favoritePhotos/view/favorite_photos.dart';
import 'package:pagination_list_view/pagination/view/pagination_view.dart';
import 'package:pagination_list_view/pagination/view/photo_details_view.dart';

import '../main.dart';

abstract class MyRoutes {
  static const mainPage = "/";
  static const authentication = "/Authentication";
  static const favoriteItems = "/FavoriteItems";
  static const paginationView = "/PaginationView";
  static const photoDetailsView = "/PhotoDetailsView";
}

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    var name = settings.name;
    final args = settings.arguments as ScreenArguments;

    switch (name) {
      case MyRoutes.mainPage:
        return PageTransition(child: const MainPage(), settings: settings, type: null);
      case MyRoutes.favoriteItems:
        return PageTransition(child: const FavoritePhotos(), settings: settings, type: null);
      case MyRoutes.paginationView:
        return PageTransition(
            child: const PaginationView(), settings: settings, type: null);
      case MyRoutes.photoDetailsView:
        return PageTransition(
            child: PhotoDetailsView(args.modelPhoto), settings: settings, type: PageTransitionType.rightToLeft);
      case MyRoutes.authentication:
      default:
        return PageTransition(child: const Authentication(), settings: settings, type: null,);
    }
  }
}
