# overlapping_circles

A simple customizable Flutter widget to show overlapping avatars with optional network images or fallback initials.

## Usage

```dart
OverlappingAvatars(
  users: [
    {"Name": "Sahil", "url": "https://example.com/sahil.jpg"},
    {"Name": "Amit"},
    {"Name": "Priya", "url": "https://example.com/priya.jpg"},
    {"Name": "Priya", "url": "assets/images/demo.png"},
  ],
)
