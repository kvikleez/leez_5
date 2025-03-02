// import 'package:flutter/material.dart';

// class FAQPage extends StatefulWidget {
//   const FAQPage({super.key});

//   @override
//   _FAQPageState createState() => _FAQPageState();
// }

// class _FAQPageState extends State<FAQPage> {
//   int? expandedIndex;
//   String searchQuery = '';
//   List<FAQItem> filteredItems = [];
//   bool isDarkMode = false;

//   final List<FAQItem> faqItems = [
//     FAQItem(
//       question: 'What is Quickleez?',
//       answer:
//           'Quickleez is a platform where you can rent or buy items like laptops, mobiles, cameras, cars, bikes, and more. It connects sellers and renters in a seamless way.',
//       category: 'General',
//     ),
//     FAQItem(
//       question: 'How do I rent an item on Quickleez?',
//       answer:
//           'To rent an item, search for the product you need, select the rental period, and proceed to payment. Once confirmed, you can pick up the item or have it delivered.',
//       category: 'Renting',
//     ),
//     FAQItem(
//       question: 'Can I buy items on Quickleez?',
//       answer:
//           'Yes, you can buy items listed on Quickleez. Simply select the "Buy" option, complete the payment, and arrange for delivery or pickup.',
//       category: 'Buying',
//     ),
//     FAQItem(
//       question: 'How do I list an item for rent or sale?',
//       answer:
//           'To list an item, create an account, go to the "Add Listing" section, fill in the details, upload images, and set the price. Your item will be visible to users once approved.',
//       category: 'Selling',
//     ),
//     FAQItem(
//       question: 'What payment methods are accepted?',
//       answer:
//           'Quickleez supports multiple payment methods, including credit/debit cards, UPI, and net banking. All transactions are secure and encrypted.',
//       category: 'Payments',
//     ),
//     FAQItem(
//       question: 'What if the item I rented is damaged?',
//       answer:
//           'If the item is damaged during the rental period, you may be charged a repair fee. Make sure to inspect the item before renting and report any pre-existing damage.',
//       category: 'Policies',
//     ),
//     FAQItem(
//       question: 'How do I contact customer support?',
//       answer:
//           'You can contact Quickleez customer support through the "Help" section in the app or email us at support@quickleez.com. We're available 24/7 to assist you.',
//       category: 'Support',
//     ),
//     FAQItem(
//       question: 'Is there a refund policy?',
//       answer:
//           'Yes, Quickleez offers a refund policy for cancellations made within 24 hours of booking. Refunds are processed within 5-7 business days.',
//       category: 'Policies',
//     ),
//   ];

//   @override
//   void initState() {
//     super.initState();
//     filteredItems = List.from(faqItems);
//   }

//   void filterFAQs(String query) {
//     setState(() {
//       searchQuery = query;
//       if (query.isEmpty) {
//         filteredItems = List.from(faqItems);
//       } else {
//         filteredItems = faqItems
//             .where((item) =>
//                 item.question.toLowerCase().contains(query.toLowerCase()) ||
//                 item.answer.toLowerCase().contains(query.toLowerCase()) ||
//                 item.category.toLowerCase().contains(query.toLowerCase()))
//             .toList();
//       }
//     });
//   }

//   List<String> get categories {
//     final Set<String> uniqueCategories = {};
//     for (var item in faqItems) {
//       uniqueCategories.add(item.category);
//     }
//     return uniqueCategories.toList()..sort();
//   }

//   void filterByCategory(String category) {
//     setState(() {
//       if (category == 'All') {
//         filteredItems = List.from(faqItems);
//       } else {
//         filteredItems = faqItems
//             .where((item) => item.category == category)
//             .toList();
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Get screen dimensions for responsive design
//     final screenWidth = MediaQuery.of(context).size.width;
//     final isWideScreen = screenWidth > 600;
    
//     final ThemeData theme = isDarkMode
//         ? ThemeData.dark().copyWith(
//             primaryColor: Colors.tealAccent,
//             colorScheme: ColorScheme.dark(
//               primary: Colors.tealAccent,
//               secondary: Colors.tealAccent.shade400,
//             ),
//           )
//         : ThemeData.light().copyWith(
//             primaryColor: Colors.teal,
//             colorScheme: ColorScheme.light(
//               primary: Colors.teal,
//               secondary: Colors.teal.shade300,
//             ),
//           );

