import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:hr_connect/features/attendance/providers/attendance_provider.dart';
import 'package:hr_connect/features/widgets/shared/qr_scanner_overlay_shape.dart';

class AttendanceScanTab extends ConsumerStatefulWidget {
  const AttendanceScanTab({super.key});

  @override
  ConsumerState<AttendanceScanTab> createState() => _AttendanceScanTabState();
}

class _AttendanceScanTabState extends ConsumerState<AttendanceScanTab> {
  final MobileScannerController _scannerController = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
    facing: CameraFacing.back,
  );

  bool _isProcessing = false;
  bool _isTorchOn = false;

  @override
  void dispose() {
    _scannerController.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) async {
    if (_isProcessing) return;

    final List<Barcode> barcodes = capture.barcodes;
    for (final barcode in barcodes) {
      if (barcode.rawValue != null) {
        setState(() => _isProcessing = true);

        final String scannedCode = barcode.rawValue!;

        HapticFeedback.lightImpact();

        try {
          await ref.read(attendanceNotifierProvider.notifier).checkIn(scannedCode);
        } catch (e) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed: $e'),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
          if (mounted) setState(() => _isProcessing = false);
          return;
        }

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Scanned Code: $scannedCode'),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        );

        await Future.delayed(const Duration(seconds: 2));

        if (mounted) setState(() => _isProcessing = false);
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Stack(
      children: [
        MobileScanner(
          controller: _scannerController,
          onDetect: _onDetect,
          errorBuilder: (context, error) {
            return Center(
              child: Text(
                'Camera error or permission denied.',
                style: TextStyle(color: colorScheme.error),
              ),
            );
          },
        ),
        Container(
          decoration: ShapeDecoration(
            shape: QrScannerOverlayShape(
              borderColor: colorScheme.primary,
              borderRadius: 20.r,
              borderLength: 40.r,
              borderWidth: 8.r,
              cutOutSize: 250.w,
            ),
          ),
        ),

        Positioned(
          top: 60.h,
          left: 0,
          right: 0,
          child: Center(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainer.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Text(
                'Point camera at the QR Code',
                style: TextStyle(color: colorScheme.onSurface, fontSize: 14.sp),
              ),
            ),
          ),
        ),

        if (_isProcessing)
          Center(
            child: Container(
              padding: EdgeInsets.all(20.r),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainer,
                shape: BoxShape.circle,
              ),
              child: const CircularProgressIndicator(),
            ),
          ),

        Positioned(
          bottom: 40.h,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () async {
                  await _scannerController.toggleTorch();
                  setState(() {
                    _isTorchOn = !_isTorchOn;
                  });
                },
                style: IconButton.styleFrom(
                  backgroundColor: Colors.black.withValues(alpha: 0.5),
                  padding: EdgeInsets.all(16.r),
                ),
                icon: Icon(
                  _isTorchOn ? Icons.flash_on_rounded : Icons.flash_off_rounded,
                  color: _isTorchOn ? Colors.yellow : Colors.white,
                  size: 28.sp,
                ),
              ),
              SizedBox(width: 40.w),
              IconButton(
                onPressed: _scannerController.switchCamera,
                style: IconButton.styleFrom(
                  backgroundColor: Colors.black.withValues(alpha: 0.5),
                  padding: EdgeInsets.all(16.r),
                ),
                icon: Icon(
                  Icons.flip_camera_ios_rounded,
                  color: Colors.white,
                  size: 28.sp,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
