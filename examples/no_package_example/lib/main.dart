import 'package:flutter/material.dart';
import 'package:no_package_example/pages/details.dart';
import 'package:no_package_example/pages/home.dart';
import 'package:responsive_layout/common_layout.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      onGenerateRoute: (settings) {
        // TODO: Why we have to wrap around each route
        switch (settings.name) {
          case '/': return MaterialPageRoute(builder: (context) {
          return LayoutResolverWidget(resolver: _resolverIn(context), child: HomePage());
        });
          case '/details': return MaterialPageRoute(builder: (context) {
          return LayoutResolverWidget(resolver: _resolverIn(context), child: DetailsPage());
        }, fullscreenDialog: true);
        default: 
          throw 'No route with name ${settings.name}';
        }
      },
    );
  }
  
  // TODO: Shouldn't we go for a smallestSide instead of always width?
  LayoutResolver _resolverIn(BuildContext context) => CommonLayout(context.deviceWidth);
}