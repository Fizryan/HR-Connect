import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomCompactTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final String fallbackText;
  final String? imageUrl;
  final String? badgeText;
  final Color? statusDotColor;
  final bool isTitleStrikeThrough;
  final VoidCallback? onTap;
  final Widget? trailing;

  const CustomCompactTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.fallbackText,
    this.imageUrl,
    this.badgeText,
    this.statusDotColor,
    this.isTitleStrikeThrough = false,
    this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
          child: Row(
            children: [
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CachedNetworkImage(
                    imageUrl: imageUrl ?? '',
                    imageBuilder: (context, imageProvider) => CircleAvatar(
                      radius: 22.r,
                      backgroundImage: imageProvider,
                    ),
                    placeholder: (context, url) => CircleAvatar(
                      radius: 22.r,
                      backgroundColor: colorScheme.surfaceContainerHighest,
                      child: Icon(
                        Icons.person,
                        size: 20.sp,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    errorWidget: (context, url, error) => CircleAvatar(
                      radius: 22.r,
                      backgroundColor: colorScheme.primaryContainer,
                      child: Text(
                        fallbackText.isNotEmpty
                            ? fallbackText[0].toUpperCase()
                            : '?',
                        style: TextStyle(
                          color: colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.sp,
                        ),
                      ),
                    ),
                  ),
                  if (statusDotColor != null) ...[
                    Container(
                      width: 12.w,
                      height: 12.w,
                      decoration: BoxDecoration(
                        color: statusDotColor,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: colorScheme.surface,
                          width: 2.w,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            title,
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w600,
                              color: colorScheme.onSurface,
                              decoration: isTitleStrikeThrough
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (badgeText != null && badgeText!.isNotEmpty) ...[
                          SizedBox(width: 8.w),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 6.w,
                              vertical: 2.h,
                            ),
                            decoration: BoxDecoration(
                              color: colorScheme.primaryContainer.withValues(
                                alpha: 0.6,
                              ),
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                            child: Text(
                              badgeText!,
                              style: TextStyle(
                                fontSize: 10.sp,
                                fontWeight: FontWeight.bold,
                                color: colorScheme.onPrimaryContainer,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              ?trailing,
            ],
          ),
        ),
      ),
    );
  }
}
