import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/http_exception.dart';
import '../providers/auth.dart';

enum AuthMode { Signup, Login }

class AuthScreen extends StatelessWidget {
  static const routeName = '/auth';

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    // final transformConfig = Matrix4.rotationZ(-8 * pi / 180);
    // transformConfig.translate(-10.0);
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(215, 117, 255, 1).withOpacity(0.5),
                  Color.fromRGBO(255, 188, 117, 1).withOpacity(0.9),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0, 1],
              ),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              height: deviceSize.height,
              width: deviceSize.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    child: Container(
                      margin: EdgeInsets.only(bottom: 20.0),
                      padding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 94.0),
                      transform: Matrix4.rotationZ(-8 * pi / 180) // pi is provided by dart // rotationZ you can say like that it's a center
                        ..translate(-10.0), // helps to give the tilt effect
                      // ..translate(-10.0), // .. not return result of translate but of previous function return data now we just translate or shift the  the matrix position little bit and then send the matrix back
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.deepOrange.shade900,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 8,
                            color: Colors.black26,
                            offset: Offset(0, 2),
                          )
                        ],
                      ),
                      child: Text(
                        'MyShop',
                        style: TextStyle(
                          color: Theme.of(context).accentTextTheme.title.color,
                          fontSize: 50,
                          fontFamily: 'Anton',
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: deviceSize.width > 600 ? 2 : 1,
                    child: AuthCard(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  const AuthCard({
    Key key,
  }) : super(key: key);

  @override
  _AuthCardState createState() => _AuthCardState();
}

// SingleTickerProviderStateMixin helps to use the _controller to animate
class _AuthCardState extends State<AuthCard> /*with SingleTickerProviderStateMixin */{
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.Login;
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  var _isLoading = false;
  final _passwordController = TextEditingController();
  // AnimationController _controller; // helps to controlling animations
  // Animation<Size> _heightAnimation; // <Size> means we want to animate the size

  @override
  void initState() {
    super.initState();
    // _controller = AnimationController(
    //   vsync: this,  // this means animate this widget
    //   duration: Duration(milliseconds: 300), 
    // );

    // // <Size> we animate the size
    // _heightAnimation = Tween<Size>( // tween helps how to animate between two values
    //   begin: Size(double.infinity, 260), // setting the begin width and height
    //   end: Size(double.infinity, 320),     // setting at end what the width and height       
    // ).animate(CurvedAnimation(
    //   parent: _controller,          // setting the controller which contain for which this animation is and duration
    //   curve: Curves.fastOutSlowIn, // setting the animation type
    // ));

    // so adding listenere so that when animate begines we will rebuilt the widget for animate
    //_heightAnimation.addListener(() => setState(() {}));

  }

  @override
  void dispose() {
    super.dispose();
    //_controller.dispose(); // disposing the animate controller
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context, 
      builder: (ctx) => AlertDialog(
        title: Text('An Error Occured!'),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            }, 
            child: Text('Okay'),
          ),
        ],
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });

    try{
      if (_authMode == AuthMode.Login) {
        // Log user in
        await Provider.of<Auth>(context, listen: false).login(
          _authData['email'], 
          _authData['password']
        );
      } else {
        // Sign user up
        await Provider.of<Auth>(context, listen: false).signup(
          _authData['email'], 
          _authData['password']
        );
      }
    } on HttpException catch(error) { // if we fail validation of data then this error will triegger
      print('Error is there $error');
      var errMessage = 'Authentication Failed';
      if (error.toString().contains('EMAIL_EXISTS')) {
        errMessage = 'This email address is already in use.'; 
      } else if (error.toString().contains('INVALID_EMAIL')) {
        errMessage = 'This is not a valid email address';
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        errMessage = 'Password is too weak';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errMessage = 'Could not find a user with this email';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errMessage = 'Invalid password.';
      }
      _showErrorDialog(errMessage);
    } catch (error) { // this error will take place when there is no proper network connection
      // catch error will occur like before reaching the request but HttpExcception is occur when we response and through error from there
      const errMessage = 'Could not login please try again letter!';
      _showErrorDialog(errMessage);
    }
    
    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
      //_controller.forward(); // starts the animation
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
      //_controller.reverse(); // here we reverse the animation
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 8.0, 
      child: AnimatedContainer( // AnimatedContainer will auto detect the change and the show it in animated way you just need to set duration and curve
        duration: Duration(milliseconds: 300), // setting total duration of animation
        curve: Curves.easeIn, // setting animation type
        height: _authMode == AuthMode.Signup ? 320 : 260,
        //height: _heightAnimation.value.height,
        constraints: //BoxConstraints(minHeight: _heightAnimation.value.height),
            BoxConstraints(minHeight: _authMode == AuthMode.Signup ? 320 : 260),
        width: deviceSize.width * 0.75,
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(labelText: 'E-Mail'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value.isEmpty || !value.contains('@')) {
                      return 'Invalid email!';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _authData['email'] = value;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  controller: _passwordController,
                  validator: (value) {
                    if (value.isEmpty || value.length < 5) {
                      return 'Password is too short!';
                    }
                  },
                  onSaved: (value) {
                    _authData['password'] = value;
                  },
                ),
                if (_authMode == AuthMode.Signup)
                  TextFormField(
                    enabled: _authMode == AuthMode.Signup,
                    decoration: InputDecoration(labelText: 'Confirm Password'),
                    obscureText: true,
                    validator: _authMode == AuthMode.Signup
                        ? (value) {
                            if (value != _passwordController.text) {
                              return 'Passwords do not match!';
                            }
                          }
                        : null,
                  ),
                SizedBox(
                  height: 20,
                ),
                if (_isLoading)
                  CircularProgressIndicator()
                else
                  RaisedButton(
                    child:
                        Text(_authMode == AuthMode.Login ? 'LOGIN' : 'SIGN UP'),
                    onPressed: _submit,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding:
                        EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
                    color: Theme.of(context).primaryColor,
                    textColor: Theme.of(context).primaryTextTheme.button.color,
                  ),
                FlatButton(
                  child: Text(
                      '${_authMode == AuthMode.Login ? 'SIGNUP' : 'LOGIN'} INSTEAD'),
                  onPressed: _switchAuthMode,
                  padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 4),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  textColor: Theme.of(context).primaryColor,
                ),
              ],
            ),
          ),
        ),
      ),  
    );
  }
}
