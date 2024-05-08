import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:utterance_search_app/src/features/result/page.dart';
import 'package:utterance_search_app/src/features/upload/page.dart';
import 'package:utterance_search_app/src/routing/locations.dart';

final navigationKey = GlobalKey<NavigatorState>();

final goRouterProvider = Provider<GoRouter>(
  (ref) {
    return GoRouter(
      initialLocation: RouteLocation.upload,
      navigatorKey: navigationKey,
      debugLogDiagnostics: false,
      routes: appRoutes,
    );
  },
);

final appRoutes = <RouteBase>[
  GoRoute(
    path: RouteLocation.upload,
    builder: UploadPage.builder,
    routes: [
      GoRoute(
        path: RouteLocation.result,
        builder: ResultPage.builder,
      ),
    ],
  ),
];
