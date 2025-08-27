import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class PermissionCard extends StatefulWidget {
  final String title;
  final String description;
  final String lottieAsset;
  final VoidCallback onRequest;
  final bool granted;
  final Duration animationDelay;

  const PermissionCard({
    super.key,
    required this.title,
    required this.description,
    required this.lottieAsset,
    required this.onRequest,
    required this.granted,
    required this.animationDelay,
  });

  @override
  State<PermissionCard> createState() => _PermissionCardState();
}

class _PermissionCardState extends State<PermissionCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));

    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    Future.delayed(widget.animationDelay, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                SizedBox(height: 60, width: 60, child: Lottie.asset(widget.lottieAsset, repeat: !widget.granted)),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.title, style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 4),
                      Text(widget.description, style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                widget.granted
                    ? const Icon(Icons.check_circle, color: Colors.green, size: 32)
                    : ElevatedButton(onPressed: widget.onRequest, child: const Text("Allow")),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
