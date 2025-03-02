import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:math';
import 'package:intl/intl.dart';

class Message {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final String category;
  final String status;
  final String icon;
  final bool isUnread;
  final int unreadCount;

  Message({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.category,
    required this.status,
    required this.icon,
    this.isUnread = false,
    this.unreadCount = 0,
  });
}

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  _MessagesScreenState createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> with SingleTickerProviderStateMixin {
  String selectedFilter = 'All';
  bool isSearchActive = false;
  final TextEditingController searchController = TextEditingController();
  late TabController _tabController;
  String searchQuery = '';
  
  final List<String> filters = ['All', 'Booking', 'Support', 'Finance', 'Events'];
  
  final List<Message> messages = [
    Message(
      id: '1',
      title: 'Leez Support',
      description: 'Your ticket #2345 has been resolved. Please confirm if the issue is fixed or reopen if needed.',
      date: DateTime.now().subtract(const Duration(hours: 2)),
      category: 'Support',
      status: 'Closed',
      icon: 'assets/logo/quickleez_1.png',
      isUnread: true,
      unreadCount: 3,
    ),
    Message(
      id: '2',
      title: 'Booking Updates',
      description: 'Your SUV for 3 days has been confirmed. Check-in the location of the car before departure.',
      date: DateTime.now().subtract(const Duration(days: 1)),
      category: 'Booking',
      status: 'Active',
      icon: 'assets/car1.png',
      isUnread: false,
      unreadCount: 0,
    ),
    Message(
      id: '3',
      title: 'Leez Finance',
      description: 'Your monthly statement is ready. Total expenses: \$1,250.75',
      date: DateTime.now().subtract(const Duration(days: 3)),
      category: 'Finance',
      status: 'Active',
      icon: 'assets/boy.png',
      isUnread: true,
      unreadCount: 1,
    ),
    Message(
      id: '4',
      title: 'Event Reminder',
      description: 'The annual tech conference starts tomorrow at 9 AM. Don\'t forget to bring your ticket!',
      date: DateTime.now().subtract(const Duration(days: 5)),
      category: 'Events',
      status: 'Active',
      icon: 'assets/girl.png',
      isUnread: false,
      unreadCount: 0,
    ),
    Message(
      id: '5',
      title: 'Support Team',
      description: 'Weve processed your refund request. The amount will be credited within 3-5 business days.',
      date: DateTime.now().subtract(const Duration(days: 7)),
      category: 'Support',
      status: 'Active',
      icon: 'assets/logo/quickleez_1.png',
      isUnread: false,
      unreadCount: 0,
    ),
    Message(
      id: '6',
      title: 'Travel Advisory',
      description: 'Weather alert for your upcoming trip to Miami. Expect rain on the first two days.',
      date: DateTime.now().subtract(const Duration(days: 10)),
      category: 'Booking',
      status: 'Active',
      icon: 'assets/car1.png',
      isUnread: false,
      unreadCount: 0,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    searchController.dispose();
    super.dispose();
  }

  void _toggleSearch() {
    setState(() {
      isSearchActive = !isSearchActive;
      if (!isSearchActive) {
        searchController.clear();
        searchQuery = '';
      } else {
        FocusScope.of(context).requestFocus(FocusNode());
      }
    });
  }

  void _performSearch(String query) {
    setState(() {
      searchQuery = query.toLowerCase();
    });
  }

  List<Message> get filteredMessages {
    List<Message> result = messages;
    
    if (selectedFilter != 'All') {
      result = result.where((message) => message.category == selectedFilter).toList();
    }
    
    if (searchQuery.isNotEmpty) {
      result = result.where((message) => 
        message.title.toLowerCase().contains(searchQuery) || 
        message.description.toLowerCase().contains(searchQuery)
      ).toList();
    }
    
    if (_tabController.index == 1) {
      result = result.where((message) => message.isUnread).toList();
    }
    
    return result;
  }

  String _formatMessageDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final messageDate = DateTime(date.year, date.month, date.day);
    
    if (messageDate == today) {
      return DateFormat('h:mm a').format(date);
    } else if (messageDate == yesterday) {
      return 'Yesterday';
    } else if (now.difference(date).inDays < 7) {
      return DateFormat('EEEE').format(date);
    } else {
      return DateFormat('MMM d').format(date);
    }
  }

  void _markAsRead(String messageId) {
    setState(() {
      final index = messages.indexWhere((message) => message.id == messageId);
      if (index != -1) {
        messages[index] = Message(
          id: messages[index].id,
          title: messages[index].title,
          description: messages[index].description,
          date: messages[index].date,
          category: messages[index].category,
          status: messages[index].status,
          icon: messages[index].icon,
          isUnread: false,
          unreadCount: 0,
        );
      }
    });
  }

  void _showDeleteConfirmation(BuildContext context, String messageId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Message'),
          content: const Text('Are you sure you want to delete this message?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
              onPressed: () {
                setState(() {
                  messages.removeWhere((message) => message.id == messageId);
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showOptionsMenu(BuildContext context, Message message) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.mark_email_read),
                title: const Text('Mark as read'),
                onTap: () {
                  _markAsRead(message.id);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.archive),
                title: const Text('Archive'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('Delete', style: TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.pop(context);
                  _showDeleteConfirmation(context, message.id);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final statusBarHeight = MediaQuery.of(context).padding.top;
    
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 120.0,
            floating: true,
            pinned: true,
            snap: false,
            elevation: 0,
            backgroundColor: Colors.white,
            title: isSearchActive
                ? TextField(
                    controller: searchController,
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: 'Search messages...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                    ),
                    onChanged: _performSearch,
                  )
                : const Text(
                    'Messages',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
            actions: [
              IconButton(
                icon: Icon(
                  isSearchActive ? Icons.close : Icons.search,
                  color: Colors.black,
                ),
                onPressed: _toggleSearch,
              ),
              if (!isSearchActive)
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert, color: Colors.black),
                  onSelected: (String result) {
                    if (result == 'markAllRead') {
                      setState(() {
                        for (int i = 0; i < messages.length; i++) {
                          if (messages[i].isUnread) {
                            messages[i] = Message(
                              id: messages[i].id,
                              title: messages[i].title,
                              description: messages[i].description,
                              date: messages[i].date,
                              category: messages[i].category,
                              status: messages[i].status,
                              icon: messages[i].icon,
                              isUnread: false,
                              unreadCount: 0,
                            );
                          }
                        }
                      });
                    }
                  },
                  itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                    const PopupMenuItem<String>(
                      value: 'markAllRead',
                      child: Text('Mark all as read'),
                    ),
                    const PopupMenuItem<String>(
                      value: 'settings',
                      child: Text('Notification settings'),
                    ),
                  ],
                ),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(88),
              child: Column(
                children: [
                  TabBar(
                    controller: _tabController,
                    indicatorColor: Colors.black,
                    labelColor: Colors.black,
                    unselectedLabelColor: Colors.grey,
                    tabs: const [
                      Tab(text: 'All'),
                      Tab(text: 'Unread'),
                    ],
                    onTap: (index) {
                      setState(() {});
                    },
                  ),
                  Container(
                    height: 50,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: filters.length,
                      itemBuilder: (context, index) {
                        final filter = filters[index];
                        final isSelected = selectedFilter == filter;

                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            checkmarkColor: Colors.white,
                            selected: isSelected,
                            showCheckmark: false,
                            backgroundColor: Colors.grey[200],
                            selectedColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            label: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              child: Text(
                                filter,
                                style: TextStyle(
                                  color: isSelected ? Colors.white : Colors.black,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                ),
                              ),
                            ),
                            onSelected: (selected) {
                              setState(() {
                                selectedFilter = filter;
                              });
                              HapticFeedback.lightImpact();
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          SliverPadding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            sliver: filteredMessages.isEmpty
                ? SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.mark_email_unread_outlined,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            searchQuery.isNotEmpty
                                ? 'No messages match your search'
                                : _tabController.index == 1
                                    ? 'No unread messages'
                                    : 'No messages in this category',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final message = filteredMessages[index];
                        final isLast = index == filteredMessages.length - 1;
                        
                        return Dismissible(
                          key: Key(message.id),
                          background: Container(
                            color: Colors.blue,
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.only(left: 20),
                            child: const Icon(Icons.mark_email_read, color: Colors.white),
                          ),
                          secondaryBackground: Container(
                            color: Colors.red,
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 20),
                            child: const Icon(Icons.delete, color: Colors.white),
                          ),
                          onDismissed: (direction) {
                            if (direction == DismissDirection.endToStart) {
                              setState(() {
                                messages.removeWhere((m) => m.id == message.id);
                              });
                            } else {
                              _markAsRead(message.id);
                            }
                          },
                          confirmDismiss: (direction) async {
                            if (direction == DismissDirection.endToStart) {
                              return await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text("Confirm"),
                                    content: const Text("Are you sure you want to delete this message?"),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () => Navigator.of(context).pop(false),
                                        child: const Text("CANCEL"),
                                      ),
                                      TextButton(
                                        onPressed: () => Navigator.of(context).pop(true),
                                        child: const Text("DELETE", style: TextStyle(color: Colors.red)),
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                            return true;
                          },
                          child: Card(
                            margin: EdgeInsets.only(
                              bottom: isLast ? 16 : 8,
                              left: 16,
                              right: 16,
                              top: index == 0 ? 8 : 0,
                            ),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(
                                color: Colors.grey[200]!,
                                width: 1,
                              ),
                            ),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(12),
                              onTap: () {
                                _markAsRead(message.id);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChatScreen(title: message.title),
                                  ),
                                );
                              },
                              onLongPress: () {
                                HapticFeedback.mediumImpact();
                                _showOptionsMenu(context, message);
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Stack(
                                      children: [
                                        CircleAvatar(
                                          radius: 24,
                                          backgroundColor: Colors.black,
                                          child: ClipOval(
                                            child: Image.asset(
                                              message.icon,
                                              color: Colors.white,
                                              width: 24,
                                              errorBuilder: (context, error, stackTrace) {
                                                return Text(
                                                  message.title[0],
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                        if (message.isUnread)
                                          Positioned(
                                            right: 0,
                                            top: 0,
                                            child: Container(
                                              padding: const EdgeInsets.all(4),
                                              decoration: BoxDecoration(
                                                color: Colors.red,
                                                shape: BoxShape.circle,
                                                border: Border.all(color: Colors.white, width: 2),
                                              ),
                                              constraints: const BoxConstraints(
                                                minWidth: 16,
                                                minHeight: 16,
                                              ),
                                              child: Text(
                                                message.unreadCount.toString(),
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                    
                                    const SizedBox(width: 16),
                                    
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  message.title,
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: message.isUnread ? FontWeight.bold : FontWeight.w500,
                                                  ),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                              Text(
                                                _formatMessageDate(message.date),
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: message.isUnread ? Colors.black : Colors.grey[600],
                                                  fontWeight: message.isUnread ? FontWeight.bold : FontWeight.normal,
                                                ),
                                              ),
                                            ],
                                          ),
                                          
                                          const SizedBox(height: 4),
                                          
                                          Text(
                                            message.description,
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: message.isUnread ? Colors.black : Colors.grey[600],
                                              fontWeight: message.isUnread ? FontWeight.w500 : FontWeight.normal,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          
                                          const SizedBox(height: 8),
                                          
                                          Row(
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                                decoration: BoxDecoration(
                                                  color: message.status == 'Active' ? Colors.green[50] : Colors.grey[100],
                                                  borderRadius: BorderRadius.circular(12),
                                                  border: Border.all(
                                                    color: message.status == 'Active' ? Colors.green[300]! : Colors.grey[300]!,
                                                    width: 1,
                                                  ),
                                                ),
                                                child: Text(
                                                  message.status,
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                    color: message.status == 'Active' ? Colors.green[700] : Colors.grey[700],
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                                decoration: BoxDecoration(
                                                  color: Colors.blue[50],
                                                  borderRadius: BorderRadius.circular(12),
                                                  border: Border.all(
                                                    color: Colors.blue[300]!,
                                                    width: 1,
                                                  ),
                                                ),
                                                child: Text(
                                                  message.category,
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                    color: Colors.blue[700],
                                                  ),
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
                      },
                      childCount: filteredMessages.length,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

// Rest of the code (NewMessageSheet, ChatScreen, etc.) remains unchanged

class ChatScreen extends StatefulWidget {
  final String title;
  
  const ChatScreen({super.key, required this.title});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<ChatMessage> messages = [];
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ImagePicker _picker = ImagePicker();
  bool _isEmojiVisible = false;
  bool _isAttachmentMenuVisible = false;
  bool _isTyping = false;
  
  @override
  void initState() {
    super.initState();
    
    // Add some sample messages
    final now = DateTime.now();
    
    messages.add(ChatMessage(
      text: 'Hello! How can I assist you today?',
      isSentByMe: false,
      timestamp: now.subtract(const Duration(minutes: 30)),
      status: MessageStatus.read,
    ));
    
    messages.add(ChatMessage(
      text: 'I need help with my recent order',
      isSentByMe: true,
      timestamp: now.subtract(const Duration(minutes: 25)),
      status: MessageStatus.read,
    ));
    
    messages.add(ChatMessage(
      text: 'Of course, I\'d be happy to help. Could you please provide your order number?',
      isSentByMe: false,
      timestamp: now.subtract(const Duration(minutes: 24)),
      status: MessageStatus.read,
    ));
    
    messages.add(ChatMessage(
      text: 'It\'s #ORD-12345-AB',
      isSentByMe: true,
      timestamp: now.subtract(const Duration(minutes: 20)),
      status: MessageStatus.read,
    ));
    
    // Start typing animation
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isTyping = true;
        });
        
        // End typing animation and add response
        Future.delayed(const Duration(seconds: 3), () {
          if (mounted) {
            setState(() {
              _isTyping = false;
              messages.add(ChatMessage(
                text: 'Thank you! I can see your order. It was shipped yesterday and should arrive by tomorrow. Is there anything specific you\'d like to know about it?',
                isSentByMe: false,
                timestamp: DateTime.now(),
                status: MessageStatus.read,
              ));
            });
            _scrollToBottom();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      final text = _controller.text;
      setState(() {
        messages.add(ChatMessage(
          text: text,
          isSentByMe: true,
          timestamp: DateTime.now(),
          status: MessageStatus.sent,
        ));
        _controller.clear();
        _isTyping = true;
      });
      _scrollToBottom();
      
      // Simulate reply after a delay
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _isTyping = false;
            messages.add(ChatMessage(
              text: 'I\'ve received your message and will get back to you shortly!',
              isSentByMe: false,
              timestamp: DateTime.now(),
              status: MessageStatus.read,
            ));
            
            // Update sent message status
            final lastUserMessageIndex = messages.indexWhere((m) => m.text == text);
            if (lastUserMessageIndex != -1) {
              messages[lastUserMessageIndex] = ChatMessage(
                text: messages[lastUserMessageIndex].text,
                image: messages[lastUserMessageIndex].image,
                isSentByMe: true,
                timestamp: messages[lastUserMessageIndex].timestamp,
                status: MessageStatus.read,
              );
            }
          });
          _scrollToBottom();
        }
      });
    }
  }

  void _sendImage(File image) {
    setState(() {
      messages.add(ChatMessage(
        image: image,
        isSentByMe: true,
        timestamp: DateTime.now(),
        status: MessageStatus.sent,
      ));
_isTyping = true;
    });
    _scrollToBottom();
    
    // Simulate reply after a delay
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _isTyping = false;
          messages.add(ChatMessage(
            text: 'Thanks for sharing the image. I\'ll review it and get back to you.',
            isSentByMe: false,
            timestamp: DateTime.now(),
            status: MessageStatus.read,
          ));
          
          // Update sent message status
          final lastIndex = messages.length - 2; // Get index of the sent image
          if (lastIndex >= 0 && messages[lastIndex].image != null) {
            messages[lastIndex] = ChatMessage(
              image: messages[lastIndex].image,
              isSentByMe: true,
              timestamp: messages[lastIndex].timestamp,
              status: MessageStatus.read,
            );
          }
        });
        _scrollToBottom();
      }
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _sendImage(File(pickedFile.path));
    }
  }

  Future<void> _takePhoto() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      _sendImage(File(pickedFile.path));
    }
  }

  void _toggleEmojiPicker() {
    setState(() {
      _isEmojiVisible = !_isEmojiVisible;
      if (_isEmojiVisible) {
        _isAttachmentMenuVisible = false;
      }
    });
  }

  void _toggleAttachmentMenu() {
    setState(() {
      _isAttachmentMenuVisible = !_isAttachmentMenuVisible;
      if (_isAttachmentMenuVisible) {
        _isEmojiVisible = false;
      }
    });
  }

  String _formatTime(DateTime timestamp) {
    return DateFormat('h:mm a').format(timestamp);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.black,
              radius: 16,
              child: Text(
                widget.title[0],
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  _isTyping ? 'Typing...' : 'Online',
                  style: TextStyle(
                    fontSize: 12,
                    color: _isTyping ? Colors.green : Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.phone),
            onPressed: () {
              // Implement call functionality
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return SafeArea(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ListTile(
                          leading: const Icon(Icons.search),
                          title: const Text('Search in conversation'),
                          onTap: () {
                            Navigator.pop(context);
                            // Implement search functionality
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.notifications_off),
                          title: const Text('Mute notifications'),
                          onTap: () {
                            Navigator.pop(context);
                            // Implement mute functionality
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.delete, color: Colors.red),
                          title: const Text('Delete conversation', style: TextStyle(color: Colors.red)),
                          onTap: () {
                            Navigator.pop(context);
                            // Confirm delete
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Delete Conversation'),
                                  content: const Text('Are you sure you want to delete this entire conversation?'),
                                  actions: <Widget>[
                                    TextButton(
                                      child: const Text('Cancel'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    TextButton(
                                      child: const Text('Delete', style: TextStyle(color: Colors.red)),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        Navigator.of(context).pop(); // Return to messages list
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Date divider
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  'Today',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[700],
                  ),
                ),
              ),
            ),
          ),
          
          // Messages list
          Expanded(
            child: GestureDetector(
              onTap: () {
                // Hide emoji picker and attachment menu when tapping on messages
                setState(() {
                  _isEmojiVisible = false;
                  _isAttachmentMenuVisible = false;
                });
              },
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  return messages[index];
                },
              ),
            ),
          ),
          
          // Typing indicator
          if (_isTyping)
            Container(
              padding: const EdgeInsets.only(left: 20, bottom: 8),
              alignment: Alignment.centerLeft,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 40,
                      child: Stack(
                        children: [
                          Positioned(
                            left: 0,
                            child: _buildTypingDot(0),
                          ),
                          Positioned(
                            left: 12,
                            child: _buildTypingDot(150),
                          ),
                          Positioned(
                            left: 24,
                            child: _buildTypingDot(300),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          
          // Attachment menu
          if (_isAttachmentMenuVisible)
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildAttachmentOption(
                    icon: Icons.photo_library,
                    color: Colors.purple,
                    label: 'Gallery',
                    onTap: _pickImage,
                  ),
                  _buildAttachmentOption(
                    icon: Icons.camera_alt,
                    color: Colors.red,
                    label: 'Camera',
                    onTap: _takePhoto,
                  ),
                  _buildAttachmentOption(
                    icon: Icons.insert_drive_file,
                    color: Colors.blue,
                    label: 'Document',
                    onTap: () {
                      // Implement document upload
                    },
                  ),
                  _buildAttachmentOption(
                    icon: Icons.location_on,
                    color: Colors.green,
                    label: 'Location',
                    onTap: () {
                      // Implement location sharing
                    },
                  ),
                ],
              ),
            ),
            
          // Emoji picker
          if (_isEmojiVisible)
            SizedBox(
              height: 250,
              child: const Placeholder(
                color: Colors.grey,
                child: Center(
                  child: Text(
                    'Emoji Picker Would Go Here',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            
          // Message input
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: const Offset(0, -1),
                ),
              ],
            ),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(
                    _isAttachmentMenuVisible ? Icons.close : Icons.attach_file,
                    color: _isAttachmentMenuVisible ? Colors.blue : Colors.grey[700],
                  ),
                  onPressed: _toggleAttachmentMenu,
                ),
                IconButton(
                  icon: Icon(
                    _isEmojiVisible ? Icons.keyboard : Icons.emoji_emotions,
                    color: _isEmojiVisible ? Colors.blue : Colors.grey[700],
                  ),
                  onPressed: _toggleEmojiPicker,
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: TextField(
                      controller: _controller,
                      maxLines: null,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: const InputDecoration(
                        hintText: 'Type a message...',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 10),
                      ),
                      onTap: () {
                        setState(() {
                          _isEmojiVisible = false;
                          _isAttachmentMenuVisible = false;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    constraints: const BoxConstraints.tightFor(width: 40, height: 40),
                    icon: const Icon(Icons.send, color: Colors.white, size: 20),
                    onPressed: _controller.text.isEmpty ? null : _sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildTypingDot(int delayMilliseconds) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
      builder: (context, value, child) {
        return Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: Colors.grey[600]?.withOpacity(
              DelayTween(begin: 0.4, end: 0.9, delay: delayMilliseconds / 1000).animate(
                CurvedAnimation(
                  parent: ModalRoute.of(context)!.animation!,
                  curve: const Interval(0.0, 1.0),
                ),
              ).value,
            ),
            borderRadius: BorderRadius.circular(4),
          ),
        );
      },
    );
  }
  
  Widget _buildAttachmentOption({
    required IconData icon,
    required Color color,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }
}

// Helper class for animated typing dots
class DelayTween extends Tween<double> {
  DelayTween({required double begin, required double end, required this.delay})
      : super(begin: begin, end: end);

  final double delay;

  @override
  double lerp(double t) {
    return super.lerp((sin((t - delay) * 2 * pi) + 1) / 2);
  }
}

enum MessageStatus {
  sent,
  delivered,
  read,
}

class ChatMessage extends StatelessWidget {
  final String? text;
  final File? image;
  final bool isSentByMe;
  final DateTime timestamp;
  final MessageStatus status;

  const ChatMessage({
    super.key, 
    this.text,
    this.image,
    required this.isSentByMe,
    required this.timestamp,
    this.status = MessageStatus.sent,
  });

  String _formatTime(DateTime time) {
    return DateFormat('h:mm a').format(time);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: isSentByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isSentByMe)
            const CircleAvatar(
              radius: 16,
              backgroundColor: Colors.black,
              child: Text(
                'L',
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          
          const SizedBox(width: 8),
          
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75,
              ),
              padding: image != null
                  ? const EdgeInsets.all(4)
                  : const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: isSentByMe
                    ? Colors.black
                    : Colors.grey[200],
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: isSentByMe ? const Radius.circular(16) : const Radius.circular(4),
                  bottomRight: isSentByMe ? const Radius.circular(4) : const Radius.circular(16),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (image != null)
                    GestureDetector(
                      onTap: () {
                        // Show full-screen image
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return Dialog(
                              insetPadding: EdgeInsets.zero,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  InteractiveViewer(
                                    panEnabled: true,
                                    minScale: 0.5,
                                    maxScale: 4,
                                    child: Image.file(image!),
                                  ),
                                  Positioned(
                                    top: 20,
                                    right: 20,
                                    child: IconButton(
                                      icon: const Icon(
                                        Icons.close,
                                        color: Colors.white,
                                        size: 30,
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          image!,
                          width: 200,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  if (text != null)
                    Text(
                      text!,
                      style: TextStyle(
                        color: isSentByMe ? Colors.white : Colors.black,
                        fontSize: 16,
                      ),
                    ),
                ],
              ),
            ),
          ),
          
          const SizedBox(width: 4),
          
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _formatTime(timestamp),
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey[600],
                ),
              ),
              if (isSentByMe)
                Icon(
                  status == MessageStatus.sent
                      ? Icons.check
                      : status == MessageStatus.delivered
                          ? Icons.done_all
                          : Icons.done_all,
                  size: 14,
                  color: status == MessageStatus.read ? Colors.blue : Colors.grey[600],
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class InteractiveViewer extends StatelessWidget {
  final Widget child;
  final bool panEnabled;
  final double minScale;
  final double maxScale;
  
  const InteractiveViewer({
    super.key,
    required this.child,
    this.panEnabled = true,
    this.minScale = 0.5,
    this.maxScale = 2.0,
  });
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
      },
      child: Container(
        color: Colors.black,
        child: Center(
          child: child,
        ),
      ),
    );
  }
}