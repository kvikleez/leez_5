import 'package:flutter/material.dart';

class FAQPage extends StatefulWidget {
  const FAQPage({super.key});

  @override
  _FAQPageState createState() => _FAQPageState();
}

class _FAQPageState extends State<FAQPage> {
  int? expandedIndex;

  final List<FAQItem> faqItems = [
    FAQItem(
      question: 'What is Quickleez?',
      answer:
          'Quickleez is a platform where you can rent or buy items like laptops, mobiles, cameras, cars, bikes, and more. It connects sellers and renters in a seamless way.',
    ),
    FAQItem(
      question: 'How do I rent an item on Quickleez?',
      answer:
          'To rent an item, search for the product you need, select the rental period, and proceed to payment. Once confirmed, you can pick up the item or have it delivered.',
    ),
    FAQItem(
      question: 'Can I buy items on Quickleez?',
      answer:
          'Yes, you can buy items listed on Quickleez. Simply select the "Buy" option, complete the payment, and arrange for delivery or pickup.',
    ),
    FAQItem(
      question: 'How do I list an item for rent or sale?',
      answer:
          'To list an item, create an account, go to the "Add Listing" section, fill in the details, upload images, and set the price. Your item will be visible to users once approved.',
    ),
    FAQItem(
      question: 'What payment methods are accepted?',
      answer:
          'Quickleez supports multiple payment methods, including credit/debit cards, UPI, and net banking. All transactions are secure and encrypted.',
    ),
    FAQItem(
      question: 'What if the item I rented is damaged?',
      answer:
          'If the item is damaged during the rental period, you may be charged a repair fee. Make sure to inspect the item before renting and report any pre-existing damage.',
    ),
    FAQItem(
      question: 'How do I contact customer support?',
      answer:
          'You can contact Quickleez customer support through the "Help" section in the app or email us at support@quickleez.com. We’re available 24/7 to assist you.',
    ),
    FAQItem(
      question: 'Is there a refund policy?',
      answer:
          'Yes, Quickleez offers a refund policy for cancellations made within 24 hours of booking. Refunds are processed within 5-7 business days.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions for responsive design
    final screenWidth = MediaQuery.of(context).size.width;
    final isWideScreen = screenWidth > 600; // Check if the screen is wide

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'FAQs',
          style: TextStyle(fontSize: isWideScreen ? 24 : 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              // Handle more options
              _showMoreOptions(context);
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: faqItems.length,
        itemBuilder: (context, index) {
          final item = faqItems[index];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ExpansionTile(
              key: Key(index.toString()),
              title: Text(
                item.question,
                style: TextStyle(fontSize: isWideScreen ? 18 : 16, fontWeight: FontWeight.w600),
              ),
              onExpansionChanged: (isExpanded) {
                setState(() {
                  expandedIndex = isExpanded ? index : null;
                });
              },
              initiallyExpanded: expandedIndex == index,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Text(item.answer),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        // Handle Learn More action
                        _showLearnMoreDialog(context, item);
                      },
                      child: Text('Learn More', style: TextStyle(color: Colors.blue)),
                    ),
                    const SizedBox(width: 8),
                    TextButton(
                      onPressed: () {
                        // Handle Share action
                        _shareFAQ(item);
                      },
                      child: Text('Share', style: TextStyle(color: Colors.blue)),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Show more options dialog
  void _showMoreOptions(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('More Options'),
          content: const Text('You can add more features here.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  // Show Learn More dialog
  void _showLearnMoreDialog(BuildContext context, FAQItem item) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(item.question),
          content: Text(item.answer),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  // Share FAQ item
  void _shareFAQ(FAQItem item) {
    // Implement sharing functionality here
    // For example, using the share_plus package
    print('Sharing: ${item.question} - ${item.answer}');
  }
}

// FAQItem Model
class FAQItem {
  final String question;
  final String answer;

  FAQItem({required this.question, required this.answer});
}