//     return Theme(
//       data: theme,
//       child: Scaffold(
//         appBar: AppBar(
//           elevation: 0,
//           title: Text(
//             'Frequently Asked Questions',
//             style: TextStyle(
//               fontSize: isWideScreen ? 24 : 20, 
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           centerTitle: true,
//           leading: IconButton(
//             icon: const Icon(Icons.arrow_back),
//             onPressed: () {
//               Navigator.pop(context);
//             },
//           ),
//           actions: [
//             IconButton(
//               icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
//               onPressed: () {
//                 setState(() {
//                   isDarkMode = !isDarkMode;
//                 });
//               },
//               tooltip: isDarkMode ? 'Switch to Light Mode' : 'Switch to Dark Mode',
//             ),
//             IconButton(
//               icon: const Icon(Icons.more_vert),
//               onPressed: () {
//                 _showMoreOptions(context);
//               },
//             ),
//           ],
//         ),
//         body: Column(
//           children: [
//             // Search bar
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: TextField(
//                 onChanged: filterFAQs,
//                 decoration: InputDecoration(
//                   hintText: 'Search FAQs...',
//                   prefixIcon: const Icon(Icons.search),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(30),
//                     borderSide: BorderSide.none,
//                   ),
//                   filled: true,
//                   fillColor: theme.colorScheme.surface,
//                   contentPadding: const EdgeInsets.symmetric(vertical: 0),
//                   suffixIcon: searchQuery.isNotEmpty
//                       ? IconButton(
//                           icon: const Icon(Icons.clear),
//                           onPressed: () {
//                             filterFAQs('');
//                           },
//                         )
//                       : null,
//                 ),
//               ),
//             ),
            
//             // Category chips
//             SingleChildScrollView(
//               scrollDirection: Axis.horizontal,
//               padding: const EdgeInsets.symmetric(horizontal: 16.0),
//               child: Row(
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.only(right: 8.0),
//                     child: FilterChip(
//                       label: const Text('All'),
//                       selected: filteredItems.length == faqItems.length && searchQuery.isEmpty,
//                       onSelected: (_) => filterByCategory('All'),
//                       backgroundColor: theme.colorScheme.surface,
//                       selectedColor: theme.colorScheme.primary,
//                       labelStyle: TextStyle(
//                         color: filteredItems.length == faqItems.length && searchQuery.isEmpty
//                             ? Colors.white
//                             : theme.textTheme.bodyLarge?.color,
//                       ),
//                     ),
//                   ),
//                   ...categories.map((category) {
//                     final isSelected = filteredItems.every((item) => item.category == category) &&
//                         filteredItems.isNotEmpty &&
//                         searchQuery.isEmpty;
//                     return Padding(
//                       padding: const EdgeInsets.only(right: 8.0),
//                       child: FilterChip(
//                         label: Text(category),
//                         selected: isSelected,
//                         onSelected: (_) => filterByCategory(category),
//                         backgroundColor: theme.colorScheme.surface,
//                         selectedColor: theme.colorScheme.primary,
//                         labelStyle: TextStyle(
//                           color: isSelected
//                               ? Colors.white
//                               : theme.textTheme.bodyLarge?.color,
//                         ),
//                       ),
//                     );
//                   }),
//                 ],
//               ),
//             ),
            
//             const SizedBox(height: 8),
            
//             // FAQ items
//             Expanded(
//               child: filteredItems.isEmpty
//                   ? Center(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           const Icon(Icons.search_off, size: 64, color: Colors.grey),
//                           const SizedBox(height: 16),
//                           Text(
//                             'No FAQs match your search',
//                             style: TextStyle(fontSize: 18, color: Colors.grey[600]),
//                           ),
//                           const SizedBox(height: 8),
//                           ElevatedButton(
//                             onPressed: () {
//                               filterFAQs('');
//                             },
//                             child: const Text('Clear Search'),
//                           ),
//                         ],
//                       ),
//                     )
//                   : ListView.builder(
//                       itemCount: filteredItems.length,
//                       padding: const EdgeInsets.only(bottom: 16.0),
//                       itemBuilder: (context, index) {
//                         final item = filteredItems[index];
//                         return AnimatedContainer(
//                           duration: const Duration(milliseconds: 300),
//                           margin: EdgeInsets.symmetric(
//                             vertical: 8.0,
//                             horizontal: isWideScreen ? 24.0 : 16.0,
//                           ),
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(12),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: theme.shadowColor.withOpacity(0.1),
//                                 blurRadius: 5,
//                                 offset: const Offset(0, 3),
//                               ),
//                             ],
//                           ),
//                           child: Card(
//                             elevation: 0,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                             child: Theme(
//                               data: Theme.of(context).copyWith(
//                                 dividerColor: Colors.transparent,
//                               ),
//                               child: ExpansionTile(
//                                 key: Key(index.toString()),
//                                 title: Text(
//                                   item.question,
//                                   style: TextStyle(
//                                     fontSize: isWideScreen ? 18 : 16,
//                                     fontWeight: FontWeight.w600,
//                                   ),
//                                 ),
//                                 subtitle: Padding(
//                                   padding: const EdgeInsets.only(top: 4.0),
//                                   child: Chip(
//                                     label: Text(
//                                       item.category,
//                                       style: const TextStyle(fontSize: 12),
//                                     ),
//                                     materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
//                                     padding: EdgeInsets.zero,
//                                     labelPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: -2),
//                                     backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
//                                   ),
//                                 ),
//                                 onExpansionChanged: (isExpanded) {
//                                   setState(() {
//                                     expandedIndex = isExpanded ? index : null;
//                                   });
//                                 },
//                                 initiallyExpanded: expandedIndex == index,
//                                 childrenPadding: const EdgeInsets.symmetric(
//                                   horizontal: 16.0,
//                                   vertical: 8.0,
//                                 ),
//                                 collapsedBackgroundColor: theme.cardColor,
//                                 backgroundColor: theme.colorScheme.surface,
//                                 leading: CircleAvatar(
//                                   backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
//                                   child: Text(
//                                     item.question[0].toUpperCase(),
//                                     style: TextStyle(
//                                       color: theme.colorScheme.primary,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                 ),
//                                 trailing: Icon(
//                                   expandedIndex == index
//                                       ? Icons.keyboard_arrow_up
//                                       : Icons.keyboard_arrow_down,
//                                   color: theme.colorScheme.primary,
//                                 ),
//                                 children: [
//                                   Text(
//                                     item.answer,
//                                     style: TextStyle(
//                                       fontSize: 16,
//                                       height: 1.5,
//                                       color: theme.textTheme.bodyMedium?.color,
//                                     ),
//                                   ),
//                                   const SizedBox(height: 16),
//                                   Row(
//                                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                                     children: [
//                                       _buildActionButton(
//                                         icon: Icons.info_outline,
//                                         label: 'Learn More',
//                                         onPressed: () => _showLearnMoreDialog(context, item),
//                                         theme: theme,
//                                       ),
//                                       _buildActionButton(
//                                         icon: Icons.share,
//                                         label: 'Share',
//                                         onPressed: () => _shareFAQ(item),
//                                         theme: theme,
//                                       ),
//                                       _buildActionButton(
//                                         icon: Icons.feedback_outlined,
//                                         label: 'Feedback',
//                                         onPressed: () => _showFeedbackDialog(context),
//                                         theme: theme,
//                                       ),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//             ),
//           ],
//         ),
//         floatingActionButton: FloatingActionButton(
//           onPressed: () {
//             _showContactSupportDialog(context);
//           },
//           tooltip: 'Contact Support',
//           child: const Icon(Icons.support_agent),
//         ),
//       ),
//     );
//   }

//   Widget _buildActionButton({
//     required IconData icon,
//     required String label,
//     required VoidCallback onPressed,
//     required ThemeData theme,
//   }) {
//     return TextButton.icon(
//       onPressed: onPressed,
//       icon: Icon(
//         icon,
//         size: 18,
//         color: theme.colorScheme.primary,
//       ),
//       label: Text(
//         label,
//         style: TextStyle(
//           color: theme.colorScheme.primary,
//         ),
//       ),
//       style: TextButton.styleFrom(
//         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(30),
//         ),
//       ),
//     );
//   }

//   // Show more options dialog
//   void _showMoreOptions(BuildContext context) {
//     final theme = Theme.of(context);
    
//     showModalBottomSheet(
//       context: context,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (context) {
//         return Container(
//           padding: const EdgeInsets.symmetric(vertical: 20),
//           child: Column(
// mainAxisSize: MainAxisSize.min,
//     children: [
//       Container(
//         width: 40,
//         height: 4,
//         margin: const EdgeInsets.only(bottom: 20),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(2),
//           color: Colors.grey[300],
//         ),
//       ),
//       ListTile(
//         leading: Icon(Icons.print, color: theme.colorScheme.primary),
//         title: const Text('Print FAQ'),
//         onTap: () {
//           Navigator.pop(context);
//           // Implement print functionality
//         },
//       ),
//       ListTile(
//         leading: Icon(Icons.star_border, color: theme.colorScheme.primary),
//         title: const Text('Save as Favorite'),
//         onTap: () {
//           Navigator.pop(context);
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('FAQ saved to favorites')),
//           );
//         },
//       ),
//       ListTile(
//         leading: Icon(Icons.chat_bubble_outline, color: theme.colorScheme.primary),
//         title: const Text('Ask a New Question'),
//         onTap: () {
//           Navigator.pop(context);
//           showAskQuestionDialog(context);
//         },
//       ),
//       ListTile(
//         leading: Icon(Icons.download_outlined, color: theme.colorScheme.primary),
//         title: const Text('Download All FAQs'),
//         onTap: () {
//           Navigator.pop(context);
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('Downloading FAQs...')),
//           );
//         },
//       ),
//     ],
//   ),
// );
// }

