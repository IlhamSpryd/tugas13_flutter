import 'package:flutter/material.dart';

class MenuSection extends StatelessWidget {
  final String title;
  final List<Widget> items;

  const MenuSection({super.key, required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              title,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                color: Colors.grey, // lo bisa ganti warna di sini
              ),
            ),
            const Spacer(),
            const Icon(Icons.more_horiz, color: Colors.grey, size: 20),
            const SizedBox(width: 10),
            const Icon(Icons.add, color: Colors.grey, size: 20),
          ],
        ),
        const SizedBox(height: 12),
        ...items,
      ],
    );
  }
}
