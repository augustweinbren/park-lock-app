import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'src/locations.dart' as locations;
import 'src/user.dart' as user_data;
import 'src/hire_now_button.dart' as hireButton;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Park Lock',
      theme: ThemeData(
        // This is the theme of your application.
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.green,
      ),
      home: const MyHomePage(title: 'Park Lock'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final Map<String, Marker> _markers = {};
  final List<locations.Locations> lockersEncapsulated = [];
  final List<int> credits = [0];
  bool dataLoaded = false;
  /* final List<user_data.User> _users = [];*/
  // List of users for making data input easier. Only one user is needed for now.
/* \todo: Figure out how to incorporate user code
  final user_data.User _userData = user_data.User();
  final user = await user_data.getUser();
*/
  Future<void> _onMapCreated(GoogleMapController controller) async {
    final lockers = await locations.getLockers();
    final runIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(devicePixelRatio: 1.0),
      'assets/run.png',
    );
    setState(() {
      lockersEncapsulated.clear();
      lockersEncapsulated.add(lockers);
      _markers.clear();
      for (final locker in lockers.lockers) {
        int availability = locker.capacity - locker.occupancy;
        final marker = Marker(
          markerId: MarkerId(locker.name),
          position: LatLng(locker.lat, locker.lng),
          infoWindow: InfoWindow(
            title: locker.name,
            snippet: locker.address +
                '\n' +
                'Locker Availability: ' +
                availability.toString() +
                '/' +
                locker.capacity.toString(),
          ),
          icon: runIcon,
        );
        _markers[locker.id] = marker;
      }
      dataLoaded = true;
    });
  }

  Future<locations.Locations> _getLockerData() async {
    while (!dataLoaded) {
      await Future.delayed(const Duration(milliseconds: 100));
    }
    return lockersEncapsulated[0];
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _onMapCreated method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      drawer: Drawer(
        // This is the main drawer, used to hold user details
        child: ListView(
          children: <Widget>[
            const SizedBox(
                height: 50.0,
                child: DrawerHeader(
                  child: Text("John Doe"),
                )),
            ListTile(
              title: const Text('Get 5 free credits'),
              onTap: () {
                setState(
                  () {
                    credits[0] += 5;
                  },
                );
                // Update the state of the app
              },
            ),
            // ListTile(
            //   title: Text('Credits: ${credits[0]}'),
            //   onTap: () {
            //     // close the drawer
            //     Navigator.pop(context);
            //   },
            // ),
          ],
        ),
      ),
      body: Column(
        // holds the map and the list of lockers
        // TODO: make boxes dynamically adjustable to fit the screen
        children: [
          SizedBox(
              width: 400,
              height: 200,
              child: GoogleMap(
                myLocationEnabled: true,
                onMapCreated: _onMapCreated,
                initialCameraPosition: const CameraPosition(
                  target: LatLng(51.52190447705794, -0.1360255301256914),
                  zoom: 11.0,
                ),
                markers: _markers.values.toSet(),
              )),
          SizedBox(
              width: 400,
              height: 390,
              child: LockerTabs(
                  lockerDataGetter: _getLockerData, credits: credits)),
        ],
      ),
    );
  }
}

class LockerTabs extends StatefulWidget {
  LockerTabs({
    Key? key,
    required this.lockerDataGetter,
    required this.credits,
  }) : super(key: key);

  final Function lockerDataGetter;
  final _saved = <locations.Locations>{};
  final List<int> credits;

  @override
  State<StatefulWidget> createState() => _LockerTabsState();
}

class _LockerTabsState extends State<LockerTabs> {
  late Future<locations.Locations> _lockerData;
  final List<locations.Locker> _favoriteLockers = [];

  @override
  void initState() {
    _lockerData = widget.lockerDataGetter();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 0,
            bottom: const TabBar(
              tabs: [
                Tab(text: "Nearby"),
                Tab(text: "Favourites"),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              FutureBuilder<locations.Locations>(
                future: _lockerData,
                builder: (BuildContext context,
                    AsyncSnapshot<locations.Locations> snapshot) {
                  if (snapshot.hasData) {
                    return LockerList(
                      viewStyle: 'Nearby',
                      lockerData: snapshot.data!,
                      favoriteLockers: _favoriteLockers,
                      credits: widget.credits,
                    );
                    // return LockerList(
                    //   sortMethod: 'Nearby',
                    //   lockerData: snapshot.data,
                    // );
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              ),
              FutureBuilder<locations.Locations>(
                future: _lockerData,
                builder: (BuildContext context,
                    AsyncSnapshot<locations.Locations> snapshot) {
                  if (snapshot.hasData) {
                    return LockerList(
                      viewStyle: 'Favourites',
                      lockerData: snapshot.data!,
                      favoriteLockers: _favoriteLockers,
                      credits: widget.credits,
                    );
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ],
          ),
        ));
  }
}

class LockerList extends StatefulWidget {
  LockerList({
    Key? key,
    required this.viewStyle,
    required this.lockerData,
    required this.favoriteLockers,
    required this.credits,
  }) : super(key: key);
  final String viewStyle;
  final locations.Locations lockerData;
  final List<locations.Locker> favoriteLockers;
  final List<int> credits;

  @override
  _LockerListState createState() => _LockerListState();
}

class _LockerListState extends State<LockerList> {
  _LockerListState();

  @override
  Widget build(BuildContext context) {
    List<locations.Locker> lockers = [];
    if (widget.viewStyle == 'Nearby') {
      lockers = widget.lockerData.lockers;
    } else if (widget.viewStyle == 'Favourites') {
      lockers = widget.favoriteLockers;
      if (lockers.isEmpty) {
        return const Center(
          child: Text('No favourites yet!'),
        );
      }
    }
    lockers.sort((a, b) => a.distance_km.compareTo(b.distance_km));
    return ListView.builder(
      itemCount: lockers.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
            isThreeLine: true,
            leading: IconButton(
              icon: Icon(
                widget.favoriteLockers.contains(lockers[index])
                    ? Icons.favorite
                    : Icons.favorite_border,
                color: widget.favoriteLockers.contains(lockers[index])
                    ? Colors.red
                    : Colors.black,
                semanticLabel: 'Add/Remove Favourite',
              ),
              onPressed: () {
                setState(() {
                  if (widget.favoriteLockers.contains(lockers[index])) {
                    widget.favoriteLockers.remove(lockers[index]);
                  } else {
                    widget.favoriteLockers.add(lockers[index]);
                  }
                });
              },
            ),
            title: Text(lockers[index].name),
            subtitle: Text(lockers[index].distance_km.toStringAsFixed(2) +
                ' km away\n' +
                (lockers[index].capacity - lockers[index].occupancy)
                    .toString() +
                '/' +
                lockers[index].capacity.toString() +
                ' lockers available'),
            trailing: lockers[index].capacity - lockers[index].occupancy > 0
                ? TextButton(
                    onPressed: () {
                      if (widget.credits[0] != 0) {
                        setState(() {
                          lockers[index].occupancy++;
                          widget.credits[0]--;
                        });
                      } else {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('No credits left!'),
                                content: const Text(
                                    'You have no credits left to book a locker.' +
                                        '\nPlease purchase more credits from the sidebar.'),
                                actions: <Widget>[
                                  TextButton(
                                    child: const Text('OK'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            });
                      }
                    },
                    child: const Text('Book'),
                  )
                : TextButton(
                    onPressed: () {},
                    child: const Text('Full',
                        style: TextStyle(color: Colors.black))));
      },
      // trailing: hireButton.HireButton(
      //   title: 'Hire Now',
      //   locker: lockers[index],

      // ),
    );
  }
}
