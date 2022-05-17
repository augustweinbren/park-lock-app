import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'src/locations.dart' as locations;
import 'src/user.dart' as user_data;

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
      ImageConfiguration(devicePixelRatio: 1.0),
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
      await Future.delayed(Duration(milliseconds: 100));
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
                  child: Text('Username'),
                )),
            ListTile(
              title: Text('Account Details'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Subscriptions'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
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
                lockerDataGetter: _getLockerData,
              )),
        ],
      ),
    );
  }
}

// class LockerTabs extends StatelessWidget {
//   const LockerTabs({Key? key, required this.loadingIndicator, required this.lockerData}) : super(key: key);

//   final void Function() loadingIndicator;
//   final List<locations.Locations> lockerData;

//   @override
//   _LockerTabsState createState() => _LockerTabsState();
// }

class LockerTabs extends StatefulWidget {
  LockerTabs({
    Key? key,
    required this.lockerDataGetter,
  }) : super(key: key);

  final Function lockerDataGetter;
  final _saved = <locations.Locations>{};

  @override
  State<StatefulWidget> createState() => _LockerTabsState();
}

class _LockerTabsState extends State<LockerTabs> {
  late Future<locations.Locations> _lockerData;

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
                      sortMethod: 'Nearby',
                      lockerData: snapshot.data!,
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
              Center(child: Text('Favourites')),

              //   FutureBuilder<LockerList>(
              //   LockerList(
              //       sortMethod: 'Recent',
              //       loadingIndicator: load,
              //       lockerData: lockers),
              //   FutureBuilder<LockerList>(
              //   LockerList(
              //       sortMethod: 'Favourites',
              //       loadingIndicator: widget.lockerData,
              //       lockerData: lockers),
            ],
          ),
        ));
  }
}

class LockerList extends StatefulWidget {
  LockerList({
    Key? key,
    required this.sortMethod,
    required this.lockerData,
  }) : super(key: key);
  final String sortMethod;
  locations.Locations lockerData;

  @override
  _lockerListState createState() => _lockerListState();
}

class _lockerListState extends State<LockerList> {
  _lockerListState();

  @override
  Widget build(BuildContext context) {
    List<locations.Locker> lockers = widget.lockerData.lockers;
    if (widget.sortMethod == 'Nearby') {
      lockers.sort((a, b) => a.distance_km.compareTo(b.distance_km));
    }
    // else if (widget.sortMethod == 'Recent') {
    //   lockers.sort((a, b) => a.lastUsed.compareTo(b.lastUsed));
    // } else if (widget.sortMethod == 'Favourites') {
    //   lockers.sort((a, b) => a.favourite.compareTo(b.favourite));
    // }
    return ListView.builder(
        itemCount: lockers.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            leading: const Icon(
              Icons.run_circle,
              color: Colors.blue,
            ),
            title: Text(lockers[index].name),
            subtitle: Text((lockers[index].capacity - lockers[index].occupancy)
                    .toString() +
                '/' +
                lockers[index].capacity.toString() +
                ' lockers available'),
            trailing: Text(lockers[index].distance_km.toString() + ' km away'),
            // alreadySaved ? Icons.favorite : Icons.favorite_border,
            // color: alreadySaved ? Colors.red : null,
            // semanticLabel: alreadySaved ? 'Remove from favourites' : 'Add to favourites',
          );
        });
    //  ListView(
    //   _onMapCreated;
    // );
    // // return ListView.builder(
    //   itemCount: 10,
    //   itemBuilder: (context, index) {
    //     return ListTile(
    //       title: Text('Locker $index'),
    //       onTap: () {
    //         Navigator.push(
    //           context,
    //           MaterialPageRoute(builder: (context) => LockerDetails()),
    //         );
    //       },
    //     );
    //   },
    // );
  }
  /*
    widget.loadingIndicator().then((widget.lockerData, widget.sortMethod);));
    */
}
