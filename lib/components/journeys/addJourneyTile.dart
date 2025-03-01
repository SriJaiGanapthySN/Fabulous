import 'package:fab/screens/journeys/journeyPlayScreen.dart';
import 'package:flutter/material.dart';

class AddJourneyTile extends StatefulWidget {
  const AddJourneyTile({
    super.key,
    required this.tile,
    required this.email,
  });

  final Map<String, dynamic> tile;
  final String email;

  @override
  State<AddJourneyTile> createState() => _AddJourneyTileState();
}

class _AddJourneyTileState extends State<AddJourneyTile> {
  @override
  void initState() {
    super.initState();
  }

  bool infotapped = false;
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Extract data from tile
    final String url =
        widget.tile['topDecoImageUrl'] ?? 'assets/images/default.jpg';
    final String title = widget.tile['title'] ?? 'No Title';
    final String subtitle = widget.tile['subtitle'] ?? 'No Subtitle';
    final String timestamp = widget.tile['timestamp']?.toString() ?? '0';

    return InkWell(
      onTap: () {
        // Navigate to the JourneyPlayScreen with email and tile data
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Journeyplayscreen(
              email: widget.email,
              data: widget.tile, // Pass the tile data if needed
            ),
          ),
        );
      },
      child: Stack(
        children: [
          // Background Image Container
          AnimatedContainer(
            duration: const Duration(milliseconds: 300), // Animation duration
            curve: Curves.easeInOut, // Smooth animation curve
            margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
            padding: EdgeInsets.all(screenWidth * 0.03),
            height: screenHeight * 0.17,
            width: screenWidth * 0.9,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: infotapped
                  ? Colors.blue // Blue when info is tapped
                  : null, // Null to show image
              image: infotapped
                  ? null // No image when info is tapped
                  : DecorationImage(
                      image: NetworkImage(url),
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          //overlay-black
          Container(
            margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
            height: screenHeight * 0.17,
            width: screenWidth * 0.9,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.26), // Semi-transparent black
              borderRadius: BorderRadius.circular(10),
            ),
          ),

          // Overlaying Title, Subtitle, Info Icon, and Percentage Text
          Positioned(
            left: screenWidth * 0.07,
            right: screenWidth * 0.07,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Info Icon at top right
                Container(
                  margin: EdgeInsets.only(left: screenWidth * 0.68),
                  child: IconButton(
                    icon: Icon(
                      Icons.info,
                      color: Colors.white,
                      size: screenWidth * 0.08,
                    ),
                    onPressed: () {
                      setState(() {
                        infotapped = !infotapped;
                      });
                    },
                  ),
                ),

                infotapped
                    ? Container(
                        margin: EdgeInsets.only(top: screenHeight * 0.02),
                        alignment: Alignment.center,
                        child: Text(
                          " jkafjkahkfhauhf afhahfuahufhw iahfuiahufihau PageMaker including versions of Lorem Ipsum.",
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: screenWidth * 0.03,
                            fontWeight: FontWeight.bold,
                            // shadows: const [
                            //   Shadow(
                            //     blurRadius: 5,
                            //     color: Colors.black,
                            //     offset: Offset(2, 2),
                            //   ),
                            // ],
                          ),
                        ),
                      )
                    :
                    // Title Text
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.only(top: screenHeight * 0),
                                child: Text(
                                  title,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: true,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: screenWidth * 0.05,
                                    fontWeight: FontWeight.bold,
                                    // shadows: const [
                                    //   Shadow(
                                    //     blurRadius: 5,
                                    //     color: Colors.black,
                                    //     offset: Offset(2, 2),
                                    //   ),
                                    // ],
                                  ),
                                ),
                              ),
                              // Subtitle Text
                              Container(
                                margin: EdgeInsets.only(
                                  top: screenHeight * 0.001,
                                ),
                                child: Text(
                                  subtitle,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: true,
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: screenWidth * 0.045,
                                    fontWeight: FontWeight.w500,
                                    shadows: const [
                                      Shadow(
                                        blurRadius: 4,
                                        color: Colors.black54,
                                        offset: Offset(1, 1),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
              ],
            ),
          ),
          // Percentage Text
          if (!infotapped)
            Positioned(
              right: 30,
              bottom: screenHeight * 0.014,
              child: Text(
                "$timestamp%", // Dynamically show timestamp as percentage
                style: TextStyle(
                  color: Colors.white,
                  fontSize: screenWidth * 0.056,
                  fontWeight: FontWeight.bold,
                  // shadows: const [
                  //   Shadow(
                  //     blurRadius: 4,
                  //     color: Colors.black54,
                  //     offset: Offset(1, 1),
                  //   ),
                  // ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
