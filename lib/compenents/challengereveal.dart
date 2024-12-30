import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Challengereveal extends StatelessWidget {
  const Challengereveal(
      {super.key, required this.url, required this.appbartext});

  final String url;
  final String appbartext;
  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Stack(
        children: [
          Container(
            color: Colors.white.withOpacity(0.8),
            height: 500,
          ),
          Container(
            color: Colors.white.withOpacity(0.7),
            height: 500,
          ),
          Column(
            children: [
              AppBar(
                backgroundColor: Colors.transparent,
                title: ClipPath(
                  clipper: DiagonalClipper(),
                  child: Container(
                    margin: EdgeInsets.only(left: 20),
                    width: 250,
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 19, 79, 21)),
                    child: Container(
                      padding: EdgeInsets.all(5),
                      alignment: Alignment.center,
                      child: Text(
                        appbartext,
                        style: TextStyle(
                          fontSize: 25,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 35, right: 30),
                child: Text("7-Day Meditation Challenge",
                    style: TextStyle(
                      fontSize: 39,
                      color: const Color.fromARGB(255, 99, 97, 97),
                      fontWeight: FontWeight.bold,
                    )),
              ),
              Container(
                margin: EdgeInsets.only(left: 35, right: 30),
                child: Text(
                    "A regular mefi sjkkdbfkjsa jsdabhfj kjashfikah kjshfikajh asdhfiuah aushfiua iudshgfiauh",
                    style: TextStyle(
                      fontSize: 20,
                      color: const Color.fromARGB(255, 129, 127, 127),
                      fontWeight: FontWeight.bold,
                    )),
              ),
              SizedBox(
                height: 20,
              ),
              Stack(
                children: [
                  Image.asset(
                    url,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    color: Colors.white.withOpacity(0.8),
                    height: 200,
                  ),
                ],
              ),
              Container(
                height: 367,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 251, 252, 251),
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 30),
                          child: Icon(
                            FontAwesomeIcons.flag,
                            size: 25,
                            color: const Color.fromARGB(255, 26, 114, 10),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Goal",
                          style: TextStyle(
                            color: Color.fromARGB(255, 26, 114, 10),
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 35, right: 30),
                      child: Text(
                          "A regular mefi sjkkdbfkjsa jsdabhfj kjashfikah kjshfikajh asdhfiuah aushfiua iudshgfiauh shkbfdjkhs jhasbdfjhas sjhavdjh",
                          style: TextStyle(
                            fontSize: 20,
                            color: const Color.fromARGB(255, 129, 127, 127),
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 30),
                          child: ElevatedButton.icon(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(255, 213, 230, 210),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              icon: Icon(
                                FontAwesomeIcons.circleInfo,
                                color: Color.fromARGB(255, 26, 114, 10),
                                size: 30,
                              ),
                              label: Text(
                                "WHY AM I DOING THIS?",
                                style: TextStyle(
                                  color: Color.fromARGB(255, 26, 114, 10),
                                  fontSize: 20,
                                ),
                              )),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 30),
                          child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Color.fromARGB(255, 26, 114, 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text(
                                "BEGIN THE CHALLENGE!",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              )),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class DiagonalClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(size.width - 10, 0); // Top-right diagonal cut
    path.lineTo(size.width, size.height); // Bottom-right corner
    path.lineTo(0, size.height); // Bottom-left corner
    path.close(); // Complete the path
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
