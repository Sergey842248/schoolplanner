import 'package:design_utils/design_utils.dart';
import 'package:flutter/material.dart';
import 'package:schulplaner_website/src/logic/website_utils.dart';
import 'package:schulplaner_website/src/widgets/assets_button.dart';
import 'package:schulplaner_website/src/widgets/svg_button.dart';

const kPlayStoreURL =
    'https://play.google.com/store/apps/details?id=com.xla.school&hl=de';
const kAppstoreURL =
    'https://apps.apple.com/de/app/schulplaner-pro/id1425606459';
const kWebAppURL = 'https://web.schulplaner.pro';

class DownloadButtons extends StatelessWidget {
  const DownloadButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const ResponsiveList(
      breakPoint: 430,
      children: [
        _DownloadAndroid(),
        SizedBox(
          width: 4,
          height: 8,
        ),
        _DownloadiOS(),
        SizedBox(
          width: 4,
          height: 10,
        ),
        _OpenWebApp(),
      ],
    );
  }
}

class _DownloadAndroid extends StatelessWidget {
  const _DownloadAndroid();
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60.0,
      width: 125.0,
      child: AssetButton(
        onTap: () {
          openUrl(
            urlString: kPlayStoreURL,
            openInNewWindow: true,
          );
        },
        assetPath: 'assets/badges/google-play-badge.png',
        height: 60.0,
      ),
    );
  }
}

class _DownloadiOS extends StatelessWidget {
  const _DownloadiOS();
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48.0,
      width: 125.0,
      child: SvgButton(
        onTap: () {
          openUrl(
            urlString: kAppstoreURL,
            openInNewWindow: true,
          );
        },
        assetPath:
            'assets/badges/Download_on_the_App_Store_Badge_DE_RGB_wht.svg',
        height: 48.0,
      ),
    );
  }
}

class _OpenWebApp extends StatelessWidget {
  const _OpenWebApp();
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48.0,
      width: 125.0,
      child: AssetButton(
        onTap: () {
          openUrl(
            urlString: kWebAppURL,
            openInNewWindow: true,
          );
        },
        assetPath: 'assets/badges/open-web-app.png',
        height: 48.0,
      ),
    );
  }
}
