import 'package:ecatalog/bloc/add_product/add_product_bloc.dart';
import 'package:ecatalog/bloc/products/products_bloc.dart';
import 'package:ecatalog/data/datasources/local_datasource.dart';
import 'package:ecatalog/data/models/request/product_request_model.dart';
import 'package:ecatalog/presentation/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController? titleController;
  TextEditingController? priceController;
  TextEditingController? descriptionController;

  @override
  void initState() {
    titleController = TextEditingController();
    priceController = TextEditingController();
    descriptionController = TextEditingController();
    super.initState();
    context.read<ProductsBloc>().add(GetProductsEvent());
  }

  @override
  void dispose() {
    super.dispose();
    titleController!.dispose();
    priceController!.dispose();
    descriptionController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
        centerTitle: true,
        leading: const SizedBox(),
        actions: [
          IconButton(
            onPressed: () async {
              await LocalDatasource().removeToken();
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                  (route) => false);
            },
            icon: const Icon(Icons.logout),
          ),
          const SizedBox(width: 10)
        ],
      ),
      body: BlocBuilder<ProductsBloc, ProductsState>(
        builder: (context, state) {
          if (state is ProductsLoaded) {
            return ListView.builder(
              itemBuilder: ((context, index) {
                return Card(
                  shadowColor: Colors.transparent,
                  child: ListTile(
                    title: Text(
                      state.data.reversed.toList()[index].title ?? '-',
                    ),
                    subtitle: Text(
                      '${state.data[index].price}\$',
                    ),
                  ),
                );
              }),
              itemCount: state.data.length,
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Add Product'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: titleController,
                        decoration: const InputDecoration(
                          labelText: 'Title',
                        ),
                      ),
                      TextField(
                        controller: priceController,
                        decoration: const InputDecoration(
                          labelText: 'Price',
                        ),
                      ),
                      TextField(
                        controller: descriptionController,
                        decoration: const InputDecoration(
                          labelText: 'Description',
                        ),
                        maxLength: 3,
                      ),
                    ],
                  ),
                  actions: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Cancel'),
                    ),
                    BlocConsumer<AddProductBloc, AddProductState>(
                      listener: (context, state) {
                        if (state is AddProductLoaded) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              backgroundColor: Colors.amber,
                              content: Text('Product added'),
                            ),
                          );
                          context.read<ProductsBloc>().add(GetProductsEvent());
                          Navigator.pop(context);
                        }
                        if (state is AddProductError) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.amber,
                              content: Text(state.message ?? 'Error'),
                            ),
                          );
                        }
                      },
                      builder: (context, state) {
                        if (state is AddProductLoading) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        return ElevatedButton(
                          onPressed: () {
                            final ProductRequestModel model =
                                ProductRequestModel(
                              title: titleController!.text,
                              price: int.parse(priceController!.text),
                              description: descriptionController!.text,
                            );
                            context.read<AddProductBloc>().add(
                                  DoAddProductEvent(model: model),
                                );
                          },
                          child: const Text('Add'),
                        );
                      },
                    ),
                  ],
                );
              });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
