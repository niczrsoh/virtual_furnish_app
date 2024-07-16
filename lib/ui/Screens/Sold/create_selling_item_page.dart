import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_3d_controller/flutter_3d_controller.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cube/flutter_cube.dart';
import 'package:image_picker/image_picker.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:o3d/o3d.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:virtual_furnish_app/bloc/Sold/create_selling_item_bloc.dart';
import 'package:virtual_furnish_app/data/model/MarketplaceProduct/product_model.dart';
import 'package:virtual_furnish_app/data/repo/Authentication/auth_repo.dart';
import 'package:virtual_furnish_app/enums/item_category.dart';
import 'package:virtual_furnish_app/main.dart';
import 'package:virtual_furnish_app/ui/Styles/color_styles.dart';
import 'package:virtual_furnish_app/ui/Widgets/custom_button.dart';
import 'package:virtual_furnish_app/ui/Widgets/custom_snackbar.dart';
import 'package:virtual_furnish_app/ui/Widgets/secondary_custom_button.dart';

class CreateSellingItemPage extends StatefulWidget {
  CreateSellingItemPage({super.key, required this.createSellingItemBloc});
  final CreateSellingItemBloc createSellingItemBloc;

  @override
  State<CreateSellingItemPage> createState() => _CreateSellingItemPageState();
}

class _CreateSellingItemPageState extends State<CreateSellingItemPage> {
  TextEditingController itemNameController = TextEditingController();

  TextEditingController priceController = TextEditingController();

  TextEditingController descriptionController = TextEditingController();
  Flutter3DController controller = Flutter3DController();
  TextEditingController locationController = TextEditingController();
  bool isButtonDisabled = false;
  List<File> selectedImages = [];
  bool isExistingModule = false;
  ItemCategory? category = ItemCategory.CHAIR;

  int? quantity = 1;

  File? selectedVideo;
  Image? _thumbnailImage;
  Uint8List? newPath;
  bool have3DModel = false;
  bool haveVideo = false;

  File? threeDimensionModel;
  //video
  Future<void> generateThumbnail(String videoPath) async {
    final uint8list = await VideoThumbnail.thumbnailData(
      video: videoPath,
      imageFormat: ImageFormat.JPEG,
      maxWidth: 128,
      quality: 75,
    );

    if (uint8list != null) {
      setState(() {
        _thumbnailImage = Image.memory(uint8list);
      });
    }
  }

  Future<void> _selectVideo() async {
    File video = await ImagePicker()
        .pickVideo(source: ImageSource.gallery)
        .then((value) => File(value!.path));
    setState(() {
      selectedVideo = video;
    });
    generateThumbnail(selectedVideo!.path);
  }

  Future<void> _selectImages() async {
    List<File> images = await getImages();

    setState(() {
      selectedImages = images;
    });
  }

  Future<List<File>> getImages() async {
    final List<XFile> pickedFiles = await ImagePicker().pickMultiImage();

    List<File> images = [];

    if (pickedFiles != null) {
      images = pickedFiles.map((XFile file) => File(file.path)).toList();
    } else {
      print('No images selected.');
    }

    return images;
  }

