import 'package:flutter/material.dart';
import 'package:qr_reader/core/functions/launch_url.dart';
import 'package:qr_reader/features/generate_qr/presentation/widgets/action_button_impl.dart';

class SmsSendSmsButton extends StatelessWidget {
  const SmsSendSmsButton({
    super.key,
    required this.data,
  });

  final String data;

  @override
  Widget build(BuildContext context) {
    return ActionButtonImpl(
      icon: const Icon(Icons.send, size: 30),
      title: 'Send SMS',
      onPressed: () async {
        await myLaunchURL(data);
      },
    );
  }
}
