class RKeeperProvider {
  // final String iikoWebLogin = dotenv.env['IIKO_WEB_LOGIN']!;
  // final String baseUrl =

  // Future<Response> getToken() async {
  //   return await post(
  //     Uri.parse('https://api-ru.iiko.services/api/1/access_token'),
  //     headers: {
  //       "content-type": "application/json",
  //     },
  //     body: jsonEncode({"apiLogin": iikoWebLogin}),
  //   );
  // }

  // Future<Response> getOrganization(String token) async {
  //   return await post(
  //       Uri.parse('https://api-ru.iiko.services/api/1/organizations'),
  //       headers: {"content-type": "application/json", "Authorization": token},
  //       body: jsonEncode({}));
  // }

  // Future<Response> getDiscounts(String token, String organizationID) async {
  //   return await post(Uri.parse('https://api-ru.iiko.services/api/1/discounts'),
  //       headers: {"content-type": "application/json", "Authorization": token},
  //       body: jsonEncode({
  //         "organizationIds": [organizationID],
  //         "includeDisabled": true
  //       }));
  // }

  // Future<Response> getTerminalGroups(
  //     String token, String organizationID) async {
  //   return await post(
  //       Uri.parse('https://api-ru.iiko.services/api/1/terminal_groups'),
  //       headers: {"content-type": "application/json", "Authorization": token},
  //       body: jsonEncode({
  //         "organizationIds": [organizationID],
  //         "includeDisabled": true
  //       }));
  // }

  // Future<Response> getOrderTypes(String token, String organizationID) async {
  //   return await post(
  //       Uri.parse('https://api-ru.iiko.services/api/1/deliveries/order_types'),
  //       headers: {"content-type": "application/json", "Authorization": token},
  //       body: jsonEncode({
  //         "organizationIds": [organizationID],
  //       }));
  // }

  // Future<Response> getCities(String token, String organizationID) async {
  //   return await post(Uri.parse('https://api-ru.iiko.services/api/1/cities'),
  //       headers: {"content-type": "application/json", "Authorization": token},
  //       body: jsonEncode({
  //         "organizationIds": [organizationID],
  //       }));
  // }

  // Future<Response> getStreets(
  //     String token, String organizationID, String cityID) async {
  //   return await post(
  //       Uri.parse('https://api-ru.iiko.services/api/1/streets/by_city'),
  //       headers: {"content-type": "application/json", "Authorization": token},
  //       body: jsonEncode({
  //         "organizationId": organizationID,
  //         "cityId": cityID,
  //       }));
  // }

  // Future<Response> getOrdersById(
  //     String token, String organizationID, String orderID) async {
  //   return await post(
  //       Uri.parse('https://api-ru.iiko.services/api/1/deliveries/by_id'),
  //       headers: {"content-type": "application/json", "Authorization": token},
  //       body: jsonEncode({
  //         "organizationId": organizationID,
  //         "orderIds": [orderID]
  //       }));
  // }

  // Future<Response> checkCorrelationID(
  //     String token, String correlationID) async {
  //   return await post(
  //       Uri.parse('https://api-ru.iiko.services/api/1/commands/status'),
  //       headers: {"content-type": "application/json", "Authorization": token},
  //       body: jsonEncode({"correlationId": correlationID}));
  // }

  // Future<Response> getMenu(String token, String organizationID) async {
  //   return await post(
  //       Uri.parse('https://api-ru.iiko.services/api/1/nomenclature'),
  //       headers: {"content-type": "application/json", "Authorization": token},
  //       body:
  //           jsonEncode({"organizationId": organizationID, "startRevision": 0}));
  // }

  // Future<Response> createDelivery(
  //     {required String token,
  //     required String organizationID,
  //     required Checkout checkout,
  //     required PikapikaUser user,
  //     required Cart cart,
  //     required String comments,
  //     required int? changeWith,
  //     required int cashbackUsed,
  //     required int numberOfPersons}) async {
  //   //Preparing map for delivery data
  //   var deliveryPoint = checkout.orderType == OrderType.delivery
  //       ? {
  //           "coordinates": {
  //             "latitude": checkout.address.geopoint.latitude,
  //             "longitude": checkout.address.geopoint.longitude
  //           },
  //           "address": {
  //             "street": {
  //               "name": checkout.address.address,
  //               "city": "Алматы",
  //             },
  //             "house": ",",
  //             "flat": checkout.address.apartmentOrOffice
  //           },
  //         }
  //       : null;

