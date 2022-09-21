import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:riders_app/globals.dart';
import 'package:smooth_star_rating_nsafe/smooth_star_rating.dart';

class RateDriverScreen extends StatefulWidget {
  final String assignedDriverId;
  RateDriverScreen({required this.assignedDriverId, super.key});

  @override
  State<RateDriverScreen> createState() => _RateDriverScreenState();
}

class _RateDriverScreenState extends State<RateDriverScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        backgroundColor: Colors.white60,
        child: Container(
          margin: const EdgeInsets.all(8),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white54,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                height: 22,
              ),
              const Text(
                'Rate Trip experience',
                style: TextStyle(
                  fontSize: 22,
                  letterSpacing: 2,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(
                height: 22,
              ),
              const Divider(
                height: 4,
                thickness: 4,
              ),
              const SizedBox(
                height: 22,
              ),
              SmoothStarRating(
                rating: countRatingStars,
                allowHalfRating: false,
                starCount: 5,
                color: Colors.green,
                borderColor: Colors.green,
                size: 46,
                onRatingChanged: (value) {
                  countRatingStars = value;
                  switch (countRatingStars.round()) {
                    case 1:
                      titleStarsRating = 'Very bad';
                      break;
                    case 2:
                      titleStarsRating = 'Bad';
                      break;
                    case 3:
                      titleStarsRating = 'Good';
                      break;
                    case 4:
                      titleStarsRating = 'Very good';
                      break;
                    case 5:
                      titleStarsRating = 'Perfect';
                      break;
                    default:
                  }
                },
              ),
              const SizedBox(
                height: 12,
              ),
              Text(
                titleStarsRating,
                style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.green),
              ),
              const SizedBox(
                height: 18,
              ),
              ElevatedButton(
                  onPressed: () {
                    DatabaseReference rateDriverRef = FirebaseDatabase.instance
                        .ref()
                        .child('drivers')
                        .child(widget.assignedDriverId)
                        .child('ratings');
                    rateDriverRef.once().then((snap) {
                      final val = snap.snapshot.value;
                      final newRate = val == null
                          ? countRatingStars
                          : (double.parse(val.toString()) + countRatingStars) /
                              2;
                      rateDriverRef.set(newRate.toString());
                      SystemNavigator.pop();
                    });
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: EdgeInsets.symmetric(horizontal: 74)),
                  child: const Text(
                    'Submit',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  )),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
