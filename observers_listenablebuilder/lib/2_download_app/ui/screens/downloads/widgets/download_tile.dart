import 'package:flutter/material.dart';

import 'download_controler.dart';
import '../../../theme/theme.dart';

class DownloadTile extends StatelessWidget {
  const DownloadTile({super.key, required this.controller});

  final DownloadController controller;

  // TODO
  IconData _statusIcon() {
    switch (controller.status) {
      case DownloadStatus.notDownloaded:
        return Icons.download;
      case DownloadStatus.downloading:
        return Icons.downloading;
      case DownloadStatus.downloaded:
        return Icons.folder_outlined;
    }
  }

  String _progressText() {
    final percent = (controller.progress * 100).toStringAsFixed(1);
    final downloaded = (controller.ressource.size * controller.progress)
        .toStringAsFixed(1);
    final total = controller.ressource.size.toStringAsFixed(0);

    return '$percent % completed - $downloaded of $total MB';
  }

  @override
  Widget build(BuildContext context) {
    // TODO
    return ListenableBuilder(
      listenable: controller,
      builder: (context, child) {
        final ressource = controller.ressource;
        final showProgressText =
            controller.status != DownloadStatus.notDownloaded;

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ressource.name,
                        style: AppTextStyles.label.copyWith(
                          color: AppColors.text,
                        ),
                      ),
                      if (showProgressText) ...[
                        const SizedBox(height: 6),
                        Text(
                          _progressText(),
                          style: AppTextStyles.label.copyWith(
                            color: AppColors.textLight,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                IconButton(
                  onPressed: controller.status == DownloadStatus.notDownloaded
                      ? controller.startDownload
                      : null,
                  icon: Icon(_statusIcon(), color: AppColors.iconNormal),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
