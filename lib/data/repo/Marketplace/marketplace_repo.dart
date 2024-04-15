
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:virtual_furnish_app/data/model/MarketplaceProduct/product_model.dart';
import 'package:virtual_furnish_app/data/repo/Authentication/auth_repo.dart';
import 'package:virtual_furnish_app/data/repo/firebaseStorageRepo.dart';

class MarketplaceRepo{

   static final CollectionReference _productCollection = FirebaseFirestore.instance.collection("MarketplaceProduct");
  //add new product using the product model
  static Future<String> addProduct ( MarketplaceProductModel productModel) async {
    try{
      if(productModel.images!=null){
      List<String> urls = [];
      for(File image in productModel.images!){
        String url = await FirebaseStorageRepo.uploadFile(path: image.path, category: "MarketplaceProduct/image/${productModel.name}");
        urls.add(url);
      }
      productModel.images = urls;
      }
      if(productModel.video!=null){
        String url = await FirebaseStorageRepo.uploadFile(path: productModel.video!, category: "MarketplaceProduct/video/${productModel.name}");
        productModel.video = url;
      }
      if(productModel.threeDimensionModel!=null){
        String url = await FirebaseStorageRepo.uploadFile(path: productModel.threeDimensionModel!, category: "MarketplaceProduct/3dModel/${productModel.name}");
        productModel.threeDimensionModel = url;
      }
      _productCollection.doc().set(productModel.toJson());
      return "Product Added";
    }
    catch(e){
      return e.toString();
    }
  }

  //get product using the product id
  static Future<MarketplaceProductModel> getSellingItem(String id) async {
    try{
      DocumentSnapshot documentSnapshot = await _productCollection.doc(id).get();
      return MarketplaceProductModel.fromJson(documentSnapshot.data() as Map<String, dynamic>);}
    catch(e){
      throw e;
    }
  }
    //get product using the seller id
  static Future<List<MarketplaceProductModel>> getSellingItems(String id) async {
    try{
    QuerySnapshot querySnapshot = await _productCollection.where("sellerID", isEqualTo: id).get();
    List<MarketplaceProductModel> items=[];
    for(DocumentSnapshot doc in querySnapshot.docs){
      MarketplaceProductModel model = MarketplaceProductModel.fromJson(doc.data() as Map<String, dynamic>);
      model.id = doc.id;
      items.add(model);}
    return items;
    // querySnapshot.docs.map((e){ 
    //   MarketplaceProductModel  model = MarketplaceProductModel.fromJson(e.data() as Map<String, dynamic>);
    //   model.id = e.id;
    //   items.add(model);
    // });
    // return items;
      }
    catch(e){
      throw e;
    }
  }
      //get product using the seller id
  static Future<List<MarketplaceProductModel>> getSellingItemsByTitle(String id, String title) async {
    try{
    QuerySnapshot querySnapshot = await _productCollection
    .where("sellerID", isEqualTo: id) 
    .get();
    //only same title
     List filters = [];
    List items = querySnapshot.docs.map((e) { 
      if(e["name"].toString().toLowerCase() == title.toLowerCase()){
      MarketplaceProductModel model = MarketplaceProductModel.fromJson(e.data() as Map<String, dynamic>);
      filters.add(model);
      return filters;}
      else{
        return filters;}
      }).toList();
    return querySnapshot.docs.map((e) => MarketplaceProductModel.fromJson(e.data() as Map<String, dynamic>)).toList();
      }
    catch(e){
      throw e;
    }
  }
  //edit product profile
  static Future<String> editMarketplaceProduct(MarketplaceProductModel productModel) async {
    try{
      // if(productModel.images!=null && !productModel.profilePic!.contains("https:/")){
      // String url = await FirebaseStorageRepo.uploadFile(path: productModel.profilePic!, category: "Profile");
      // productModel.profilePic = url;}
      // String uid = AuthRepo.getCurrentMarketplaceProductId()!;
      // print(productModel.toJson());
      // Map updatedData = {
      //   "productname": productModel.productname,
      //   "email": productModel.email,
      //   "age": productModel.age,
      //   "profile_pic": productModel.profilePic,
      //   "contact": productModel.contact,
      //   "status": productModel.status
      // };
      // _productCollection.doc(uid).update(Map<String, dynamic>.from(updatedData));
      return "MarketplaceProduct Updated";
    }
    catch(e){
      return e.toString();
    }
  }
  //delete selling item
  static Future<String> deleteSellingItem(String id) async {
    try{
      //get the product details
      DocumentSnapshot documentSnapshot = await _productCollection.doc(id).get();
      MarketplaceProductModel productModel = MarketplaceProductModel.fromJson(documentSnapshot.data() as Map<String, dynamic>);
      //delete also the images, video and 3d object in storage if got
      if(productModel.images!=null){
        for(String url in productModel.images!){
          FirebaseStorage.instance.refFromURL(url).delete();
        }
      }
      if(productModel.video!=null){
         FirebaseStorage.instance.refFromURL(productModel.video.toString()).delete();
      }
      if(productModel.threeDimensionModel!=null){
         FirebaseStorage.instance.refFromURL(productModel.threeDimensionModel.toString()).delete();
      }
        //delete the product
      _productCollection.doc(id).delete();
      return "MarketplaceProduct Deleted";
    }
    catch(e){
      return e.toString();
    }
  }

  //get all marketplace products
  static Future<List<MarketplaceProductModel>> getAllMarketplaceProducts() async {
    try{
    QuerySnapshot querySnapshot = await _productCollection.get();
    return querySnapshot.docs.map((e) => MarketplaceProductModel.fromJson(e.data() as Map<String, dynamic>)).toList();
    }
    catch(e){
      throw e;
    }
  }
  //get all marketplace products by title 
  static Future<List<MarketplaceProductModel>> fetchMarketplaceProductByTitle(String title) async {
    try{
    QuerySnapshot querySnapshot = await _productCollection.get();
    List<MarketplaceProductModel> filters = [];
    //using for 
    for(DocumentSnapshot doc in querySnapshot.docs){
      if(doc["name"].toString().toLowerCase() == title.toLowerCase()){
      MarketplaceProductModel model = MarketplaceProductModel.fromJson(doc.data() as Map<String, dynamic>);
       model.id = doc.id;
      filters.add(model);}
    }
    return filters;}
    catch(e){
      throw e;
    }
  }

  //get all marketplace products by category
  static Future<List<MarketplaceProductModel>> fetchMarketplaceProductByCategory(String category) async {
  try{
    QuerySnapshot querySnapshot = await _productCollection.get();
    List<MarketplaceProductModel> filters = [];
    //using for 
    for(DocumentSnapshot doc in querySnapshot.docs){
      if(doc["category"].toString().toLowerCase() == category.toLowerCase()){
      MarketplaceProductModel model = MarketplaceProductModel.fromJson(doc.data() as Map<String, dynamic>);
      model.id = doc.id;
      filters.add(model);}
    }
    return filters;}
    catch(e){
      throw e;
    }
  }
  //get marketpalce product by id
  static Future<MarketplaceProductModel> getMarketplaceProductById(String id) async {
    try{
      DocumentSnapshot documentSnapshot = await _productCollection.doc(id).get();
      
      MarketplaceProductModel model= MarketplaceProductModel.fromJson(documentSnapshot.data() as Map<String, dynamic>);
      model.id = documentSnapshot.id;
      return model;
      }
    catch(e){
      throw e;
    }
  }
}