import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_connect/core/const/enums.dart';
import 'package:hr_connect/core/di/injection.dart';
import 'package:hr_connect/features/logic/account/data/model/account_model.dart';
import 'package:hr_connect/features/logic/account/providers/account_provider.dart';
import 'package:hr_connect/features/logic/account/providers/account_state.dart';
import 'package:hr_connect/features/logic/user_management/data/models/user_model.dart';
import 'package:hr_connect/features/logic/user_management/providers/user_provider.dart';
import 'package:hr_connect/features/logic/user_management/providers/user_state.dart';
import 'package:hr_connect/features/widgets/presentation/shared/custom_text_field.dart';

class AdminCreateUserScreen extends StatefulWidget {
  final ColorScheme colorScheme;
  final UserProvider userProvider;

  const AdminCreateUserScreen({
    super.key,
    required this.colorScheme,
    required this.userProvider,
  });

  @override
  State<AdminCreateUserScreen> createState() => _AdminCreateUserScreenState();
}

class _AdminCreateUserScreenState extends State<AdminCreateUserScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameCtrl = TextEditingController();
  final TextEditingController _lastNameCtrl = TextEditingController();

  late UserRole _selectedRole = UserRole.values.first;
  bool _isActive = true;
  bool _isLoading = false;

  bool _isFetchingAccounts = true;
  String? _selectedUid;
  List<AccountModel> _availableAccounts = [];

  @override
  void initState() {
    super.initState();
    _fetchUnassignedAccounts();
  }

  Future<void> _fetchUnassignedAccounts() async {
    final accountProvider = sl<AccountProvider>();
    await accountProvider.fetchAllAccounts();
    
    List<String> assignedUids = widget.userProvider.value.maybeWhen(
      dataList: (users) => users.map((u) => u.uid).toList(),
      orElse: () => [],
    );

    if (assignedUids.isEmpty) {
      await widget.userProvider.fetchAllUsers();
      assignedUids = widget.userProvider.value.maybeWhen(
        dataList: (users) => users.map((u) => u.uid).toList(),
        orElse: () => [],
      );
    }

    final accountsState = accountProvider.value;
    accountsState.maybeWhen(
      dataList: (accounts) {
        final assignedUidsSet = assignedUids.toSet();
        _availableAccounts = accounts.where((a) => !assignedUidsSet.contains(a.uid)).toList();
      },
      orElse: () {},
    );

    if (mounted) {
      if (_availableAccounts.isNotEmpty) {
        _selectedUid = _availableAccounts.first.uid;
      }
      setState(() => _isFetchingAccounts = false);
    }
  }

  @override
  void dispose() {
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedUid == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an unassigned account')),
      );
      return;
    }

    setState(() => _isLoading = true);

    final newUser = UserModel(
      uid: _selectedUid!,
      firstName: _firstNameCtrl.text.trim(),
      lastName: _lastNameCtrl.text.trim(),
      role: _selectedRole,
      isActive: _isActive,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    try {
      await widget.userProvider.createUser(newUser);
    } catch (e) {
      debugPrint('Error creating user: $e');
    }

    if (!mounted) return;

    setState(() => _isLoading = false);

    widget.userProvider.value.maybeWhen(
      success: (msg) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(msg)));
        widget.userProvider.fetchAllUsers();
        Navigator.pop(context);
      },
      error: (msg) => ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(msg))),
      orElse: () {
        widget.userProvider.fetchAllUsers();
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Create User',
          style: TextStyle(color: colorScheme.onSurface),
        ),
        backgroundColor: colorScheme.surfaceContainer,
      ),
      body: _isLoading || _isFetchingAccounts
          ? const Center(child: CircularProgressIndicator())
          : _availableAccounts.isEmpty
              ? const Center(child: Text('No unassigned accounts available'))
              : SingleChildScrollView(
                  padding: EdgeInsets.all(16.w),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DropdownButtonFormField<String>(
                          initialValue: _selectedUid,
                          decoration: const InputDecoration(labelText: 'Unassigned Account'),
                          items: _availableAccounts.map((account) {
                            return DropdownMenuItem(
                              value: account.uid,
                              child: Text(account.email),
                            );
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) setState(() => _selectedUid = val);
                          },
                          validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                        ),
                        SizedBox(height: 16.h),
                        CustomTextField(
                          controller: _firstNameCtrl,
                          hint: 'First Name',
                          icon: Icons.person_outline,
                          theme: theme,
                          validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                        ),
                        SizedBox(height: 16.h),
                        CustomTextField(
                          controller: _lastNameCtrl,
                          hint: 'Last Name',
                          icon: Icons.person_outline,
                          theme: theme,
                          validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                        ),
                        SizedBox(height: 16.h),
                        DropdownButtonFormField<UserRole>(
                          initialValue: _selectedRole,
                          decoration: const InputDecoration(labelText: 'Role'),
                          items: UserRole.values
                              .map(
                                (role) => DropdownMenuItem(
                                  value: role,
                                  child: Text(role.name.toUpperCase()),
                                ),
                              )
                              .toList(),
                          onChanged: (v) {
                            if (v != null) setState(() => _selectedRole = v);
                          },
                        ),
                        SizedBox(height: 16.h),
                        SwitchListTile(
                          title: const Text('Active Status'),
                          contentPadding: EdgeInsets.zero,
                          value: _isActive,
                          onChanged: (v) => setState(() => _isActive = v),
                        ),
                        SizedBox(height: 32.h),
                        SizedBox(
                          width: double.infinity,
                          height: 48.h,
                          child: ElevatedButton(
                            onPressed: _submit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colorScheme.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.r),
                              ),
                            ),
                            child: Text(
                              'Create User',
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: colorScheme.onPrimary,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }
}
