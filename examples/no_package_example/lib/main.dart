import 'package:flutter/material.dart';
import 'package:no_package_example/pages/details.dart';
import 'package:no_package_example/pages/home.dart';
import 'package:responsive_layout/common_layout.dart';

void main() {
  final commonLayout = CommonLayout();
  
  runApp(MaterialApp(
      initialRoute: '/',
      onGenerateRoute: (settings) {
        // TODO: Why we have to wrap around each route
        switch (settings.name) {
          case '/': return MaterialPageRoute(builder: (context) {
          return LayoutResolverWidget(resolver: commonLayout, child: HomePage());
        });
          case '/details': return MaterialPageRoute(builder: (context) {
          return LayoutResolverWidget(resolver: commonLayout, child: DetailsPage());
        }, fullscreenDialog: true);
        default: 
          throw 'No route with name ${settings.name}';
        }
      },
    ),);
}