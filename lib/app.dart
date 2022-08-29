import 'package:flutter_hacker_news_app/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'blocs/stories_provider.dart';
import 'blocs/comments_provider.dart';
import 'screens/details_screen.dart';
import 'screens/home_screen.dart';
import 'package:get_storage/get_storage.dart';

class App extends StatelessWidget {

  @override
  Widget build(context) {
    return CommentsProvider(
      child: StoriesProvider(
        child: MaterialApp(
          title: 'Hacker News!',
          onGenerateRoute: routes,
          color: Colors.white,
        ),
      ),
    );
  }

  Route routes(RouteSettings settings) {
    final box = GetStorage();
    if (settings.name == '/') {
      return MaterialPageRoute(
        builder: (context) {
          // key is a key holder for
          print(box.read('key'));
          return box.read('key')==null? const LoginScreen()
          :const HomeScreen();
        }
      );
    } else {
      return MaterialPageRoute(
        builder: (context) {
          final commentsBloc = CommentsProvider.of(context);
          final itemId = int.parse(settings.name.replaceFirst('/', ''));

          commentsBloc.fetchItemWithComments(itemId);

            return DetailsScreen(
            itemId: itemId
          );
          }
      );
    }
  }
}
