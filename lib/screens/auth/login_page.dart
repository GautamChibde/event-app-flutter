import 'package:eventapp/screens/auth/bloc/auth_bloc.dart';
import 'package:eventapp/screens/auth/password_reset_confirm_dialog.dart';
import 'package:eventapp/screens/auth/password_reset_dialog.dart';
import 'package:eventapp/screens/auth/signup_page.dart';
import 'package:eventapp/screens/event/events_page.dart';
import 'package:eventapp/screens/user_edit/edit_user_profile_page.dart';
import 'package:eventapp/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';

class LoginPage extends StatefulWidget {
  static const kRoute = "/login";

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  AuthBloc _authBloc = new AuthBloc();
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    _authBloc.add(CheckUserEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      listener: (context, state) {
        if (state is LoggedInSuccessState) {
          Navigator.of(context).pushNamed(
            EditUserProfilePage.kRoute,
            arguments: state.user,
          );
        } else if (state is ProfileCreatedState) {
          Navigator.of(context).pushNamedAndRemoveUntil(
            EventsPage.kRoute,
            (Route<dynamic> route) => false,
          );
        }
      },
      bloc: _authBloc,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Login"),
        ),
        backgroundColor: Colors.white,
        body: _body(context),
      ),
    );
  }

  Container _body(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _email(),
            SizedBox(height: 12),
            _password(),
            SizedBox(height: 12),
            _loginButton(),
            _signUpButton(context),
            _forgotPassword(context),
            SizedBox(height: 12),
            _errorMessage()
          ],
        ),
      ),
    );
  }

  Widget _loginButton() {
    return MaterialButton(
      child: StreamBuilder(
        stream: _authBloc.loading,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Text("Error");
          if (snapshot.data) {
            return CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            );
          }
          return Text("Log In".toUpperCase());
        },
      ),
      color: Colors.green,
      textColor: Colors.white,
      onPressed: () => _onLogin(),
    );
  }

  _errorMessage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Center(
        child: StreamBuilder<Object>(
          stream: _authBloc.errorMessage,
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.data == null) return Container();
            return Text(
              snapshot.data,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.redAccent, fontWeight: FontWeight.w600),
            );
          },
        ),
      ),
    );
  }

  FlatButton _signUpButton(BuildContext context) {
    return FlatButton(
      child: Text("Sign Up"),
      textColor: Colors.green,
      onPressed: () {
        Navigator.of(context).pushNamed(SignUpPage.kRoute);
      },
    );
  }

  TextFormField _password() {
    return TextFormField(
      controller: _passwordController,
      obscureText: true,
      decoration: InputDecoration(
        labelText: "Password",
        hintText: "Password",
        border: OutlineInputBorder(
          borderRadius: new BorderRadius.circular(8.0),
          borderSide: new BorderSide(),
        ),
      ),
    );
  }

  TextFormField _email() {
    return TextFormField(
      controller: _emailController,
      validator: (input) {
        if (Validator.validEmail(input)) {
          return null;
        }
        return "Invalid email";
      },
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: "Email",
        hintText: "Enter company email address",
        border: OutlineInputBorder(
          borderRadius: new BorderRadius.circular(8.0),
          borderSide: new BorderSide(),
        ),
      ),
    );
  }

  _onLogin() {
    if (_formKey.currentState.validate()) {
      _authBloc.login(_emailController.text, _passwordController.text);
    }
  }

  _forgotPassword(BuildContext context) {
    return InkWell(
      onTap: () => {
        showPlatformDialog(
          context: context,
          builder: (BuildContext context) {
            return PasswordResetDialog(
              onSubmit: (email) async {
                await _authBloc.resetPassword(email);
                Navigator.pop(context);
                showPlatformDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return PasswordResetConfirmDialog(email: email);
                    });
              },
            );
          },
        ),
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Text(
            "Forgot password?",
            style: TextStyle(color: Colors.redAccent),
          ),
        ),
      ),
    );
  }
}
