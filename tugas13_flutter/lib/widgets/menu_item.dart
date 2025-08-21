import 'package:flutter/material.dart';

class MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const MenuItem({super.key, required this.icon, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        splashColor: Colors.grey.withOpacity(0.5),
        child: Container(
          padding: const EdgeInsets.all(14),
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
          ),
          child: Row(
            children: [
              Icon(icon, color: Colors.grey),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(fontFamily: 'Poppins', fontSize: 15),
              ),
              const Spacer(),
              const Icon(Icons.more_horiz, color: Colors.grey),
              const SizedBox(width: 10),
              const Icon(Icons.add, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