// // Show Learn More dialog with enhanced design
// void showLearnMoreDialog(BuildContext context, FAQItem item) {
// final theme = Theme.of(context);

// showDialog(
//   context: context,
//   builder: (context) {
//     return AlertDialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//       title: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               CircleAvatar(
//                 backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
//                 child: Text(
//                   item.category[0].toUpperCase(),
//                   style: TextStyle(
//                     color: theme.colorScheme.primary,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: Text(
//                   item.question,
//                   style: const TextStyle(fontSize: 18),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 8),
//           Chip(
//             label: Text(item.category),
//             backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
//           ),
//         ],
//       ),
//       content: SingleChildScrollView(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Detailed Answer:',
//               style: TextStyle(fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               item.answer,
//               style: const TextStyle(height: 1.5),
//             ),
//             const SizedBox(height: 16),
//             const Text(
//               'Related Questions:',
//               style: TextStyle(fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 8),
//             ...faqItems
//                 .where((faq) => faq.category == item.category && faq.question != item.question)
//                 .take(2)
//                 .map((faq) => Padding(
//                       padding: const EdgeInsets.only(bottom: 8.0),
//                       child: ListTile(
//                         title: Text(faq.question),
//                         contentPadding: EdgeInsets.zero,
//                         leading: const Icon(Icons.question_answer_outlined, size: 18),
//                         dense: true,
//                         onTap: () {
//                           Navigator.pop(context);
//                           showLearnMoreDialog(context, faq);
//                         },
//                       ),
//                     ))
//                 ,
//           ],
//         ),
//       ),
//       actions: [
//         TextButton.icon(
//           icon: const Icon(Icons.share, size: 18),
//           label: const Text('Share'),
//           onPressed: () {
//             Navigator.pop(context);
//             shareFAQ(item);
//           },
//         ),
//         TextButton.icon(
//           icon: const Icon(Icons.close, size: 18),
//           label: const Text('Close'),
//           onPressed: () => Navigator.of(context).pop(),
//         ),
//       ],
//     );
//   },
// );
// }

