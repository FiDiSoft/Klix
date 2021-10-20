import 'package:flutter/material.dart';
import 'package:kumpulin/constant/theme.dart';
import 'package:kumpulin/db/img_database.dart';
import 'package:kumpulin/models/google_auth.dart';
import 'package:kumpulin/models/img.dart';
import 'package:kumpulin/screen/camera/camera_screen.dart';
import 'package:kumpulin/screen/detail/detail_page.dart';
import 'package:kumpulin/widgets/build_button.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<Img> images;
  bool isLoading = false;

  @override
  void initState() {
    refreshImages();

    super.initState();
  }

  @override
  void dispose() {
    ImgDatabase.instance.close();

    super.dispose();
  }

  Future refreshImages() async {
    setState(() => isLoading = !isLoading);

    images = await ImgDatabase.instance.listImg();

    setState(() => isLoading = !isLoading);
  }

  @override
  Widget build(BuildContext context) {
    Size mediaQuery = MediaQuery.of(context).size;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(290),
        child: Container(
          width: mediaQuery.width,
          height: 270.0,
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
                              content: const Text('Are you sure to log out ?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('cancel'),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    await GoogleAuth.signOut();
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
                  onTap: () {},
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
                      content: const Text('This action can delete all data'),
                      actions: [
                        TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('cancel')),
                        TextButton(
                            onPressed: () => Navigator.pop(context),
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
                )
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const CameraScreen(),
          ),
        ),
        backgroundColor: primaryColor,
        child: const Icon(Icons.add),
      ),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : images.isEmpty
                ? const Text(
                    'No Images',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  )
                : GridView.builder(
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const DetailPage())),
                        borderRadius: BorderRadius.circular(10.0),
                        child: Card(
                          margin: const EdgeInsets.all(10.0),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: Image.asset(
                              'assets/place.png',
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
      ),
    );
  }
}




// body: Container(
      //   width: mediaQuery.width,
      //   padding: const EdgeInsets.symmetric(horizontal: 20.0),
      //   child: GridView.builder(
      //     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      //         crossAxisCount: 2),
      //     itemBuilder: (context, i) {
      //       return InkWell(
      //         onTap: () => Navigator.push(context,
      //             MaterialPageRoute(builder: (_) => const DetailPage())),
      //         borderRadius: BorderRadius.circular(10.0),
      //         child: Card(
      //           margin: const EdgeInsets.all(10.0),
      //           shape: RoundedRectangleBorder(
      //               borderRadius: BorderRadius.circular(10.0)),
      //           child: ClipRRect(
      //             borderRadius: BorderRadius.circular(10.0),
      //             child: Image.asset(
      //               'assets/place.png',
      //               fit: BoxFit.cover,
      //             ),
      //           ),
      //         ),
      //       );
      //     },
      //     itemCount: 10,
      //   ),
      // ),
