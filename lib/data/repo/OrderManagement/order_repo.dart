import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:virtual_furnish_app/data/model/OrderManagement/market_order_model.dart';
import 'package:virtual_furnish_app/data/model/OrderManagement/order_status_model.dart';
import 'package:virtual_furnish_app/data/repo/Authentication/auth_repo.dart';

class OrderRepo{

  //firebase url
  static final CollectionReference _sellerCollection = FirebaseFirestore.instance.collection("SellAccount");
  static final CollectionReference _userCollection = FirebaseFirestore.instance.collection("User");
  static const String sellerCollectionName = 'MarketOrder';
  static const String userCollectionName = 'MarketOrder';

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
    await _sellerCollection.doc(id).collection(sellerCollectionName).add(order.toJson());
    return "Order Created";
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
  Future<MarketOrder> updateOrder(MarketOrder order) async {
    // update order from api
     return MarketOrder();
  }

  Future<MarketOrder> deleteOrder(int id) async {
    // delete order from api
     return MarketOrder();
  }
}