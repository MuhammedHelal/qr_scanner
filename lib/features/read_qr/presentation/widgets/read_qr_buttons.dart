import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_reader/core/utils/colors.dart';
import 'package:qr_reader/features/read_qr/manager/read_qr_cubit/read_qr_cubit.dart';
import 'package:qr_reader/features/read_qr/presentation/widgets/flash_button.dart';

class ReadQrButtons extends StatelessWidget {
  const ReadQrButtons({super.key});
  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<ReadQrCubit>(context);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: const BoxDecoration(
        color: AppColors.blackGreyish,
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            onPressed: () async {
              cubit.scanBycamera();
              await cubit.controller?.resumeCamera();
            },
            icon: const Icon(Icons.camera_alt),
          ),
          IconButton(
            onPressed: () async {
              await cubit.scanImageFromGallery();
            },
            icon: const Icon(
              Icons.image_outlined,
            ),
          ),
          BlocBuilder<ReadQrCubit, ReadQrState>(
            builder: (context, state) {
              if (state is ReadQrSuccess || state is ReadQrFail) {
                return const IconButton(
                  onPressed: null,
                  icon: Icon(
                    Icons.flash_off_outlined,
                  ),
                );
              }
              return const FlashButton();
            },
          ),
        ],
      ),
    );
  }
}
