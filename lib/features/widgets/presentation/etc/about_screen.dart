import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  late Future<PackageInfo> _packageInfoFuture;

  @override
  void initState() {
    super.initState();
    _packageInfoFuture = PackageInfo.fromPlatform();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorScheme.surfaceContainer,
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: Text(
          'About',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: colorScheme.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Container(
                    width: 100.w,
                    height: 100.w,
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer.withValues(
                        alpha: 0.5,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset(
                      'assets/logo_icon.png',
                      width: 100.w,
                      height: 100.h,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          padding: EdgeInsets.all(24.w),
                          decoration: BoxDecoration(
                            color: colorScheme.onSurface,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.business_center_rounded,
                            size: 60.sp,
                            color: colorScheme.surface,
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'HRConnect',
                          style: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w800,
                            color: colorScheme.onSurface,
                            letterSpacing: -0.5,
                          ),
                        ),
                        Text(
                          'Human Resource Management App',
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w100,
                            color: colorScheme.onSurfaceVariant,
                            letterSpacing: 0.5,
                          ),
                        ),
                        FutureBuilder<PackageInfo>(
                          future: _packageInfoFuture,
                          builder: (context, snapshot) {
                            final versionStr = snapshot.hasData
                                ? snapshot.data!.version
                                : 'Loading...';
                            return Text(
                              'Version: $versionStr',
                              style: TextStyle(
                                color: colorScheme.onSurface.withValues(
                                  alpha: 0.6,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              Text(
                'HRConnect is a comprehensive human resources management system designed to streamline employee data, requests, and management workflows efficiently.',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: colorScheme.onSurface,
                  height: 1.5,
                ),
              ),
              Divider(height: 40.h, indent: 10, endIndent: 10),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'HRConnect Team',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: colorScheme.primary,
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              Container(
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(
                    color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                  ),
                ),
                child: Column(
                  children: [
                    _buildTeamMember(context, 'Muhammad Fathir Rizky Salam'),
                    Divider(
                      height: 1,
                      indent: 56.w,
                      endIndent: 16.w,
                      color: colorScheme.outlineVariant,
                    ),
                    _buildTeamMember(context, 'Hafizryandin Haykal Matondang'),
                    Divider(
                      height: 1,
                      indent: 56.w,
                      endIndent: 16.w,
                      color: colorScheme.outlineVariant,
                    ),
                    _buildTeamMember(context, 'Hafidz Naufal Pradana'),
                    Divider(
                      height: 1,
                      indent: 56.w,
                      endIndent: 16.w,
                      color: colorScheme.outlineVariant,
                    ),
                    _buildTeamMember(context, 'Haidar Zahran Haryono'),
                  ],
                ),
              ),
              SizedBox(height: 40.h),
              _buildInfoCard(
                context: context,
                icon: Icons.code_rounded,
                title: 'Open Source Licenses',
                onTap: () async {
                  final packageInfo = await _packageInfoFuture;
                  if (!context.mounted) return;
                  showLicensePage(
                    context: context,
                    applicationName: 'HRConnect',
                    applicationVersion: 'v${packageInfo.version}',
                    applicationIcon: Padding(
                      padding: EdgeInsets.all(12.w),
                      child: Image.asset(
                        'assets/logo_icon.png',
                        width: 100.w,
                        height: 100.h,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            padding: EdgeInsets.all(24.w),
                            decoration: BoxDecoration(
                              color: colorScheme.onSurface,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.business_center_rounded,
                              size: 60.sp,
                              color: colorScheme.surface,
                            ),
                          );
                        },
                      ),
                    ),
                    applicationLegalese:
                        '© ${DateTime.now().year} HRConnect Team.',
                  );
                },
              ),
              SizedBox(height: 48.h),
              Text(
                '© ${DateTime.now().year} HRConnect.\nAll rights reserved.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12.sp, color: colorScheme.outline),
              ),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTeamMember(BuildContext context, String name) {
    final colorScheme = Theme.of(context).colorScheme;
    final initial = name.isNotEmpty ? name[0].toUpperCase() : '?';

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16.r,
            backgroundColor: colorScheme.primaryContainer,
            child: Text(
              initial,
              style: TextStyle(
                color: colorScheme.onPrimaryContainer,
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Text(
              name,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: colorScheme.surfaceContainerLowest,
      borderRadius: BorderRadius.circular(16.r),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Row(
            children: [
              Icon(icon, color: colorScheme.primary, size: 24.sp),
              SizedBox(width: 16.w),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: colorScheme.onSurfaceVariant,
                size: 22.sp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
