import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hr_connect/core/config/capitalize.dart';
import 'package:hr_connect/core/config/validator.dart';
import 'package:hr_connect/core/constants/enum.dart';
import 'package:hr_connect/features/shared/widgets/custom_button.dart';
import 'package:hr_connect/features/shared/widgets/custom_confirm_dialog.dart';
import 'package:hr_connect/features/shared/widgets/custom_snackbar.dart';
import 'package:hr_connect/features/shared/widgets/custom_text_field.dart';
import 'package:hr_connect/features/user_management/data/model/user_model.dart';
import 'package:hr_connect/features/user_management/providers/user_provider.dart';

class EditUserScreen extends ConsumerStatefulWidget {
  final UserModel user;
  const EditUserScreen({super.key, required this.user});

  @override
  ConsumerState<EditUserScreen> createState() => _EditUserScreenState();
}

class _EditUserScreenState extends ConsumerState<EditUserScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;

  Role? _selectedRole;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(
      text: widget.user.data.firstName,
    );
    _lastNameController = TextEditingController(
      text: widget.user.data.lastName,
    );
    _emailController = TextEditingController(text: widget.user.data.email);
    _selectedRole = Role.values.firstWhere(
      (role) => role == widget.user.data.role,
      orElse: () => Role.unknown,
    );
    if (_selectedRole == Role.unknown) _selectedRole = null;
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _confirmSave() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_selectedRole == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a role for this user.')),
      );
      return;
    }

    FocusScope.of(context).unfocus();

    showCustomConfirmDialog(
      context: context,
      title: 'Save User Data',
      description: 'Are you sure you want to change the user data?',
      confirmButtonText: 'Confirm',
      onConfirm: _saveUser,
    );
  }

  Future<void> _saveUser() async {
    setState(() {
      _isSaving = true;
    });

    final newData = UserData(
      email: _emailController.text.trim(),
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      role: _selectedRole!,
      avatarUrl: widget.user.data.avatarUrl,
    );

    final result = await ref
        .read(userNotifierProvider.notifier)
        .updateUser(widget.user.id, newData);

    if (!mounted) return;

    setState(() {
      _isSaving = false;
    });

    result.fold(
      (failure) {
        CustomSnackBar.showError(context, message: failure.message);
      },
      (_) async {
        CustomSnackBar.showSuccess(
          context,
          message: 'User updated successfully!',
        );
        ref.read(userNotifierProvider.notifier).refreshUsers();
        context.pop();
      },
    );
  }

  @override
  Widget build(BuildContext contet) {
    final theme = Theme.of(contet);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorScheme.surfaceContainer,
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: Text(
          'Edit User',
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
                CachedNetworkImage(
                  imageUrl: widget.user.data.avatarUrl ?? '',
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: colorScheme.primary.withValues(alpha: 0.2),
                        width: 2.w,
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 50.r,
                      backgroundImage: imageProvider,
                    ),
                  ),
                  placeholder: (context, url) => CircleAvatar(
                    radius: 50.r,
                    backgroundColor: colorScheme.surfaceContainerHighest,
                    child: Icon(
                      Icons.person_rounded,
                      size: 40.sp,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  errorWidget: (context, url, error) => CircleAvatar(
                    radius: 50.r,
                    backgroundColor: colorScheme.primaryContainer,
                    child: Text(
                      widget.user.data.firstName.isNotEmpty
                          ? widget.user.data.firstName[0].toUpperCase()
                          : '?',
                      style: TextStyle(
                        fontSize: 28.sp,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
                Text(
                  'ID: ${widget.user.id}',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: colorScheme.onSurfaceVariant,
                    fontFamily: 'monospace',
                  ),
                ),
                Text(
                  'Created At: ${DateTime.now().difference(widget.user.createdAt).inDays} days ago',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: colorScheme.onSurfaceVariant,
                    fontFamily: 'monospace',
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'Updated At: ${DateTime.now().difference(widget.user.updatedAt).inDays} days ago',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: colorScheme.onSurfaceVariant,
                    fontFamily: 'monospace',
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'Active: ${widget.user.isActive ? 'Yes' : 'No'}',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: colorScheme.onSurfaceVariant,
                    fontFamily: 'monospace',
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 32.h),
                CustomTextField(
                  controller: _firstNameController,
                  title: 'First Name',
                  hint: 'Enter first name',
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
                  hint: 'Enter last name',
                  icon: Icons.person_rounded,
                  colorScheme: colorScheme,
                  isLoading: _isSaving,
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  validator: Validator.requiredValidator,
                ),
                SizedBox(height: 16.h),
                CustomTextField(
                  controller: _emailController,
                  title: 'Email Address',
                  hint: 'Enter email address',
                  icon: Icons.email_rounded,
                  colorScheme: colorScheme,
                  isLoading: _isSaving,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.done,
                  validator: Validator.emailValidator,
                ),
                SizedBox(height: 16.h),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'User Role',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    DropdownButtonFormField<Role>(
                      initialValue: _selectedRole,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: colorScheme.surfaceContainerHighest,
                        prefixIcon: Icon(
                          Icons.admin_panel_settings_rounded,
                          color: colorScheme.onSurfaceVariant,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 16.h,
                        ),
                      ),
                      dropdownColor: colorScheme.surfaceContainer,
                      items: Role.values.where((r) => r != Role.unknown).map((
                        role,
                      ) {
                        return DropdownMenuItem(
                          value: role,
                          child: Text(
                            Capitalize.firstLetterUppercase(role.name),
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: colorScheme.onSurface,
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: _isSaving
                          ? null
                          : (value) {
                              setState(() {
                                _selectedRole = value;
                              });
                            },
                    ),
                  ],
                ),
                SizedBox(height: 40.h),
                CustomButton(
                  text: 'Save User Data',
                  isLoading: _isSaving,
                  onPressed: _confirmSave,
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
