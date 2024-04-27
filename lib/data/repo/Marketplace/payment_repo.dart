import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:virtual_furnish_app/data/model/MarketplaceProduct/payment_model.dart';
import 'package:virtual_furnish_app/data/repo/Authentication/auth_repo.dart';

class PaymentRepo{
 //firebase url
   static final CollectionReference _userCollection = FirebaseFirestore.instance.collection("User");
   static const String collectionName = 'Payment';

   
  //get collection of payments
  static DocumentReference getDocumentReference() {
    String? userID = AuthRepo.getCurrentUserId();
    return _userCollection.doc(userID);
  }
  
  static Future<List<PaymentModel>> getPayments() async {
    QuerySnapshot querySnapshot = await getDocumentReference().collection(collectionName).get();
    List<PaymentModel> items=[];
    for(DocumentSnapshot doc in querySnapshot.docs){
      PaymentModel model = PaymentModel.fromJson(doc.data() as Map<String, dynamic>);
      model.id = doc.id;
      items.add(model);}
    return items;
  }

  static Future<PaymentModel> getPaymentById(int id) async {
    // get payment by id from api
     return PaymentModel();
  }

  static Future<String> createPayment(PaymentModel payment) async {
  try{
    await getDocumentReference().collection(collectionName).add(payment.toJson());
    return "Payment Created";
    }
    catch(e){
      return e.toString();
    }
  }

  static Future<PaymentModel> updatePayment(PaymentModel payment) async {
    // update payment from api
     return PaymentModel();
  }

 static Future<PaymentModel> deletePayment(int id) async {
    // delete payment from api
     return PaymentModel();
  }


}