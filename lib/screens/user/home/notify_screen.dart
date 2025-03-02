import 'package:flutter/material.dart';

// -----------------------------------------------------------------------------
// Notification Item Model
// -----------------------------------------------------------------------------
class NotificationItem {
  final String id;
  final String title;
  final String content;
  final String timeAgo; // e.g. "2 minutes ago"
  bool read;

  NotificationItem({
    required this.id,
    required this.title,
    required this.content,
    required this.timeAgo,
    this.read = false,
  });
}

// -----------------------------------------------------------------------------
// Sample Notifications
// -----------------------------------------------------------------------------
final List<NotificationItem> sampleNotifications = [
  NotificationItem(
    id: '1',
    title: 'New Connection Request',
    content: 'Sarah Thompson would like to connect with you',
    timeAgo: '2 minutes ago',
    read: false,
  ),
  NotificationItem(
    id: '2',
    title: 'Message Received',
    content: 'Michael Chen sent you a message about the upcoming project',
    timeAgo: '15 minutes ago',
    read: false,
  ),
  NotificationItem(
    id: '3',
    title: 'Event Reminder',
    content: 'Virtual Team Meeting starts in 30 minutes',
    timeAgo: '30 minutes ago',
    read: false,
  ),
  NotificationItem(
    id: '4',
    title: 'Project Update',
    content: 'Emily Wilson made changes to "Q4 Marketing Strategy"',
    timeAgo: '1 hour ago',
    read: true,
  ),
  NotificationItem(
    id: '5',
    title: 'Task Completed',
    content: 'David Anderson completed the assigned task "Review Documentation"',
    timeAgo: '2 hours ago',
    read: true,
  ),
];

// -----------------------------------------------------------------------------
// Main Entry
// -----------------------------------------------------------------------------


// -----------------------------------------------------------------------------
// Notification Screen
// -----------------------------------------------------------------------------
class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Master list of notifications
  final List<NotificationItem> _notifications = List.from(sampleNotifications);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  // Returns the "All" notifications
  List<NotificationItem> get allNotifications => _notifications;

  // Returns only "Unread" notifications
  List<NotificationItem> get unreadNotifications =>
      _notifications.where((n) => !n.read).toList();

  // Delete a single notification
  void _deleteNotification(String id) {
    setState(() {
      _notifications.removeWhere((item) => item.id == id);
    });
  }

  // Clear all notifications
  void _clearAllNotifications() {
    setState(() {
      _notifications.clear();
    });
  }

  // Mark a notification as read
  void _markAsRead(NotificationItem item) {
    setState(() {
      item.read = true;
    });
  }

  // "Load More" logic (dummy for now)
  void _loadMore() {
    // For demonstration, you could fetch more from server
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Load more pressed')),
    );
  }

  // Navigate to detail page
  void _openNotificationDetail(NotificationItem item) async {
    // Mark as read when user views it
    _markAsRead(item);

    // Push detail page
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => NotificationDetailPage(notificationItem: item),
      ),
    );

    // After returning, we remain on the same tab
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // "All" + "Unread"
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context), // or handle your own logic
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            'Notifications',
            style: TextStyle(color: Colors.black),
          ),
          actions: [
            TextButton(
              onPressed: _clearAllNotifications,
              child: const Text(
                'Clear All',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
          bottom: TabBar(
            controller: _tabController,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.black,
            tabs: const [
              Tab(text: 'All'),
              Tab(text: 'Unread'),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            // ALL Notifications Tab
            _buildNotificationList(allNotifications),
            // UNREAD Notifications Tab
            _buildNotificationList(unreadNotifications),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationList(List<NotificationItem> notifications) {
    if (notifications.isEmpty) {
      return const Center(
        child: Text('No notifications to show'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      itemCount: notifications.length + 1, // +1 for "Load More" button
      itemBuilder: (context, index) {
        if (index < notifications.length) {
          final item = notifications[index];
          return _NotificationCard(
            notificationItem: item,
            onTap: () => _openNotificationDetail(item),
            onDelete: () => _deleteNotification(item.id),
          );
        } else {
          // "Load More" button at the end
          return Center(
            child: TextButton(
              onPressed: _loadMore,
              child: const Text('Load More'),
            ),
          );
        }
      },
    );
  }
}

// -----------------------------------------------------------------------------
// Notification Card Widget
// -----------------------------------------------------------------------------
class _NotificationCard extends StatelessWidget {
  final NotificationItem notificationItem;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _NotificationCard({
    required this.notificationItem,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    // Card style based on read/unread
    final Color cardColor = notificationItem.read ? Colors.white : Colors.grey[100]!;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title + close (X) icon
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    notificationItem.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                InkWell(
                  onTap: onDelete,
                  child: const Icon(Icons.close, size: 20),
                ),
              ],
            ),
            const SizedBox(height: 4),

            // Content
            Text(
              notificationItem.content,
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 4),

            // Time
            Text(
              notificationItem.timeAgo,
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Notification Detail Page
// -----------------------------------------------------------------------------
class NotificationDetailPage extends StatelessWidget {
  final NotificationItem notificationItem;

  const NotificationDetailPage({super.key, required this.notificationItem});

  @override
  Widget build(BuildContext context) {
    // In a real app, you might fetch more details about the notification here.
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Detail', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              notificationItem.title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              notificationItem.timeAgo,
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
            const Divider(height: 32),
            Text(
              notificationItem.content,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
