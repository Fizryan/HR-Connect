import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hr_connect/core/config/validator.dart';
import 'package:hr_connect/features/auth/providers/auth_provider.dart';
import 'package:hr_connect/features/shared/widgets/custom_button.dart';
import 'package:hr_connect/features/shared/widgets/custom_confirm_dialog.dart';
import 'package:hr_connect/features/shared/widgets/custom_text_field.dart';
import 'package:hr_connect/features/user_management/data/model/user_model.dart';
import 'package:hr_connect/features/user_management/providers/user_provider.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final currentUser = ref.read(authNotifierProvider).value;

    _firstNameController = TextEditingController(
      text: currentUser?.data.firstName ?? '',
    );
    _lastNameController = TextEditingController(
      text: currentUser?.data.lastName ?? '',
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  void _confirmUpdate() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    FocusScope.of(context).unfocus();

    showCustomConfirmDialog(
      context: context,
      title: 'Update Profile',
      description: 'Are you sure you want to change the profile name?',
      confirmButtonText: 'Confirm',
      onConfirm: () => _saveProfile,
    );
  }

  Future<void> _saveProfile(UserModel currentUser) async {
    setState(() {
      _isSaving = true;
    });

    final colorScheme = Theme.of(context).colorScheme;
    final newData = UserData(
      email: currentUser.data.email,
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      role: currentUser.data.role,
      avatarUrl: currentUser.data.avatarUrl,
    );

    final result = await ref
        .read(userNotifierProvider.notifier)
        .updateUser(currentUser.id, newData);

    if (!mounted) return;

    setState(() {
      _isSaving = false;
    });

    result.fold(
      (failure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.error_outline, color: colorScheme.onErrorContainer),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    failure.message,
                    style: TextStyle(color: colorScheme.onErrorContainer),
                  ),
                ),
              ],
            ),
            backgroundColor: colorScheme.errorContainer,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
            margin: EdgeInsets.all(20.w),
            elevation: 0,
          ),
        );
      },
      (_) async {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Profile updated successfully!'),
            backgroundColor: colorScheme.primary,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
            margin: EdgeInsets.all(20.w),
          ),
        );
        ref.read(userNotifierProvider.notifier).refreshUsers();

        ref.invalidate(authNotifierProvider);

        context.pop();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final currentUser = ref.watch(authNotifierProvider).value;

    if (currentUser == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

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
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CachedNetworkImage(
                      imageUrl: currentUser.data.avatarUrl ?? '',
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
                          Icons.person_rounded,
                          size: 50.sp,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      errorWidget: (context, url, error) => CircleAvatar(
                        radius: 60.r,
                        backgroundColor: colorScheme.primaryContainer,
                        child: Text(
                          currentUser.data.firstName.isNotEmpty
                              ? currentUser.data.firstName[0].toUpperCase()
                              : '?',
                          style: TextStyle(
                            fontSize: 30.sp,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onPrimaryContainer,
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {}, // TODO: Implement avatar upload
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
                  hint: currentUser.data.firstName,
                  icon: Icons.person_rounded,
                  colorScheme: colorScheme,
                  isLoading: _isSaving,
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  validator: Validator.requiredValidator,
                ),
                SizedBox(height: 16.h),
                CustomTextField(
                  controller: _lastNameController,
                  title: 'Last Name',
                  hint: currentUser.data.lastName,
                  icon: Icons.person_rounded,
                  colorScheme: colorScheme,
                  isLoading: _isSaving,
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _confirmUpdate(),
                  validator: Validator.requiredValidator,
                ),
                SizedBox(height: 40.h),
                CustomButton(
                  text: 'Update Profile',
                  isLoading: _isSaving,
                  onPressed: _confirmUpdate,
                  colorScheme: colorScheme,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
