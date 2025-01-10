import 'package:flutter/material.dart';

class CustomButtonDiscover extends StatelessWidget {
  const CustomButtonDiscover(
      {super.key, required this.routineName, required this.URL});
  final String routineName;
  final String URL;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      width: 200,
      decoration: BoxDecoration(
        color: Colors.transparent,
      ),
      child: Card(
        child: Stack(
          children: [
            Positioned.fill(
              child: Align(
                alignment: Alignment.centerRight,
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                      child: Image.asset(
                        URL,
                        fit: BoxFit.cover,
                        height: 90,
                        width: 100,
                      ),
                    ),
                    Container(
                      height: 90,
                      width: 100,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.4),
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          routineName.replaceAll(' ', '\n'),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
