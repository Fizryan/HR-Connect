import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RecentList<T> extends StatelessWidget {
  final List<T> items;
  final String emptyMesage;
  final IconData emptyIcon;
  final Widget Function(T item) itemBuilder;

  const RecentList({
    super.key,
    required this.items,
    required this.emptyMesage,
    required this.emptyIcon,
    required this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(emptyIcon, size: 48),
            const SizedBox(height: 16),
            Text(emptyMesage, style: const TextStyle(fontSize: 16)),
          ],
        ),
      );
    }

    final recentItems = items.take(5).toList();

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: recentItems.length,
      separatorBuilder: (context, index) => SizedBox(height: 8.h),
      itemBuilder: (context, index) => itemBuilder(recentItems[index]),
    );
  }
}
