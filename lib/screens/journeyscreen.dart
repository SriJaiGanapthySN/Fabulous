import 'package:fab/models/skill.dart';
import 'package:fab/models/skillTrack.dart';
import 'package:fab/screens/journeysecondlevel.dart';
import 'package:fab/services/journey_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Journeyscreen extends StatefulWidget {
  final String email;
  const Journeyscreen({super.key, required this.email});

  @override
  State<Journeyscreen> createState() => _JourneyscreenState();
}

class _JourneyscreenState extends State<Journeyscreen> with SingleTickerProviderStateMixin{
  final JourneyService _journeyService = JourneyService();
  skillTrack? skilltrack;
  bool _isLoading = true;
  String skillTrackID = '';
  List<Skill> skills = [];

  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1500),
  )..repeat();
  late final Animation<double> _scaleAnimation =
      Tween<double>(begin: 0.6, end: 1.2).animate(_controller);
  late final Animation<double> _fadeAnimation =
      Tween<double>(begin: 1, end: 0.2).animate(_controller);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  @override
  void initState() {
    super.initState();
    print("object_________________");
    _fetchJourney();
  }

  Future<void> fetchSkill() async {
    try {
      final result = await _journeyService.getSkills(skillTrackID, widget.email);
      setState(() {
        skills = result;
      });
      // _addskillLevel();
    } catch (e) {
      print('Error adding skill: $e');
    }
  }

  Future<void> _fetchJourney() async {
    try {
      final journey = await _journeyService.fetchUnreleasedJourney(widget.email);
      if (journey != null) {
        setState(() {
          skilltrack = journey;
          _isLoading = false;
          skillTrackID = skilltrack!.objectId;
        });
        fetchSkill();
      } else {
        print('No unreleased journey found.');
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching journey: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Color colorFromString(String colorString) {
  // Remove the '#' if it's there and parse the hex color code
  String hexColor = colorString.replaceAll('#', '');
  
  // Ensure the string has the correct length (6 digits)
  if (hexColor.length == 6) {
    // Parse the color string to an integer and return it as a Color
    return Color(int.parse('0xFF$hexColor')); // Adding 0xFF to indicate full opacity
  } else {
    throw FormatException('Invalid color string format');
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Journey'),
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {},
          ),
        ],
      ),
      body:_isLoading
        ? Center(child: CircularProgressIndicator())
        : skilltrack == null
            ? Center(child: Text("No journey found"))
            :
       Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 12),
            width: double.infinity,
            padding: EdgeInsets.all(50),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              image: DecorationImage(
                  image: NetworkImage(skilltrack!.imageUrl),
                  fit: BoxFit.cover),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '6/${skilltrack!.skillLevelCount} events achieved',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                SizedBox(height: 4),
                Text(
                  '24% completion',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          SizedBox(height: 46),
          Expanded(
            child: ListView.builder(
              itemCount: skills.length,
              itemBuilder: (context, index) {
                final skill = skills[index];
                return GestureDetector(
                  onTap: () {
          // Navigate to the SkillDetailScreen and pass skill.objective
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Journeysecondlevel(skill: skill,email: widget.email,skilltrack: skilltrack!),
            ),
          );
        },
                
        child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          // CircleAvatar(
                          //   backgroundColor:colorFromString(skill.color),
                          //   child: skill.iconUrl != null
                          //       ? SvgPicture.network(
                          //           skill.iconUrl,
                          //           width: 20,
                          //           height: 20,
                          //           fit: BoxFit.contain,
                          //         )
                          //       : Icon(
                          //           Icons.help_outline,
                          //           size: 20,
                          //           color: Colors.white,
                          //         ),
                          // ),
                          Stack(
                          children: [
                            FadeTransition(
                              opacity: _fadeAnimation,
                              child: ScaleTransition(
                                scale: _scaleAnimation,
                                child: Container(
                                  width: 45,
                                  height: 45,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: 
                                    // item['isCompleted']
                                        // ? 
                                        const Color.fromARGB(
                                            255, 121, 186, 80),
                                        // : const Color.fromARGB(
                                        //     255, 255, 255, 255),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.only(left: 3, top: 2),
                              child: CircleAvatar(
                                backgroundColor: colorFromString(skill.color),
                                // item['isCompleted']
                                    // ? const Color.fromARGB(255, 102, 179, 55)
                                    // : const Color.fromARGB(255, 203, 195, 195),
                                // child: Icon(
                                //   item['icon'],
                                //   size: 20,
                                //   color: item['isCompleted']
                                //       ? const Color.fromARGB(255, 252, 252, 252)
                                //       : const Color.fromARGB(
                                //           255, 102, 101, 101),
                                // ),
                                child: skill.iconUrl != null
                                ? SvgPicture.network(
                                    skill.iconUrl,
                                    width: 20,
                                    height: 20,
                                    fit: BoxFit.contain,
                                  )
                                : Icon(
                                    Icons.help_outline,
                                    size: 20,
                                    color: Colors.white,
                                  ),
                              ),
                            ),
                          ],
                        ),
                          if (index != skills.length - 1)
                            DottedLineNearIcon(),
                        ],
                      ),
                      
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              skill.title,
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Progress info not available',
                              style: TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class DottedLineNearIcon extends StatelessWidget {
  const DottedLineNearIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 2,
      height: 50,
      child: CustomPaint(
        painter: DottedLinePainter(),
      ),
    );
  }
}

class DottedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 2;

    double startY = 0;
    final dashHeight = 4;
    final spaceHeight = 4;

    while (startY < size.height) {
      canvas.drawLine(
        Offset(size.width / 2, startY),
        Offset(size.width / 2, startY + dashHeight),
        paint,
      );
      startY += dashHeight + spaceHeight;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}