import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

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

        // await ref.read(attendanceNotifierProvider.notifier).submitAttendance(scannedCode);

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

class QrScannerOverlayShape extends ShapeBorder {
  final Color borderColor;
  final double borderWidth;
  final double overlayOpacity;
  final double borderRadius;
  final double borderLength;
  final double cutOutSize;

  const QrScannerOverlayShape({
    this.borderColor = Colors.blue,
    this.borderWidth = 3.0,
    this.overlayOpacity = 0.50,
    this.borderRadius = 0,
    this.borderLength = 40,
    this.cutOutSize = 250,
  });

  @override
  EdgeInsetsGeometry get dimensions => const EdgeInsets.all(10);

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return Path()
      ..fillType = PathFillType.evenOdd
      ..addPath(getOuterPath(rect), Offset.zero);
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    Path getLeftTopPath(Rect rect) {
      return Path()
        ..moveTo(rect.left, rect.bottom)
        ..lineTo(rect.left, rect.top)
        ..lineTo(rect.right, rect.top);
    }

    return getLeftTopPath(rect)
      ..lineTo(rect.right, rect.bottom)
      ..lineTo(rect.left, rect.bottom)
      ..lineTo(rect.left, rect.top);
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    final width = rect.width;
    final height = rect.height;
    final mCutOutSize = cutOutSize;

    final backgroundPaint = Paint()
      ..color = Colors.black.withValues(alpha: overlayOpacity)
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;

    final boxPaint = Paint()
      ..color = Colors.black.withValues(alpha: overlayOpacity)
      ..style = PaintingStyle.fill
      ..blendMode = BlendMode.dstOut;

    final cutOutRect = Rect.fromLTWH(
      rect.left + width / 2 - mCutOutSize / 2,
      rect.top + height / 2 - mCutOutSize / 2,
      mCutOutSize,
      mCutOutSize,
    );

    canvas.saveLayer(rect, backgroundPaint);
    canvas.drawRect(rect, backgroundPaint);
    canvas.drawRRect(
      RRect.fromRectAndRadius(cutOutRect, Radius.circular(borderRadius)),
      boxPaint,
    );
    canvas.restore();

    final path = Path();

    path.moveTo(cutOutRect.left, cutOutRect.top + borderLength);
    path.quadraticBezierTo(
      cutOutRect.left,
      cutOutRect.top,
      cutOutRect.left + borderRadius,
      cutOutRect.top,
    );
    path.lineTo(cutOutRect.left + borderLength, cutOutRect.top);

    path.moveTo(cutOutRect.right - borderLength, cutOutRect.top);
    path.quadraticBezierTo(
      cutOutRect.right,
      cutOutRect.top,
      cutOutRect.right,
      cutOutRect.top + borderRadius,
    );
    path.lineTo(cutOutRect.right, cutOutRect.top + borderLength);

    path.moveTo(cutOutRect.right, cutOutRect.bottom - borderLength);
    path.quadraticBezierTo(
      cutOutRect.right,
      cutOutRect.bottom,
      cutOutRect.right - borderRadius,
      cutOutRect.bottom,
    );
    path.lineTo(cutOutRect.right - borderLength, cutOutRect.bottom);

    path.moveTo(cutOutRect.left + borderLength, cutOutRect.bottom);
    path.quadraticBezierTo(
      cutOutRect.left,
      cutOutRect.bottom,
      cutOutRect.left,
      cutOutRect.bottom - borderRadius,
    );
    path.lineTo(cutOutRect.left, cutOutRect.bottom - borderLength);

    canvas.drawPath(path, borderPaint);
  }

  @override
  ShapeBorder scale(double t) => this;
}
