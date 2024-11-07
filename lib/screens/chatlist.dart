import 'package:flutter/material.dart';

class ChatList extends StatelessWidget {
  final List<Map<String, String>> chatMessages = [
    {
      'avatar':
          'https://goswirl-assets.s3.ap-south-1.amazonaws.com/brand_logo/1722321030_1671443727_velocity-logo.jpg', // Replace with actual image URLs
      'username': 'John',
      'message': 'Hey, how are you?',
      'time': '10:30 AM',
    },
    {
      'avatar':
          'https://goswirl-assets.s3.ap-south-1.amazonaws.com/brand_logo/1722321030_1671443727_velocity-logo.jpg',
      'username': 'Alice',
      'message': 'I am fine, what about you?',
      'time': '10:32 AM',
    },
    {
      'avatar':
          'https://goswirl-assets.s3.ap-south-1.amazonaws.com/brand_logo/1722321030_1671443727_velocity-logo.jpg',
      'username': 'David',
      'message': 'Hello everyone!',
      'time': '10:33 AM',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: chatMessages.length,
        itemBuilder: (context, index) {
          final chatMessage = chatMessages[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 0.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // User Avatar
                ClipOval(
                  child: Image.network(
                    chatMessage['avatar']!,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Username and time
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                chatMessage['username']!,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(width: 5),
                              Text(
                                chatMessage['time']!,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          Image.asset(
                            'packages/swirl_shortvideosdk/assets/images/pin.png',
                            width: 20,
                            height: 20,
                            fit: BoxFit.cover,
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      // Message Text
                      Text(
                        chatMessage['message']!,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
