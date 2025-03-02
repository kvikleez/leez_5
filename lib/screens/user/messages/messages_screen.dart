import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:intl/intl.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:shimmer/shimmer.dart';
import 'package:provider/provider.dart';
import 'dart:io';

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}

class Message {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final String category;
  final String status;
  final String avatar;
  bool unread;
  final bool isOnline;
  final List<MessageAttachment> attachments;
  final String lastSenderName;

  Message({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.category,
    required this.status,
    required this.avatar,
    this.unread = false,
    this.isOnline = false,
    this.attachments = const [],
    this.lastSenderName = '',
  });

  Message copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? date,
    String? category,
    String? status,
    String? avatar,
    bool? unread,
    bool? isOnline,
    List<MessageAttachment>? attachments,
    String? lastSenderName,
  }) {
    return Message(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      category: category ?? this.category,
      status: status ?? this.status,
      avatar: avatar ?? this.avatar,
      unread: unread ?? this.unread,
      isOnline: isOnline ?? this.isOnline,
      attachments: attachments ?? this.attachments,
      lastSenderName: lastSenderName ?? this.lastSenderName,
    );
  }
}

class MessageAttachment {
  final String type; 
  final String url;
  final String previewUrl;
  final String name;
  final int size;

  MessageAttachment({
    required this.type,
    required this.url,
    this.previewUrl = '',
    this.name = '',
    this.size = 0,
  });
}

class MessageProvider with ChangeNotifier {
  List<Message> _messages = [];
  bool _isLoading = true;
  
  List<Message> get messages => _messages;
  bool get isLoading => _isLoading;
  
  MessageProvider() {
    _loadMessages();
  }
  
  Future<void> _loadMessages() async {
    await Future.delayed(const Duration(seconds: 2));
    
    _messages = [
      Message(
        id: '1',
        title: 'Leez Support',
        description: 'This case is closed due to inactivity. Please create a new ticket if needed.',
        date: DateTime.now().subtract(const Duration(hours: 3)),
        category: 'Support',
        status: 'Closed',
        avatar: 'assets/logo/quickleez_1.png',
        unread: true,
        isOnline: true,
        lastSenderName: 'Agent Sarah',
      ),
      Message(
        id: '2',
        title: 'Travel Planning Group',
        description: 'Alex: Let\'s finalize our itinerary for the trip next month!',
        date: DateTime.now().subtract(const Duration(days: 1)),
        category: 'Travelling',
        status: 'Active',
        avatar: 'assets/avatars/travel_group.png',
        unread: true,
        isOnline: false,
        attachments: [
          MessageAttachment(
            type: 'image',
            url: 'assets/images/travel_map.png',
            previewUrl: 'assets/images/travel_map_thumb.png',
            name: 'Travel Itinerary',
          ),
        ],
        lastSenderName: 'Alex Chen',
      ),
      Message(
        id: '3',
        title: 'Technical Support',
        description: 'Your ticket #1234 has been updated. Click to view details.',
        date: DateTime.now().subtract(const Duration(days: 2)),
        category: 'Support',
        status: 'Pending',
        avatar: 'assets/logo/support_icon.png',
        unread: false,
        isOnline: true,
        lastSenderName: 'Support Team',
      ),
      Message(
        id: '4',
        title: 'Flight Booking',
        description: 'Your flight to New York is confirmed for Mar 15, 2025. Boarding pass attached.',
        date: DateTime.now().subtract(const Duration(days: 3)),
        category: 'Travelling',
        status: 'Confirmed',
        avatar: 'assets/logo/flight_icon.png',
        unread: false,
        isOnline: false,
        attachments: [
          MessageAttachment(
            type: 'file',
            url: 'assets/files/boarding_pass.pdf',
            name: 'Boarding Pass',
            size: 1240000,
          ),
        ],
        lastSenderName: 'Flight Services',
      ),
      Message(
        id: '5',
        title: 'Hotel Reservation',
        description: 'Your hotel reservation has been confirmed. Check-in: Mar 15, 2025',
        date: DateTime.now().subtract(const Duration(days: 3, hours: 2)),
        category: 'Travelling',
        status: 'Confirmed',
        avatar: 'assets/logo/hotel_icon.png',
        unread: false,
        isOnline: false,
        attachments: [
          MessageAttachment(
            type: 'image',
            url: 'assets/images/hotel_preview.jpg',
            name: 'Hotel Details',
          ),
        ],
        lastSenderName: 'Hotel Booking',
      ),
    ];
    
    _isLoading = false;
    notifyListeners();
  }
  
