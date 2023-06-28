import 'package:flutter/material.dart';
import 'package:unjabbed_admin/presentation/user/tutorial_screen.dart';
import 'package:unjabbed_admin/presentation/user/user.screen.dart';
import '../../domain/core/interfaces/widget/drawer.dart';
import '../package/package.screen.dart';
import '../screens.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with AutomaticKeepAliveClientMixin {
  late PageController controller;
  @override
  void initState() {
    controller=PageController(initialPage: 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      drawer: drawer(context,controller),
      appBar: AppBar(elevation: 0,),
      body: Row(
        children: [
          Expanded(
            child: PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: controller,
              children:  [
                UserScreen(),
                TutorialScreen(),
                PackageScreen(),
                ItemaccessScreen(),
                AuthChangePasswordScreen(),
                VerifyScreen(),
                UserReportScreen(),
                UserReviewScreen()
              ],
            ),
          ),
        ],
      ),
    );
  }
  @override
  bool get wantKeepAlive => true;
}



