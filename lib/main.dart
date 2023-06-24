import 'package:ecatalog/bloc/add_catalog/add_catalog_cubit.dart';
import 'package:ecatalog/bloc/add_product/add_product_bloc.dart';
import 'package:ecatalog/bloc/login/login_bloc.dart';
import 'package:ecatalog/bloc/products/products_bloc.dart';
import 'package:ecatalog/bloc/register/register_bloc.dart';
import 'package:ecatalog/data/datasources/auth_datasource.dart';
import 'package:ecatalog/data/datasources/product_datasource.dart';
import 'package:ecatalog/presentation/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => RegisterBloc(AuthDatasource()),
        ),
        BlocProvider(
          create: (context) => LoginBloc(AuthDatasource()),
        ),
        BlocProvider(
          create: (context) => ProductsBloc(ProductDataSource()),
        ),
        BlocProvider(
          create: (context) => AddProductBloc(ProductDataSource()),
        ),
        BlocProvider(
          create: (context) => AddCatalogCubit(ProductDataSource()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'E-Catalog',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const LoginPage(),
      ),
    );
  }
}
