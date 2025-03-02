import 'package:flutter/material.dart';

// -----------------------------------------------------------------------------
// Notification Item Model
// -----------------------------------------------------------------------------
class NotificationItem {
  final String id;
  final String title;
  final String content;
  final String timeAgo; // e.g. "2 minutes ago"
  final NotificationType type;
  bool read;

  NotificationItem({
    required this.id,
    required this.title,
    required this.content,
    required this.timeAgo,
    required this.type,
    this.read = false,
  });
}

// Enum for notification types
enum NotificationType {
  connection,
  message,
  reminder,
  update,
  task
}

// Extension to get icon and color for each notification type
extension NotificationTypeExtension on NotificationType {
  IconData get icon {
    switch (this) {
      case NotificationType.connection:
        return Icons.person_add;
      case NotificationType.message:
        return Icons.message;
      case NotificationType.reminder:
        return Icons.event;
      case NotificationType.update:
        return Icons.update;
      case NotificationType.task:
        return Icons.task_alt;
    }
  }

  Color get color {
    switch (this) {
      case NotificationType.connection:
        return Colors.blue;
      case NotificationType.message:
        return Colors.green;
      case NotificationType.reminder:
        return Colors.orange;
      case NotificationType.update:
        return Colors.purple;
      case NotificationType.task:
        return Colors.teal;
    }
  }
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
    type: NotificationType.connection,
    read: false,
  ),
  NotificationItem(
    id: '2',
    title: 'Message Received',
    content: 'Michael Chen sent you a message about the upcoming project',
    timeAgo: '15 minutes ago',
    type: NotificationType.message,
    read: false,
  ),
  NotificationItem(
    id: '3',
    title: 'Event Reminder',
    content: 'Virtual Team Meeting starts in 30 minutes',
    timeAgo: '30 minutes ago',
    type: NotificationType.reminder,
    read: false,
  ),
  NotificationItem(
    id: '4',
    title: 'Project Update',
    content: 'Emily Wilson made changes to "Q4 Marketing Strategy"',
    timeAgo: '1 hour ago',
    type: NotificationType.update,
    read: true,
  ),
  NotificationItem(
    id: '5',
    title: 'Task Completed',
    content: 'David Anderson completed the assigned task "Review Documentation"',
    timeAgo: '2 hours ago',
    type: NotificationType.task,
    read: true,
  ),
];

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
  
  // Selection mode
  bool _selectionMode = false;
  final Set<String> _selectedItems = {};
  
  // Filter
  NotificationType? _currentFilter;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Returns the "All" notifications with optional filter
  List<NotificationItem> get allNotifications {
    if (_currentFilter == null) {
      return _notifications;
    }
    return _notifications.where((n) => n.type == _currentFilter).toList();
  }

  // Returns only "Unread" notifications with optional filter
  List<NotificationItem> get unreadNotifications {
    if (_currentFilter == null) {
      return _notifications.where((n) => !n.read).toList();
    }
    return _notifications.where((n) => !n.read && n.type == _currentFilter).toList();
  }

  // Delete a single notification
  void _deleteNotification(String id) {
    setState(() {
      _notifications.removeWhere((item) => item.id == id);
      _selectedItems.remove(id);
      if (_selectedItems.isEmpty) {
        _selectionMode = false;
      }
    });
  }

  // Delete selected notifications
  void _deleteSelected() {
    setState(() {
      _notifications.removeWhere((item) => _selectedItems.contains(item.id));
      _selectedItems.clear();
      _selectionMode = false;
    });
  }

  // Clear all notifications
  void _clearAllNotifications() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Clear all notifications?'),
          content: const Text('This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('CANCEL'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _notifications.clear();
                  _selectedItems.clear();
                  _selectionMode = false;
                });
                Navigator.of(context).pop();
              },
              child: const Text('CLEAR'),
            ),
          ],
        );
      },
    );
  }

  // Mark a notification as read
  void _markAsRead(NotificationItem item) {
    setState(() {
      item.read = true;
    });
  }

  // Mark all as read
  void _markAllAsRead() {
    setState(() {
      for (var notification in _notifications) {
        notification.read = true;
      }
    });
  }

  // Mark selected as read
  void _markSelectedAsRead() {
    setState(() {
      for (var notification in _notifications) {
        if (_selectedItems.contains(notification.id)) {
          notification.read = true;
        }
      }
      _selectedItems.clear();
      _selectionMode = false;
    });
  }

  // Toggle selection mode
  void _toggleSelectionMode() {
    setState(() {
      _selectionMode = !_selectionMode;
      if (!_selectionMode) {
        _selectedItems.clear();
      }
    });
  }

  // Toggle selection of an item
  void _toggleItemSelection(String id) {
    setState(() {
      if (_selectedItems.contains(id)) {
        _selectedItems.remove(id);
        if (_selectedItems.isEmpty) {
          _selectionMode = false;
        }
      } else {
        _selectedItems.add(id);
      }
    });
  }

  // Set the current filter
  void _setFilter(NotificationType? type) {
    setState(() {
      _currentFilter = type;
    });
    Navigator.pop(context);
  }

  // Show filter dialog
  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Filter Notifications'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView(
              shrinkWrap: true,
              children: [
                ListTile(
                  leading: const Icon(Icons.clear_all),
                  title: const Text('All Types'),
                  selected: _currentFilter == null,
                  onTap: () => _setFilter(null),
                ),
                ...NotificationType.values.map((type) {
                  return ListTile(
                    leading: Icon(type.icon, color: type.color),
                    title: Text(_typeToString(type)),
                    selected: _currentFilter == type,
                    onTap: () => _setFilter(type),
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  // Helper to convert type to string
  String _typeToString(NotificationType type) {
    switch (type) {
      case NotificationType.connection:
        return 'Connections';
      case NotificationType.message:
        return 'Messages';
      case NotificationType.reminder:
        return 'Reminders';
      case NotificationType.update:
        return 'Updates';
      case NotificationType.task:
        return 'Tasks';
    }
  }

  // "Load More" logic (dummy for now)
  void _loadMore() {
    // For demonstration, you could fetch more from server
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Loading more notifications...')),
    );
  }

  // Navigate to detail page
  void _openNotificationDetail(NotificationItem item) async {
    if (_selectionMode) {
      _toggleItemSelection(item.id);
      return;
    }
    
    // Mark as read when user views it
    _markAsRead(item);

    // Push detail page
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => NotificationDetailPage(notificationItem: item),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // "All" + "Unread"
      child: Scaffold(
        appBar: _buildAppBar(),
        body: TabBarView(
          controller: _tabController,
          children: [
            // ALL Notifications Tab
            _buildNotificationList(allNotifications),
            // UNREAD Notifications Tab
            _buildNotificationList(unreadNotifications),
          ],
        ),
        floatingActionButton: !_selectionMode && unreadNotifications.isNotEmpty 
            ? FloatingActionButton(
                onPressed: _markAllAsRead,
                backgroundColor: Colors.blue,
                child: const Icon(Icons.done_all),
              ) 
            : null,
      ),
    );
  }

  AppBar _buildAppBar() {
    if (_selectionMode) {
      return AppBar(
        backgroundColor: Colors.blue.shade100,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: _toggleSelectionMode,
        ),
        title: Text('${_selectedItems.length} selected'),
        actions: [
          IconButton(
            icon: const Icon(Icons.done_all),
            onPressed: _markSelectedAsRead,
            tooltip: 'Mark as read',
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _deleteSelected,
            tooltip: 'Delete selected',
          ),
        ],
      );
    }

    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.pop(context),
      ),
      backgroundColor: Colors.white,
      elevation: 1,
      centerTitle: true,
      title: const Text(
        'Notifications',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.filter_list),
          onPressed: _showFilterDialog,
          tooltip: 'Filter',
        ),
        IconButton(
          icon: const Icon(Icons.select_all),
          onPressed: _toggleSelectionMode,
          tooltip: 'Select',
        ),
        IconButton(
          icon: const Icon(Icons.delete_sweep),
          onPressed: _clearAllNotifications,
          tooltip: 'Clear all',
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(48),
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Colors.grey.shade300, width: 1),
            ),
          ),
          child: TabBar(
            controller: _tabController,
            labelColor: Colors.blue,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.blue,
            tabs: [
              Tab(
                text: 'All',
                icon: Badge(
                  label: Text('${allNotifications.length}'),
                  child: const Icon(Icons.notifications),
                ),
              ),
              Tab(
                text: 'Unread',
                icon: Badge(
                  label: Text('${unreadNotifications.length}'),
                  isLabelVisible: unreadNotifications.isNotEmpty,
                  child: const Icon(Icons.mark_email_unread),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationList(List<NotificationItem> notifications) {
    if (notifications.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: () async {
        // Simulate a refresh
        await Future.delayed(const Duration(seconds: 1));
        setState(() {
          // In a real app, you would fetch new notifications here
        });
      },
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        itemCount: notifications.length + 1, // +1 for "Load More" button
        itemBuilder: (context, index) {
          if (index < notifications.length) {
            final item = notifications[index];
            return _NotificationCard(
              notificationItem: item,
              onTap: () => _openNotificationDetail(item),
              onDelete: () => _deleteNotification(item.id),
              isSelected: _selectedItems.contains(item.id),
              selectionMode: _selectionMode,
            );
          } else {
            // "Load More" button at the end
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton.icon(
                  onPressed: _loadMore,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Load More'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _currentFilter?.icon ?? Icons.notifications_off,
            size: 80,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 16),
          Text(
            'No notifications',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _currentFilter == null
                ? 'You\'re all caught up!'
                : 'No notifications in this category',
            style: TextStyle(
              color: Colors.grey.shade600,
            ),
          ),
          if (_currentFilter != null)
            Padding(
              padding: const EdgeInsets.only(top: 24),
              child: TextButton.icon(
                onPressed: () => _setFilter(null),
                icon: const Icon(Icons.filter_alt_off),
                label: const Text('Clear Filter'),
              ),
            ),
        ],
      ),
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
  final bool isSelected;
  final bool selectionMode;

  const _NotificationCard({
    required this.notificationItem,
    required this.onTap,
    required this.onDelete,
    this.isSelected = false,
    this.selectionMode = false,
  });

  @override
  Widget build(BuildContext context) {
    // Base card styling
    final bool isUnread = !notificationItem.read;
    final Color baseColor = isUnread ? Colors.blue.shade50 : Colors.white;
    final Color cardColor = isSelected ? Colors.blue.shade100 : baseColor;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: isUnread ? Colors.blue.shade100 : Colors.grey.shade200,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
        border: isSelected
            ? Border.all(color: Colors.blue, width: 2)
            : Border.all(color: Colors.grey.shade200),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Type icon
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: notificationItem.type.color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        notificationItem.type.icon,
                        color: notificationItem.type.color,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    
                    // Title and timestamp
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            notificationItem.title,
                            style: TextStyle(
                              fontWeight: isUnread ? FontWeight.bold : FontWeight.w500,
                              fontSize: 16,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            notificationItem.timeAgo,
                            style: TextStyle(color: Colors.grey[600], fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    
                    // Selection or delete
                    if (selectionMode)
                      Checkbox(
                        value: isSelected,
                        onChanged: (_) => onTap(),
                        activeColor: Colors.blue,
                      )
                    else
                      IconButton(
                        icon: const Icon(Icons.close, size: 18),
                        onPressed: onDelete,
                        color: Colors.grey.shade600,
                        splashRadius: 20,
                      ),
                  ],
                ),
                
                const SizedBox(height: 12),
                
                // Content
                Padding(
                  padding: const EdgeInsets.only(left: 40),
                  child: Text(
                    notificationItem.content,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade800,
                    ),
                  ),
                ),
                
                // Unread indicator
                if (isUnread && !selectionMode)
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      margin: const EdgeInsets.only(top: 8),
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
          ),
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
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Notification Details'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Sharing functionality would go here')),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header with notification type icon
            Container(
              padding: const EdgeInsets.all(24),
              color: Colors.white,
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: notificationItem.type.color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      notificationItem.type.icon,
                      color: notificationItem.type.color,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          notificationItem.title,
                          style: const TextStyle(
                            fontSize: 20, 
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          notificationItem.timeAgo,
                          style: TextStyle(
                            color: Colors.grey[600], 
                            fontSize: 14
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 12),
            
            // Content card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Details',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    notificationItem.content,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),
                  
                  // For demonstration purposes, add some fake additional content
                  const SizedBox(height: 24),
                  Text(
                    'Additional information would appear here based on the notification type.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade700,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 12),
            
            // Action buttons
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Primary action triggered')),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: notificationItem.type.color,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text('Take Action'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text('Dismiss'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}