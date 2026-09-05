// lib/widgets/app_shimmer.dart
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class AppShimmer extends StatelessWidget {
  const AppShimmer({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Shimmer.fromColors(
      baseColor: colorScheme.surfaceContainerHighest,
      highlightColor: colorScheme.surfaceContainerLowest,
      child: child,
    );
  }
}

/// Kotak placeholder generic, dipakai buat nyusun skeleton custom.
class AppShimmerBox extends StatelessWidget {
  const AppShimmerBox({
    super.key,
    this.width,
    this.height = 16,
    this.borderRadius = 8,
  });

  final double? width;
  final double height;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white, // warna ini di-override sama Shimmer.fromColors di parent
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}

/// Preset skeleton buat list item ala ListTile (icon + 2 baris teks).
/// Cocok buat dipakai gantiin ListScreen kamu pas loading state.
class AppShimmerListTile extends StatelessWidget {
  const AppShimmerListTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 16, right: 16),
      child: Container(
        height: 72,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const AppShimmerBox(width: 40, height: 40, borderRadius: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  AppShimmerBox(width: 120),
                  SizedBox(height: 8),
                  AppShimmerBox(width: 180, height: 12),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Helper cepat: N buah shimmer list tile dibungkus AppShimmer.
class AppShimmerListView extends StatelessWidget {
  const AppShimmerListView({super.key, this.itemCount = 6});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 16),
        itemCount: itemCount,
        itemBuilder: (context, index) => const AppShimmerListTile(),
      ),
    );
  }
}