// // Share FAQ item
// void shareFAQ(FAQItem item) {
// // Implement sharing functionality here
// // For example, using the share_plus package
// ScaffoldMessenger.of(context).showSnackBar(
//   SnackBar(content: Text('Sharing: ${item.question}')),
// );
// }

// // Show feedback dialog
// void showFeedbackDialog(BuildContext context) {
// final TextEditingController feedbackController = TextEditingController();
// final formKey = GlobalKey<FormState>();

// showDialog(
//   context: context,
//   builder: (context) {
//     return AlertDialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//       title: const Text('Submit Feedback'),
//       content: Form(
//         key: formKey,
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const Text('How helpful was this FAQ?'),
//             const SizedBox(height: 12),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: List.generate(5, (index) {
//                 return IconButton(
//                   onPressed: () {
//                     // Implement rating functionality
//                   },
//                   icon: Icon(
//                     Icons.star_border,
//                     color: Colors.amber,
//                   ),
//                 );
//               }),
//             ),
//             const SizedBox(height: 16),
//             TextFormField(
//               controller: feedbackController,
//               maxLines: 3,
//               decoration: const InputDecoration(
//                 hintText: 'Tell us how we can improve this FAQ',
//                 border: OutlineInputBorder(),
//               ),
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return 'Please enter some feedback';
//                 }
//                 return null;
//               },
//             ),
//           ],
//         ),
//       ),
//       actions: [
//         TextButton(
//           onPressed: () => Navigator.of(context).pop(),
//           child: const Text('Cancel'),
//         ),
//         ElevatedButton(
//           onPressed: () {
//             if (formKey.currentState!.validate()) {
//               Navigator.pop(context);
//               ScaffoldMessenger.of(context).showSnackBar(
//                 const SnackBar(content: Text('Thank you for your feedback!')),
//               );
//             }
//           },
//           child: const Text('Submit'),
//         ),
//       ],
//     );
//   },
// );
// }

