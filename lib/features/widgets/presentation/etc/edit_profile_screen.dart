import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_connect/features/user_management/data/model/user_model.dart';
import 'package:hr_connect/features/user_management/providers/user_provider.dart';
import 'package:hr_connect/features/widgets/shared/custom_text_field.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  final UserModel user;
  const EditProfileScreen({super.key, required this.user});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;

  late final email = widget.user.email;
  late final createdAt = widget.user.createdAt;
  late final updatedAt = widget.user.updatedAt;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(text: widget.user.firstName);
    _lastNameController = TextEditingController(text: widget.user.lastName);
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    final updatedFirstName = _firstNameController.text;
    final updatedLastName = _lastNameController.text;

    if (updatedFirstName.isEmpty || updatedLastName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please fill in all fields',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.error,
            ),
          ),
          backgroundColor: Theme.of(context).colorScheme.errorContainer,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final updateData = {
      'firstName': updatedFirstName,
      'lastName': updatedLastName,
      'email': widget.user.email,
      'role': widget.user.role.name,
    };

    ref
        .read(userNotifierProvider.notifier)
        .updateUser(widget.user.id, updateData);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Profile updated successfully'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Theme.of(context).colorScheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorScheme.surfaceContainer,
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: Text(
          'Edit Profile',
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
      body: Stack(
        children: [
          Positioned(
            top: 30.h,
            right: 40.w,
            child: Container(
              width: 200.w,
              height: 200.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colorScheme.primary.withValues(alpha: 0.1),
              ),
            ),
          ),
          Positioned(
            top: 10.h,
            right: 10.w,
            child: Container(
              width: 50.w,
              height: 50.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colorScheme.primary.withValues(alpha: 0.1),
              ),
            ),
          ),
          Positioned(
            top: 240.h,
            right: 240.w,
            child: Container(
              width: 100.w,
              height: 100.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colorScheme.primary.withValues(alpha: 0.1),
              ),
            ),
          ),
          Positioned(
            bottom: 30.h,
            left: 40.w,
            child: Container(
              width: 200.w,
              height: 200.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colorScheme.primary.withValues(alpha: 0.1),
              ),
            ),
          ),
          Positioned(
            bottom: 10.h,
            left: 5.w,
            child: Container(
              width: 50.w,
              height: 50.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colorScheme.primary.withValues(alpha: 0.1),
              ),
            ),
          ),
          Positioned(
            bottom: 240.h,
            left: 240.w,
            child: Container(
              width: 100.w,
              height: 100.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colorScheme.primary.withValues(alpha: 0.1),
              ),
            ),
          ),
          SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Padding(
              padding: EdgeInsetsGeometry.symmetric(
                horizontal: 24.w,
                vertical: 20.h,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CachedNetworkImage(
                        imageUrl: widget.user.avatarUrl ?? '',
                        imageBuilder: (context, imageProvider) => Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: colorScheme.primary.withValues(alpha: 0.2),
                              width: 2.w,
                            ),
                          ),
                          child: CircleAvatar(
                            radius: 60.r,
                            backgroundImage: imageProvider,
                          ),
                        ),
                        placeholder: (context, url) => CircleAvatar(
                          radius: 60.r,
                          backgroundColor: colorScheme.surfaceContainerHighest,
                          child: Icon(
                            Icons.person,
                            size: 50.sp,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        errorWidget: (context, url, error) => CircleAvatar(
                          radius: 60.r,
                          backgroundColor: colorScheme.primaryContainer,
                          child: Icon(Icons.person, color: colorScheme.primary),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          // TODO: Implement image upload logic
                        },
                        child: Container(
                          padding: EdgeInsets.all(8.r),
                          decoration: BoxDecoration(
                            color: colorScheme.primary,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: colorScheme.surface,
                              width: 3.w,
                            ),
                          ),
                          child: Icon(
                            Icons.camera_alt_rounded,
                            color: colorScheme.onPrimary,
                            size: 20.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 40.h),
                  CustomTextField(
                    controller: _firstNameController,
                    title: 'First Name',
                    hint: widget.user.firstName,
                    icon: Icons.person,
                    theme: theme,
                    keyboardType: TextInputType.name,
                  ),
                  SizedBox(height: 18.h),
                  CustomTextField(
                    controller: _lastNameController,
                    title: 'Last Name',
                    hint: widget.user.lastName,
                    icon: Icons.person,
                    theme: theme,
                    keyboardType: TextInputType.name,
                  ),
                  Divider(height: 30.h, indent: 10.w, endIndent: 10.w),
                  Text(
                    'Read Only',
                    style: TextStyle(color: colorScheme.onSurfaceVariant),
                  ),
                  SizedBox(height: 18.h),
                  CustomTextField(
                    title: 'Email',
                    hint: email,
                    icon: Icons.email,
                    theme: theme,
                    readOnly: true,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: 18.h),
                  CustomTextField(
                    title: 'Created At',
                    hint: (createdAt ?? 'Data Empty').toString(),
                    icon: Icons.calendar_today,
                    theme: theme,
                    readOnly: true,
                  ),
                  SizedBox(height: 18.h),
                  CustomTextField(
                    title: 'Updated At',
                    hint: (updatedAt ?? 'Data Empty').toString(),
                    icon: Icons.calendar_today,
                    theme: theme,
                    readOnly: true,
                  ),
                  SizedBox(height: 16.h),
                  SizedBox(
                    width: double.infinity,
                    height: 54.h,
                    child: FilledButton(
                      onPressed: _saveProfile,
                      style: FilledButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        foregroundColor: colorScheme.onPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'Save Changes',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 40.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