  void markAsRead(String messageId) {
    final index = _messages.indexWhere((msg) => msg.id == messageId);
    if (index != -1 && _messages[index].unread) {
      _messages[index].unread = false;
      notifyListeners();
    }
  }
  
  void markAllAsRead() {
    bool changed = false;
    for (var i = 0; i < _messages.length; i++) {
      if (_messages[i].unread) {
        _messages[i].unread = false;
        changed = true;
      }
    }
    if (changed) {
      notifyListeners();
    }
  }
  
  void deleteMessage(String messageId) {
    _messages.removeWhere((msg) => msg.id == messageId);
    notifyListeners();
  }
  
  void archiveMessage(String messageId) {

    final index = _messages.indexWhere((msg) => msg.id == messageId);
    if (index != -1) {
      _messages[index] = _messages[index].copyWith(status: 'Archived');
      notifyListeners();
    }
  }
  
  void addNewMessage(Message message) {
    _messages.insert(0, message);
    notifyListeners();
  }
}

class MessagingApp extends StatelessWidget {
  const MessagingApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => MessageProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            title: 'Enhanced Messaging App',
            debugShowCheckedModeBanner: false,
            themeMode: themeProvider.themeMode,
            theme: ThemeData(
              primaryColor: Colors.blue,
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.blue,
                brightness: Brightness.light,
              ),
              useMaterial3: true,
              appBarTheme: const AppBarTheme(
                centerTitle: false,
                elevation: 0,
              ),
              cardTheme: CardTheme(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
            darkTheme: ThemeData(
              primaryColor: Colors.blueAccent,
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.blue,
                brightness: Brightness.dark,
              ),
              useMaterial3: true,
              appBarTheme: const AppBarTheme(
                centerTitle: false,
                elevation: 0,
              ),
              cardTheme: CardTheme(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
            home: const MessagesScreen(),
          );
        },
      ),
    );
  }
}

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({Key? key}) : super(key: key);

  @override
  _MessagesScreenState createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> with SingleTickerProviderStateMixin {
  String selectedFilter = 'All';
  final TextEditingController _searchController = TextEditingController();
  late TabController _tabController;
  bool _showSearch = false;
  final FocusNode _searchFocusNode = FocusNode();
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {
        switch (_tabController.index) {
          case 0:
            selectedFilter = 'All';
            break;
          case 1:
            selectedFilter = 'Travelling';
            break;
          case 2:
            selectedFilter = 'Support';
            break;
        }
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  List<Message> getFilteredMessages(BuildContext context) {
    final messageProvider = Provider.of<MessageProvider>(context);
    final searchQuery = _searchController.text.toLowerCase();
    
    if (messageProvider.isLoading) {
      return [];
    }
    
    return messageProvider.messages.where((message) {
      final matchesCategory = selectedFilter == 'All' || 
          message.category == selectedFilter;
      final matchesSearch = searchQuery.isEmpty ||
          message.title.toLowerCase().contains(searchQuery) ||
          message.description.toLowerCase().contains(searchQuery) ||
          message.status.toLowerCase().contains(searchQuery) ||
          message.lastSenderName.toLowerCase().contains(searchQuery);
      return matchesCategory && matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.themeMode == ThemeMode.dark;
    
    return Scaffold(
      body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                floating: true,
                pinned: true,
                snap: false,
                title: _showSearch
                    ? TextField(
                        controller: _searchController,
                        focusNode: _searchFocusNode,
                        decoration: InputDecoration(
                          hintText: 'Search...',
                          border: InputBorder.none,
                          hintStyle: TextStyle(color: isDark ? Colors.grey[400] : Colors.grey[600]),
                        ),
                        style: TextStyle(
                          color: isDark ? Colors.white : Colors.black,
                          fontSize: 16,
                        ),
                        onChanged: (_) => setState(() {}),
                      )
                    : const Text(
                        'Messages',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                actions: [
                  IconButton(
                    icon: Icon(_showSearch ? Icons.close : Icons.search),
                    onPressed: () {
                      setState(() {
                        _showSearch = !_showSearch;
                        if (_showSearch) {
                          _searchFocusNode.requestFocus();
                        } else {
                          _searchController.clear();
                        }
                      });
                    },
                  ),
                  IconButton(
                    icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
                    onPressed: () {
                      themeProvider.toggleTheme();
                    },
                  ),
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert),
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'mark_all_read',
                        child: Row(
                          children: [
                            Icon(Icons.done_all, size: 18),
                            SizedBox(width: 8),
                            Text('Mark all as read'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'archived',
                        child: Row(
                          children: [
                            Icon(Icons.archive, size: 18),
                            SizedBox(width: 8),
                            Text('Archived Messages'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'settings',
                        child: Row(
                          children: [
                            Icon(Icons.settings, size: 18),
                            SizedBox(width: 8),
                            Text('Message Settings'),
                          ],
                        ),
                      ),
                    ],
                    onSelected: (value) {
                      if (value == 'mark_all_read') {
                        Provider.of<MessageProvider>(context, listen: false).markAllAsRead();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('All messages marked as read'),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        );
                      } else if (value == 'archived') {
                      } else if (value == 'settings') {
                      }
                    },
                  ),
                ],
                bottom: TabBar(
                  controller: _tabController,
                  indicatorColor: Theme.of(context).colorScheme.primary,
                  tabs: const [
                    Tab(text: 'All'),
                    Tab(text: 'Travelling'),
                    Tab(text: 'Support'),
                  ],
                ),
              ),
            ];
          },
          body: _buildMessageList(),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Theme.of(context).colorScheme.primary,
        icon: const Icon(Icons.edit, color: Colors.white),
        label: const Text('New Message', style: TextStyle(color: Colors.white)),
        onPressed: () => _showNewMessageDialog(context),
      ),
    );
  }

  Widget _buildMessageList() {
    final messageProvider = Provider.of<MessageProvider>(context);
    
    if (messageProvider.isLoading) {
      return _buildLoadingShimmer();
    }
    
    final filteredMessages = getFilteredMessages(context);
    
    if (filteredMessages.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: () async {
        
        await Future.delayed(const Duration(seconds: 1));
        setState(() {});
      },
      child: AnimationLimiter(
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: filteredMessages.length,
          itemBuilder: (context, index) {
            return AnimationConfiguration.staggeredList(
              position: index,
              duration: const Duration(milliseconds: 375),
              child: SlideAnimation(
                verticalOffset: 50.0,
                child: FadeInAnimation(
                  child: _buildMessageTile(filteredMessages[index]),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildLoadingShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 5,
        itemBuilder: (_, __) => Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 16,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      height: 16,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: 80,
                      height: 24,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    final theme = Theme.of(context);
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.forum_outlined, 
            size: 80, 
            color: theme.brightness == Brightness.dark ? Colors.grey[400] : Colors.grey[300],
          ),
          const SizedBox(height: 16),
          Text(
            'No messages found',
            style: TextStyle(
              color: theme.brightness == Brightness.dark ? Colors.grey[400] : Colors.grey[600],
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _searchController.text.isNotEmpty 
                ? 'Try a different search term' 
                : 'Your messages will appear here',
            style: TextStyle(
              color: theme.brightness == Brightness.dark ? Colors.grey[500] : Colors.grey[700],
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 24),
          if (_searchController.text.isNotEmpty)
            TextButton.icon(
              icon: const Icon(Icons.clear),
              label: const Text('Clear Search'),
              onPressed: () {
                setState(() {
                  _searchController.clear();
                });
              },
            ),
        ],
      ),
    );
  }

  Widget _buildMessageTile(Message message) {
    final theme = Theme.of(context);
    final messageProvider = Provider.of<MessageProvider>(context, listen: false);
    
    return Slidable(
      key: Key(message.id),
      startActionPane: ActionPane(
        motion: const DrawerMotion(),
        children: [
          SlidableAction(
            onPressed: (_) {
              messageProvider.deleteMessage(message.id);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Message deleted'),
                  action: SnackBarAction(
                    label: 'Undo',
                    onPressed: () {
                      messageProvider.addNewMessage(message);
                    },
                  ),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              );
            },
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        children: [
          SlidableAction(
            onPressed: (_) {
              messageProvider.markAsRead(message.id);
            },
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            icon: Icons.check,
            label: 'Read',
          ),
          SlidableAction(
            onPressed: (_) {
              messageProvider.archiveMessage(message.id);
            },
            backgroundColor: Colors.grey,
            foregroundColor: Colors.white,
            icon: Icons.archive,
            label: 'Archive',
          ),
        ],
      ),
      child: Card(
        elevation: message.unread ? 3 : 1,
        margin: const EdgeInsets.only(bottom: 8),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            messageProvider.markAsRead(message.id);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatScreen(message: message),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAvatar(message),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              message.title,
                              style: TextStyle(
                                fontWeight: message.unread ? FontWeight.bold : FontWeight.normal,
                                fontSize: 16,
                                color: message.unread 
                                    ? theme.brightness == Brightness.dark ? Colors.white : Colors.black
                                    : theme.brightness == Brightness.dark ? Colors.grey[300] : Colors.grey[700],
                              ),
                            ),
                          ),
                          Text(
                            _formatMessageDate(message.date),
                            style: TextStyle(
                              color: theme.brightness == Brightness.dark ? Colors.grey[400] : Colors.grey[500],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      if (message.lastSenderName.isNotEmpty) 
                        Text(
                          message.lastSenderName,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      const SizedBox(height: 2),
                      Text(
                        message.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: message.unread 
                              ? theme.brightness == Brightness.dark ? Colors.white70 : Colors.black87
                              : theme.brightness == Brightness.dark ? Colors.grey[400] : Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildStatusChip(message.status),
                          if (message.attachments.isNotEmpty)
                            Icon(
                              Icons.attachment,
                              size: 16,
                              color: theme.brightness == Brightness.dark ? Colors.grey[400] : Colors.grey[600],
                            ),
                          if (message.unread)
                            Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar(Message message) {
    return Stack(
      children: [
        Hero(
          tag: 'avatar-${message.id}',
          child: CircleAvatar(
            radius: 28,
            backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            child: ClipOval(
              child: Image.asset(
                message.avatar,
                width: 56,
                height: 56,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return CircleAvatar(
                    radius: 28,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    child: Text(
                      message.title.substring(0, 1).toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        if (message.isOnline)
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
                border: Border.all(color: Theme.of(context).scaffoldBackgroundColor, width: 2),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildStatusChip(String status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _statusColor(status).withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: _statusColor(status),
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  void _showNewMessageDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'New Message',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Search contacts',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Recent Contacts',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.primaries[index % Colors.primaries.length],
                          child: Text(
                            String.fromCharCode(65 + index),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text('Contact ${index + 1}'),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  final message = Message(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    title: 'New Chat',
                    description: 'Start typing to begin conversation',
                    date: DateTime.now(),
                    category: 'Support',
                    status: 'New',
                    avatar: 'assets/avatars/user.png',
                    unread: true,
                    isOnline: false,
                  );
                  
                  Provider.of<MessageProvider>(context, listen: false).addNewMessage(message);
                  
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatScreen(message: message),
                    ),
                  );
                },
                child: const Text('Start New Chat'),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'closed':
        return Colors.red;
      case 'archived':
        return Colors.grey;
      case 'confirmed':
        return Colors.blue;
      case 'new':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  String _formatMessageDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final messageDate = DateTime(date.year, date.month, date.day);
    
    if (messageDate == today) {
      return DateFormat.jm().format(date); 
    } else if (messageDate == yesterday) {
      return 'Yesterday';
    } else if (now.difference(date).inDays < 7) {
      return DateFormat.E().format(date); 
    } else {
      return DateFormat.MMMd().format(date); 
    }
  }
}

class ChatScreen extends StatefulWidget {
  final Message message;

  const ChatScreen({Key? key, required this.message}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _showEmojiPicker = false;
  final List<ChatMessage> _messages = [];
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    _loadInitialMessages();
    
    if (widget.message.isOnline) {
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _isTyping = true;
          });
          
          Future.delayed(const Duration(seconds: 3), () {
            if (mounted) {
              setState(() {
                _isTyping = false;
                _addMessage(
                  ChatMessage(
                    text: 'Thank you for reaching out! How can we assist you today?',
                    isMe: false,
                    time: DateTime.now(),
                    attachments: [],
                  ),
                );
              });
            }
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _loadInitialMessages() {
    setState(() {
      _messages.addAll([
        ChatMessage(
          text: 'Welcome to ${widget.message.title}!',
          isMe: false,
          time: DateTime.now().subtract(const Duration(minutes: 30)),
          attachments: [],
        ),
      ]);
      
      if (widget.message.attachments.isNotEmpty) {
        _messages.add(
          ChatMessage(
            text: 'Here are the details you requested.',
            isMe: false,
            time: DateTime.now().subtract(const Duration(minutes: 25)),
            attachments: widget.message.attachments,
          ),
        );
      }
    });
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    final newMessage = ChatMessage(
      text: _messageController.text.trim(),
      isMe: true,
      time: DateTime.now(),
      attachments: [],
    );

    setState(() {
      _messages.add(newMessage);
      _messageController.clear();
      _showEmojiPicker = false;
    });

    Future.delayed(const Duration(milliseconds: 100), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });

    if (widget.message.category == 'Support') {
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          setState(() {
            _isTyping = true;
          });
          
          Future.delayed(const Duration(seconds: 2), () {
            if (mounted) {
              setState(() {
                _isTyping = false;
                _addMessage(
                  ChatMessage(
                    text: 'Thanks for your message. Our support team will get back to you as soon as possible.',
                    isMe: false,
                    time: DateTime.now(),
                    attachments: [],
                  ),
                );
              });
            }
          });
        }
      });
    }
  }

  void _addMessage(ChatMessage message) {
    setState(() {
      _messages.add(message);
    });

    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _toggleEmojiPicker() {
    setState(() {
      _showEmojiPicker = !_showEmojiPicker;
    });
  }

  void _selectAttachment() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final newMessage = ChatMessage(
        text: 'Sent an image',
        isMe: true,
        time: DateTime.now(),
        attachments: [
          MessageAttachment(
            type: 'image',
            url: image.path,
            name: image.name,
          ),
        ],
      );

      _addMessage(newMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        leadingWidth: 30,
        title: Row(
          children: [
            Hero(
              tag: 'avatar-${widget.message.id}',
              child: CircleAvatar(
                radius: 20,
                backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                child: ClipOval(
                  child: Image.asset(
                    widget.message.avatar,
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return CircleAvatar(
                        radius: 20,
                        backgroundColor: theme.colorScheme.primary,
                        child: Text(
                          widget.message.title.substring(0, 1).toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.message.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: widget.message.isOnline ? Colors.green : Colors.grey,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        widget.message.isOnline ? 'Online' : 'Offline',
                        style: TextStyle(
                          fontSize: 12,
                          color: theme.brightness == Brightness.dark ? 
                            Colors.grey[400] : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.videocam_outlined),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Video call feature coming soon')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.call_outlined),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Voice call feature coming soon')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (context) => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      leading: const Icon(Icons.delete_outline),
                      title: const Text('Delete Conversation'),
                      onTap: () {
                        Navigator.pop(context);
                        Provider.of<MessageProvider>(context, listen: false)
                            .deleteMessage(widget.message.id);
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.block),
                      title: const Text('Block Contact'),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.archive_outlined),
                      title: const Text('Archive Chat'),
                      onTap: () {
                        Navigator.pop(context);
                        Provider.of<MessageProvider>(context, listen: false)
                            .archiveMessage(widget.message.id);
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.search),
                      title: const Text('Search in Conversation'),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildChatHistory(),
          _buildTypingIndicator(),
          _buildInputArea(),
          if (_showEmojiPicker) _buildEmojiPicker(),
        ],
      ),
    );
  }

  Widget _buildChatHistory() {
    return Expanded(
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: _messages.length,
        itemBuilder: (context, index) {
          final message = _messages[index];
          final showAvatar = index == 0 || 
              (_messages[index - 1].isMe != message.isMe);
              
          return _buildMessageBubble(message, showAvatar);
        },
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message, bool showAvatar) {
    final theme = Theme.of(context);
    final isMe = message.isMe;
    final messageTime = DateFormat.jm().format(message.time);
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe && showAvatar)
            CircleAvatar(
              radius: 16,
              backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
              child: ClipOval(
                child: Image.asset(
                  widget.message.avatar,
                  width: 32,
                  height: 32,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return CircleAvatar(
                      radius: 16,
                      backgroundColor: theme.colorScheme.primary,
                      child: Text(
                        widget.message.title.substring(0, 1).toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  },
                ),
              ),
            )
          else if (!isMe)
            const SizedBox(width: 32),
            
          Flexible(
            child: Column(
              crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.75,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: isMe 
                        ? theme.colorScheme.primary
                        : theme.brightness == Brightness.dark 
                            ? Colors.grey[800] 
                            : Colors.grey[200],
                    borderRadius: BorderRadius.circular(20).copyWith(
                      bottomRight: isMe ? const Radius.circular(0) : null,
                      bottomLeft: !isMe ? const Radius.circular(0) : null,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                    children: [
                      Text(
                        message.text,
                        style: TextStyle(
                          color: isMe 
                              ? Colors.white 
                              : theme.brightness == Brightness.dark 
                                  ? Colors.white 
                                  : Colors.black87,
                        ),
                      ),
                      if (message.attachments.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        ...message.attachments.map((attachment) {
                          if (attachment.type == 'image') {
                            if (attachment.url.startsWith('assets/')) {
                              return Container(
                                margin: const EdgeInsets.only(top: 8),
                                width: 200,
                                height: 150,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  image: DecorationImage(
                                    image: AssetImage(attachment.url),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              );
                            } else {
                              return Container(
                                margin: const EdgeInsets.only(top: 8),
                                width: 200,
                                height: 150,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.file(
                                    File(attachment.url),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              );
                            }
                          } else if (attachment.type == 'file') {
                            return Container(
                              margin: const EdgeInsets.only(top: 8),
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.insert_drive_file, size: 20),
                                  const SizedBox(width: 8),
                                  Flexible(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          attachment.name,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(fontWeight: FontWeight.w500),
                                        ),
                                        if (attachment.size > 0)
                                          Text(
                                            '${(attachment.size / 1024 / 1024).toStringAsFixed(1)} MB',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Icon(Icons.download, size: 20),
                                ],
                              ),
                            );
                          }
                          return Container();
                        }).toList(),
                      ],
                      const SizedBox(height: 4),
                      Text(
                        messageTime,
                        style: TextStyle(
                          fontSize: 10,
                          color: isMe 
                              ? Colors.white.withOpacity(0.7) 
                              : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          if (isMe && showAvatar)
            CircleAvatar(
              radius: 12,
              backgroundColor: theme.colorScheme.primary,
              child: Text(
                'Me'.substring(0, 1),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          else if (isMe)
            const SizedBox(width: 24),
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    if (!_isTyping) return const SizedBox.shrink();
    
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.only(left: 16, bottom: 8),
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
            child: ClipOval(
              child: Image.asset(
                widget.message.avatar,
                width: 32,
                height: 32,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return CircleAvatar(
                    radius: 16,
                    backgroundColor: theme.colorScheme.primary,
                    child: Text(
                      widget.message.title.substring(0, 1).toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: theme.brightness == Brightness.dark 
                  ? Colors.grey[800] 
                  : Colors.grey[200],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                _buildDot(1),
                _buildDot(2),
                _buildDot(3),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(int position) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      child: AnimatedOpacity(
        opacity: _isTyping ? 1.0 : 0.0,
        duration: Duration(milliseconds: 600 + position * 100),
        curve: Curves.easeInOut,
        child: Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            color: Colors.grey[600],
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }

  Widget _buildInputArea() {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.brightness == Brightness.dark ? Colors.grey[900] : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, -2),
            blurRadius: 5,
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(
              _showEmojiPicker ? Icons.keyboard : Icons.emoji_emotions_outlined,
              color: theme.brightness == Brightness.dark ? Colors.grey[400] : Colors.grey[600],
            ),
            onPressed: _toggleEmojiPicker,
          ),
          IconButton(
            icon: Icon(
              Icons.attach_file,
              color: theme.brightness == Brightness.dark ? Colors.grey[400] : Colors.grey[600],
            ),
            onPressed: _selectAttachment,
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: theme.brightness == Brightness.dark ? Colors.grey[800] : Colors.grey[200],
                borderRadius: BorderRadius.circular(24),
              ),
              child: TextField(
                controller: _messageController,
                decoration: const InputDecoration(
                  hintText: 'Type a message...',
                  border: InputBorder.none,
                ),
                textCapitalization: TextCapitalization.sentences,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white),
              onPressed: _sendMessage,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmojiPicker() {
    return SizedBox(
      height: 250,
      child: EmojiPicker(
        onEmojiSelected: (Category? category, Emoji emoji) {
          setState(() {
            _messageController.text = _messageController.text + emoji.emoji;
          });
        },
        textEditingController: _messageController,
        config: Config(
          height: 256,
          emojiViewConfig: EmojiViewConfig(
            columns: 7,
            loadingIndicator: const SizedBox.shrink(),
            noRecents: const Text('No recent emojis'),
          ),
          skinToneConfig: const SkinToneConfig(),
          bottomActionBarConfig: const BottomActionBarConfig(),
          categoryViewConfig: CategoryViewConfig(
            initCategory: Category.RECENT,
            backgroundColor: Theme.of(context).brightness == Brightness.dark 
                ? Colors.grey[900]! 
                : Colors.white,
            tabIndicatorAnimDuration: kTabScrollDuration,
            categoryIcons: const CategoryIcons(),
          ),
        ),
      ),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isMe;
  final DateTime time;
  final List<MessageAttachment> attachments;

  ChatMessage({
    required this.text,
    required this.isMe,
    required this.time,
    required this.attachments,
  });
}
