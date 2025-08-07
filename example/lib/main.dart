import 'package:flutter/material.dart';
// Make sure this path is correct for your local package
import 'package:overlapping_circles/overlapping_circles.dart';

class HomeScreen extends StatelessWidget {
  // User list remains the same...
  final List<Map<String, String>> users = [
    {"url": "https://i.pravatar.cc/250?img=1", "Name": "Alice Johnson"},
    {"url": "assets/images/image1.png"},
    {"url": "https://robohash.org/example1", "Name": "Jennifer Lee"},
    {"url": "", "Name": "David Wilson"},
    {"url": "https://loremflickr.com/250/250/avatar", "Name": "Emily Davis"},
    {"url": "https://avatar-placeholder.iran.liara.run/avatars/1", "Name": "James Miller"},
    {"url": "e2", "Name": "Sophia Martinez"},
    {"url": "https://i.pravatar.cc/250?img=2", "Name": "Christopher Anderson"},
    {"url": "https://api.dicebear.com/7.x/pixel-art/svg?seed=unique3", "Name": "Olivia Thomas"},
    {"url": "", "Name": "Daniel Taylor"},
  ];

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Avatares Personalizados"),
      ),
      body: Center(
        child: OverlappingAvatars(
            users: users,
            // avatarRadius: 0,

            maxVisible: 5,

            // Parameters below are ignored because avatarBuilder is being used,
            // but are kept here for demonstration.
            // avatarBackgroundColor: Colors.pinkAccent,
            fallbackTextStyle: const TextStyle(color: Colors.cyan),

            // 👇 THIS IS THE CORRECTED BUILDER
            avatarBuilder: (context, user) {
              final name = user['Name'] ?? '';
              final url = user['url'] ?? '';
              final firstLetter = name.isNotEmpty ? name[0].toUpperCase() : '?';

              final fallback = Text(firstLetter, style: const TextStyle(color: Colors.white, fontSize: 18));

              Widget imageWidget;

              if (url.startsWith('http')) {
                imageWidget = Image.network(
                  url,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => fallback,
                );
              } else if (url.startsWith('assets/')) {
                imageWidget = Image.asset(
                  url,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => fallback,
                );
              } else {
                imageWidget = fallback;
              }

              return Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [Colors.purple, Colors.orange],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                padding: const EdgeInsets.all(2.5),
                child: CircleAvatar(
                  radius: 30 - 2.5,
                  backgroundColor: Colors.grey.shade700,
                  child: ClipOval(
                    child: imageWidget,
                  ),
                ),
              );
            }),
      ),
    );
  }
}
