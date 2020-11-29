import 'package:flutter/material.dart';

// this class will help to give animation when we create on the fly route with push
//MaterialPageRoute if you remeber we use this when we make on fly route
class CustomRoute<T> extends MaterialPageRoute<T> { // <T> helps to indentify that it's the generic class 
  CustomRoute({WidgetBuilder builder, RouteSettings settings}) 
  : super(
    builder: builder,
    settings: settings,
  );

  @override
  Widget buildTransitions(
    BuildContext context, 
    Animation<double> animation, 
    Animation<double> secondaryAnimation, 
    Widget child
  ) {
    
    // if we are at initial route we normally return the page
    // if we are at another we add the fade animation
    if (settings.name == '/') {
      return child;
    }
    
    return FadeTransition(
        opacity: animation,
        child: child,
    );
  }
}

// this class will give animation pushNamed routes
class CustomPageTransitionBuilder extends PageTransitionsBuilder {
  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context, 
    Animation<double> animation, 
    Animation<double> secondaryAnimation, 
    Widget child
  ) {
    
    // if we are at initial route we normally return the page
    // if we are at another we add the fade animation
    if (route.settings.name == '/') {
      return child;
    }
    
    return FadeTransition(
        opacity: animation,
        child: child,
    );
  }
}