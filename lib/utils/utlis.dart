import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

showdialog() {}

navigation(context, Widget screen) {
  Navigator.of(context).push(MaterialPageRoute(builder: (c) => screen));
}

Widget image(String url) {
  return FadeInImage.assetNetwork(
    placeholder: 'assets/images/placeholder.png',
    image: url,
    fit: BoxFit.cover,
  );
}

Widget cachedImage(String url) {
  return FittedBox(
    fit: BoxFit.cover,
    child: CachedNetworkImage(
      imageUrl: url,
      placeholder: (c, s) => Image.asset(
        'assets/images/placeholder.png',
        fit: BoxFit.cover,
      ),
      fit: BoxFit.cover,
    ),
  );
}

Container error(BuildContext context, Function fun) {
  return Container(
      alignment: Alignment.center,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(
                  Iconsax.refresh,
                  color: Theme.of(context).primaryColor,
                ),
                onPressed: fun,
              ),
              Text(
                "Something went wrong",
                style: Theme.of(context)
                    .textTheme
                    .headline2
                    .copyWith(color: Theme.of(context).dividerColor),
              ),
            ],
          ),
        ),
      ));
}
