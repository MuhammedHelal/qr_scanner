import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_reader/core/utils/colors.dart';
import 'package:qr_reader/core/utils/text_styles.dart';
import 'package:qr_reader/core/widgets/show_qr_view_with_cubit.dart';
import 'package:qr_reader/features/scan_qr/manager/scan_qr_cubit/scan_qr_cubit.dart';
import 'package:qr_reader/features/scan_qr/presentation/widgets/scan_qr_buttons.dart';

class ScanQrView extends StatelessWidget {
  const ScanQrView({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<ScanQrCubit>(context);
    return SafeArea(
      child: Stack(
        alignment: Alignment.center,
        fit: StackFit.expand,
        clipBehavior: Clip.none,
        children: [
          BlocBuilder<ScanQrCubit, ScanQrState>(
            builder: (context, state) {
              if (state is ReadQrSuccess) {
                return ShowQrViewWithCubit(
                  key: GlobalKey(),
                  state.data!,
                  isScanned: true,
                );
              } else if (state is ReadQrFail) {
                return Center(
                  child: Text(
                    state.message,
                    style: AppTextStyles.primary26W500,
                  ),
                );
              }
              return Focus(
                autofocus: true,
                onFocusChange: (value) async {
                  if (!value) {
                    await cubit.controller?.pauseCamera();
                  } else {
                    await cubit.controller?.resumeCamera();
                  }
                },
                child: QRView(
                  overlay: QrScannerOverlayShape(
                    borderColor: AppColors.primary,
                    borderWidth: 10,
                    borderRadius: 10,
                    borderLength: 30,
                    cutOutSize: MediaQuery.sizeOf(context).width * 0.8,
                  ),
                  cameraFacing: CameraFacing.back,
                  key: cubit.qrKey,
                  onQRViewCreated: cubit.onQRViewCreated,
                ),
              );
            },
          ),
          const Positioned(
            top: 0,
            right: 0,
            left: 0,
            child: ScanQrButtons(),
          )
        ],
      ),
    );
  }
}
