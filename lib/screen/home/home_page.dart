import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kumpulin/constant/theme.dart';
import 'package:kumpulin/db/img_database.dart';
import 'package:kumpulin/models/img.dart';
import 'package:kumpulin/models/providers/selected_provider.dart';
import 'package:kumpulin/screen/camera/camera_screen.dart';
import 'package:kumpulin/screen/detail/detail_page.dart';
import 'package:kumpulin/screen/home/widgets/AppBarWidget.dart';
import 'package:kumpulin/screen/home/widgets/ItemGridWidget.dart';
import 'package:kumpulin/screen/home/widgets/SendAllAndDeleteButtonWidget.dart';
import 'package:kumpulin/screen/home/widgets/SendButtonWidget.dart';
import 'package:kumpulin/screen/maps/google_maps.dart';
import 'package:kumpulin/screen/send/send_page.dart';
import 'package:kumpulin/view_models/check.dart';
import 'package:provider/provider.dart';
import 'package:kumpulin/models/providers/img_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.user}) : super(key: key);
  final User user;
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isChecked = false;
  final check = Check();

  @override
  void initState() {
    check.getCheck().then((value) {
      isChecked = value;

      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    ImgProvider().updateImages = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void _showSnackbar(String title) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          padding: const EdgeInsets.all(20),
          content: Text(
            title,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    }

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ImgProvider()),
        ChangeNotifierProvider(create: (context) => SelectedImgProvider())
      ],
      child: ChangeNotifierProvider<ImgProvider>(
        create: (context) => ImgProvider(),
        child: Consumer<ImgProvider>(builder: (_, _imgProvider, __) {
          Future<void> _checkLocation() async {
            final db = await ImgDatabase.instance.index();
            List<LatLng> latLongList = <LatLng>[];

            for (var i = 0; i < db.length; i++) {
              latLongList.add(LatLng(
                  double.parse(db[i].latitude), double.parse(db[i].longitude)));
            }

            if (latLongList.isEmpty) {
              const snackBar = SnackBar(
                backgroundColor: Colors.red,
                padding: EdgeInsets.all(20),
                content: Text(
                  'Please add a image!',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                duration: Duration(seconds: 2),
              );

              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            } else {
              isChecked = !isChecked;

              if (isChecked == false) {
                isChecked = !isChecked;
              } else {
                isChecked = isChecked;
              }

              setState(() {
                check.setCheck(isChecked);
              });

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GoogleMaps(latLong: latLongList),
                ),
              );
            }
          }

          Future<void> _addImage() async {
            setState(() {
              isChecked = false;
              check.setCheck(isChecked);
            });

            List<Img>? totalImg = await _imgProvider.updateImages;

            if (totalImg!.length < 50) {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CameraScreen(
                    user: widget.user,
                  ),
                ),
              );

              _imgProvider.updateImages = ImgDatabase.instance.index();
            } else {
              const snackBar = SnackBar(
                backgroundColor: Colors.red,
                padding: EdgeInsets.all(20),
                content: Text(
                  'Image list is full!',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                duration: Duration(seconds: 2),
              );

              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
          }

          return Scaffold(
            floatingActionButton: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FloatingActionButton(
                  onPressed: _checkLocation,
                  heroTag: 'gpsButton',
                  backgroundColor: secondaryColor,
                  child: const Icon(Icons.gps_fixed, color: Colors.black,),
                ),
                const SizedBox(height: 10.0),
                FloatingActionButton(
                  onPressed: _addImage,
                  heroTag: 'addButton',
                  backgroundColor: secondaryColor,
                  child: const Icon(Icons.add, color: Colors.black,),
                ),
              ],
            ),
            body: FutureBuilder<List<Img>>(
              future: _imgProvider.updateImages,
              builder: (BuildContext context, snapShot) {
                return Consumer<SelectedImgProvider>(
                  builder: (_, _selectedImgProvider, __) {
                    // method for SendAll or Delete
                    Future<void> _sendAllOrDeleteCallback() async {
                      if (_selectedImgProvider.isSelectable) {
                        _selectedImgProvider.addAll(snapShot.data!);
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => SendPage(
                              user: widget.user,
                              listImages: _selectedImgProvider.listImages,
                            ),
                          ),
                        );
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Delete all images?'),
                            content:
                                const Text('This action will delete all images'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('cancel'),
                              ),
                              TextButton(
                                onPressed: () async {
                                  await ImgDatabase.instance.destroyAll();

                                  _imgProvider.updateImages =
                                      ImgDatabase.instance.index();

                                  setState(() {
                                    isChecked = false;
                                    check.setCheck(isChecked);
                                    check.destroyShared();
                                  });

                                  Navigator.pop(context);
                                },
                                child: const Text('yes'),
                              ),
                            ],
                          ),
                        );
                      }
                    }

                    // method send image
                    Future<void> _sendButtonCallback() async {
                      List<Img> _listImg = await ImgDatabase.instance.index();
                      if (_listImg.isEmpty) {
                        _showSnackbar('Please add a image!');
                      } else {
                        if (_selectedImgProvider.isSelectable) {
                          if (_selectedImgProvider.listImages.length > 0) {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => SendPage(
                                  user: widget.user,
                                  listImages: _selectedImgProvider.listImages,
                                ),
                              ),
                            );
                          } else {
                            _showSnackbar("Choose at least 1 image");
                          }
                        } else {
                          _selectedImgProvider.statusSelect = true;
                        }
                      }
                    }

                    return OrientationBuilder(builder: (context, orientation) {
                      bool isLandscape = orientation == Orientation.landscape;
                      return CustomScrollView(
                        slivers: <Widget>[
                          // App bar
                          AppBarWidget(
                            onPressed: () {
                              _selectedImgProvider.statusSelect = false;
                              _selectedImgProvider.removeAll();
                            },
                            statusSelected: _selectedImgProvider.isSelectable,
                            statusCheckLocation: isChecked,
                          ),
                          // Button send and delete
                          SliverPadding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            sliver: SliverList(
                              delegate: SliverChildListDelegate(
                                [
                                  SendButtonWidget(
                                    onTap: _sendButtonCallback,
                                    statusSelect:
                                        _selectedImgProvider.isSelectable,
                                  ),
                                  SendAllAndDeleteButtonWidget(
                                    onTap: _sendAllOrDeleteCallback,
                                    statusSelect:
                                        _selectedImgProvider.isSelectable,
                                  ),
                                  if (snapShot.hasData) ...[
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 12),
                                      child: Center(
                                        child: Text(
                                            'Images : ${snapShot.data!.length.toString()} / 50'),
                                      ),
                                    ),
                                  ]
                                ],
                              ),
                            ),
                          ),
                          if (snapShot.hasData) ...[
                            SliverPadding(
                              padding: const EdgeInsets.only(
                                left: 12,
                                right: 12,
                                bottom: 32,
                              ),
                              sliver: SliverGrid(
                                delegate: SliverChildBuilderDelegate(
                                    (BuildContext context, int index) {
                                  final image = snapShot.data![index];
                                  return ItemGridWidget(
                                    image: image,
                                    onTap: () async {
                                      if (_selectedImgProvider.isSelectable) {
                                        if (_selectedImgProvider.listImages
                                            .contains(image)) {
                                          _selectedImgProvider.remove(image);
                                        } else {
                                          _selectedImgProvider.add(image);
                                        }
                                      } else {
                                        await Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) => DetailPage(
                                              image: image,
                                            ),
                                          ),
                                        );

                                        _imgProvider.updateImages =
                                            ImgDatabase.instance.index();
                                      }
                                    },
                                    selectedImage: _selectedImgProvider
                                        .listImages
                                        .contains(image),
                                    statusSelected:
                                        _selectedImgProvider.isSelectable,
                                  );
                                }, childCount: snapShot.data!.length),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: isLandscape ? 3 : 2,
                                  crossAxisSpacing: 16,
                                  mainAxisSpacing: 16,
                                ),
                              ),
                            )
                          ]
                        ],
                      );
                    });
                  },
                );
              },
            ),
          );
        }),
      ),
    );
  }
}
