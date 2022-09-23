import 'package:flutter/material.dart';
import 'package:riders_app/globals.dart';
import 'package:riders_app/mainScreens/trip_history_screen.dart';
import 'package:riders_app/splash/splash_screen.dart';

class MyDrawer extends StatefulWidget {
  final String? email;
  final String? name;
  final double? width;
  final Color? canvasColor;
  const MyDrawer(
      {Key? key, this.email, this.name, this.width, this.canvasColor})
      : super(key: key);

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
    // ignore: sized_box_for_whitespace
    return Container(
      width: widget.width,
      child: Theme(
        data: Theme.of(context).copyWith(canvasColor: widget.canvasColor),
        child: Drawer(
          child: ListView(children: [
            Container(
              height: 165,
              color: Colors.grey,
              child: DrawerHeader(
                decoration: const BoxDecoration(color: Colors.black),
                child: Row(
                  children: [
                    const Icon(
                      Icons.person,
                      size: 40,
                      color: Colors.grey,
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.name.toString(),
                          style: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          widget.email.toString(),
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TripHistoryScrenn()));
              },
              child: const ListTile(
                leading: Icon(Icons.history),
                title: Text(
                  'History',
                  style: TextStyle(color: Colors.white54),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: const ListTile(
                leading: Icon(Icons.person),
                title: Text(
                  'Profile',
                  style: TextStyle(color: Colors.white54),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: const ListTile(
                leading: Icon(Icons.info),
                title: Text(
                  'About',
                  style: TextStyle(color: Colors.white54),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                firebaseAuth.signOut();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const MySplashScreen()));
              },
              child: const ListTile(
                leading: Icon(Icons.logout),
                title: Text(
                  'Log out',
                  style: TextStyle(color: Colors.white54),
                ),
              ),
            )
          ]),
        ),
      ),
    );
  }
}
