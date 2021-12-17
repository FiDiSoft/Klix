import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kumpulin/models/img.dart';

class ItemGridWidget extends StatelessWidget {
  const ItemGridWidget({
    Key? key,
    required this.image,
    required this.onTap,
    required this.selectedImage,
    required this.statusSelected,
  }) : super(key: key);

  final Img image;
  final VoidCallback onTap;
  final bool selectedImage;
  final bool statusSelected;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10.0),
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Image.file(
              File(image.imgPath),
              fit: BoxFit.cover,
            ),
          ),
          if (statusSelected) ...[
            Positioned(
              right: 10,
              top: 10,
              child: selectedImage
                  ? const Icon(
                      Icons.check_box,
                      color: Colors.white,
                      size: 25,
                    )
                  : const Icon(
                      Icons.check_box_outline_blank,
                      color: Colors.white,
                      size: 25,
                    ),
            ),
          ],
        ],
      ),
    );
  }
}
