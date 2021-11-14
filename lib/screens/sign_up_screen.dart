import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:instagram_flutter02/common_widgets/instaDart_richText.dart';
import 'package:instagram_flutter02/services/api/auth_service.dart';
import 'package:instagram_flutter02/utilities/themes.dart';

class SignUpScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  String _email = "";
  String _password = "";
  BuildContext? _context;
  bool _isLoading = false;

  _submit() async {
    FocusScope.of(_context!).unfocus();
    _formKey.currentState?.save();
    if (!_isLoading) {
      _isLoading = true;
      print(_formKey.currentState!.validate());
      if (!_formKey.currentState!.validate()) return _isLoading = false;
      try {
        await AuthService.signUpUser(_email.trim(), _password.trim());
      } on PlatformException catch (err) {
        // _showErrorDialog(err.message!);
        throw (err);
      }
      _isLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    _context = context;

    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                InstaDartRichText(
                    kBillabongFamilyTextStyle.copyWith(fontSize: 50.0)),
                Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.always,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30.0, vertical: 10.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Email',
                          ),
                          validator: (input) => !input!.contains('@')
                              ? 'Please enter a valid email'
                              : null,
                          onSaved: (input) => _email = input!,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30.0, vertical: 10.0),
                        child: TextFormField(
                          decoration: InputDecoration(labelText: 'Password'),
                          obscureText: true,
                          validator: (input) => input!.length < 6
                              ? 'Password must be at least 6 characters'
                              : null,
                          onSaved: (input) => _password = input!,
                        ),
                      ),
                      SizedBox(height: 20.0),
                      Container(
                        width: 250.0,
                        child: FlatButton(
                          onPressed: _submit,
                          color: Colors.blue,
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            'Signup',
                            style: kFontColorWhiteSize18TextStyle,
                          ),
                        ),
                      ),
                      SizedBox(height: 20.0),
                      Container(
                        width: 250.0,
                        child: FlatButton(
                          onPressed: () => Navigator.pop(context),
                          color: Colors.blue,
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            'Back to Login',
                            style: kFontColorWhiteSize18TextStyle,
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
