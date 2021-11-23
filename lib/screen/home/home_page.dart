import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import 'package:kumpulin/constant/theme.dart';
import 'package:kumpulin/db/img_database.dart';
import 'package:kumpulin/models/google_auth.dart';
import 'package:kumpulin/models/img.dart';
import 'package:kumpulin/models/img_provider.dart';
import 'package:kumpulin/screen/camera/camera_screen.dart';
import 'package:kumpulin/screen/detail/detail_page.dart';
import 'package:kumpulin/screen/maps/google_maps.dart';
import 'package:kumpulin/screen/send/send_page.dart';
import 'package:kumpulin/widgets/build_button.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
    required this.user,
  }) : super(key: key);

  final User user;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void dispose() {
    ImgProvider().updateImages = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size mediaQuery = MediaQuery.of(context).size;

    return ChangeNotifierProvider<ImgProvider>(
      create: (context) => ImgProvider(),
      child: Consumer<ImgProvider>(
        builder: (_, imgProvider, __) {
          return Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(290),
              child: Container(
                width: mediaQuery.width,
                height: 290.0,
                padding: const EdgeInsets.fromLTRB(22.0, 20.0, 22.0, 10.0),
                child: SafeArea(
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'All picture',
                            style: headingStyle.copyWith(
                              fontSize: 22.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          CircleAvatar(
                            backgroundColor: Colors.transparent,
                            child: IconButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('Log out '),
                                    content:
                                        const Text('Are you sure to log out ?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text('cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          await signOut();
                                          Navigator.pop(context);
                                        },
                                        child: const Text('yes'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              icon: const Icon(Icons.exit_to_app,
                                  color: Color(0xff123D59)),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 50.0),
                      InkWell(
                        borderRadius: BorderRadius.circular(10.0),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => SendPage(user: widget.user),
                            ),
                          );
                        },
                        child: BuildButton(
                          btnColor: primaryColor,
                          btnBorder: Border.all(width: 1),
                          btnText: 'Send all data',
                          btnTextStyle: bodyTextStyle.copyWith(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      InkWell(
                        borderRadius: BorderRadius.circular(10.0),
                        onTap: () => showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Delete All Data'),
                            content:
                                const Text('This action can delete all data'),
                            actions: [
                              TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('cancel')),
                              TextButton(
                                  onPressed: () async {
                                    await ImgDatabase.instance.destroyAll();

                                    imgProvider.updateImages =
                                        ImgDatabase.instance.index();

                                    Navigator.pop(context);
                                  },
                                  child: const Text('yes')),
                            ],
                          ),
                        ),
                        child: BuildButton(
                          btnColor: whiteBackground,
                          btnBorder: Border.all(
                            color: primaryColor,
                            width: 1,
                          ),
                          btnText: 'Delete all data',
                          btnTextStyle: bodyTextStyle.copyWith(
                              color: primaryColor, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      FutureBuilder<List<Img>>(
                          future: imgProvider.updateImages,
                          builder: (context, snapshot) {
                            return snapshot.hasData
                                ? Text(
                                    'Total gambar : ${snapshot.data!.length.toString()}')
                                : const Text('');
                          })
                    ],
                  ),
                ),
              ),
            ),
            floatingActionButton: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FloatingActionButton(
                  onPressed: () async {
                    final db = await ImgDatabase.instance.index();
                    List<LatLng> latLongList = <LatLng>[];

                    for (var i = 0; i < db.length; i++) {
                      latLongList.add(LatLng(double.parse(db[i].latitude),
                          double.parse(db[i].longitude)));
                    }

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GoogleMaps(latLong: latLongList),
                      ),
                    );
                  },
                  heroTag: 'gpsButton',
                  backgroundColor: primaryColor,
                  child: const Icon(Icons.gps_fixed),
                ),
                const SizedBox(height: 10.0),
                FloatingActionButton(
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CameraScreen(),
                      ),
                    );

                    imgProvider.updateImages = ImgDatabase.instance.index();
                  },
                  heroTag: 'addButton',
                  backgroundColor: primaryColor,
                  child: const Icon(Icons.add),
                ),
              ],
            ),
            body: FutureBuilder<List<Img>>(
              future: imgProvider.updateImages,
              builder: (context, snapshot) {
                return snapshot.hasData
                    ? snapshot.data!.isEmpty
                        ? const Center(
                            child: Text(
                            'No Images',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ))
                        : Container(
                            margin:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: GridView.builder(
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, index) {
                                final image = snapshot.data![index];

                                return InkWell(
                                  onTap: () async {
                                    await Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => DetailPage(
                                          image: image,
                                        ),
                                      ),
                                    );

                                    imgProvider.updateImages =
                                        ImgDatabase.instance.index();
                                  },
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0)),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10.0),
                                      child: Image.file(
                                        File(image.imgPath),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                );
                              },
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                              ),
                            ),
                          )
                    : const Center(child: CircularProgressIndicator());
              },
            ),
          );
        },
      ),
    );
  }
}
