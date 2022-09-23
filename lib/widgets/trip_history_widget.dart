import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:riders_app/models/trip.dart';

class TripHistoryWidget extends StatefulWidget {
  final Trip trip;
  TripHistoryWidget(this.trip, {super.key});

  @override
  State<TripHistoryWidget> createState() => _TripHistoryWidgetState();
}

class _TripHistoryWidgetState extends State<TripHistoryWidget> {
  String formatDateAndTime(String rawDateTime) {
    final dateTime = DateTime.parse(rawDateTime);
    return '${DateFormat.MMMd(dateTime)}, ${DateFormat.y().format(dateTime)}, ${DateFormat.jm().format(dateTime)}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black54,
      child: Padding(
        padding: EdgeInsets.all(18),
        child: Column(
          children: [
            Row(
              children: [
                Text(widget.trip.driverName),
                SizedBox(
                  width: 12,
                ),
                Text(
                  widget.trip.fareAmount,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                )
              ],
            ),
            Row(
              children: [
                const Icon(
                  Icons.car_repair,
                  color: Colors.grey,
                ),
                SizedBox(
                  width: 12,
                ),
                Text(
                  widget.trip.carDetails,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                )
              ],
            ),
            Row(
              children: [
                Image.asset(
                  'images/origin.png',
                  height: 20,
                  width: 20,
                ),
                const SizedBox(
                  width: 12,
                ),
                Text(
                  widget.trip.originAddress,
                  style: const TextStyle(fontSize: 18),
                )
              ],
            ),
            Row(
              children: [
                Image.asset(
                  'images/destination.png',
                  height: 20,
                  width: 20,
                ),
                const SizedBox(
                  width: 12,
                ),
                Text(
                  widget.trip.destinationAddress,
                  style: const TextStyle(fontSize: 18),
                )
              ],
            ),
            Text(formatDateAndTime(widget.trip.time),
                style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
