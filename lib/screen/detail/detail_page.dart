import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kumpulin/constant/theme.dart';
import 'package:kumpulin/db/img_database.dart';
import 'package:kumpulin/models/providers/form_provider.dart';
import 'package:kumpulin/models/img.dart';
import 'package:kumpulin/widgets/build_button.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({Key? key, required this.image}) : super(key: key);

  final Img image;

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late String img;
  late TextEditingController descController;
  late TextEditingController latController;
  late TextEditingController longController;
  late DateTime timeStamps;

  bool isChecked = false;

  Future<bool> getCheck() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getBool('${widget.image.id}key') ?? false;
  }

  void setCheck(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('${widget.image.id}key', value);
  }

  void destroyShared() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.remove('${widget.image.id}key');
  }

  @override
  void initState() {
    super.initState();
    img = widget.image.img;
    latController = TextEditingController(text: widget.image.latitude);
    longController = TextEditingController(text: widget.image.longitude);
    descController = TextEditingController(text: widget.image.desc);
    timeStamps = widget.image.timeStamps;
    getCheck().then((value) {
      isChecked = value;

      setState(() {});
    });
  }

  @override
  void dispose() {
    descController.dispose();
    latController.dispose();
    longController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    openMapsSheet(context) async {
      try {
        final coords = Coords(double.parse(latController.text),
            double.parse(longController.text));
        const title = "Coordinate picture";
        final availableMaps = await MapLauncher.installedMaps;

        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return SafeArea(
              child: SingleChildScrollView(
                child: SizedBox(
                  child: Wrap(
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.all(10.0),
                        child: Text(
                          'Select maps',
                          style: bodyTextStyle.copyWith(fontSize: 20),
                        ),
                      ),
                      const Divider(),
                      for (var map in availableMaps)
                        ListTile(
                          onTap: () => map.showMarker(
                            coords: coords,
                            title: title,
                          ),
                          title: Text(map.mapName),
                          leading: SvgPicture.asset(
                            map.icon,
                            height: 30.0,
                            width: 30.0,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      } catch (e) {
        print(e);
      }
    }

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<FormProvider>(
            create: (context) => FormProvider()),
      ],
      child: Consumer<FormProvider>(builder: (_, formProvider, __) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            shadowColor: Colors.transparent,
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(
                Icons.arrow_back,
                color: primaryColor,
              ),
            ),
            title: (formProvider.isEdit == false)
                ? Text(
                    'Detail Page',
                    style: headingStyle.copyWith(
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : Text(
                    'Detail Page',
                    style: headingStyle.copyWith(
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
          body: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
              child: Column(
                children: [
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    margin: const EdgeInsets.all(10.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Image.file(
                        File(widget.image.imgPath),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30.0),
                  TextFormField(
                    readOnly: formProvider.isEdit,
                    decoration: const InputDecoration(
                      hintText: 'Type your description...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(8),
                        ),
                      ),
                    ),
                    maxLines: 5,
                    maxLength: 1000,
                    controller: descController,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    readOnly: true,
                    decoration: const InputDecoration(
                      hintText: 'Latitude',
                      labelText: 'Latitude',
                      labelStyle: TextStyle(fontSize: 20),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(8),
                        ),
                      ),
                    ),
                    controller: latController,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    readOnly: true,
                    decoration: const InputDecoration(
                      hintText: 'Longitude',
                      labelText: 'Longitude',
                      labelStyle: TextStyle(fontSize: 20),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(8),
                        ),
                      ),
                    ),
                    controller: longController,
                  ),
                  const Divider(
                    height: 50.0,
                    thickness: 1,
                  ),
                  InkWell(
                    borderRadius: BorderRadius.circular(10.0),
                    onTap: () {
                      formProvider.isEdit = !formProvider.isEdit;
                      final imgPODO = widget.image.copy(
                        img: img,
                        latitude: latController.text,
                        longitude: longController.text,
                        desc: descController.text,
                        timeStamps: DateTime.now(),
                      );

                      if (formProvider.isEdit == true) {
                        ImgDatabase.instance.update(imgPODO);

                        const snackBar = SnackBar(
                          backgroundColor: Colors.green,
                          padding: EdgeInsets.all(20),
                          content: Text(
                            'Updated successfully!',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          duration: Duration(seconds: 1),
                        );

                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    },
                    child: BuildButton(
                      btnColor: primaryColor,
                      btnBorder: Border.all(color: primaryColor, width: 1),
                      btnText: (formProvider.isEdit == false) ? 'Save' : 'Edit',
                      btnTextStyle: bodyTextStyle.copyWith(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  InkWell(
                    borderRadius: BorderRadius.circular(10.0),
                    onTap: () async {
                      openMapsSheet(context);

                      isChecked = !isChecked;

                      if (isChecked == false) {
                        isChecked = !isChecked;
                      } else {
                        isChecked = isChecked;
                      }

                      setState(() {
                        setCheck(isChecked);
                      });
                    },
                    child: BuildButton(
                      btnColor: primaryColor,
                      btnBorder: Border.all(
                        color:
                            (isChecked == false) ? primaryColor : Colors.green,
                        width: 1,
                      ),
                      btnText: (isChecked == false)
                          ? 'Check location'
                          : 'Location checked',
                      btnTextStyle: bodyTextStyle.copyWith(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  InkWell(
                    borderRadius: BorderRadius.circular(10.0),
                    onTap: () => showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Delete data ?'),
                        content: const Text('Tap "yes" to continue'),
                        actions: [
                          TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Close')),
                          TextButton(
                              onPressed: () async {
                                destroyShared();
                                await ImgDatabase.instance.destroy(
                                    widget.image.id!, widget.image.imgPath);
                                Navigator.of(context)
                                    .popUntil((route) => route.isFirst);
                              },
                              child: const Text('Yes')),
                        ],
                      ),
                    ),
                    child: BuildButton(
                      btnColor: whiteBackground,
                      btnBorder: Border.all(
                        color: Colors.red,
                        width: 1,
                      ),
                      btnText: 'Delete',
                      btnTextStyle: bodyTextStyle.copyWith(
                          color: Colors.red, fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
