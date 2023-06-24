import 'package:ecatalog/bloc/products/products_bloc.dart';
import 'package:ecatalog/data/datasources/local_datasource.dart';
import 'package:ecatalog/presentation/add_product_page.dart';
import 'package:ecatalog/presentation/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // TextEditingController? titleController;
  // TextEditingController? priceController;
  // TextEditingController? descriptionController;

  final scrollController = ScrollController();

  @override
  void initState() {
    // titleController = TextEditingController();
    // priceController = TextEditingController();
    // descriptionController = TextEditingController();
    super.initState();
    context.read<ProductsBloc>().add(GetProductsEvent());
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        context.read<ProductsBloc>().add(NextProductsEvent());
      }
    });
  }

  // @override
  // void dispose() {
  //   super.dispose();
    // titleController!.dispose();
    // priceController!.dispose();
    // descriptionController!.dispose();
  // }

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
              context.read<ProductsBloc>().add(ClearProductsEvent());
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
              padding: const EdgeInsets.symmetric(horizontal: 10),
              controller: scrollController,
              itemBuilder: ((context, index) {
                if (state.isNext && index == state.data.length) {
                  return const Padding(
                    padding: EdgeInsets.all(20),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
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
              itemCount:
                  state.isNext ? state.data.length + 1 : state.data.length,
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) {
            return const AddProductPage();
          }));
          // showDialog(
          //     context: context,
          //     builder: (context) {
          //       return AlertDialog(
          //         title: const Text('Add Product'),
          //         content: Column(
          //           mainAxisSize: MainAxisSize.min,
          //           children: [
          //             TextField(
          //               controller: titleController,
          //               decoration: const InputDecoration(
          //                 labelText: 'Title',
          //               ),
          //             ),
          //             TextField(
          //               controller: priceController,
          //               decoration: const InputDecoration(
          //                 labelText: 'Price',
          //               ),
          //             ),
          //             TextField(
          //               controller: descriptionController,
          //               decoration: const InputDecoration(
          //                 labelText: 'Description',
          //               ),
          //               maxLength: 3,
          //             ),
          //           ],
          //         ),
          //         actions: [
          //           ElevatedButton(
          //             onPressed: () {
          //               Navigator.pop(context);
          //             },
          //             child: const Text('Cancel'),
          //           ),
          //           BlocConsumer<AddProductBloc, AddProductState>(
          //             listener: (context, state) {
          //               if (state is AddProductLoaded) {
          //                 ScaffoldMessenger.of(context).showSnackBar(
          //                   const SnackBar(
          //                     backgroundColor: Colors.amber,
          //                     content: Text('Product added'),
          //                   ),
          //                 );
          //                 // context.read<ProductsBloc>().add(GetProductsEvent());
          //                 context
          //                     .read<ProductsBloc>()
          //                     .add(AddSingleProductEvent(model: state.data));
          //                 Navigator.pop(context);
          //               }
          //               if (state is AddProductError) {
          //                 ScaffoldMessenger.of(context).showSnackBar(
          //                   SnackBar(
          //                     backgroundColor: Colors.amber,
          //                     content: Text(state.message),
          //                   ),
          //                 );
          //               }
          //             },
          //             builder: (context, state) {
          //               if (state is AddProductLoading) {
          //                 return const Center(
          //                     child: CircularProgressIndicator());
          //               }
          //               return ElevatedButton(
          //                 onPressed: () {
          //                   final ProductRequestModel model =
          //                       ProductRequestModel(
          //                     title: titleController!.text,
          //                     price: int.parse(priceController!.text),
          //                     description: descriptionController!.text,
          //                   );
          //                   context.read<AddProductBloc>().add(
          //                         DoAddProductEvent(model: model),
          //                       );
          //                 },
          //                 child: const Text('Add'),
          //               );
          //             },
          //           ),
          //         ],
          //       );
          //     });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
