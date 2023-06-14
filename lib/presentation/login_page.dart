import 'package:ecatalog/bloc/login/login_bloc.dart';
import 'package:ecatalog/data/datasources/local_datasource.dart';
import 'package:ecatalog/data/models/request/login_request_model.dart';
import 'package:ecatalog/presentation/home_page.dart';
import 'package:ecatalog/presentation/register_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController? emailController;
  TextEditingController? passwordController;

  @override
  void initState() {
    checkAuth();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    super.initState();
  }

  void checkAuth() async {
    final auth = await LocalDatasource().getToken();
    if (auth.isNotEmpty) {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return const HomePage();
      }));
    }
  }

  @override
  void dispose() {
    super.dispose();
    emailController!.dispose();
    passwordController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login Page"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Center(child: Text("Login Page")),
            const SizedBox(
              height: 30,
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: "Email",
              ),
            ),
            TextField(
              obscureText: true,
              controller: passwordController,
              decoration: const InputDecoration(
                labelText: "Password",
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            BlocConsumer<LoginBloc, LoginState>(
              builder: (context, state) {
                if (state is LoginLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return ElevatedButton(
                    onPressed: () {
                      final requestModel = LoginRequestModel(
                          email: emailController!.text,
                          password: passwordController!.text);
                      context.read<LoginBloc>().add(
                            DoLoginEvent(model: requestModel),
                          );
                    },
                    child: const Text('Login'));
              },
              listener: (context, state) {
                if (state is LoginError) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.red,
                  ));
                }

                if (state is LoginLoaded) {
                  LocalDatasource().saveToken(state.model.accessToken);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                        'Login Success with id: ${state.model.accessToken}'),
                    backgroundColor: Colors.blue,
                  ));
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const HomePage();
                  }));
                }
              },
            ),
            const SizedBox(
              height: 16,
            ),
            InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) {
                  return const RegisterPage();
                }));
              },
              child: const Text('Belum punya akun? Register'),
            )
            // BlocListener<RegisterBloc, RegisterState>(
            //   listener: (context, state) {
            //     if (state is RegisterError) {
            //       ScaffoldMessenger.of(context).showSnackBar(
            //         SnackBar(
            //           content: Text(state.message),
            //           backgroundColor: Colors.red,
            //         ),
            //       );
            //     }
            //     if (state is RegisterLoaded) {
            //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            //         content:
            //             Text("Register Success with id: ${state.model.id}"),
            //         backgroundColor: Colors.blue,
            //       ));
            //       Navigator.of(context).push(MaterialPageRoute(
            //           builder: (context) => const HomePage()));
            //     }
            //   },
            //   child: BlocBuilder<RegisterBloc, RegisterState>(
            //     builder: (context, state) {
            //       if (state is RegisterLoading) {
            //         return const Center(child: CircularProgressIndicator());
            //       }
            //       return ElevatedButton(
            //           onPressed: () {
            //             final requestModel = RegisterRequestModel(
            //               name: nameController!.text,
            //               email: emailController!.text,
            //               password: passwordController!.text,
            //             );
            //             context.read<RegisterBloc>().add(
            //                   DoRegisterEvent(model: requestModel),
            //                 );
            //           },
            //           child: const Text("Register"));
            //     },
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
