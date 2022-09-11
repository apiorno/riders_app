import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:riders_app/globals.dart';
import 'package:riders_app/helpers/request_helper.dart';
import 'package:riders_app/info_handler/app_info.dart';
import 'package:riders_app/models/directions_address.dart';
import 'package:riders_app/models/predicted_place.dart';
import 'package:riders_app/widgets/progress_dialog.dart';

class PlacePredictionTile extends StatefulWidget {
  final PredictedPlace predictedPlace;

  const PlacePredictionTile(this.predictedPlace, {Key? key}) : super(key: key);

  @override
  State<PlacePredictionTile> createState() => _PlacePredictionTileState();
}

class _PlacePredictionTileState extends State<PlacePredictionTile> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        showDialog(
            context: context,
            builder: (context) => const ProgressDialog(
                  message: 'Setting Up Drop-Off, Please wait',
                ));

        try {
          final response = await RequestHelper.receiveRequest(
              'https://maps.googleapis.com/maps/api/place/details/json?place_id=${widget.predictedPlace.placeId}&key=$mapKey');
          Navigator.pop(context);
          if (response['status'] == 'OK') {
            final newUserDropOffAddress =
                DirectionsAddress.fromJson(response['result']);
            Provider.of<AppInfo>(context, listen: false)
                .updateDropOffLocationAddress(newUserDropOffAddress);

            setState(() {
              userDropoffAddress = newUserDropOffAddress.locationName!;
            });
            Navigator.pop(context, true);
          }
        } catch (e) {
          Navigator.pop(context);
          return;
        }
      },
      style: ElevatedButton.styleFrom(primary: Colors.white24),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
          children: [
            const Icon(
              Icons.add_location,
              color: Colors.grey,
            ),
            const SizedBox(
              width: 14,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    widget.predictedPlace.mainText!,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 16, color: Colors.white54),
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  Text(
                    widget.predictedPlace.secondaryText!,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 12, color: Colors.white54),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
