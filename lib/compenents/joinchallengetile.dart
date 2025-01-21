import 'package:flutter/material.dart';

class Joinchallengetile extends StatelessWidget {
  const Joinchallengetile({super.key, required this.url, required this.title,this.onTap});

  final String url;
  final String title;
  final VoidCallback? onTap;
  

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        InkWell(
          onTap: onTap,
          child: Container(
            margin: EdgeInsets.only(left: 10),
            height: 110,
            width: 230,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(url),
                  fit: BoxFit.cover,
                  alignment: Alignment.center),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        Container(
          alignment: Alignment.topLeft,
          margin: EdgeInsets.only(left: 30, top: 20),
          width: 200,
          child: Text(
            title,
            style: TextStyle(
              color: const Color.fromARGB(255, 8, 8, 8),
              fontSize: 29,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            softWrap: false,
          ),
        ),
      ],
    );
  }
}
