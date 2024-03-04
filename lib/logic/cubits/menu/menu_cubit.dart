import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:littlebrazil/data/models/category.dart';
import 'package:littlebrazil/data/models/product.dart';
import 'package:littlebrazil/data/repositories/firestore_repository.dart';
part 'menu_state.dart';

//Cubit for working with restaurant's menu
class MenuCubit extends Cubit<MenuState> {
  final FirestoreRepository firestoreRepository;
  MenuCubit(this.firestoreRepository) : super(MenuLoadingState());
  void getMenu() async {
    try {
      List<Category> categories = const [
        // Steaks
        Category(
          type: CategoryType.usual,
          name: "Стейки",
          categoryID: "steaks",
          products: [
            Product(
              categoryID: "steaks",
              title: "Рибай стейк",
              tag: ProductTags.discount,
              imageUrls: [
                "https://optim.tildacdn.pro/tild3662-6165-4434-b562-313063633662/-/format/webp/54d40c4a1b6bc_-_fire.jpg",
                "https://optim.tildacdn.pro/tild6361-6132-4232-b435-383038363737/-/format/webp/bbq-pictures-xb9hxhb.jpg"
              ],
              price: 1500, // Price in your currency
              rmsID: "12345",
              categoryTitle: "Стейки",
              description:
                  "Сочный мраморный рибай стейк из мраморной говядины, приготовленный на гриле.",
              // Add other product properties as needed (tag, order, gift, groupModifiers)
            ),
            Product(
              categoryID: "steaks",
              title: "Филе-миньон",
              imageUrls: [
                "https://optim.tildacdn.pro/tild3066-3761-4433-a634-313532333233/-/format/webp/1663762209_28-mykale.jpg"
              ],
              price: 2000, // Price in your currency
              rmsID: "54321",
              categoryTitle: "Стейки",
              description:
                  "Нежное филе-миньон из молодой телятины, приготовленное по вашему вкусу.",
              // Add other product properties as needed (tag, order, gift, groupModifiers)
            ),
            // Add more steak products here
          ],
        ),

        // Fish
        Category(
          type: CategoryType.usual,
          name: "Рыба",
          categoryID: "fish",
          products: [
            Product(
              categoryID: "fish",
              title: "Дорадо на гриле",
              imageUrls: [
                "https://optim.tildacdn.pro/tild3331-3562-4835-b963-633531386332/-/format/webp/cache_899438757.jpg"
              ],
              price: 1200, // Price in your currency
              rmsID: "67890",
              categoryTitle: "Рыба",
              description: "Целая дорадо, приготовленная на гриле с овощами.",
              // Add other product properties as needed (tag, order, gift, groupModifiers)
            ),
            Product(
              categoryID: "fish",
              title: "Лосось с запеченными овощами",
              imageUrls: [''],
              price: 1800, // Price in your currency
              rmsID: "09876",
              categoryTitle: "Рыба",
              description:
                  "Филе лосося, запеченное с овощами под сливочным соусом.",
              // Add other product properties as needed (tag, order, gift, groupModifiers)
            ),
            // Add more fish products here
          ],
        ),

        // Salads
        Category(
          type: CategoryType.usual,
          name: "Салаты",
          categoryID: "salads",
          products: [
            Product(
              categoryID: "salads",
              tag: ProductTags.hit,
              title: "Салат с киноа и маринованным лососем в остром соусе",
              imageUrls: [
                "https://optim.tildacdn.pro/tild3331-3562-4835-b963-633531386332/-/format/webp/cache_899438757.jpg"
              ],
              price: 800, // Price in your currency
              rmsID: "24680",
              categoryTitle: "Салаты",
              description:
                  "Классический греческий салат с помидорами, огурцами, оливками, сыром фета и оливковым маслом.",
              // Add other product properties as needed (tag, order, gift, groupModifiers)
            ),
            Product(
              categoryID: "salads",
              title: "Цезарь с курицей",
              imageUrls: [
                "https://optim.tildacdn.pro/tild3331-3562-4835-b963-633531386332/-/format/webp/cache_899438757.jpg"
              ],
              price: 1000, // Price in your currency
              rmsID: "35791",
              categoryTitle: "Салаты",
              description:
                  "Салат Цезарь с курицей, сыром пармезан и фирменным соусом.",
              // Add other product properties as needed (tag, order, gift, groupModifiers)
            ),
            // Add more salad products here
          ],
        ),

        // Drinks
        Category(
          type: CategoryType.usual,
          name: "Напитки",
          categoryID: "drinks",
          products: [
            Product(
              categoryID: "drinks",
              tag: ProductTags.latest,
              title: "Кока-кола",
              imageUrls: [
                "https://optim.tildacdn.pro/tild3331-3562-4835-b963-633531386332/-/format/webp/cache_899438757.jpg"
              ],
              price: 200,
              rmsID: "46802",
              categoryTitle: "Напитки",
              description: "Классическая газировка Coca-Cola.",
              // Add other product properties as needed (tag, order, gift, groupModifiers)
            ),
            Product(
              categoryID: "drinks",
              title: "Лимонад",
              imageUrls: [
                "https://optim.tildacdn.pro/tild3331-3562-4835-b963-633531386332/-/format/webp/cache_899438757.jpg"
              ],
              price: 300, // Price in your currency
              rmsID: "57913",
              categoryTitle: "Напитки",
              description: "Освежающий домашний лимонад.",
              // Add other product properties as needed (tag, order, gift, groupModifiers)
            ),
            // Add more drink products here
          ],
        ),

        // Desserts
        Category(
          type: CategoryType.usual,
          name: "Десерты",
          categoryID: "desserts",
          products: [
            Product(
              categoryID: "desserts",
              title: "Тирамису",
              imageUrls: [
                "https://optim.tildacdn.pro/tild3331-3562-4835-b963-633531386332/-/format/webp/cache_899438757.jpg"
              ],
              price: 400, // Price in your currency
              rmsID: "68024",
              categoryTitle: "Десерты",
              description: "Итальянский десерт тирамису с кофейным вкусом.",
              // Add other product properties as needed (tag, order, gift, groupModifiers)
            ),
            Product(
              categoryID: "desserts",
              title: "Фруктовый салат",
              imageUrls: [
                "https://optim.tildacdn.pro/tild3331-3562-4835-b963-633531386332/-/format/webp/cache_899438757.jpg"
              ],
              price: 350, // Price in your currency
              rmsID: "79135",
              categoryTitle: "Десерты",
              description:
                  "Ассорти из свежих фруктов, порезанных и заправленных йогуртом.",
              // Add other product properties as needed (tag, order, gift, groupModifiers)
            ),
            // Add more dessert products here
          ],
        ),

        Category(
          type: CategoryType.extraSales,
          name: "Extra sales",
          categoryID: "extrasales",
          products: [
            Product(
              categoryID: "desserts",
              title: "Фруктовый салат",
              imageUrls: [
                "https://optim.tildacdn.pro/tild3331-3562-4835-b963-633531386332/-/format/webp/cache_899438757.jpg"
              ],
              price: 350, // Price in your currency
              rmsID: "79135",
              categoryTitle: "Десерты",
              description:
                  "Ассорти из свежих фруктов, порезанных и заправленных йогуртом.",
              // Add other product properties as needed (tag, order, gift, groupModifiers)
            ),
            Product(
              categoryID: "steaks",
              title: "Рибай стейк",
              imageUrls: [
                "https://optim.tildacdn.pro/tild3662-6165-4434-b562-313063633662/-/format/webp/54d40c4a1b6bc_-_fire.jpg",
                "https://optim.tildacdn.pro/tild6361-6132-4232-b435-383038363737/-/format/webp/bbq-pictures-xb9hxhb.jpg"
              ],
              price: 1500, // Price in your currency
              rmsID: "12345",
              categoryTitle: "Стейки",
              description:
                  "Сочный мраморный рибай стейк из мраморной говядины, приготовленный на гриле.",
              // Add other product properties as needed (tag, order, gift, groupModifiers)
            ),
            Product(
              categoryID: "steaks",
              title: "Филе-миньон",
              imageUrls: [
                "https://optim.tildacdn.pro/tild3066-3761-4433-a634-313532333233/-/format/webp/1663762209_28-mykale.jpg"
              ],
              price: 2000, // Price in your currency
              rmsID: "54321",
              categoryTitle: "Стейки",
              description:
                  "Нежное филе-миньон из молодой телятины, приготовленное по вашему вкусу.",
              // Add other product properties as needed (tag, order, gift, groupModifiers)
            ),
            // Add more steak products here
          ],
        ),
      ];

      // String token = await iikoRepository.getToken();
      // String organizationId = await iikoRepository.getOrganization(token);
      // var categories =
      //     await iikoRepository.getMenu(token, organizationId, mobileAppGroupID);
      emit(MenuLoadedState(categories: categories));
    } catch (e) {
      print(e.toString());
      emit(MenuErrorState(e.toString()));
    }
  }
}
