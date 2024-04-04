import 'package:littlebrazil/data/models/about_restaurant_model.dart';
import 'package:littlebrazil/data/models/address.dart';
import 'package:littlebrazil/data/models/cashback_data.dart';
import 'package:littlebrazil/data/models/contacts.dart';
import 'package:littlebrazil/data/models/delivery_zone.dart';
import 'package:littlebrazil/data/models/order.dart';
import 'package:littlebrazil/data/models/promocode.dart';
import 'package:littlebrazil/data/models/restaurant_user.dart';
import 'package:littlebrazil/data/models/story_sections.dart';
import 'package:littlebrazil/data/providers/firestore_provider.dart';

class FirestoreRepository {
  final FirestoreProvider firestoreProvider;

  FirestoreRepository(this.firestoreProvider);

  //Get contacts
  Future<ContactsModel> getContactsData() async {
    var contactsSnapshot = await firestoreProvider.getContactsData();
    var data = contactsSnapshot.data();

    return ContactsModel.fromMap(data!);
  }

  //Get stories
  Future<List<StorySection>> getStories() async {
    var promotionsDocs = await firestoreProvider.getStories();

    return promotionsDocs
        .map((snapshot) => StorySection.fromMap(snapshot.data()))
        .toList();
  }

  //Write new user
  Future<void> writeNewUser(
      String phoneNumber, String name, int? welcomeBonus) async {
    await firestoreProvider.writeNewUser(phoneNumber, name, welcomeBonus);
  }

  //Edit current user
  Future<void> editUser(String phoneNumber, Map<String, dynamic> map) async {
    await firestoreProvider.editUser(phoneNumber, map);
  }

  //Remove current users personal information
  Future<void> deleteUser(String phoneNumber) async {
    await firestoreProvider.deleteUser(phoneNumber);
  }

  //Get data of current user in Firebase Firestore
  Future<RestaurantUser> retrieveUser(String phoneNumber) async {
    var data = await firestoreProvider.retrieveUser(phoneNumber);
    if (data == null) {
      throw Exception("No user in cloud Firestore with $phoneNumber phone");
    }
    return RestaurantUser.fromMap(data);
  }

  //Get all saved addresses of certain user
  Future<List<Address>> getAddressesOfUser(String phoneNumber) async {
    var addressesDocs = await firestoreProvider.getAddressesOfUser(phoneNumber);

    return addressesDocs
        .map((snapshot) => Address.fromMap(snapshot.data()))
        .toList();
  }

  //Add address to profile of certain phone number
  Future<void> addAddress(String phoneNumber, Address address) async {
    await firestoreProvider.addAddress(phoneNumber, address.toMap());
  }

  //Delete address from profile of certain phone number
  Future<void> removeAddress(String phoneNumber, Address address) async {
    await firestoreProvider.removeAddress(phoneNumber, address.toMap());
  }

  //Retrieve all promocodes
  Future<List<Promocode>> getPromocodes() async {
    var promocodeDocs = await firestoreProvider.getPromocodes();

    return promocodeDocs
        .map((snapshot) => Promocode.fromMap(snapshot.data()))
        .toList();
  }

  //Get delivery zones
  Future<List<DeliveryZone>> getDeliveryZones() async {
    var deliveryZonesDocs = await firestoreProvider.getDeliveryZones();

    return deliveryZonesDocs
        .map((snapshot) => DeliveryZone.fromMap(snapshot.data()))
        .toList();
  }

  //Add order
  Future<void> createOrder(Order order) async {
    await firestoreProvider.createOrder(order.toMap());
  }

  //Get order history of certain user
  Future<List<Order>> getOrderHistoryOfUser(String phoneNumber) async {
    var ordersDocs = await firestoreProvider.getOrderHistoryOfUser(phoneNumber);

    return ordersDocs
        .map((snapshot) => Order.fromMap(snapshot.data()))
        .toList();
  }

  //Get cashback system data (percent value, is enabled or not)
  Future<CashbackData> getCashbackData() async {
    var cashbackDoc = await firestoreProvider.getCashbackData();
    return CashbackData.fromMap(cashbackDoc.data()!);
  }

  //Edit user cashback
  Future<void> editUserCashback(String phoneNumber, int newCashback) async {
    await firestoreProvider.editUserCashback(phoneNumber, newCashback);
  }

  //Get user cashback
  Future<int> getUserCashback(String phoneNumber) async {
    var userDoc = await firestoreProvider.retrieveUser(phoneNumber);
    return userDoc!['cashback'] ?? 0;
  }

  //Sending email using Firebase extension
  Future<void> sendEmail(
      String sendEmailTo, String subject, String html) async {
    await firestoreProvider.sendEmail(sendEmailTo, subject, html);
  }

  //Add the used promocode for user account to certain collection
  Future<void> addUsedPromocodeToUser(
      String phoneNumber, String promocode) async {
    await firestoreProvider.addUsedPromocodeToUser(phoneNumber, promocode);
  }

  //Get all used promocodes of current user via phone number
  Future<List<String>> getUsedPromocodesOfUser(String phoneNumber) async {
    var usedPromocodesDocs =
        await firestoreProvider.getUsedPromocodesOfUser(phoneNumber);

    return usedPromocodesDocs.map((snapshot) => snapshot.id).toList();
  }

  //Get about restaurant data
  Future<AboutRestaurantModel> getAboutRestaurantData() async {
    var aboutRestaurantSnapshot =
        await firestoreProvider.getAboutRestaurantData();
    var data = aboutRestaurantSnapshot.data();

    return AboutRestaurantModel.fromMap(data!);
  }
}
