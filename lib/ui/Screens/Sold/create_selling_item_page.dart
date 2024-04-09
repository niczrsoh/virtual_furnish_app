

import 'dart:io';
import 'dart:math';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cube/flutter_cube.dart';
import 'package:image_picker/image_picker.dart';
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

   TextEditingController locationController = TextEditingController();
    bool isButtonDisabled = false;
  List<File> selectedImages = [];
  bool isExistingModule = false;
  ItemCategory? category = ItemCategory.CHAIR;

  int? quantity = 1;

  File? selectedVideo;
  Image? _thumbnailImage;

  bool have3DModel = false;
  bool haveVideo = false;

  FilePickerResult? threeDimensionModel;
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
    File video = await ImagePicker().pickVideo(source: ImageSource.gallery).then((value) => File(value!.path));
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
    FilePickerResult? model = await FilePicker.platform.pickFiles(type: FileType.any);
    setState(() {
      threeDimensionModel = model!;
    });
    print('path: : ${threeDimensionModel!.toString()}');
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Create Selling Item'),
      ),
      body:  GestureDetector(
        onTap: () {
           FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: BlocConsumer<CreateSellingItemBloc, CreateSellingItemState>(
          listener: (context, state) {
            if (state is CreateSellingItemSuccess) {
              CustomSnackbar.showSuccessSnackbar(context, 'Item added successfully');
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
                      child: Column(
                        children: [
                          //image picker
                          Container(
                            height: 100,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children:[
                                  GestureDetector(
                                    onTap: () {
                                      _selectImages();
                                    },
                                    child: Container(
                                          width: 100,
                                          height: 100,
                                          color: Colors.grey[300],
                                          child: Center(child: Text('+ Add photos (Up to 5 photos)', textAlign: TextAlign.center,))
                                        ),
                                  ),
                                      SizedBox(width: 10,),
                                  Container(
                                    height: 100,
                                    width: mq.width - 100,
                                    child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    physics: const BouncingScrollPhysics(),
                                    itemCount: selectedImages.length,
                                    itemBuilder: (BuildContext context, int index) {
                                      return Image.file(selectedImages[index], width: 100, height: 100, fit: BoxFit.cover,);
                                    },
                                                          ),
                                  ),]
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          TextFormField(
                            controller: priceController,
                            //number only
                            keyboardType: TextInputType.number,
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                            decoration: const InputDecoration(
                              labelText: 'Price',
                              prefix: Text('RM '),
                            ),
                          ),
                          SizedBox(height: 10),
                          TextFormField(
                            controller: itemNameController,
                            decoration: const InputDecoration(
                              labelText: 'Item Name',
                            ),
                          ),
                          SizedBox(height: 10),
                          //Quantity with plus and minus button
                          Row(
                            children: [
                              Text('Quantity: '),
                              SizedBox(width: 10,),
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
                          Row(
                            children:[ 
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
                            ),]
                          ),
                          SizedBox(height: 10),
                          //description
                          TextFormField(
                            controller: descriptionController,
                            maxLines: 5,
                            decoration: const InputDecoration(
                              labelText: 'Description',
                              hintText: 'Describe what you are selling and includes details such as brand, warranty, and other T&C...'
                            ),
                          ),
                          SizedBox(height: 10),
                          //location
                          TextFormField(
                            controller: locationController,
                            decoration: const InputDecoration(
                              labelText: 'Location',
                            ),
                          ),
                          SizedBox(height: 10),
                          //switch for having 3d model or not
                          Row(
                            children: [
                              Text('Have 3D Model ?'),
                              Switch(
                                activeColor: CustomColor.vfPrimaryColor,
                                inactiveTrackColor: CustomColor.vfPrimaryColor.withOpacity(0.5),
                                value: have3DModel, onChanged: (bool value) {
                                setState(() {
                                  have3DModel = value;
                                });
                              }),
                            ],
                          ),
                          //if have 3d model, show textfield for 3d model
                          if (have3DModel)
                            Row(
                              children: [
                                SecondaryCustomButton(
                                  width: mq.width * 0.4,
                                  onPressed: (){}, buttonText: 'Automation', isDisabled: isButtonDisabled),
                                SizedBox(width: 10,),
                                SecondaryCustomButton(
                                   width: mq.width * 0.4,
                                  onPressed: (){
                                    setState(() {
                                      isExistingModule = true;
                                    });
                                    _add3DModel();
                                  }, buttonText: 'Existing Module', isDisabled: isButtonDisabled)
                                
                              ],
                            ),
                          SizedBox(height: 10),
                          (have3DModel && isExistingModule && threeDimensionModel==null)?
                            Container(
                              height: 100,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(child: Text('3D Model Added', textAlign: TextAlign.center,)),
                            )
                            :(threeDimensionModel!=null)?Container(
                              height: 200,
                              child: Cube(
                                        onSceneCreated: (Scene scene) {
                                          scene.world.add(Object(fileName: threeDimensionModel?.files[0].path, scale: Vector3(8,8,8), backfaceCulling: false, isAsset: false,));
                                        }),
                            ):
                            SizedBox(height: 10),
                         Row(
                            children: [
                              Text('Have A Video ?'),
                              Switch(value: haveVideo,
                                     activeColor: CustomColor.vfPrimaryColor,
                                inactiveTrackColor: CustomColor.vfPrimaryColor.withOpacity(0.5),
                               onChanged: (bool value) {
                                setState(() {
                                  haveVideo = value;
                                });
                              }),
                            ],
                          ),
                          SizedBox(height: 10),
                          //if have 3d model, show textfield for 3d model
                          (haveVideo && selectedVideo != null && _thumbnailImage!=null)?
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/video_player', arguments: {'videoFile': selectedVideo});
                            },
                            child: _thumbnailImage):
                           
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
                              child: Center(child: Text('Add A Video', textAlign: TextAlign.center,))),
                          ),
                          SizedBox(height: 10),
                          CustomButton(
                            isDisabled: isButtonDisabled,
                            onPressed: () {
                              if(isButtonDisabled == false){
                                CustomSnackbar.showLoadingSnackbar(context, 'Adding Item');
                                setState(() {
                                  isButtonDisabled = true;
                                });
                              MarketplaceProductModel productModel = MarketplaceProductModel(
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
                                threeDimensionModel: threeDimensionModel?.files[0].path,
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
                                threeDimensionModel: threeDimensionModel?.files[0].path,
                              ));}
                            },
                            buttonText: 'Create Selling Item',
                          ),
                      ],),
                    ),
                  )
                    );
          },
        ),
      ));
  }
}

