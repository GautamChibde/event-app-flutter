import 'package:eventapp/screens/auth/bloc/auth_bloc.dart';
import 'package:eventapp/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpPage extends StatefulWidget {
  static const kRoute = "/signup";
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  AuthBloc _authBloc = new AuthBloc();

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      listener: (context, state) {
        if (state is SignUpSuccessState) {
          Navigator.of(context).pop();
        }
      },
      bloc: _authBloc,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Sign Up"),
        ),
        backgroundColor: Colors.white,
        body: Container(
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
                _confirmPassword(),
                SizedBox(height: 12),
                _signUpButton(),
                SizedBox(height: 12),
                _errorMessage()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _signUpButton() {
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
            return Text("Sign Up".toUpperCase());
          }),
      color: Colors.green,
      textColor: Colors.white,
      onPressed: () => _onSignUp(),
    );
  }

  TextFormField _email() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      validator: (input) {
        if (!Validator.validEmail(input)) {
          return "invalid email";
        }
        return null;
      },
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

  TextFormField _confirmPassword() {
    return TextFormField(
      controller: _confirmPasswordController,
      validator: (input) {
        if (_passwordController.text == input) {
          return null;
        }
        return "password dont match";
      },
      obscureText: true,
      decoration: InputDecoration(
        labelText: "confirm password",
        hintText: "confirm password",
        border: OutlineInputBorder(
          borderRadius: new BorderRadius.circular(8.0),
          borderSide: new BorderSide(),
        ),
      ),
    );
  }

  _onSignUp() {
    if (_formKey.currentState.validate()) {
      _authBloc.signUp(_emailController.text, _passwordController.text);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  _errorMessage() {
    return Center(
      child: StreamBuilder<Object>(
        stream: _authBloc.errorMessage,
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data == null) return Container();
          return Text(
            snapshot.data,
            style:
                TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w600),
          );
        },
      ),
    );
  }
}
