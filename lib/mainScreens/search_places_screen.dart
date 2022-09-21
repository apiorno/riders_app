import 'package:flutter/material.dart';
import 'package:riders_app/globals.dart';
import 'package:riders_app/helpers/request_helper.dart';
import 'package:riders_app/models/predicted_place.dart';
import 'package:riders_app/widgets/place_prediction_tile.dart';

class SearchPlacesScreen extends StatefulWidget {
  const SearchPlacesScreen({Key? key}) : super(key: key);

  @override
  State<SearchPlacesScreen> createState() => _SearchPlacesScreenState();
}

class _SearchPlacesScreenState extends State<SearchPlacesScreen> {
  List<PredictedPlace> predictedPlaces = [];
  Future<void> findPLaceAutoCOmpleteSearch(String input) async {
    if (input.length > 1) {
      final urlAutoCompleteSearch =
          'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&key=$mapKey&components=country:AR';

      try {
        final response =
            await RequestHelper.receiveRequest(urlAutoCompleteSearch);

        if (response['status'] == 'OK') {
          setState(() {
            predictedPlaces = (response['predictions'] as List)
                .map((jsonData) => PredictedPlace.fromJson(jsonData))
                .toList();
          });
        }
      } catch (e) {
        return;
      }
    } else {
      setState(() {
        predictedPlaces = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Container(
            height: 160,
            decoration: const BoxDecoration(color: Colors.black54, boxShadow: [
              BoxShadow(
                  color: Colors.white54,
                  blurRadius: 8,
                  spreadRadius: 0.5,
                  offset: Offset(0.7, 0.7))
            ]),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  const SizedBox(
                    height: 25,
                  ),
                  Stack(
                    children: [
                      GestureDetector(
                        onTap: () {},
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.grey,
                        ),
                      ),
                      const Center(
                        child: Text(
                          'Search & Set DropOff Location',
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    width: 18,
                  ),
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: TextField(
                      onChanged: findPLaceAutoCOmpleteSearch,
                      decoration: const InputDecoration(
                          hintText: 'Search here ...',
                          fillColor: Colors.white54,
                          filled: true,
                          border: InputBorder.none,
                          contentPadding:
                              EdgeInsets.only(left: 11, top: 8, bottom: 8)),
                    ),
                  ))
                ],
              ),
            ),
          ),
          if (predictedPlaces.isNotEmpty)
            Expanded(
              child: ListView.separated(
                  physics: const ClampingScrollPhysics(),
                  itemBuilder: (context, index) =>
                      PlacePredictionTile(predictedPlaces[index]),
                  separatorBuilder: (context, index) => const Divider(
                        height: 1,
                        thickness: 1,
                        color: Colors.grey,
                      ),
                  itemCount: predictedPlaces.length),
            )
        ],
      ),
    );
  }
}
