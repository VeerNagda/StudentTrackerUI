import 'package:go_router/go_router.dart';
import 'package:ui/screens/AdminHomePage.dart';
import 'package:ui/screens/HomePage.dart';
import 'package:ui/screens/login_page.dart';
import 'package:ui/services/shared_service.dart';

// Import your screen widgets

// Define your routes in a separate file
class RouteConfig {
  static late bool isAuth;
  static GoRouter returnRouter(){

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
        ),
        GoRoute(
          path: '/admin',
          name: "admin",
          builder: (context, state) => const AdminHomePage(),
        ),
      ],
      //TODO add error page
      redirect: (context, state) async{
        await SharedService.isLoggedIn();
        isAuth = SharedService.isAuth;
        if(!isAuth && state.fullPath != "/"){
          return '/';
        }
        else if(isAuth && SharedService.role == 0){
          return '/admin';
        }
        else if(isAuth && SharedService.role == 1){
          return '/home';
        }
        return null;
      }
    );
  }
}
