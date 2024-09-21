import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qr_reader/core/functions/format_datetime.dart';
import 'package:qr_reader/core/functions/show_toast.dart';
import 'package:qr_reader/core/services/locator.dart';
import 'package:qr_reader/core/utils/colors.dart';
import 'package:qr_reader/features/history/domain/history_item_entity.dart';
import 'package:qr_reader/features/history/presentation/manager/history_cubit/history_cubit.dart';

class HistoryListViewItem extends StatelessWidget {
  const HistoryListViewItem({
    super.key,
    required this.item,
  });
  final HistoryItemEntity item;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        /*   navigateWithoutNavBar(
          context,
          ViewHistoryQrItem(item: item),
        );*/
      },
      onLongPress: () async {
        await Clipboard.setData(ClipboardData(text: item.qrData ?? item.data));
        showToast(message: 'Copied', color: Colors.green);
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.all(12),
        padding: const EdgeInsets.all(12),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(16),
          ),
          color: AppColors.blackGreyish,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppColors.primary,
                  width: 2.5,
                  strokeAlign: BorderSide.strokeAlignOutside,
                ),
              ),
              child: QrImageView(
                backgroundColor: Colors.white,
                size: 60,
                data: item.data,
              ),
            ),
            const Gap(12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    item.qrData ?? item.data,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Gap(8),
                  Text(item.type),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () async {
                    await confirmDelete(context);
                  },
                  icon: const Icon(Icons.delete_forever, size: 35),
                ),
                Text(formatDateTimeTime(item.date)),
                Text(formatDateTimeDate(item.date)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<dynamic> confirmDelete(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          alignment: Alignment.center,
          title: const Text(
            'Delete?',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.primary),
          ),
          content: const Text(
            'Are you sure?',
            textAlign: TextAlign.center,
          ),
          actions: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
                const Gap(12),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  onPressed: () async {
                    Navigator.pop(context);

                    await locator<HistoryCubit>().deleteHistory(item);
                  },
                  child: const Text('Delete'),
                ),
              ],
            )
          ],
        );
      },
    );
  }
}
