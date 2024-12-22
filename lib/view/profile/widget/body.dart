import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:sneakers_app/Authentication/accountmanagment.dart';
import 'package:sneakers_app/theme/custom_app_theme.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Authentication
import 'package:sneakers_app/view/Favourite/favourite_shoes.dart';

import '../../../animation/fadeanimation.dart';
import '../../../models/models.dart';
import '../../../utils/constants.dart';
import '../../../widget/location.dart';
import 'repeated_list.dart';
import '../../../data/dummy_data.dart';

class BodyProfile extends StatefulWidget {
  const BodyProfile({Key? key}) : super(key: key);

  @override
  _BodyProfileState createState() => _BodyProfileState();
}

class _BodyProfileState extends State<BodyProfile> {
  int statusCurrentIndex = 0;
  String userName = '';

  var userEmail; // Default name for the user

  @override
  void initState() {
    super.initState();
    getUserName().then((name) {
      setState(() {
        userName = name!;
      });
    });
  }

  // Fetch the logged-in user's display name

  void navigateToFavoriteShoes(BuildContext context, String userEmail) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FavoriteShoesScreen(userEmail: userEmail),
      ),
    );
  }
  Future<String?> getUserName() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        final docSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid) // Use user.uid for document ID (recommended)
            .get();

        if (docSnapshot.exists) {
          final userName = docSnapshot.data()?['name'];
          return userName ?? 'User'; // Default value if 'name' is absent
        } else {
          print("User document does not exist.");
          return null; // Handle document absence or errors
        }
      } on FirebaseException catch (e) {
        print("Error fetching user data: ${e.message}");
        return null; // Handle potential Firestore errors gracefully
      }
    } else {
      print("No user is logged in.");
      return null; // Handle no logged-in user gracefully
    }
  }




  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
          width: width,
          height: height,
          child: Column(
            children: [
              topProfilePicAndName(width, height),
              // SizedBox(height: 40),
              // middleStatusListView(width, height),
              const SizedBox(height: 30),
              middleDashboard(width, height),
              bottomSection(width, height),
            ],
          ),
        );
      },
    );
  }

  // Top Profile Photo And Name Components
  Widget topProfilePicAndName(double width, double height) {
    return FadeAnimation(
      delay: 1,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage(
                "https://avatars.githubusercontent.com/u/91388754?v=4"),
          ),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userName, // Display the logged-in user's name
                style: AppThemes.profileDevName,
              ),
              const Text(
                "User",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          const SizedBox(width: 10),
          IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=>AccountManagementScreen()));
            },
            icon: const Icon(
              Icons.edit_outlined,
              color: Colors.grey,
            ),
          )
        ],
      ),
    );
  }

  // Middle Status List View Components
  // Widget middleStatusListView(double width, double height) {
  //   return FadeAnimation(
  //     delay: 1.5,
  //     child: Container(
  //       width: width,
  //       height: height / 9,
  //       child: SingleChildScrollView(
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Padding(
  //               padding: const EdgeInsets.only(left: 15),
  //               child: Text(
  //                 "My Status",
  //                 style: TextStyle(
  //                   fontWeight: FontWeight.w500,
  //                   color: Colors.grey,
  //                   fontSize: 15,
  //                 ),
  //               ),
  //             ),
  //             SizedBox(height: 5),
  //             Center(
  //               child: Container(
  //                 width: width / 1.12,
  //                 height: height / 13,
  //                 child: ListView.builder(
  //                   physics: BouncingScrollPhysics(),
  //                   scrollDirection: Axis.horizontal,
  //                   itemCount: userStatus.length,
  //                   itemBuilder: (ctx, index) {
  //                     UserStatus status = userStatus[index];
  //                     return GestureDetector(
  //                       onTap: () {
  //                         setState(() {
  //                           statusCurrentIndex = index;
  //                         });
  //                       },
  //                       child: Padding(
  //                         padding: EdgeInsets.symmetric(horizontal: 5),
  //                         child: Container(
  //                           margin: EdgeInsets.all(5),
  //                           width: 120,
  //                           decoration: BoxDecoration(
  //                             color: statusCurrentIndex == index
  //                                 ? status.selectColor
  //                                 : status.unSelectColor,
  //                             borderRadius: BorderRadius.circular(25),
  //                           ),
  //                           child: Row(
  //                             mainAxisAlignment: MainAxisAlignment.center,
  //                             children: [
  //                               Text(
  //                                 status.emoji,
  //                                 style: TextStyle(fontSize: 16),
  //                               ),
  //                               SizedBox(width: 4),
  //                               Text(
  //                                 status.txt,
  //                                 style: TextStyle(
  //                                   fontWeight: FontWeight.w600,
  //                                   color: AppConstantsColor.lightTextColor,
  //                                   fontSize: 16,
  //                                 ),
  //                               ),
  //                             ],
  //                           ),
  //                         ),
  //                       ),
  //                     );
  //                   },
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // Middle Dashboard ListTile Components
  Widget middleDashboard(double width, double height) {
    return FadeAnimation(
      delay: 2,
      child: SizedBox(
        width: width,
        height: height / 2.6,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "    Dashboard",
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 10),
            RoundedLisTile(
              width: width,
              height: height,
              leadingBackColor: Colors.green[600],
              icon: Icons.wallet_travel_outlined,
              title: "Payments",
              trailing: Container(
                width: 80,
                height: 30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.blue[700],
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "2 New",
                      style: TextStyle(
                        color: AppConstantsColor.lightTextColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: AppConstantsColor.lightTextColor,
                      size: 15,
                    ),
                  ],
                ),
              ),
            ),
            RoundedLisTile(
              width: width,
              height: height,
              leadingBackColor: Colors.yellow[600],
              icon: Icons.archive,
              title: "Store Locator",
              trailing: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LocationScreen()),
                        );
                      },
                      child: const Icon(
                        Icons.arrow_forward_ios,
                        color: AppConstantsColor.darkTextColor,
                        size: 15,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: (){
                Get.to(FavoriteShoesScreen(userEmail: userEmail));
              },
              child: RoundedLisTile(
                width: width,
                height: height,
                leadingBackColor: Colors.grey[400],
                icon: Icons.favorite,
                title: "Favourites",
                trailing: Container(
                  width: 140,
                  height: 30,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.red[500],
                  ),
                  // child: Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   crossAxisAlignment: CrossAxisAlignment.center,
                  //   children: [
                  //     Text(
                  //       "Action Needed  ",
                  //       style: TextStyle(
                  //         color: AppConstantsColor.lightTextColor,
                  //         fontWeight: FontWeight.w500,
                  //       ),
                  //     ),
                  //     Icon(
                  //       Icons.arrow_forward_ios,
                  //       color: AppConstantsColor.lightTextColor,
                  //       size: 15,
                  //     ),
                  //   ],
                  // ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // My Account Section Components
  Widget bottomSection(double width, double height) {
    return FadeAnimation(
      delay: 2.5,
      child: SizedBox(
        width: width,
        height: height / 6.5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "    My Account",
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "    Log Out",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.red[500],
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
