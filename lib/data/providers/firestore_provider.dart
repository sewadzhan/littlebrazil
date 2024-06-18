import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreProvider {
  final FirebaseFirestore firebaseFirestore;
  final CollectionReference<Map<String, dynamic>> productsCollection;

  FirestoreProvider(this.firebaseFirestore)
      : productsCollection = firebaseFirestore.collection('products');

  //Get contacts data (phone, email, socials and etc)
  Future<DocumentSnapshot<Map<String, dynamic>>> getContactsData() async {
    return await firebaseFirestore.collection('config').doc('contacts').get();
  }

  //Get list of stories
  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getStories() async {
    return await firebaseFirestore
        .collection('stories')
        // .orderBy('order')
        .get()
        .then((value) => value.docs);
  }

  //Register new user in Firestore
  Future<void> writeNewUser(
      String phoneNumber, String name, int? welcomeBonus) async {
    await firebaseFirestore.collection('users').doc(phoneNumber).set({
      'name': name,
      'phoneNumber': phoneNumber,
      'cashback': welcomeBonus ?? 0
    }).then((value) => log("New user added"));
  }

  //Get all data from current user via phone number
  Future<Map<String, dynamic>?> retrieveUser(String phoneNumber) async {
    var snapshot =
        await firebaseFirestore.collection('users').doc(phoneNumber).get();
    return snapshot.data();
  }

  //Edit personal data of current user via phone number
  Future<void> editUser(String phoneNumber, Map<String, dynamic> map) async {
    await firebaseFirestore
        .collection('users')
        .doc(phoneNumber)
        .update(map)
        .then((value) => log("User $phoneNumber was edited"));
  }

  //Delete personal data of current user via phone number
  Future<void> deleteUser(String phoneNumber) async {
    await firebaseFirestore.collection('users').doc(phoneNumber).delete().then(
        (value) =>
            log("User $phoneNumber was successfully deleted from Firestore"));
  }

  //Get all addresses of current user via phone number
  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getAddressesOfUser(
      String phoneNumber) async {
    return await firebaseFirestore
        .collection('users/$phoneNumber/addresses')
        .get()
        .then((value) => value.docs);
  }

  //Add new address to current user
  Future<void> addAddress(String phoneNumber, Map<String, dynamic> map) async {
    await firebaseFirestore
        .collection('users/$phoneNumber/addresses')
        .doc(map['id'])
        .set(map)
        .then((value) => log("Address ${map['id']} was added successfully"));
  }

  //Remove certain address from current user
  Future<void> removeAddress(
      String phoneNumber, Map<String, dynamic> map) async {
    await firebaseFirestore
        .collection('users/$phoneNumber/addresses')
        .doc(map['id'])
        .delete()
        .then((value) => log("Address ${map['id']} was removed successfully"));
  }

  //Retrieve all promocodes
  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>>
      getPromocodes() async {
    return await firebaseFirestore
        .collection('promocodes')
        .get()
        .then((value) => value.docs);
  }

  //Get all delivery zones
  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>>
      getDeliveryZones() async {
    return await firebaseFirestore
        .collection('deliveryZones')
        .get()
        .then((value) => value.docs);
  }

  //Add new order
  Future<void> createOrder(Map<String, dynamic> map) async {
    await firebaseFirestore
        .collection('orders')
        .doc(map['id'].toString())
        .set(map)
        .then((value) => log("ORDER №${map['id']} was added successfully"));
  }

  //Get order history of current user via phone number
  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>>
      getOrderHistoryOfUser(String phoneNumber) async {
    return await firebaseFirestore
        .collection('orders')
        .where('phoneNumber', isEqualTo: phoneNumber)
        .orderBy('dateTime', descending: true)
        .get()
        .then((value) => value.docs);
  }

  //Get cashback system data (percent value, is enabled or not)
  Future<DocumentSnapshot<Map<String, dynamic>>> getCashbackData() async {
    return await firebaseFirestore
        .collection('config')
        .doc('cashback_system')
        .get();
  }

  //Edit user cashback
  Future<void> editUserCashback(String phoneNumber, int newCashback) async {
    await firebaseFirestore
        .collection('users')
        .doc(phoneNumber)
        .update({'cashback': newCashback});
  }

  //Sending email using Firebase extension
  Future<void> sendEmail(
      String sendEmailTo, String subject, String html) async {
    await firebaseFirestore.collection('mail').add({
      'to': sendEmailTo,
      'message': {'subject': subject, 'html': html}
    }).then((value) => log("Queued email for delivery!"));
  }

  //Add the used promocode for user account to certain collection
  Future<void> addUsedPromocodeToUser(
      String phoneNumber, String promocode) async {
    await firebaseFirestore
        .collection('users/$phoneNumber/usedPromocodes')
        .doc(promocode)
        .set({});
  }

  //Get all used promocodes of current user via phone number
  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>>
      getUsedPromocodesOfUser(String phoneNumber) async {
    return await firebaseFirestore
        .collection('users/$phoneNumber/usedPromocodes')
        .get()
        .then((value) => value.docs);
  }

  //Get about restaurant data
  Future<DocumentSnapshot<Map<String, dynamic>>>
      getAboutRestaurantData() async {
    return await firebaseFirestore
        .collection('config')
        .doc('about_restaurant')
        .get();
  }

  //Get FAQs
  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getFAQs() async {
    return await firebaseFirestore
        .collection('faq')
        .get()
        .then((value) => value.docs);
  }

  //Get about company data
  Future<DocumentSnapshot<Map<String, dynamic>>> getAboutCompanyData() async {
    return await firebaseFirestore
        .collection('config')
        .doc('aboutCompany')
        .get();
  }
}
