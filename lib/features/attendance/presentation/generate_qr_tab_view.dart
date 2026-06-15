import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_connect/features/attendance/providers/attendance_provider.dart';
import 'package:hr_connect/features/shared/widgets/custom_button.dart';
import 'package:qr_flutter/qr_flutter.dart';

class GenerateQrTabView extends ConsumerWidget {
  const GenerateQrTabView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    final qrState = ref.watch(attendanceQrNotifier);
    final qrData = qrState.value;
    final isGenerating = qrState.isLoading;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 250.w,
            height: 250.w,
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.white70,
              borderRadius: BorderRadius.circular(24.r),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.shadow.withValues(alpha: 0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: _buildQrContent(qrState, qrData, colorScheme),
          ),
          SizedBox(height: 12.h),
          Text(
            'Generate a secure QR code for employees to scan. This code will expire automatically.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14.sp,
              color: colorScheme.onSurfaceVariant,
              height: 1.5,
            ),
          ),

          SizedBox(height: 40.h),

          CustomButton(
            text: qrData == null ? 'Generate QR Code' : 'Regenerate QR',
            isLoading: isGenerating,
            onPressed: () {
              ref.read(attendanceQrNotifier.notifier).generateQrCode();
            },
            colorScheme: colorScheme,
          ),
        ],
      ),
    );
  }

  Widget _buildQrContent(
    AsyncValue<String?> state,
    String? data,
    ColorScheme colorScheme,
  ) {
    if (state.isLoading) {
      return Center(
        child: CircularProgressIndicator(color: colorScheme.primary),
      );
    }

    if (state.hasError) {
      return Center(
        child: Text(
          'Failed to load.\n${state.error}',
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    if (data == null || data.isEmpty) {
      return Center(
        child: Text(
          'No QR Generated',
          style: TextStyle(
            color: Colors.grey.shade400,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    return Center(
      child: QrImageView(
        data: data,
        version: QrVersions.auto,
        size: 200.w,
        backgroundColor: Colors.white,
        errorCorrectionLevel: QrErrorCorrectLevel.Q,
      ),
    );
  }
}