// // Show contact support dialog
// void showContactSupportDialog(BuildContext context) {
// showDialog(
//   context: context,
//   builder: (context) {
//     return AlertDialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//       title: const Text('Contact Support'),
//       content: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           const Text('Choose how you would like to contact our support team:'),
//           const SizedBox(height: 20),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               buildContactOption(
//                 context: context,
//                 icon: Icons.chat_bubble_outline,
//                 label: 'Chat',
//                 onTap: () {
//                   Navigator.pop(context);
//                   // Implement chat functionality
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(content: Text('Starting chat with support...')),
//                   );
//                 },
//               ),
//               buildContactOption(
//                 context: context,
//                 icon: Icons.email_outlined,
//                 label: 'Email',
//                 onTap: () {
//                   Navigator.pop(context);
//                   // Implement email functionality
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(
//                       content: Text('Opening email to support@quickleez.com...'),
//                     ),
//                   );
//                 },
//               ),
//               buildContactOption(
//                 context: context,
//                 icon: Icons.phone_outlined,
//                 label: 'Call',
//                 onTap: () {
//                   Navigator.pop(context);
//                   // Implement call functionality
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(content: Text('Calling support...')),
//                   );
//                 },
//               ),
//             ],
//           ),
//         ],
//       ),
//       actions: [
//         TextButton(
//           onPressed: () => Navigator.of(context).pop(),
//           child: const Text('Cancel'),
//         ),
//       ],
//     );
//   },
// );
// }

// Widget buildContactOption({
//   required BuildContext context,
//   required IconData icon,
//   required String label,
//   required VoidCallback onTap,
// }) {
//   return InkWell(
//     onTap: onTap,
//     borderRadius: BorderRadius.circular(12),
//     child: Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           CircleAvatar(
//             radius: 24,
//             backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
//             child: Icon(
//               icon,
//               color: Theme.of(context).colorScheme.primary,
//             ),
//           ),
//           const SizedBox(height: 8),
//           Text(label),
//         ],
//       ),
//     ),
//   );
// }

// // Show ask question dialog
// void showAskQuestionDialog(BuildContext context) {
//   final TextEditingController questionController = TextEditingController();
//   final formKey = GlobalKey<FormState>();

//   showDialog(
//     context: context,
//     builder: (context) {
//       return AlertDialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//         title: const Text('Ask a New Question'),
//         content: Form(
//           key: formKey,
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               TextFormField(
//                 controller: questionController,
//                 maxLines: 3,
//                 decoration: const InputDecoration(
//                   hintText: 'Type your question here',
//                   border: OutlineInputBorder(),
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter your question';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 16),
//               DropdownButtonFormField<String>(
//                 decoration: const InputDecoration(
//                   labelText: 'Category',
//                   border: OutlineInputBorder(),
//                 ),
//                 items: [
//                   ...categories.map((category) => DropdownMenuItem(
//                         value: category,
//                         child: Text(category),
//                       )),
//                 ],
//                 onChanged: (value) {},
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please select a category';
//                   }
//                   return null;
//                 },
//               ),
//             ],
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(),
//             child: const Text('Cancel'),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               if (formKey.currentState!.validate()) {
//                 Navigator.pop(context);
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(
//                     content: Text('Question submitted successfully! We\'ll respond shortly.'),
//                   ),
//                 );
//               }
//             },
//             child: const Text('Submit'),
//           ),
//         ],
//       );
//     },
//   );
// }
// }

// // Enhanced FAQItem Model
// class FAQItem {
//   final String question;
//   final String answer;
//   final String category;

//   FAQItem({
//     required this.question,
//     required this.answer,
//     required this.category,
//   });
// }