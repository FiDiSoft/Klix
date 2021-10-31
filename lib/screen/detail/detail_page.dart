import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kumpulin/constant/theme.dart';
import 'package:kumpulin/db/img_database.dart';
import 'package:kumpulin/models/form_provider.dart';
import 'package:kumpulin/models/img.dart';
import 'package:kumpulin/widgets/build_button.dart';
import 'package:provider/provider.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({Key? key, required this.image}) : super(key: key);

  final Img image;

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late String img;
  late String longitude;
  late String latitude;
  late TextEditingController descController;
  late DateTime timeStamps;

  @override
  void initState() {
    super.initState();
    img = widget.image.img;
    longitude = widget.image.longitude;
    latitude = widget.image.latitude;
    descController = TextEditingController(text: widget.image.desc);
    timeStamps = widget.image.timeStamps;
  }

  @override
  void dispose() {
    descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<FormProvider>(
      create: (_) => FormProvider(),
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
                    'Edit Page',
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
                        File(widget.image.img),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30.0),
                  TextFormField(
                    readOnly: formProvider.isEdit,
                    decoration: const InputDecoration(
                      hintText: 'type something...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(8),
                        ),
                      ),
                    ),
                    maxLines: 5,
                    controller: descController,
                  ),
                  const SizedBox(height: 30.0),
                  Text('Longitude : ${widget.image.longitude}'),
                  Text('Latitude : ${widget.image.latitude}'),
                  const SizedBox(height: 30.0),
                  InkWell(
                    borderRadius: BorderRadius.circular(10.0),
                    onTap: () {
                      formProvider.isEdit = !formProvider.isEdit;
                      final imgPODO = widget.image.copy(
                        img: img,
                        longitude: longitude,
                        latitude: latitude,
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
                    onTap: () => showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Delete Data'),
                        content: const Text('This action can delete the data'),
                        actions: [
                          TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('cancel')),
                          TextButton(
                              onPressed: () async {
                                await ImgDatabase.instance
                                    .destroy(widget.image.id!);
                                Navigator.of(context)
                                    .popUntil((route) => route.isFirst);
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
                      btnText: 'Delete',
                      btnTextStyle: bodyTextStyle.copyWith(
                          color: primaryColor, fontWeight: FontWeight.bold),
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