  Future<void> _add3DModel() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.any);
    if (result != null) {
      PlatformFile file = result.files.first;
      final appDir = await getApplicationDocumentsDirectory();
      final filePath = '${appDir.path}/${file.name}';

      // Copy the selected file to the app's documents directory
      final newFile = await File(file.path!).copy(filePath);
      final newPath = await File(newFile!.path ?? '').readAsBytes();

      setState(() {
        threeDimensionModel = newFile;
        this.newPath = newPath;
      });
    }
  }

    Future<String> _getFilePath() async {
    // For this example, we'll use a sample file stored in the app's document directory.
    // Replace this with the actual file path as needed.
    final directory = await getApplicationDocumentsDirectory();
    final filePath = 'storage/emulated/0/Android/data/com.example.virtual_furnish_app/files/Download/model.glb';

    // // Ensure the file exists (you might want to handle this more gracefully in a real app)
    // if (!File(filePath).existsSync()) {
    //   // Copy a sample file to the destination for demonstration purposes.
    //   final sampleFile = File('assets/model.glb');
    //   sampleFile.copySync(filePath);
    // }

    return filePath;
  }
  static final GlobalKey<FormState> _formSellingKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('Create Selling Item'),
        ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: BlocConsumer<CreateSellingItemBloc, CreateSellingItemState>(
            listener: (context, state) {
              if (state is CreateSellingItemLoading) {
                CustomSnackbar.showLoadingSnackbar(context, 'Adding Item');
              } else if (state is CreateSellingItemSuccess) {
                CustomSnackbar.showSuccessSnackbar(
                    context, 'Item added successfully');
                setState(() {
                  isButtonDisabled = false;
                });
              } else if (state is CreateSellingItemFailed) {
                CustomSnackbar.showFailSnackbar(context, 'Failed to add item');
                setState(() {
                  isButtonDisabled = false;
                });
              }
            },
            builder: (context, state) {
              return Center(
                  child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
                    key: _formSellingKey,
                    child: Column(
                      children: [
                        //image picker
                        Container(
                          height: 100,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(children: [
                              GestureDetector(
                                onTap: () {
                                  _selectImages();
                                },
                                child: Container(
                                    width: 100,
                                    height: 100,
                                    color: Colors.grey[300],
                                    child: Center(
                                        child: Text(
                                      '+ Add photos (Up to 5 photos)',
                                      textAlign: TextAlign.center,
                                    ))),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Container(
                                height: 100,
                                width: mq.width - 100,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  physics: const BouncingScrollPhysics(),
                                  itemCount: selectedImages.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    return Image.file(
                                      selectedImages[index],
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    );
                                  },
                                ),
                              ),
                            ]),
                          ),
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          controller: priceController,
                          //number only
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: const InputDecoration(
                            labelText: 'Price',
                            prefix: Text('RM '),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a price for the published furniture.';
                            }
                          },
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          controller: itemNameController,
                          decoration: const InputDecoration(
                            labelText: 'Item Name',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a name for the published furniture.';
                            }
                          },
                        ),
                        SizedBox(height: 10),
                        //Quantity with plus and minus button
                        Row(
                          children: [
                            Text('Quantity: '),
                            SizedBox(
                              width: 10,
                            ),
                            IconButton(
                              onPressed: () {
                                if (quantity != null) {
                                  setState(() {
                                    quantity = quantity! + 1;
                                  });
                                } else {
                                  quantity = 1;
                                }
                              },
                              icon: const Icon(Icons.add),
                            ),
                            Text(quantity.toString()),
                            IconButton(
                              onPressed: () {
                                if (quantity != null) {
                                  setState(() {
                                    quantity = quantity! - 1;
                                  });
                                } else {
                                  quantity = 1;
                                }
                              },
                              icon: const Icon(Icons.remove),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        //category dropdown
                        Row(children: [
                          Text('Category: '),
                          DropdownButton<ItemCategory>(
                            value: category,
                            onChanged: (ItemCategory? newValue) {
                              setState(() {
                                category = newValue;
                              });
                            },
                            items: ItemCategory.values
                                .map<DropdownMenuItem<ItemCategory>>(
                                    (ItemCategory value) {
                              return DropdownMenuItem<ItemCategory>(
                                value: value,
                                child: Text(value.toString().split('.').last),
                              );
                            }).toList(),
                          ),
                        ]),
                        SizedBox(height: 10),
                        //description
                        TextFormField(
                          controller: descriptionController,
                          maxLines: 5,
                          decoration: const InputDecoration(
                              labelText: 'Description',
                              hintText:
                                  'Describe what you are selling and includes details such as brand, warranty, and other T&C...'),
                           validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a description for the published furniture';
                            }
                          },
                        ),
                        SizedBox(height: 10),
                        //location
                        TextFormField(
                          controller: locationController,
                          decoration: const InputDecoration(
                            labelText: 'Location',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a location for the published furniture';
                            }else if(!value.contains(RegExp(r'^[a-zA-Z]'))){
                              return 'The location is invalid.';
                            }
                          },
                        ),
                        SizedBox(height: 10),
                        //switch for having 3d model or not
                        Row(
                          children: [
                            Text('Have 3D Model ?'),
                            Switch(
                                activeColor: CustomColor.vfPrimaryColor,
                                inactiveTrackColor:
                                    CustomColor.vfPrimaryColor.withOpacity(0.5),
                                value: have3DModel,
                                onChanged: (bool value) {
                                  setState(() {
                                    have3DModel = value;
                                  });
                                }),
                          ],
                        ),
                        //if have 3d model, show textfield for 3d model
                        if (have3DModel)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                '*The current 3d model should be in glb format only.',
                                style: TextStyle(fontSize: 10),
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  SecondaryCustomButton(
                                      width: mq.width * 0.4,
                                      onPressed: () async {
                                       var template = await Navigator.pushNamed(context, '/select_3d_template');
                                       if(template !=null){
                                       var result = await Navigator.pushNamed(
                                            context, '/3d_modelling');
                                      if(result != null){
                                        _getFilePath().then((value) async{
                                          threeDimensionModel =  File(value);
                                             newPath = await File(threeDimensionModel!.path ?? '').readAsBytes();
                                          setState(() {
                                            isExistingModule = true;
                                            threeDimensionModel =  File(value);
                                            this.newPath = newPath;
                                          });
                                      
                                        });}
                                      }
                                      },
                                      buttonText: '3D Modelling',
                                      isDisabled: isButtonDisabled),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  SecondaryCustomButton(
                                      width: mq.width * 0.4,
                                      onPressed: () {
                                        setState(() {
                                          isExistingModule = true;
                                        });
                                        _add3DModel();
                                      },
                                      buttonText: 'Existing Module',
                                      isDisabled: isButtonDisabled)
                                ],
                              ),
                            ],
                          ),
                        SizedBox(height: 10),
                        (have3DModel &&
                                isExistingModule &&
                                threeDimensionModel == null)
                            ? Container(
                                height: 100,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                    child: Text(
                                  '3D Model Added',
                                  textAlign: TextAlign.center,
                                )),
                              )
                            : (threeDimensionModel != null)
                                ? Container(
                                    child: GestureDetector(
                                      onTap: () {
                                        //open from other app
                    
                                        Navigator.pushNamed(
                                            context, '/3d_model_viewer',
                                            arguments: {
                                              'path': threeDimensionModel!.path
                                            });
                                      },
                                      child: Column(
                                        children: [
                                          Icon(Icons.file_present),
                                          Text(threeDimensionModel!.path
                                              .split('/')
                                              .last),
                                        ],
                                      ),
                                    ),
                                  )
                                : SizedBox(height: 10),
                        Row(
                          children: [
                            Text('Have A Video ?'),
                            Switch(
                                value: haveVideo,
                                activeColor: CustomColor.vfPrimaryColor,
                                inactiveTrackColor:
                                    CustomColor.vfPrimaryColor.withOpacity(0.5),
                                onChanged: (bool value) {
                                  setState(() {
                                    haveVideo = value;
                                  });
                                }),
                          ],
                        ),
                        SizedBox(height: 10),
                        //if have 3d model, show textfield for 3d model
                        (haveVideo &&
                                selectedVideo != null &&
                                _thumbnailImage != null)
                            ? GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(context, '/video_player',
                                      arguments: {'videoFile': selectedVideo});
                                },
                                child: _thumbnailImage)
                            :
                    
                            //add video container
                            GestureDetector(
                                onTap: () {
                                  _selectVideo();
                                },
                                child: Container(
                                    height: 100,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Center(
                                        child: Text(
                                      'Add A Video',
                                      textAlign: TextAlign.center,
                                    ))),
                              ),
                        SizedBox(height: 10),
                        CustomButton(
                          isDisabled: isButtonDisabled,
                          onPressed: () {
                            if (isButtonDisabled == false) {
                             
                              setState(() {
                                isButtonDisabled = true;
                              });
                                //validate first
                            CustomSnackbar.showLoadingSnackbar(context, "Validating Form ...");
                            bool result = _formSellingKey.currentState!.validate();
                            if(result==true){
                             //check if at least an img is selected
                            if(selectedImages.isEmpty){
                              CustomSnackbar.showFailSnackbar(context, 'Please select at least an image.');
                              setState(() {
                                isButtonDisabled = false;
                              });
                            }else{
                             CustomSnackbar.showLoadingSnackbar(
                                  context, 'Adding Item');
                              MarketplaceProductModel productModel =
                                  MarketplaceProductModel(
                                name: itemNameController.text.trim(),
                                category: category!.toString().split('.').last,
                                amount: quantity!,
                                buyers: 0,
                                description: descriptionController.text.trim(),
                                location: locationController.text.trim(),
                                images: selectedImages,
                                sellerID: AuthRepo.getCurrentUserId()!,
                                video: selectedVideo?.path,
                                price: double.parse(priceController.text.trim()),
                                threeDimensionModel: threeDimensionModel?.path,
                              );
                              //for dev checking
                              debugPrint(productModel.toString());
                              //add item to firestore
                              widget.createSellingItemBloc.add(AddProduct(
                                name: itemNameController.text.trim(),
                                price: double.parse(priceController.text.trim()),
                                description: descriptionController.text.trim(),
                                location: locationController.text.trim(),
                                category: category!.toString().split('.').last,
                                amount: int.parse(quantity.toString()),
                                images: selectedImages,
                                video: selectedVideo?.path,
                                sellerID: AuthRepo.getCurrentUserId()!,
                                buyers: 0,
                                threeDimensionModel: threeDimensionModel?.path,
                              ));}
                            }else{
                              CustomSnackbar.showFailSnackbar(context, 'Validate fail. Please check the form again.');
                              setState(() {
                                isButtonDisabled = false;
                              });
                            }}
                          },
                          buttonText: 'Create Selling Item',
                        ),
                      ],
                    ),
                  ),
                ),
              ));
            },
          ),
        ));
  }
}
