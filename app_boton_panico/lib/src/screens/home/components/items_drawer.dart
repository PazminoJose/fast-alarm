import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class DrawerItems {
  static Widget account(user) => Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 7),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Icon(
                  Icons.email_outlined,
                  color: Colors.white,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(user.email),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 7),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Icon(
                  Icons.phone_outlined,
                  color: Colors.white,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(user.person.phone),
              ],
            ),
          ),
        ],
      );

  Widget accountPicture(size) => ClipOval(
        child: SizedBox(
          child: CachedNetworkImage(
            width: size.width * 0.9,
            height: size.width * 0.07,
            fit: BoxFit.cover,
            imageUrl:
                "https://www.afondochile.cl/site/wp-content/uploads/2018/06/jose-vaisman-e1529942487664.jpg",
            errorWidget: (context, url, error) => Icon(Icons.error_outline),
            placeholder: (context, url) => CircularProgressIndicator(),
          ),
        ),
      );
}
