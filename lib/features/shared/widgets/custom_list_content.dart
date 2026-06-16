import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomListContent<T> extends StatelessWidget {
  final List<T> items;
  final bool isLoading;
  final String? error;
  final DateTime? lastFetchTime;
  final String emptyMessage;
  final Future<void> Function() onRefresh;
  final Widget Function(T item) itemBuilder;
  final Widget? filterSection;

  const CustomListContent({
    super.key,
    required this.items,
    required this.isLoading,
    required this.onRefresh,
    required this.itemBuilder,
    this.error,
    this.lastFetchTime,
    this.emptyMessage = 'No items found.',
    this.filterSection,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        if (isLoading) const LinearProgressIndicator(),
        if (error != null) ...[
          Container(
            width: double.infinity,
            color: colorScheme.errorContainer,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: Text(
              error!,
              style: TextStyle(color: colorScheme.onErrorContainer),
              textAlign: TextAlign.center,
            ),
          ),
        ],
        if (lastFetchTime != null) ...[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 6.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                StreamBuilder(
                  stream: Stream.periodic(const Duration(minutes: 1)),
                  builder: (context, _) {
                    final minutes = DateTime.now()
                        .difference(lastFetchTime!)
                        .inMinutes;
                    final timeString = minutes == 0
                        ? 'Just now'
                        : '$minutes minute${minutes > 1 ? 's' : ''} ago';
                    return Text(
                      'Last updated: $timeString',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
        ?filterSection,
        Expanded(
          child: RefreshIndicator(
            onRefresh: onRefresh,
            backgroundColor: colorScheme.surfaceContainerHighest,
            color: colorScheme.primary,
            child: items.isEmpty
                ? ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.5,
                        child: Center(
                          child: Text(
                            emptyMessage,
                            style: TextStyle(
                              color: colorScheme.onSurfaceVariant,
                              fontSize: 15.sp,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                : ListView.separated(
                    physics: const AlwaysScrollableScrollPhysics(
                      parent: ClampingScrollPhysics(),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    itemCount: items.length,
                    separatorBuilder: (context, index) => Divider(
                      height: 1,
                      indent: 76.w,
                      endIndent: 20.w,
                      color: colorScheme.outlineVariant.withValues(alpha: 0.3),
                    ),
                    itemBuilder: (context, index) => itemBuilder(items[index]),
                  ),
          ),
        ),
      ],
    );
  }
}
