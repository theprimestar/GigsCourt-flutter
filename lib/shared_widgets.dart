// ========================================
// GigsCourt - Shared Widgets
// ========================================

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'models.dart';
import 'services.dart';

// ========== TOAST ==========
void showToast(BuildContext context, String message, {bool isError = false, bool isSuccess = false}) {
  final overlay = Overlay.of(context);
  final overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      bottom: 80,
      left: 16,
      right: 16,
      child: Material(
        color: Colors.transparent,
        child: TweenAnimationBuilder(
          tween: Tween<double>(begin: 0, end: 1),
          duration: const Duration(milliseconds: 300),
          builder: (context, value, child) {
            return Opacity(
              opacity: value,
              child: Transform.translate(
                offset: Offset(0, 20 * (1 - value)),
                child: child,
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: isError 
                  ? Colors.red.withOpacity(0.95)
                  : isSuccess 
                      ? Colors.green.withOpacity(0.95)
                      : Colors.black.withOpacity(0.85),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Text(
              message,
              style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    ),
  );

  overlay.insert(overlayEntry);
  Future.delayed(const Duration(seconds: 3), () {
    overlayEntry.remove();
  });
}

// ========== SKELETON CARD ==========
class SkeletonCard extends StatelessWidget {
  const SkeletonCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Theme.of(context).brightness == Brightness.light 
          ? Colors.grey[300]! 
          : Colors.grey[800]!,
      highlightColor: Theme.of(context).brightness == Brightness.light 
          ? Colors.grey[100]! 
          : Colors.grey[700]!,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Theme.of(context).dividerColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(width: 120, height: 14, color: Colors.white),
                    const SizedBox(height: 8),
                    Container(width: 80, height: 12, color: Colors.white),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Container(width: 70, height: 28, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20))),
                const SizedBox(width: 8),
                Container(width: 70, height: 28, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20))),
                const SizedBox(width: 8),
                Container(width: 70, height: 28, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20))),
              ],
            ),
            const SizedBox(height: 12),
            Container(width: 150, height: 12, color: Colors.white),
          ],
        ),
      ),
    );
  }
}

// ========== PROVIDER CARD ==========
class ProviderCard extends StatelessWidget {
  final String userId;
  final String displayName;
  final String? photoURL;
  final double rating;
  final int reviewCount;
  final List<String> services;
  final double distanceMeters;
  final bool isActive;
  final int gigCount;
  final int monthlyGigs;
  final VoidCallback onTap;

  const ProviderCard({
    super.key,
    required this.userId,
    required this.displayName,
    this.photoURL,
    required this.rating,
    required this.reviewCount,
    required this.services,
    required this.distanceMeters,
    required this.isActive,
    required this.gigCount,
    required this.monthlyGigs,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final avatarUrl = photoURL != null && photoURL!.isNotEmpty
        ? getOptimizedImageUrl(photoURL!)
        : 'https://ui-avatars.com/api/?name=${Uri.encodeComponent(displayName)}';
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Theme.of(context).dividerColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFFE67E22), width: 2),
                    image: DecorationImage(
                      image: NetworkImage(avatarUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              displayName,
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (isActive) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFF4CAF50),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text(
                                'Active',
                                style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.star, size: 14, color: Color(0xFFFFC107)),
                          const SizedBox(width: 4),
                          Text(
                            '${rating.toStringAsFixed(1)} ($reviewCount)',
                            style: TextStyle(fontSize: 13, color: Theme.of(context).textTheme.bodySmall?.color),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: services.take(3).map((service) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(service, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                );
              }).toList(),
            ),
            if (gigCount > 0) ...[
              const SizedBox(height: 12),
              Text(
                '${isActive ? '🔥 ' : ''}$monthlyGigs gigs this month',
                style: TextStyle(fontSize: 12, color: Theme.of(context).textTheme.bodySmall?.color),
              ),
            ],
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.location_on, size: 14, color: Colors.grey),
                const SizedBox(width: 4),
                Text(formatDistance(distanceMeters), style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
