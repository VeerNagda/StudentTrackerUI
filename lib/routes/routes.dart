import 'package:go_router/go_router.dart';
import 'package:path/path.dart';
import 'package:ui/models/event/DetailedEventAttendanceReport.dart';
import 'package:ui/screens/AddGroup.dart';
import 'package:ui/screens/AddSingleUser.dart';
import 'package:ui/screens/AdminHomePage.dart';
import 'package:ui/screens/DetailAttendaceReport.dart';
import 'package:ui/screens/HomePage.dart';
import 'package:ui/screens/TakePictureScreen.dart';
import 'package:ui/screens/event_form.dart';
import 'package:ui/screens/login_page.dart';
import 'package:ui/screens/map.dart';
import 'package:ui/services/shared_service.dart';

// Import your screen widgets

// Define your routes in a separate file
class RouteConfig {
  static late bool isAuth;

  static GoRouter returnRouter() {
    return GoRouter(
        // Define your routes
        initialLocation: '/',
        routes: [
          // Home route
          GoRoute(
            path: '/',
            name: 'login',
            builder: (context, state) => const LoginPage(),
          ),
          GoRoute(
              path: '/home',
              name: "home",
              builder: (context, state) => const HomePage(),
              routes: [
                GoRoute(
                    path: "verify-user",
                    name: "verify-user",
                    builder: (context, state) => const TakePictureScreen())
              ]),
          GoRoute(
              path: '/admin',
              name: "admin",
              builder: (context, state) => const AdminHomePage(),
              routes: [
                GoRoute(
                  path: "add-venue",
                  name: "add-venue",
                  builder: (context, state) => const MapScreen(),
                ),
                GoRoute(
                  path: "single-user",
                  name: "single-user",
                  builder: (context, state) => AddSingleUserPage(
                      sapId: state.uri.queryParameters["sapId"]),
                ),
                GoRoute(
                  path: "bulk-user",
                  name: "bulk-user",
                  builder: (context, state) => const AddGroup(),
                ),
                GoRoute(
                  path: "add-event",
                  name: "add-event",
                  builder: (context, state) =>
                      EventForm(eventId: state.uri.queryParameters["eventId"]),
                ),
                GoRoute(
                    path: "attendance-detail",
                    name: "attendance-detail",
                    builder: (context, state) => DetailAttendaceReportState(
                        eventID: state.uri.queryParameters["eventID"]))
              ]),
        ],
        //TODO add error page
        redirect: (context, state) async {
          await SharedService.isLoggedIn();
          isAuth = SharedService.isAuth;
          if (!isAuth) {
            return '/';
          } else if (state.fullPath!.contains("/admin") ||
              SharedService.role == 0) {
            if (state.fullPath!.split('/').length < 3) {
              return '/admin';
            } else {
              return null;
            }
          } else if (state.fullPath!.contains("/home") ||
              SharedService.role == 1) {
            if (state.fullPath!.split('/').length < 3) {
              return '/home';
            } else {
              return null;
            }
          }
          return null;
        });
  }
}
