import 'package:flutter/material.dart';
import 'package:kumpulin/constant/theme.dart';
import 'package:kumpulin/models/google_auth.dart';

class AppBarWidget extends StatelessWidget {
  const AppBarWidget({
    Key? key,
    required this.statusSelected,
    required this.onPressed,
    required this.statusCheckLocation,
  }) : super(key: key);
  final bool statusSelected;
  final bool statusCheckLocation;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: statusSelected,
      leading: statusSelected
          ? IconButton(
              icon: const Icon(Icons.close),
              onPressed: onPressed,
            )
          : null,
      backgroundColor: statusSelected ? primaryColor : Colors.transparent,
      toolbarHeight: 80,
      title: Text(
        statusSelected ? "Pilih gambar" : 'Daftar gambar',
        style: headingStyle.copyWith(
          fontWeight: FontWeight.bold,
          fontSize: 18,
          color: statusSelected ? Colors.white : primaryColor,
        ),
      ),
      actions: [
        if (!statusSelected) ...[
          if (statusCheckLocation) ...[
            TextButton.icon(
              onPressed: null,
              icon: const Icon(
                Icons.check,
                color: Colors.green,
              ),
              label: const Text(
                'Lokasi',
                style: TextStyle(
                  color: Color(0xff333333),
                ),
              ),
            )
          ],
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Keluar '),
                  content: const Text('Anda yakin akan keluar ?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('batal'),
                    ),
                    TextButton(
                      onPressed: () async {
                        await signOut();
                        Navigator.pop(context);
                      },
                      child: const Text('ya'),
                    ),
                  ],
                ),
              );
            },
            icon: const Icon(Icons.exit_to_app, color: Color(0xff333333)),
          ),
          IconButton(
            onPressed: () {
              showAboutDialog(
                context: context,
                applicationIcon: const Image(image: AssetImage('assets/cipta_logo.jpeg'), width: 75, height: 75,),
                applicationName: 'About Page App',
                applicationVersion: '0.0.1',
                applicationLegalese: 'Develop by Cipta Teknologi',
                children: <Widget>[
                  const Text('Kumpul-in app is Android-based mobile app. This App is useful to record cordinate location, field image acquisition, and textual description.The information is well-summarized and and can be through email.Hance, makes communication and information sharing become easier in any organization.'),
                ],
              );
            },
            icon: const Icon(Icons.info_outline),
            color: primaryColor,
          )
        ]
      ],
    );
  }
}
