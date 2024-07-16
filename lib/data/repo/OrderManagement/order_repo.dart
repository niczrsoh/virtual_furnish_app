import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:virtual_furnish_app/bloc/OrderManagement/order_detail_bloc.dart';
import 'package:virtual_furnish_app/data/model/OrderManagement/market_order_model.dart';
import 'package:virtual_furnish_app/data/model/OrderManagement/order_status_model.dart';
import 'package:virtual_furnish_app/data/repo/Authentication/auth_repo.dart';

class OrderRepo{

  //firebase url
  static final CollectionReference _sellerCollection = FirebaseFirestore.instance.collection("SellAccount");
  static final CollectionReference _userCollection = FirebaseFirestore.instance.collection("User");
  static const String sellerCollectionName = 'MarketOrder';
  static const String userCollectionName = 'OrderStatus';
  
  //get collection of orders
  static DocumentReference getSellerDocumentReference() {
    String? sellerID = AuthRepo.getCurrentUserId();
    return _sellerCollection.doc(sellerID);
  }
  static DocumentReference getUserDocumentReference() {
    String? userID = AuthRepo.getCurrentUserId();
    return _userCollection.doc(userID);
  }
  
  static Future<List<MarketOrder>> getOrders() async {
    QuerySnapshot querySnapshot = await getSellerDocumentReference().collection(sellerCollectionName).get();
    List<MarketOrder> items=[];
    for(DocumentSnapshot doc in querySnapshot.docs){
      MarketOrder model = MarketOrder.fromJson(doc.data() as Map<String, dynamic>);
      model.id = doc.id;
      items.add(model);}
    return items;
  }

  Future<MarketOrder> getOrderById(int id) async {
    // get order by id from api
     return MarketOrder();
  }

  static Future<String> createOrder(MarketOrder order, String id) async {
  try{
     CollectionReference collectionReference = await _sellerCollection.doc(id).collection(sellerCollectionName);
     DocumentReference documentReference = await collectionReference.add(order.toJson());
    return "Order Created:${documentReference.id}";
    }
    catch(e){
      return e.toString();
    }
  }

  static Future<String> createOrderStatus(OrderStatus order, String id) async {
  try{
    await _userCollection.doc(id).collection(userCollectionName).add(order.toJson());
    return "Order Status Created";
    }
    catch(e){
      return e.toString();
    }
  }
  //get all order status
  static Future<List<OrderStatus>> getOrderStatus() async {
    QuerySnapshot querySnapshot = await getUserDocumentReference().collection(userCollectionName).get();
    List<OrderStatus> items=[];
    for(DocumentSnapshot doc in querySnapshot.docs){
      OrderStatus model = OrderStatus.fromJson(doc.data() as Map<String, dynamic>);
      model.id = doc.id;
      items.add(model);}
    return items;
  }
  static Future<String> updateOrder(String id, String type, String value, String customerID) async {
    try{
      type = type.trim();
      //first letter of type is lowercase
      String firstLetter = type[0].toLowerCase();
      type = firstLetter + type.substring(1);
      Map updatedData = {
        type: value,
      };
      if(type == 'status'){
        //update the user side also
        CollectionReference reference=_userCollection.doc(customerID).collection(userCollectionName); 
        //find the market order id
        QuerySnapshot querySnapshot = await reference.where('from', isEqualTo: id).get();
        for(DocumentSnapshot doc in querySnapshot.docs){
          if(value == 'shipped')
          reference.doc(doc.id).update({"status": value,"latestTransaction": "Your order has been shipped"});
          else if(value == 'process')
          reference.doc(doc.id).update({"status": value,"latestTransaction": "Seller is processing your order"});
        }
      }else if(type == 'transactionNumber'){
                //update the user side also
                CollectionReference reference=_userCollection.doc(customerID).collection(userCollectionName); 
                //find the market order id
                QuerySnapshot querySnapshot = await reference.where('from', isEqualTo: id).get();
                for(DocumentSnapshot doc in querySnapshot.docs){
                  reference.doc(doc.id).update({"trackingNumber": value});
                }
      }
      getSellerDocumentReference().collection(sellerCollectionName).doc(id).update(Map<String, dynamic>.from(updatedData));
      
      return value;
    }
    catch(e){
      return e.toString();
    }
  }
  //get an order detail
  static Future<MarketOrder> getOrderDetail(String id) async {
    QuerySnapshot querySnapshot = await getSellerDocumentReference().collection(sellerCollectionName).where('id', isEqualTo: id).get();
    MarketOrder model = MarketOrder.fromJson(querySnapshot.docs[0].data() as Map<String, dynamic>);
    model.id = querySnapshot.docs[0].id;
    return model;
  }
  Future<MarketOrder> deleteOrder(int id) async {
    // delete order from api
     return MarketOrder();
  }

  static Future<List<OrderStatus>> fetchOrderByType(String type) async {
    // fetch order by type from api
    QuerySnapshot querySnapshot = await getUserDocumentReference().collection(userCollectionName).where('status', isEqualTo: type).get();
    List<OrderStatus> items=[];
    for(DocumentSnapshot doc in querySnapshot.docs){
      OrderStatus model = OrderStatus.fromJson(doc.data() as Map<String, dynamic>);
      model.id = doc.id;
      items.add(model);}
    return items;
  }

  //get order numbers
  static Future<int> getOrderNumbers() async {
    QuerySnapshot querySnapshot = await getUserDocumentReference().collection(userCollectionName).get();
    return querySnapshot.docs.length;
  }
  //confirm user item 
  static Future<void> confirmUserItem(String orderID) async {
    await getUserDocumentReference().collection(userCollectionName).doc(orderID).update({"status": "completed"});
  }
}