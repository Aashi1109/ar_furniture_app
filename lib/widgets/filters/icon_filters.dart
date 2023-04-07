// import 'package:flutter/material.dart';

// class FiltersIcon extends StatefulWidget {
//   const FiltersIcon(this.setCurrentFilter, {super.key});
//   final Function setCurrentFilter;
//   // final bool reset;

//   @override
//   State<FiltersIcon> createState() => _FiltersIconState();
// }

// class _FiltersIconState extends State<FiltersIcon> {
//   final List<Map<String, String>> _iconUrls = [
//     {'url': 'assets/images/chair_1.png', 'text': 'Chair'},
//     {'url': 'assets/images/decor_1.png', 'text': 'Decor'},
//     {'url': 'assets/images/pot_3.png', 'text': 'Pot'},
//     {'url': 'assets/images/sofa.png', 'text': 'Sofa'},
//     {'url': 'assets/images/wallart_1.png', 'text': 'Wallart'},
//     {'url': 'assets/images/table_1.png', 'text': 'Table'},
//   ];
//   int? _selectedIndex;
//   void _filterTapHandler(int curIndex) {
//     setState(() {
//       // if (widget.reset) {
//       //   _selectedIndex = null;
//       // }
//       _selectedIndex = curIndex;
//       widget.setCurrentFilter(_iconUrls[_selectedIndex!]['text']);
//     });
//   }

//   Widget buildIconFilterItem(
//       VoidCallback itemTapHanlder, bool isTapped, Map<String, String> fileUrl) {
//     return InkWell(
//       onTap: itemTapHanlder,
//       child: Container(
//         padding: const EdgeInsets.symmetric(
//           vertical: 8.0,
//           horizontal: 16,
//         ),
//         decoration: BoxDecoration(
//           // color: Colors.amber,
//           color: isTapped
//               ? Theme.of(context).colorScheme.secondary
//               : Theme.of(context).colorScheme.tertiary,
//           borderRadius: BorderRadius.circular(20),
//         ),
//         margin: const EdgeInsets.only(
//           right: 15,
//         ),
//         height: 80,
//         width: 120,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Image.asset(
//               fileUrl['url']!,
//               height: 40,
//               width: 40,
//               fit: BoxFit.contain,
//             ),
//             Text(
//               fileUrl['text']!,
//               style: TextStyle(
//                 color: !isTapped
//                     ? Theme.of(context).colorScheme.primary
//                     : Theme.of(context).colorScheme.onPrimary,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 80,
//       child: ListView.builder(
//         shrinkWrap: true,
//         scrollDirection: Axis.horizontal,
//         itemBuilder: (context, index) => buildIconFilterItem(
//           () => _filterTapHandler(index),
//           _selectedIndex == index ? true : false,
//           _iconUrls[index],
//         ),
//         itemCount: _iconUrls.length,
//       ),
//     );
//   }
// }
