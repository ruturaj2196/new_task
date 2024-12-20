// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:search_map_location/bloc/bloc/store_list_bloc.dart';

class ShowStores extends StatefulWidget {
  const ShowStores({super.key});

  @override
  State<ShowStores> createState() => _ShowStoresState();
}

class _ShowStoresState extends State<ShowStores> {
  int currentIndex = 0; // Tracks the selected index
  Location location = Location();
  MapController mapController = MapController();
  double latitude = 0;
  double longitude = 0;

  bool serviceEnabled = false;
  PermissionStatus? _permissionGranted;
  LocationData? _locationData;
  @override
  void initState() {
    initialLocation();
    super.initState();
  }

  void initialLocation() async {
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) return;
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) return;
    }

    _locationData = await location.getLocation();
    setState(() {
      latitude = _locationData?.latitude ?? latitude;
      longitude = _locationData?.longitude ?? longitude;
    });

    // Move the map after the location is fetched
    mapController.move(LatLng(latitude, longitude), 16);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StoreListBloc()..add(LoadStoresListEvent()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Stores',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.orange,
        ),
        body: BlocBuilder<StoreListBloc, StoreListInitialState>(
          builder: (context, state) {
            if (state.storeDate.isNotEmpty) {
              final list = state.storeDate;
              return CustomScrollView(
                slivers: [
                  SliverAppBar(
                    expandedHeight: MediaQuery.of(context).size.height * 0.5,
                    floating: false,
                    pinned: false,
                    flexibleSpace: FlexibleSpaceBar(
                      background: Container(
                        color: Colors.blue,
                        child: FlutterMap(
                            mapController: mapController,
                            options: MapOptions(
                              initialZoom: 5,
                            ),
                            children: [
                              TileLayer(
                                urlTemplate:
                                    'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                userAgentPackageName: 'com.example.app',
                              ),
                              MarkerLayer(
                                markers: list.map((store) {
                                  return Marker(
                                    width: 80.0,
                                    height: 80.0,
                                    point: LatLng(
                                      latitude,
                                      longitude,
                                    ),
                                    child: const Icon(
                                      Icons.location_pin,
                                      color: Colors.red,
                                      size: 40,
                                    ),
                                  );
                                }).toList(),
                              ),
                            ]),
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(
                              top: 5, right: 15, left: 15, bottom: 5),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                latitude = double.parse(
                                    list[index].latitude.toString());

                                longitude = double.parse(
                                    list[index].longitude.toString());
                                debugPrint(latitude.toString());

                                mapController.move(
                                    LatLng(latitude, longitude), 16);
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border:
                                    Border.all(color: Colors.orange, width: .8),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.storefront_outlined,
                                        color: Colors.orange,
                                        size: 20,
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            list[index]
                                                .storeAddress!
                                                .split(',')[1]
                                                .toString(),
                                            style: const TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            '${list[index].storeAddress!.split(',')[0]}, ${list[index].storeAddress!.split(',')[1]}',
                                            style:
                                                const TextStyle(fontSize: 13),
                                          ),
                                        ],
                                      ),
                                      const Expanded(child: SizedBox()),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${list[index].distance!.toString()} km',
                                            style: const TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const Text(
                                            'Away',
                                            style: TextStyle(fontSize: 13),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      const Text(
                                        'Today, ',
                                        style: TextStyle(fontSize: 12),
                                      ),
                                      Text(
                                        list[index].dayOfWeek.toString(),
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                      Text(
                                        ' ${list[index].startTime.toString()} - ${list[index].endTime.toString()}',
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      childCount: list.length, // Number of stores
                    ),
                  ),
                ],
              );
            } else {
              return const Center(
                child: Text('Something went wrond !'),
              );
            }
          },
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          backgroundColor: Colors.orange,
          onTap: (index) {},
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                color: Colors.white,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.restaurant_menu),
              label: 'Menu',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.storefront_outlined),
              label: 'Stores',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_bag),
              label: 'Cart',
            ),
          ],
        ),
      ),
    );
  }
}


/**
 *  */