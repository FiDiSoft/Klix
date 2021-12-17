import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kumpulin/constant/theme.dart';
import 'package:kumpulin/models/img.dart';
import 'package:kumpulin/widgets/build_button.dart';
import 'package:provider/provider.dart';
import 'package:kumpulin/models/providers/img_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => ImgProvider())],
      child: ChangeNotifierProvider<ImgProvider>(
        create: (context) => ImgProvider(),
        child: Consumer<ImgProvider>(builder: (_, _imgProvider, __) {
          return Scaffold(
            body: Container(
              margin: const EdgeInsets.symmetric(horizontal: 22),
              child: FutureBuilder<List<Img>>(
                  future: _imgProvider.updateImages,
                  builder: (BuildContext context, snapShot) {
                    return CustomScrollView(
                      slivers: <Widget>[
                        // App bar
                        SliverAppBar(
                          backgroundColor: Colors.transparent,
                          title: Text(
                            'Daftar gambar',
                            style: headingStyle.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 22.0,
                            ),
                          ),
                        ),
                        // Button send and delete
                        SliverList(
                          delegate: SliverChildListDelegate(
                            [
                              Container(
                                margin: const EdgeInsets.only(
                                  top: 30.0,
                                ),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(10.0),
                                  onTap: () {},
                                  child: BuildButton(
                                    btnColor: primaryColor,
                                    btnBorder: Border.all(width: 1),
                                    btnText: 'Kirim semua gambar',
                                    btnTextStyle: bodyTextStyle.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(
                                  top: 8.0,
                                  bottom: 16.0,
                                ),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(10.0),
                                  onTap: () {},
                                  child: BuildButton(
                                    btnColor: whiteBackground,
                                    btnBorder: Border.all(
                                      width: 1,
                                      color: primaryColor,
                                    ),
                                    btnText: 'Hapus semua gambar',
                                    btnTextStyle: bodyTextStyle.copyWith(
                                      color: primaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (snapShot.hasData) ...[
                          SliverGrid(
                            delegate: SliverChildBuilderDelegate(
                                (BuildContext context, int index) {
                              final image = snapShot.data![index];
                              return InkWell(
                                onTap: () async {},
                                borderRadius: BorderRadius.circular(10.0),
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10.0),
                                    child: Image.file(
                                      File(image.imgPath),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              );
                            }, childCount: snapShot.data!.length),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 4,
                              mainAxisSpacing: 4,
                            ),
                          )
                        ]
                      ],
                    );
                  }),
            ),
          );
        }),
      ),
    );
  }
}
