import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_connect/core/const/enums.dart';
import 'package:hr_connect/features/user_management/data/model/user_model.dart';
import 'package:hr_connect/features/user_management/providers/user_provider.dart';
import 'package:hr_connect/features/user_management/providers/user_state.dart';
import 'package:hr_connect/features/widgets/presentation/etc/edit_profile_screen.dart';

class UserManagementScreen extends ConsumerStatefulWidget {
  const UserManagementScreen({super.key});

  @override
  ConsumerState<UserManagementScreen> createState() =>
      _UserManagementScreenState();
}

class _UserManagementScreenState extends ConsumerState<UserManagementScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  UserRole? _selectedRole;
  bool _isSearchActive = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(userNotifierProvider.notifier).fetchUsers();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _capitalize(String s) =>
      s.isNotEmpty ? '${s[0].toUpperCase()}${s.substring(1)}' : '';

  List<UserModel> _getFilteredUsers(List<UserModel> users) {
    return users.where((user) {
      final matchesSearch =
          user.fullName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          user.role.name.toLowerCase().contains(_searchQuery.toLowerCase());

      final matchesRole = _selectedRole == null || user.role == _selectedRole;

      return matchesSearch && matchesRole;
    }).toList();
  }

  void _toggleSearch() {
    setState(() {
      _isSearchActive = !_isSearchActive;
      if (!_isSearchActive) {
        _searchController.clear();
        _searchQuery = '';
        _selectedRole = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final userState = ref.watch(userNotifierProvider);

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: colorScheme.surface,
        title: Text(
          'User Management',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isSearchActive ? Icons.close_rounded : Icons.search_rounded,
              color: colorScheme.onSurfaceVariant,
            ),
            onPressed: _toggleSearch,
            tooltip: 'Search & Filter',
          ),
          SizedBox(width: 8.w),
        ],
      ),
      body: userState.maybeMap(
        loading: (_) => const Center(child: CircularProgressIndicator()),
        error: (state) => _buildErrorState(state.message, colorScheme),
        loaded: (state) => _buildUserContent(state.users, colorScheme),
        orElse: () => const SizedBox.shrink(),
      ),
    );
  }

  Widget _buildErrorState(String message, ColorScheme colorScheme) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 64.sp,
              color: colorScheme.error,
            ),
            SizedBox(height: 16.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 24.h),
            FilledButton.icon(
              onPressed: () =>
                  ref.read(userNotifierProvider.notifier).fetchUsers(),
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserContent(List<UserModel> users, ColorScheme colorScheme) {
    final filteredUsers = _getFilteredUsers(users);
    return Column(
      children: [
        if (_isSearchActive)
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                child: SearchBar(
                  controller: _searchController,
                  hintText: 'Search name or role...',
                  hintStyle: WidgetStateProperty.all(
                    TextStyle(
                      color: colorScheme.onSurfaceVariant.withValues(
                        alpha: 0.7,
                      ),
                    ),
                  ),
                  elevation: WidgetStateProperty.all(0),
                  backgroundColor: WidgetStateProperty.all(
                    colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                  ),
                  leading: Icon(
                    Icons.search_rounded,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  trailing: _searchQuery.isNotEmpty
                      ? [
                          IconButton(
                            icon: const Icon(Icons.clear_rounded),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _searchQuery = '');
                            },
                          ),
                        ]
                      : null,
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),
              ),
              SizedBox(
                height: 40.h,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 8.w),
                      child: ChoiceChip(
                        label: const Text('All Roles'),
                        selected: _selectedRole == null,
                        showCheckmark: false,
                        selectedColor: colorScheme.primaryContainer,
                        onSelected: (selected) {
                          if (selected) setState(() => _selectedRole = null);
                        },
                      ),
                    ),
                    ...UserRole.values.where((r) => r != UserRole.unknown).map((
                      role,
                    ) {
                      return Padding(
                        padding: EdgeInsets.only(right: 8.w),
                        child: ChoiceChip(
                          label: Text(_capitalize(role.name)),
                          selected: _selectedRole == role,
                          showCheckmark: false,
                          selectedColor: colorScheme.primaryContainer,
                          onSelected: (selected) {
                            setState(
                              () => _selectedRole = selected ? role : null,
                            );
                          },
                        ),
                      );
                    }),
                  ],
                ),
              ),
              SizedBox(height: 8.h),
            ],
          ),
        Expanded(
          child: filteredUsers.isEmpty
              ? Center(
                  child: Text(
                    'No users found.',
                    style: TextStyle(
                      color: colorScheme.onSurfaceVariant,
                      fontSize: 15.sp,
                    ),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: () async =>
                      ref.read(userNotifierProvider.notifier).fetchUsers(),
                  backgroundColor: colorScheme.surfaceContainerHighest,
                  color: colorScheme.primary,
                  child: ListView.separated(
                    physics: const AlwaysScrollableScrollPhysics(
                      parent: BouncingScrollPhysics(),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    itemCount: filteredUsers.length,
                    separatorBuilder: (context, index) => Divider(
                      height: 1,
                      indent: 76.w,
                      endIndent: 20.w,
                      color: colorScheme.outlineVariant.withValues(alpha: 0.3),
                    ),
                    itemBuilder: (context, index) {
                      final user = filteredUsers[index];
                      return _buildCompactUserTile(user, colorScheme);
                    },
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildCompactUserTile(UserModel user, ColorScheme colorScheme) {
    return Material(
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EditProfileScreen(user: user),
            ),
          );
        },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
          child: Row(
            children: [
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CachedNetworkImage(
                    imageUrl: user.avatarUrl ?? '',
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
                      child: Icon(
                        Icons.person,
                        size: 20.sp,
                        color: colorScheme.primary,
                      ),
                    ),
                  ),
                  Container(
                    width: 12.w,
                    height: 12.w,
                    decoration: BoxDecoration(
                      color: user.isActive ? Colors.green : colorScheme.error,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: colorScheme.surface,
                        width: 2.w,
                      ),
                    ),
                  ),
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
                            user.fullName,
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w600,
                              color: colorScheme.onSurface,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
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
                            _capitalize(user.role.name),
                            style: TextStyle(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onPrimaryContainer,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      user.email,
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
              PopupMenuButton<String>(
                icon: Icon(
                  Icons.more_vert_rounded,
                  color: colorScheme.onSurfaceVariant,
                  size: 22.sp,
                ),
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                onSelected: (value) {
                  if (value == 'deactivate') {
                    _showDeactivateDialog(context, user, colorScheme);
                  }
                  if (value == 'delete') {
                    _showDeleteDialog(context, user, colorScheme);
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'deactivate',
                    child: Row(
                      children: [
                        Icon(
                          Icons.block_rounded,
                          color: colorScheme.error,
                          size: 20.sp,
                        ),
                        SizedBox(width: 12.w),
                        Text(
                          user.isActive ? 'Deactivate' : 'Activate',
                          style: TextStyle(
                            color: colorScheme.error,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(
                          Icons.delete_rounded,
                          color: colorScheme.error,
                          size: 20.sp,
                        ),
                        SizedBox(width: 12.w),
                        Text(
                          'Delete',
                          style: TextStyle(
                            color: colorScheme.error,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeactivateDialog(
    BuildContext context,
    UserModel targetUser,
    ColorScheme colorScheme,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: colorScheme.surfaceContainerLowest,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          title: Text(
            targetUser.isActive ? 'Deactivate User' : 'Activate User',
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
          ),
          content: Text(
            'Are you sure you want to change the status for ${targetUser.fullName}?',
            style: TextStyle(
              fontSize: 14.sp,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(color: colorScheme.onSurfaceVariant),
              ),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: colorScheme.error,
                foregroundColor: colorScheme.onError,
              ),
              onPressed: () {
                Navigator.pop(context);
                ref.read(userNotifierProvider.notifier).deactivateUser(
                  targetUser.id,
                  {'isActive': !targetUser.isActive},
                );
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteDialog(
    BuildContext context,
    UserModel targetUser,
    ColorScheme colorScheme,
  ) {
    final TextEditingController confirmController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            final isNameMatched =
                confirmController.text.trim() == targetUser.fullName;
            return AlertDialog(
              backgroundColor: colorScheme.surfaceContainerLowest,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.r),
              ),
              title: Text(
                'Delete User',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.error,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'This action cannot be undone. This will permanently delete the user account and all associated data.',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'Please type "${targetUser.fullName}" to confirm:',
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  TextField(
                    controller: confirmController,
                    onChanged: (value) {
                      setState(() {});
                    },
                    decoration: InputDecoration(
                      hintText: targetUser.fullName,
                      hintStyle: TextStyle(
                        color: colorScheme.onSurfaceVariant.withValues(
                          alpha: 0.5,
                        ),
                      ),
                      filled: true,
                      fillColor: colorScheme.surfaceContainerHighest,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 12.h,
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: colorScheme.onSurfaceVariant),
                  ),
                ),
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: isNameMatched
                        ? colorScheme.error
                        : colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
                    foregroundColor: colorScheme.onError,
                  ),
                  onPressed: isNameMatched
                      ? () {
                          Navigator.pop(context);
                          ref
                              .read(userNotifierProvider.notifier)
                              .deleteUser(targetUser.id);
                        }
                      : null,
                  child: const Text('Delete'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