  //   //Preparing comments data
  //   var orderComment = checkout.deliveryTime == DeliveryTimeType.fast
  //       ? "Время доставки: Как можно скорее; "
  //       : "Время доставки: ${checkout.certainTimeOrder}; ";
  //   if (comments.isNotEmpty) {
  //     orderComment += "Доп комментарии: $comments; ";
  //   }
  //   if (checkout.paymentMethod == PaymentMethod.cash) {
  //     orderComment += "Сдача с: $changeWith; ";
  //   }
  //   if (checkout.paymentMethod == PaymentMethod.nonCash) {
  //     orderComment += "Оплата безналичными; ";
  //   }

  //   //Preparing payment data
  //   String paymentTypeKind;
  //   String paymentTypeId;

  //   switch (checkout.paymentMethod) {
  //     case PaymentMethod.cash:
  //       paymentTypeKind = "Cash";
  //       paymentTypeId = "09322f46-578a-d210-add7-eec222a08871"; // CHANGE!!!!!!
  //       break;
  //     case PaymentMethod.nonCash:
  //       paymentTypeKind = "Cash";
  //       paymentTypeId = "09322f46-578a-d210-add7-eec222a08871"; // CHANGE!!!!!!!
  //       break;
  //     case PaymentMethod.bankCard:
  //       paymentTypeKind = "Card";
  //       paymentTypeId = "c2ae5448-ac8a-4f7a-885f-166bf2a9dcf3"; // CHANGE!!!!!!!
  //       break;
  //     case PaymentMethod.savedBankCard:
  //       paymentTypeKind = "Card";
  //       paymentTypeId = "c2ae5448-ac8a-4f7a-885f-166bf2a9dcf3"; // CHANGE!!!!!!
  //       break;
  //     case PaymentMethod.applePay:
  //       paymentTypeKind = "Card";
  //       paymentTypeId = "c2ae5448-ac8a-4f7a-885f-166bf2a9dcf3"; // CHANGE!!!!!!
  //       break;
  //     default:
  //       paymentTypeKind = "Cash";
  //       paymentTypeId = "09322f46-578a-d210-add7-eec222a08871"; // CHANGE!!!!!!
  //   }

  //   //Preparing discount info
  //   var discountsInfo = cart.activePromocode != null &&
  //           cart.activePromocode!.discountID.isNotEmpty
  //       ? {
  //           "discounts": [
  //             {
  //               "discountTypeId": cart.activePromocode!.discountID,
  //               "sum": cart.discount,
  //               "type": "RMS"
  //             }
  //           ]
  //         }
  //       : null;

  //   //Using cashback for discount
  //   if (cashbackUsed < 0) {
  //     var discountSum = cashbackUsed * -1;
  //     var orderTotal = checkout.deliveryCost + cart.subtotal;

  //     //Check if cashback discount is higher than order total
  //     if ((cashbackUsed * -1) > orderTotal) {
  //       discountSum = orderTotal;
  //     }

  //     discountsInfo = {
  //       "discounts": [
  //         {
  //           "discountTypeId": "6ca6fc0c-99e3-4ddb-8869-f03d642122df",
  //           "sum": discountSum,
  //           "type": "RMS"
  //         }
  //       ]
  //     };
  //     orderComment += "Применены $discountSum накопительных баллов";
  //   }

  //   //Preparing items
  //   var items = cart.items
  //       .map((e) => {
  //             "productId": e.product.iikoID,
  //             "price": e.product.price,
  //             "type": "Product",
  //             "amount": e.count,
  //             "modifiers": e.orderModifiers.map((e) => e.toMap()).toList()
  //           })
  //       .toList();

  //   //Find terminal group
  //   var terminalResponse = await getTerminalGroups(token, organizationID);
  //   var terminalGroupId = jsonDecode(terminalResponse.body)['terminalGroups'][0]
  //       ['items'][0]['id'];

  //   //Output of applied promocode in order comments
  //   if (cart.activePromocode != null) {
  //     orderComment += " ПРИМЕНЕН ПРОМОКОД: ${cart.activePromocode!.code}";
  //   }

