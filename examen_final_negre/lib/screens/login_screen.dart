import 'package:flutter/material.dart';
import 'package:examen_final_negre/providers/db_provider.dart';
import 'package:examen_final_negre/providers/login_form_provider.dart';
import 'package:examen_final_negre/ui/input_decorations.dart';
import 'package:examen_final_negre/widgets/widgets.dart';
import 'package:provider/provider.dart';

/**
 * S'ha fet el widget en statefull per poder tenir en compte les dades guardades
 * No s'ha pogut implementar
 */
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthBackground(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 250),
              CardContainer(
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    Text(
                      'Login',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    SizedBox(height: 30),
                    ChangeNotifierProvider(
                      create: (_) => LoginFormProvider(),
                      child: _LoginForm(),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 50),

              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoginForm extends StatefulWidget {
  @override
  State<_LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<_LoginForm> {
  @override
  Widget build(BuildContext context) {
    final loginForm = Provider.of<LoginFormProvider>(context);
    final isLoggedIn = DBProvider.db.checkIsLogin();

    
    return Container(
      child: Form(
        key: loginForm.formKey,
        //TODO: Mantenir la referencia a la Key
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            TextFormField(
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(
                hintText: 'john.doe@gmail.com',
                labelText: 'Correu electrònic',
                prefixIcon: Icons.alternate_email_outlined,
              ),
              onChanged: (value) => loginForm.email = value,
              validator: (value) {
                String pattern =
                    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                RegExp regExp = new RegExp(pattern);
                return regExp.hasMatch(value!) ? null : 'No es de tipus correu';
              },
            ),
            SizedBox(height: 30),
            TextFormField(
              autocorrect: false,
              obscureText: true,
              keyboardType: TextInputType.visiblePassword,
              decoration: InputDecorations.authInputDecoration(
                hintText: '*****',
                labelText: 'Contrasenya',
                prefixIcon: Icons.lock_outline,
              ),
              onChanged: (value) => loginForm.password = value,
              validator: (value) {
                return (value != null && value.length >= 6)
                    ? null
                    : 'La contrasenya ha de ser de 6 caràcters';
              },
            ),
            SizedBox(height: 30),
            SwitchListTile.adaptive(
              value: loginForm.saveCredentials,
              title: Text('Disponible'),
              activeColor: Colors.indigo,
              onChanged: (value) => loginForm.saveCredentials = value,
            ),
            SizedBox(height: 30),
            MaterialButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              disabledColor: Colors.grey,
              elevation: 0,
              color: Colors.deepPurple,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                child: Text(
                  loginForm.isLoading ? 'Esperi' : 'Iniciar sessió',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              onPressed:
                  loginForm.isLoading
                      ? null
                      : () async {
                        // Deshabilitam el teclat
                        FocusScope.of(context).unfocus();
                        if (loginForm.saveCredentials) {
                          if (loginForm.isValidForm()) {
                            loginForm.isLoading = true;
                            await loginForm.loginUser(
                              loginForm.email,
                              loginForm.password,
                              loginForm.saveCredentials
                            );
                            loginForm.isLoading = false;
                            if (loginForm.accesGranted) {
                              Navigator.pushReplacementNamed(context, 'home');
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(loginForm.errorMessage)),
                              );
                            }
                          }
                        } else {
                          if (loginForm.isValidForm()) {
                            loginForm.isLoading = true;
                            await loginForm.loginUserWithoutSave(
                              loginForm.email,
                              loginForm.password,
                              loginForm.saveCredentials
                            );
                            loginForm.isLoading = false;
                            if (loginForm.accesGranted) {
                              Navigator.pushReplacementNamed(context, 'home');
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(loginForm.errorMessage)),
                              );
                            }
                          }
                        }
                      },
            ),
          ],
        ),
      ),
    );
  }
}
