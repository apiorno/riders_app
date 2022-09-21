import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:riders_app/globals.dart';
import 'package:riders_app/helpers/repository_helper.dart';
import 'package:smooth_star_rating_nsafe/smooth_star_rating.dart';

class SelectNearestActiveDriversScreen extends StatefulWidget {
  final DatabaseReference? referenceRideRequest;
  const SelectNearestActiveDriversScreen(this.referenceRideRequest, {Key? key})
      : super(key: key);

  @override
  State<SelectNearestActiveDriversScreen> createState() =>
      _SelectNearestActiveDriversScreenState();
}

class _SelectNearestActiveDriversScreenState
    extends State<SelectNearestActiveDriversScreen> {
  String fareAmount = '';

  String getFareAmountAccordingToVehicleType(int index) {
    if (tripDirectionsInfo != null) {
      switch (availableDrivers[index]['car_details']['type']) {
        case 'byke':
          fareAmount =
              (RepositoryHelper.calculateFareAmountFromOriginToDestination(
                          tripDirectionsInfo) /
                      2)
                  .toStringAsFixed(1);
          break;
        case 'uber-x':
          fareAmount =
              (RepositoryHelper.calculateFareAmountFromOriginToDestination(
                          tripDirectionsInfo) *
                      2)
                  .toStringAsFixed(1);
          break;
        case 'uber-go':
          fareAmount =
              (RepositoryHelper.calculateFareAmountFromOriginToDestination(
                      tripDirectionsInfo))
                  .toString();
          break;
        default:
      }
    }
    return fareAmount;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.white54,
        title: const Text(
          'Nearest ONline Drivers',
          style: TextStyle(fontSize: 18),
        ),
        leading: IconButton(
            onPressed: () {
              widget.referenceRideRequest!.remove();
              Fluttertoast.showToast(
                  msg: 'You have cancelled your drive request');
              SystemNavigator.pop();
            },
            icon: const Icon(
              Icons.close,
              color: Colors.white,
            )),
      ),
      body: ListView.builder(
          itemCount: availableDrivers.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  chosenDriverId = availableDrivers[index]['id'].toString();
                });
                Navigator.pop(context, true);
              },
              child: Card(
                color: Colors.grey,
                elevation: 3,
                shadowColor: Colors.green,
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  leading: Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Image.asset(
                      'images/${availableDrivers[index]['car_details']['type'].toString()}.png',
                      width: 70,
                    ),
                  ),
                  title: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        availableDrivers[index]['name'],
                        style: const TextStyle(
                            fontSize: 14, color: Colors.black54),
                      ),
                      Text(
                        availableDrivers[index]['car_details']['car_model'],
                        style: const TextStyle(
                            fontSize: 12, color: Colors.black54),
                      ),
                      SmoothStarRating(
                        rating: 3.5,
                        color: Colors.black,
                        borderColor: Colors.black,
                        allowHalfRating: true,
                        starCount: 5,
                        size: 15,
                      )
                    ],
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '\$ ${getFareAmountAccordingToVehicleType(index)}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      Text(
                        tripDirectionsInfo?.durationText ?? '',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black54,
                            fontSize: 12),
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      Text(
                        tripDirectionsInfo?.distanceText ?? '',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black54,
                            fontSize: 12),
                      )
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }
}
