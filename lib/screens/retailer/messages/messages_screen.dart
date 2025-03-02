// import 'package:flutter/material.dart';

// class Message {
//   final String title;
//   final String description;
//   final String date;
//   final String category;
//   final String status;
//   final String icon;

//   Message({
//     required this.title,
//     required this.description,
//     required this.date,
//     required this.category,
//     required this.status,
//     required this.icon,
//   });
// }

// class MessagesScreen extends StatefulWidget {
//   const MessagesScreen({Key? key}) : super(key: key);

//   @override
//   _MessagesScreenState createState() => _MessagesScreenState();
// }

// class _MessagesScreenState extends State<MessagesScreen> {
//   String selectedFilter = 'All';
//   final List<String> filters = ['All', 'Travelling', 'Support'];
  
//   final List<Message> messages = [
//     Message(
//       title: 'leez Support',
//       description: 'leez: This case is closed due to inac...',
//       date: '21/2/25',
//       category: 'Support',
//       status: 'Closed',
//       icon: 'assets/logo/quickleez_1.png', // You'll need to add this asset
//     ),
//     // Add more messages here as needed
//   ];

//   List<Message> get filteredMessages {
//     if (selectedFilter == 'All') return messages;
//     return messages.where((message) => message.category == selectedFilter).toList();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Header with search and menu
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   const Text(
//                     'Messages',
//                     style: TextStyle(
//                       fontSize: 24,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   Row(
//                     children: [
//                       IconButton(
//                         icon: const Icon(Icons.search),
//                         onPressed: () {
//                           // Implement search functionality
//                         },
//                       ),
//                       IconButton(
//                         icon: const Icon(Icons.more_horiz),
//                         onPressed: () {
//                           // Implement menu functionality
//                         },
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
              
//               const SizedBox(height: 16),
              
//               // Filter chips
//               SizedBox(
//                 height: 40,
//                 child: ListView.builder(
//                   scrollDirection: Axis.horizontal,
//                   itemCount: filters.length,
//                   itemBuilder: (context, index) {
//                     final filter = filters[index];
//                     final isSelected = selectedFilter == filter;
                    
//                     return Padding(
//                       padding: const EdgeInsets.only(right: 8),
//                       child: FilterChip(
//                         selected: isSelected,
//                         backgroundColor: isSelected ? Colors.black : Colors.grey[200],
//                         label: Text(
//                           filter,
//                           style: TextStyle(
//                             color: isSelected ? Colors.white : Colors.black,
//                           ),
//                         ),
//                         onSelected: (selected) {
//                           setState(() {
//                             selectedFilter = filter;
//                           });
//                         },
//                       ),
//                     );
//                   },
//                 ),
//               ),
              
//               const SizedBox(height: 16),
              
//               // Messages list
//               Expanded(
//                 child: ListView.builder(
//                   itemCount: filteredMessages.length,
//                   itemBuilder: (context, index) {
//                     final message = filteredMessages[index];
                    
//                     return ListTile(
//                       leading: CircleAvatar(
//                         backgroundColor: Colors.black,
//                         child: Image.asset(
//                           message.icon,
//                           color: Colors.white,
//                           width: 24,
//                         ),
//                       ),
//                       title: Text(message.title),
//                       subtitle: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(message.description),
//                           Text(
//                             message.status,
//                             style: const TextStyle(
//                               color: Colors.grey,
//                               fontSize: 12,
//                             ),
//                           ),
//                         ],
//                       ),
//                       trailing: Text(
//                         message.date,
//                         style: const TextStyle(
//                           color: Colors.grey,
//                           fontSize: 12,
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }