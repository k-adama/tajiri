// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:pull_to_refresh/pull_to_refresh.dart';
// import 'package:tajiri_pos_mobile/presentation/controllers/navigation/home/home.controller.dart';
// import 'package:tajiri_pos_mobile/presentation/screens/navigation/home/components/story_element_component.dart';

// class StoryScreen extends StatefulWidget {
//   const StoryScreen({super.key});

//   @override
//   State<StoryScreen> createState() => _StoryScreenState();
// }

// class _StoryScreenState extends State<StoryScreen> {
//   PageController? pageController;
//   RefreshController? controller;

//   @override
//   void initState() {
//     pageController = PageController(initialPage: 0);
//     controller = RefreshController();

//     super.initState();
//   }

//   @override
//   void dispose() {
//     pageController!.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<HomeController>(
//       builder: (homeController) => PageView.builder(
//         controller: pageController,
//         itemCount: 1,
//         physics: const PageScrollPhysics(),
//         itemBuilder: (context, index) {
//           return StoryElementComponent(
//             story: homeController.stories,
//             nextPage: () {
//               final lastIndex = homeController.stories.length - 1;
//               if (index != lastIndex) {
//                 pageController!.animateToPage(++index,
//                     duration: const Duration(milliseconds: 500),
//                     curve: Curves.easeIn);
//                 setState(() {});
//               } else {
//                 Navigator.pop(context);
//               }
//             },
//             prevPage: () {
//               const firstIndex = 0;
//               if (index != firstIndex) {
//                 pageController!.animateToPage(--index,
//                     duration: const Duration(milliseconds: 500),
//                     curve: Curves.easeIn);
//                 setState(() {});
//               } else {
//                 Navigator.pop(context);
//               }
//             },
//           );
//         },
//       ),
//     );
//   }
// }
