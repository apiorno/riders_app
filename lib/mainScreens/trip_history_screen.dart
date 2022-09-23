import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:riders_app/info_handler/app_info.dart';
import 'package:riders_app/widgets/trip_history_widget.dart';

class TripHistoryScrenn extends StatefulWidget {
  const TripHistoryScrenn({super.key});

  @override
  State<TripHistoryScrenn> createState() => _TripHistoryScrennState();
}

class _TripHistoryScrennState extends State<TripHistoryScrenn> {
  @override
  Widget build(BuildContext context) {
    final appInfo = Provider.of<AppInfo>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trips history'),
        leading: IconButton(
            onPressed: () {
              SystemNavigator.pop();
            },
            icon: const Icon(Icons.close)),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) =>
            TripHistoryWidget(appInfo.tripsHistory[index]),
        itemCount: appInfo.tripsHistory.length,
        physics: const ClampingScrollPhysics(),
        shrinkWrap: true,
      ),
    );
  }
}
