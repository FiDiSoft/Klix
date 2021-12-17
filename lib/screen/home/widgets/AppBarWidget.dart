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
                  color: Color(0xff123D59),
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
            icon: const Icon(Icons.exit_to_app, color: Color(0xff123D59)),
          ),
          IconButton(
            onPressed: () {
              showAboutDialog(
                context: context,
                applicationIcon: const FlutterLogo(),
                applicationName: 'About Page App',
                applicationVersion: '0.0.1',
                applicationLegalese: 'Develop by company',
                children: <Widget>[
                  const Text('abababababab'),
                  const Text('cacacccCc'),
                  const Text('sSsSsSasasas'),
                ],
              );
            },
            icon: const Icon(Icons.more_vert),
            color: primaryColor,
          )
        ]
      ],
    );
  }
}
