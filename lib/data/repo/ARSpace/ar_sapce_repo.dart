import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:virtual_furnish_app/data/model/ARSpace/ar_media_storage_model.dart';
import 'package:virtual_furnish_app/data/model/Authentication/sell_account_model.dart';
import 'package:virtual_furnish_app/data/model/Authentication/user_model.dart';
import 'package:virtual_furnish_app/data/model/MarketplaceProduct/product_model.dart';
import 'package:virtual_furnish_app/data/repo/Authentication/auth_repo.dart';
import 'package:virtual_furnish_app/data/repo/Authentication/user_repo.dart';
import 'package:virtual_furnish_app/data/repo/firebaseStorageRepo.dart';

class ArSpaceRepo{

   static final CollectionReference _userCollection = FirebaseFirestore.instance.collection("User");
   static final CollectionReference _marketplaceCollection = FirebaseFirestore.instance.collection("MarketplaceProduct");
   static final folderName = "ARMediaStorage";
   static DocumentReference getDocument(){
      String uid = AuthRepo.getCurrentUserId()!;
      return  _userCollection.doc(uid);
   }
  //add new user using the user model
  static Future<String> addMedia(ARMediaStorageModel arMedia) async {
    try{
      //save media to firebase storage
      if(arMedia.image != null && arMedia.image != ""){
        String url = await FirebaseStorageRepo.uploadFile(path: arMedia.image!, category: folderName);
        arMedia.image = url;
      }else if(arMedia.image != null && arMedia.video != ""){
        String url = await FirebaseStorageRepo.uploadFile(path: arMedia.video!, category: folderName);
        arMedia.video = url;
      }
      //get current user acc
      await getDocument().collection(folderName).add(arMedia.toJson());
      return "Media Added";
    }
    catch(e){  
      return e.toString();
    }
  }
  //get all media
  static Future<List<ARMediaStorageModel>> getAllMedia() async {
    try{
      List <ARMediaStorageModel> arMediaList = [];
      QuerySnapshot querySnapshot = await getDocument().collection(folderName).get();
      querySnapshot.docs.forEach((element) {
        ARMediaStorageModel model = ARMediaStorageModel.fromJson(element.data() as Map<String, dynamic>);
        model.id = element.id;
        arMediaList.add(model);
      });
      return arMediaList;
    }
    catch(e){
      throw e;
    }
  }
  //get suggested product
  static Future<List<MarketplaceProductModel>> getSuggestedProduct(String category) async {
    try{
      List <MarketplaceProductModel> arMediaList = [];
      //map for different category
      Map<String, String> categoryMap = {
        "CHAIR" : "TABLE",
        "TABLE" : "CHAIR",
        "CABINET" : "DRAWER",
        "DRAWER" : "CABINET",
        "BED" : "CURTAIN",
        "CURTAIN" : "BED",
        "BABY_FURNITURE" : "DRAWER",
      };
      //get the suggested pair product
      QuerySnapshot querySnapshot = await _marketplaceCollection.where("category", isEqualTo: categoryMap[category]).get();
      querySnapshot.docs.forEach((element) {
        MarketplaceProductModel model = MarketplaceProductModel.fromJson(element.data() as Map<String, dynamic>);
        model.id = element.id;
        arMediaList.add(model);
      });
      return arMediaList;
    }
    catch(e){
      throw e;
    }
  }

}