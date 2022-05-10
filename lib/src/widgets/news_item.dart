import 'dart:developer';

import 'package:clipboard/clipboard.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as material;
import 'package:news_app/src/models/article.dart';
import 'package:share_plus/share_plus.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsItem extends StatelessWidget {
  final Article article;
  const NewsItem({Key? key, required this.article}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Typography typography = FluentTheme.of(context).typography;

    return HoverButton(
      onPressed: () async {
        if (!await launchUrl(Uri.parse(article.uri))) {
          log('Could not launch url ${article.uri}');
        }
      },
      cursor: SystemMouseCursors.click,
      builder: (ctx, states) {
        return material.Card(
          child: Column(
            children: [
              Container(
                height: 150,
                width: double.infinity,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                  child: FadeInImage.memoryNetwork(
                    placeholder: kTransparentImage,
                    imageErrorBuilder: (ctx, error, stackTrace) {
                      return const Icon(
                        material.Icons.error,
                        color: Colors.grey,
                      );
                    },
                    image:
                        article.urlToImage ?? 'https://via.placeholder.com/180',
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
                  child: Text(
                    article.title,
                    style: typography.bodyLarge?.apply(
                      fontSizeFactor: 0.8,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        article.captionText(),
                        style: typography.caption?.apply(fontSizeFactor: 1),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    DropDownButton(
                      title: const Icon(FluentIcons.share),
                      items: [
                        MenuFlyoutItem(
                          text: const Text('Open in browser'),
                          leading: const Icon(FluentIcons.edge_logo),
                          onPressed: () async {
                            if (!await launchUrl(Uri.parse(article.uri))) {
                              log('Could not launch url ${article.uri}');
                            }
                          },
                        ),
                        MenuFlyoutItem(
                          text: const Text('Send'),
                          leading: const Icon(FluentIcons.send),
                          onPressed: () async {
                            Share.share(
                                'Check out this article ${article.uri}');
                          },
                        ),
                        MenuFlyoutItem(
                          text: const Text('Copy URL'),
                          leading: const Icon(FluentIcons.copy),
                          onPressed: () async {
                            FlutterClipboard.copy(article.uri).then((value) =>
                                showCopiedSnackbar(context, article.uri));
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void showCopiedSnackbar(BuildContext context, String copiedText) {
    showSnackbar(
      context,
      Snackbar(
        content: RichText(
          text: TextSpan(
            text: 'Copied ',
            style: const TextStyle(color: Colors.white),
            children: [
              TextSpan(
                text: copiedText,
                style: TextStyle(
                  color: Colors.orange,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        extended: true,
      ),
    );
  }
}
