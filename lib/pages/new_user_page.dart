import 'package:wishlist/models/user.dart';
import 'package:wishlist/pages/wishlist_list_page.dart';
import 'package:wishlist/state_manege/new_user_store/new_user_store.dart';
import 'package:wishlist/util/custom_assets.dart';
import 'package:wishlist/widgets/user_clip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';

import '../container.dart';
import '../theme.dart';

class NewUserPage extends StatefulWidget {
  const NewUserPage({super.key});

  @override
  State<NewUserPage> createState() => _NewUserPageState();
}

class _NewUserPageState extends State<NewUserPage> {
  late NewUserStore _newUserStore;
  late List<ReactionDisposer> _disposers;

  @override
  void initState() {
    getDependecies();
    super.initState();
  }

  getDependecies() async {
    _newUserStore = sl();
    _disposers = [
      reaction((_) => _newUserStore.inputError, (String? error) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(error ?? "")));
      }),
      reaction((_) => _newUserStore.user, (User? user) {
        if (user != null) goToCartListPage(user);
      })
    ];
  }

  @override
  void dispose() {
    // ignore: avoid_function_literals_in_foreach_calls
    _disposers.forEach((r) => r());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CColors.blue.withOpacity(0.0),
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
        decoration: BoxDecoration(
            gradient: RadialGradient(
                radius: 0.7, colors: [CColors.cerelean, CColors.blue])),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Text(
                "Select you icon and name",
                style: TextStyle(
                    color: CColors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ),
            GestureDetector(
              onTap: () {
                _buildSelectUserIcon();
              },
              child: SizedBox(
                  height: 100,
                  width: 100,
                  child: Observer(
                      builder: (_) => UserIconClip(
                          iconpath: _newUserStore.userIconSelected))),
            ),
            Observer(
              builder: (_) => TextField(
                controller: TextEditingController(text: _newUserStore.userName),
                textAlign: TextAlign.center,
                cursorColor: CColors.white,
                style: TextStyle(color: CColors.white),
                decoration: InputDecoration(
                    errorText: _newUserStore.inputError,
                    hintText: "Name",
                    alignLabelWithHint: true,
                    hintStyle: TextStyle(
                      color: CColors.white,
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: CColors.white),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: CColors.white),
                    )),
                onChanged: (value) => _newUserStore.userName = value,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 40.0),
              child: TextButton.icon(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: CColors.blue),
                  onPressed: () {
                    _newUserStore.createNewUser();
                  },
                  icon: Icon(
                    Icons.open_in_new_outlined,
                    color: CColors.white,
                  ),
                  label: Text(
                    "Save New User",
                    style: TextStyle(color: CColors.white),
                  )),
            ),
          ],
        ),
      ),
    );
  }

  void _buildSelectUserIcon() {
    List<String> iconsList = CustomAssets.userIcons;

    showModalBottomSheet(
      context: context,
      builder: (context) => BottomSheet(
        onClosing: () {},
        builder: (context) => StatefulBuilder(
          builder: (context, bottomSheetSetState) => Container(
            height: 250,
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Select an User Icon",
                      style: TextStyle(
                          color: CColors.blue, fontWeight: FontWeight.bold),
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("Cancel",
                            style: TextStyle(color: CColors.blue))),
                  ],
                ),
                Expanded(
                  child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(
                            iconsList.length,
                            (index) => GestureDetector(
                                  onTap: () {
                                    _newUserStore.userIconSelected =
                                        iconsList[index];
                                    bottomSheetSetState(() {});
                                    setState(() {});
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Stack(
                                          children: [
                                            Container(
                                              width: 100,
                                              height: 100,
                                              decoration: _newUserStore
                                                          .userIconSelected ==
                                                      iconsList[index]
                                                  ? BoxDecoration(
                                                      boxShadow: const [
                                                          BoxShadow(
                                                              color:
                                                                  Colors.green,
                                                              spreadRadius: 1)
                                                        ],
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              180))
                                                  : null,
                                              child: UserIconClip(
                                                  iconpath: iconsList[index]),
                                            ),
                                            _newUserStore.userIconSelected ==
                                                    iconsList[index]
                                                ? const Icon(
                                                    Icons.verified,
                                                    color: Colors.green,
                                                  )
                                                : Container()
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                )),
                      )),
                ),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Continue",
                        style: TextStyle(color: CColors.blue))),
              ],
            ),
          ),
        ),
      ),
    );
  }

  goToCartListPage(User newUser) => Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (_) => WishlistListPage(user: newUser)));
}
