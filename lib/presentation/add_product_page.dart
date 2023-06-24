import 'dart:io';

import 'package:camera/camera.dart';
import 'package:ecatalog/bloc/add_catalog/add_catalog_cubit.dart';
import 'package:ecatalog/data/models/request/product_request_model.dart';
import 'package:ecatalog/presentation/camera_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  TextEditingController? titleController;
  TextEditingController? priceController;
  TextEditingController? descriptionController;

  XFile? image;
  List<XFile>? images;

  void takePicture(XFile image) {
    this.image = image;
    setState(() {});
  }

  void takeMultiplePicture(List<XFile> images) {
    this.images = images;
    setState(() {});
  }

  @override
  void initState() {
    titleController = TextEditingController();
    priceController = TextEditingController();
    descriptionController = TextEditingController();
    super.initState();
  }

  Future<void> getImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? photo = await picker.pickImage(
      source: source,
      imageQuality: 50,
    );

    if (photo != null) {
      image = photo;
      setState(() {});
    }
  }

  Future<void> getMultipleImage() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile> photos = await picker.pickMultiImage();
    images = photos;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Product Page"),
      ),
      body: ListView(
        children: [
          image != null
              ? Container(
                  margin: const EdgeInsets.symmetric(horizontal: 30),
                  height: 200,
                  width: 200,
                  child: Image.file(File(image!.path)))
              : Container(
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(border: Border.all()),
                ),
          images != null
              ? SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      ...images!
                          .map((e) => SizedBox(
                                width: 100,
                                height: 120,
                                child: Image.file(File(e.path)),
                              ))
                          .toList()
                    ],
                  ),
                )
              : const SizedBox(),
          const SizedBox(
            height: 8,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                  onPressed: () async {
                    await availableCameras().then((value) =>
                        Navigator.push(context, MaterialPageRoute(builder: (_) {
                          return CameraPage(
                            takePicture: takePicture,
                            cameras: value,
                          );
                        })));
                  },
                  child: const Text("Camera")),
              ElevatedButton(
                  onPressed: () {
                    getImage(ImageSource.gallery);
                    // getMultipleImage();
                  },
                  child: const Text("Gallery")),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 30,
            ),
            child: Column(
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
                  maxLines: 3,
                ),
                const SizedBox(height: 10),
                BlocListener<AddCatalogCubit, AddCatalogState>(
                  listener: (context, state) {
                    state.maybeWhen(
                      orElse: () {},
                      loaded: (model) {
                        debugPrint(model.toString());
                        Navigator.pop(context);
                      },
                    );
                  },
                  child: BlocBuilder<AddCatalogCubit, AddCatalogState>(
                    builder: (context, state) {
                      return state.maybeWhen(
                        orElse: () {
                          return ElevatedButton(
                            onPressed: () {
                              final ProductRequestModel model =
                                  ProductRequestModel(
                                title: titleController!.text,
                                price: int.parse(priceController!.text),
                                description: descriptionController!.text,
                              );
                              context.read<AddCatalogCubit>().addCatalog(
                                    model,
                                    image!,
                                  );
                            },
                            child: const Text('Submit'),
                          );
                        },
                        loading: () {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
