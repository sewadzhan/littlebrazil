import 'package:littlebrazil/data/providers/rkeeper_provider.dart';

class RKeeperRepository {
  final RKeeperProvider rKeeperProvider;

  const RKeeperRepository(this.rKeeperProvider);

  // Future<String> getToken() async {
  //   Response response = await iikoProvider.getToken();
  //   if (response.statusCode == 200) {
  //     Map<String, dynamic> body = jsonDecode(response.body);

  //     return "Bearer ${body['token']}";
  //   }
  //   throw PikapikaException("Unable to retrieve token");
  // }

  // Future<String> getOrganization(String token) async {
  //   Response response = await iikoProvider.getOrganization(token);

  //   if (response.statusCode == 200) {
  //     Map<String, dynamic> body = jsonDecode(response.body);

  //     return body['organizations'][0]['id'];
  //   }
  //   throw PikapikaException("Unable to retrieve organization ID");
  // }

  // Future<List<Category>> getMenu(
  //     String token, String organizationID, String mobileAppGroupID) async {
  //   Response response = await iikoProvider.getMenu(token, organizationID);

  //   if (response.statusCode == 200) {
  //     Map<String, dynamic> body = jsonDecode(response.body);

  //     List<dynamic> groups = body['groups'];
  //     List<dynamic> products = body['products'];

  //     log(groups.toString());

  //     groups.sort(((a, b) => a['order'].compareTo(b['order'])));

  //     //Retrieving a list of all group modifiers with their children
  //     List<GroupModifier> groupModifiers = groups
  //         .where((element) => element['isGroupModifier'] == true)
  //         .map((e) => GroupModifier.fromMapIiko(e, products))
  //         .toList();

  //     return groups
  //         .where((element) =>
  //             element['parentGroup'] ==
  //             mobileAppGroupID) //Get groups from folder "Mobile app" //5dc35460-b455-4afe-a1e6-f6ec81b40bc7
  //         .map((e) => Category.fromMapIiko(e, products, groupModifiers))
  //         .where((element) => element.products.isNotEmpty)
  //         .toList();
  //   }
  //   throw PikapikaException("Unable to retrieve organization ID");
  // }

  // Future<void> createDelivery(
  //     {required String token,
  //     required String organizationID,
  //     required Checkout checkout,
  //     required PikapikaUser user,
  //     required Cart cart,
  //     required String comments,
  //     required int? changeWith,
  //     required int cashbackUsed,
  //     required int numberOfPersons}) async {
  //   Response response = await iikoProvider.createDelivery(
  //       token: token,
  //       organizationID: organizationID,
  //       checkout: checkout,
  //       user: user,
  //       cart: cart,
  //       comments: comments,
  //       changeWith: changeWith,
  //       cashbackUsed: cashbackUsed,
  //       numberOfPersons: numberOfPersons);

  //   log("IIKO RESPONSE BODY " + response.body);
  //   Map<String, dynamic> body = jsonDecode(response.body);

  //   if (response.statusCode == 200 &&
  //       body['orderInfo']['creationStatus'] != "Error") {
  //     return;
  //   }
  //   throw PikapikaException("Произошла непредвидимая ошибка. Попробуйте позже");
  // }
}
