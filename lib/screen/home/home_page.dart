import 'package:flutter/material.dart';
import 'package:kumpulin/constant/theme.dart';
import 'package:kumpulin/models/img.dart';
import 'package:kumpulin/models/providers/selected_provider.dart';
import 'package:kumpulin/screen/home/widgets/ItemGridWidget.dart';
import 'package:kumpulin/screen/home/widgets/SendAllAndDeleteButtonWidget.dart';
import 'package:kumpulin/screen/home/widgets/SendButtonWidget.dart';
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
      providers: [
        ChangeNotifierProvider(create: (context) => ImgProvider()),
        ChangeNotifierProvider(create: (context) => SelectedImgProvider())
      ],
      child: ChangeNotifierProvider<ImgProvider>(
        create: (context) => ImgProvider(),
        child: Consumer<ImgProvider>(builder: (_, _imgProvider, __) {
          return Scaffold(
            body: FutureBuilder<List<Img>>(
                future: _imgProvider.updateImages,
                builder: (BuildContext context, snapShot) {
                  return Consumer<SelectedImgProvider>(
                      builder: (_, _selectedImgProvider, __) {
                    return CustomScrollView(
                      slivers: <Widget>[
                        // App bar
                        SliverAppBar(
                          leading: _selectedImgProvider.isSelectable
                              ? IconButton(
                                  icon: const Icon(Icons.close),
                                  onPressed: () {
                                    _selectedImgProvider.statusSelect = false;
                                    _selectedImgProvider.removeAll();
                                  },
                                )
                              : null,
                          backgroundColor: _selectedImgProvider.isSelectable
                              ? primaryColor
                              : Colors.transparent,
                          toolbarHeight: 70,
                          title: Text(
                            _selectedImgProvider.isSelectable
                                ? "Pilih gambar"
                                : 'Daftar gambar',
                            style: headingStyle.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: _selectedImgProvider.isSelectable
                                  ? Colors.white
                                  : primaryColor,
                            ),
                          ),
                        ),
                        // Button send and delete
                        SliverPadding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          sliver: SliverList(
                            delegate: SliverChildListDelegate(
                              [
                                SendButtonWidget(
                                  onTap: () {
                                    _selectedImgProvider.statusSelect =
                                        !_selectedImgProvider.isSelectable;
                                  },
                                  statusSelect:
                                      _selectedImgProvider.isSelectable,
                                ),
                                SendAllAndDeleteButtonWidget(
                                  onTap: () {
                                    if (_selectedImgProvider.isSelectable) {
                                      _selectedImgProvider
                                          .addAll(snapShot.data!);
                                    }
                                  },
                                  statusSelect:
                                      _selectedImgProvider.isSelectable,
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (snapShot.hasData) ...[
                          SliverPadding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
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
                                    } else {}
                                  },
                                  selectedImage: _selectedImgProvider.listImages
                                      .contains(image),
                                  statusSelected:
                                      _selectedImgProvider.isSelectable,
                                );
                              }, childCount: snapShot.data!.length),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                              ),
                            ),
                          )
                        ]
                      ],
                    );
                  });
                }),
          );
        }),
      ),
    );
  }
}