  //   return await post(
  //     Uri.parse('https://api-ru.iiko.services/api/1/deliveries/create'),
  //     headers: {
  //       "content-type": "application/json",
  //       "Authorization": token,
  //     },
  //     body: jsonEncode({
  //       "organizationId": organizationID,
  //       "terminalGroupId": terminalGroupId,
  //       "createOrderSettings": {"mode": "Async"},
  //       "order": {
  //         "items": items,
  //         "payments": [
  //           {
  //             "paymentTypeKind": paymentTypeKind,
  //             "sum": "${checkout.deliveryCost + cart.subtotal - cart.discount}",
  //             "paymentTypeId": paymentTypeId
  //           }
  //         ],
  //         "orderTypeId": checkout.orderType == OrderType.pickup
  //             ? "5b1508f9-fe5b-d6af-cb8d-043af587d5c2"
  //             : "76067ea3-356f-eb93-9d14-1fa00d082c4e",
  //         "phone": user.phoneNumber,
  //         "comment": orderComment,
  //         "customer": {
  //           "name": user.name,
  //           "email": user.email,
  //           "comment": " ",
  //         },
  //         "guests": {
  //           "count": numberOfPersons,
  //         },
  //         "deliveryPoint": deliveryPoint,
  //         "discountsInfo": discountsInfo
  //       }
  //     }),
  //   );
  // }

  // //iikoCard functions
  // //Get customer info
  // Future<Response> getCustomerInfo(
  //     String token, String organizationID, String phone) async {
  //   return await post(
  //       Uri.parse(
  //           'https://api-ru.iiko.services/api/1/loyalty/iiko/customer/info'),
  //       headers: {"content-type": "application/json", "Authorization": token},
  //       body: jsonEncode({
  //         "organizationId": organizationID,
  //         "phone": phone,
  //         "type": "phone",
  //       }));
  // }

  // //Create or update customer
  // Future<Response> createCustomer(
  //     String token, String organizationID, String phone, String name) async {
  //   return await post(
  //       Uri.parse(
  //           'https://api-ru.iiko.services/api/1/loyalty/iiko/customer/create_or_update'),
  //       headers: {"content-type": "application/json", "Authorization": token},
  //       body: jsonEncode({
  //         "organizationId": organizationID,
  //         "phone": phone,
  //         "name": name,
  //       }));
  // }

  // //Refill balance
  // Future<Response> refillBalance(String token, String organizationID,
  //     String customerId, double sum) async {
  //   return await post(
  //       Uri.parse(
  //           'https://api-ru.iiko.services/api/1/loyalty/iiko/customer/wallet/topup'),
  //       headers: {"content-type": "application/json", "Authorization": token},
  //       body: jsonEncode({
  //         "organizationId": organizationID,
  //         "customerId": customerId,
  //         "sum": sum,
  //       }));
  // }

  // //Withdraw balance
  // Future<Response> withdrawBalance(String token, String organizationID,
  //     String customerId, double sum) async {
  //   return await post(
  //       Uri.parse(
  //           'https://api-ru.iiko.services/api/1/loyalty/iiko/customer/wallet/chargeoff'),
  //       headers: {"content-type": "application/json", "Authorization": token},
  //       body: jsonEncode({
  //         "organizationId": organizationID,
  //         "customerId": customerId,
  //         "sum": sum,
  //       }));
  // }

  // //iiko Orders section
  // //Create order
  // Future<Response> createOrder({
  //   required String token,
  //   required String organizationId,
  //   required String terminalGroupId,
  //   required Map<String, dynamic> items,
  //   required Map<String, dynamic> discountsInfo,
  //   required String paymentTypeKind,
  //   required double finalSum,
  //   required String paymentTypeId,
  //   required String phone,
  //   required String name,
  // }) async {
  //   return await post(
  //     Uri.parse('https://api-ru.iiko.services/api/1/order/create'),
  //     headers: {
  //       "content-type": "application/json",
  //       "Authorization": token,
  //     },
  //     body: jsonEncode({
  //       "organizationId": organizationId,
  //       "terminalGroupId": terminalGroupId,
  //       "createOrderSettings": {"mode": "Async"},
  //       "order": {
  //         "items": items,
  //         "payments": [
  //           {
  //             "paymentTypeKind": paymentTypeKind,
  //             "sum": finalSum,
  //             "paymentTypeId": paymentTypeId
  //           }
  //         ],
  //         "phone": phone,
  //         "customer": {
  //           "name": name,
  //           "comment": " ",
  //         },
  //         "discountsInfo": discountsInfo
  //       }
  //     }),
  //   );
  // }

  // //Close Order
  // Future<Response> closeOrder({
  //   required String token,
  //   required String organizationId,
  //   required String orderId,
  // }) async {
  //   return await post(
  //     Uri.parse('https://api-ru.iiko.services/api/1/order/close'),
  //     headers: {
  //       "content-type": "application/json",
  //       "Authorization": token,
  //     },
  //     body: jsonEncode({
  //       "organizationId": organizationId,
  //       "orderId": orderId,
  //     }),
  //   );
  // }
}
