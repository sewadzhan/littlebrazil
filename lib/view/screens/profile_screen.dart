import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:littlebrazil/view/components/bottom_sheets/loyal_system_bottom_sheet.dart';
import 'package:littlebrazil/view/components/list_tiles/profile_list_tile.dart';
import 'package:littlebrazil/view/config/constants.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.only(top: Constants.defaultPadding * 1.5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  decoration: const BoxDecoration(
                      color: Constants.lightGreenColor,
                      borderRadius: BorderRadius.all(Radius.circular(12))),
                  height: 175,
                  margin: EdgeInsets.symmetric(
                      horizontal: Constants.defaultPadding),
                  padding: EdgeInsets.only(
                    top: Constants.defaultPadding,
                    bottom: Constants.defaultPadding,
                    left: Constants.defaultPadding * 1.3,
                    right: Constants.defaultPadding,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Se Von",
                            style: Constants.headlineTextTheme.displayLarge!
                                .copyWith(
                                    color: Constants.primaryColor,
                                    fontWeight: FontWeight.w600),
                          ),
                          TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: Constants.thirdPrimaryColor,
                              shape: const CircleBorder(),
                              minimumSize: const Size(35, 35),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            onPressed: () {
                              Navigator.pushNamed(context, '/editUser');
                            },
                            child: SvgPicture.asset(
                              'assets/icons/pencil.svg',
                              colorFilter: const ColorFilter.mode(
                                  Constants.darkGrayColor, BlendMode.srcIn),
                            ),
                          )
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          RichText(
                              text: TextSpan(
                                  text: "Ваш баланс\n",
                                  style: Constants.textTheme.bodyMedium!
                                      .copyWith(height: 1.2),
                                  children: [
                                TextSpan(
                                    text: "3200 Б",
                                    style: Constants
                                        .headlineTextTheme.displayLarge!
                                        .copyWith(fontWeight: FontWeight.w600))
                              ])),
                          TextButton(
                              style: TextButton.styleFrom(
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              onPressed: () async {
                                await showModalBottomSheet(
                                    context: context,
                                    builder: (context1) =>
                                        const LoyalSystemBottomSheet());
                              },
                              child: Text(
                                "Подробнее",
                                style: Constants.textTheme.titleLarge!.copyWith(
                                    fontSize: 12,
                                    decoration: TextDecoration.underline),
                              ))
                        ],
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: Constants.defaultPadding * 1.5,
                      right: Constants.defaultPadding * 1.5,
                      top: Constants.defaultPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const ProfileListTile(
                          title: "История заказов", routeName: ''),
                      const ProfileListTile(title: "Мои адреса", routeName: ''),
                      const ProfileListTile(
                          title: "Забронировать стол", routeName: ''),
                      const ProfileListTile(
                          title: "Часто задаваемые вопросы", routeName: ''),
                      const ProfileListTile(
                          title: "Сменить язык", routeName: ''),
                      SizedBox(
                        height: Constants.defaultPadding,
                      ),
                      const ProfileListTile(
                          title: "О разработчике", routeName: ''),
                      const ProfileListTile(
                          title: "Выйти из аккаунта", routeName: ''),
                      InkWell(
                        onTap: () {},
                        child: Container(
                          margin: EdgeInsets.only(
                              top: Constants.defaultPadding * 1.5),
                          padding: EdgeInsets.symmetric(
                            vertical: Constants.defaultPadding * 0.75,
                            horizontal: Constants.defaultPadding * 0.5,
                          ),
                          decoration: const BoxDecoration(
                              color: Constants.lightGrayColor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(6))),
                          child: Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    right: Constants.defaultPadding * 0.75),
                                child: SizedBox(
                                  width: 30,
                                  height: 30,
                                  child: SvgPicture.asset(
                                    'assets/icons/question.svg',
                                    colorFilter: const ColorFilter.mode(
                                        Constants.darkGrayColor,
                                        BlendMode.srcIn),
                                  ),
                                ),
                              ),
                              Text(
                                "Нужна помощь?",
                                style: Constants.headlineTextTheme.displaySmall!
                                    .copyWith(
                                        fontSize: Constants.headlineTextTheme
                                                .displaySmall!.fontSize! +
                                            2,
                                        height: 0.25),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
