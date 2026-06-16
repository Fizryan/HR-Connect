import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_connect/core/constants/enum.dart';
import 'package:hr_connect/features/attendance/providers/attendance_provider.dart';
import 'package:hr_connect/features/shared/widgets/custom_snackbar.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScanQrTabView extends ConsumerStatefulWidget {
  const ScanQrTabView({super.key});

  @override
  ConsumerState<ScanQrTabView> createState() => _ScanQrTabViewState();
}

class _ScanQrTabViewState extends ConsumerState<ScanQrTabView>
    with WidgetsBindingObserver {
  late MobileScannerController _scannerController;
  bool _isProcessing = false;
  bool _isScannerActive = true;

  QrType _selectedType = QrType.checkin;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _scannerController = MobileScannerController(
      detectionSpeed: DetectionSpeed.noDuplicates,
      facing: CameraFacing.back,
      cameraResolution: const Size(1280, 720),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _scannerController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (!_scannerController.value.isInitialized) return;

    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused) {
      _scannerController.stop();
    } else if (state == AppLifecycleState.resumed && _isScannerActive) {
      _scannerController.start();
    }
  }

  Future<void> _onDetect(BarcodeCapture capture) async {
    if (_isProcessing || !_isScannerActive) return;

    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isEmpty) return;

    final String? rawValue = barcodes.first.rawValue;
    if (rawValue == null) return;

    String token;
    if (rawValue.contains('#')) {
      token = rawValue.split('#').last;
    } else {
      token = rawValue;
    }

    setState(() {
      _isProcessing = true;
      _isScannerActive = false;
    });

    _scannerController.stop();

    try {
      final provider = ref.read(attendanceMeProvider.notifier);
      final result = _selectedType == QrType.checkin
          ? await provider.checkInAt(token)
          : await provider.checkOutAt(token);

      if (!mounted) return;

      result.fold(
        (failure) {
          CustomSnackBar.showError(context, message: failure.message);
          setState(() => _isScannerActive = true);
          _scannerController.start();
        },
        (_) {
          CustomSnackBar.showSuccess(
            context,
            message: 'Attendance recorded successfully',
          );
        },
      );
    } catch (e) {
      if (!mounted) return;
      CustomSnackBar.showError(context, message: e.toString());
      setState(() => _isScannerActive = true);
      _scannerController.start();
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SegmentedButton<QrType>(
            segments: const [
              ButtonSegment<QrType>(
                value: QrType.checkin,
                label: Text('Check In'),
                icon: Icon(Icons.login_rounded),
              ),
              ButtonSegment<QrType>(
                value: QrType.checkout,
                label: Text('Check Out'),
                icon: Icon(Icons.logout_rounded),
              ),
            ],
            selected: {_selectedType},
            onSelectionChanged: _isProcessing
                ? null
                : (Set<QrType> newSelection) {
                    setState(() {
                      _selectedType = newSelection.first;
                    });
                  },
            style: SegmentedButton.styleFrom(
              selectedBackgroundColor: colorScheme.primaryContainer,
              selectedForegroundColor: colorScheme.onPrimaryContainer,
            ),
          ),
          SizedBox(height: 24.h),
          Container(
            width: 300.w,
            height: 300.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24.r),
              border: Border.all(
                color: _isProcessing
                    ? colorScheme.outline
                    : colorScheme.primary,
                width: 4.w,
              ),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.primary.withValues(alpha: 0.1),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.r),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  MobileScanner(
                    controller: _scannerController,
                    onDetect: _onDetect,
                    errorBuilder: (context, error) {
                      return Center(
                        child: Icon(
                          Icons.videocam_off_rounded,
                          color: colorScheme.error,
                          size: 50.sp,
                        ),
                      );
                    },
                  ),
                  if (_isProcessing) ...[
                    Container(
                      color: Colors.black.withValues(alpha: 0.7),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(color: colorScheme.primary),
                          SizedBox(height: 16.h),
                          Text(
                            'Verifying...',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          SizedBox(height: 24.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton.filledTonal(
                onPressed: () => _scannerController.toggleTorch(),
                icon: const Icon(Icons.flash_on_rounded),
                style: IconButton.styleFrom(
                  padding: EdgeInsets.all(12.w),
                  backgroundColor: colorScheme.surfaceContainerHighest,
                  foregroundColor: colorScheme.onSurface,
                ),
              ),
              SizedBox(width: 16.w),
              IconButton.filledTonal(
                onPressed: () => _scannerController.switchCamera(),
                icon: const Icon(Icons.flip_camera_android_outlined),
                style: IconButton.styleFrom(
                  padding: EdgeInsets.all(12.w),
                  backgroundColor: colorScheme.surfaceContainerHighest,
                  foregroundColor: colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
