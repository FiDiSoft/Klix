import 'dart:io';

import 'package:excel/excel.dart';
import 'package:intl/intl.dart';
import 'package:kumpulin/db/img_database.dart';
import 'package:kumpulin/models/img.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;


class ConvertExcel {
  void _addDataToColumnOrRow(
      {required Sheet sheet,
      required String cellIndex,
      required String value,
      CellStyle? cellStyle}) {
    var curentRow = sheet.cell(CellIndex.indexByString(cellIndex));
    if (cellStyle != null) {
      curentRow.cellStyle = cellStyle;
    }
    curentRow.value = value;
  }

  void generateExcel() async {
    final excel = Excel.createExcel();
    final sheet = excel[excel.getDefaultSheet()!];

    // additional data
    _addDataToColumnOrRow(sheet: sheet, cellIndex: 'A1', value: 'User email');
    _addDataToColumnOrRow(
        sheet: sheet, cellIndex: 'B1', value: 'dika1254@gmail.com');
    String dateNow = DateFormat("yyyy-MM-dd").format(DateTime.now());
    _addDataToColumnOrRow(sheet: sheet, cellIndex: 'A2', value: 'Date');
    _addDataToColumnOrRow(sheet: sheet, cellIndex: 'B2', value: dateNow);

    // header excell
    // content header id, nama-image(nama lokasinya), latitude, longitude, timstamp
    CellStyle headerCellStyle =
        CellStyle(backgroundColorHex: '#FFFF00', fontColorHex: '#000000');
    _addDataToColumnOrRow(
      sheet: sheet,
      cellIndex: 'A4',
      value: 'TIMESTAMP',
      cellStyle: headerCellStyle,
    );

    _addDataToColumnOrRow(
      sheet: sheet,
      cellIndex: 'B4',
      value: 'KETERANGAN',
      cellStyle: headerCellStyle,
    );

    _addDataToColumnOrRow(
      sheet: sheet,
      cellIndex: 'C4',
      value: 'IMAGE NAME',
      cellStyle: headerCellStyle,
    );

    _addDataToColumnOrRow(
      sheet: sheet,
      cellIndex: 'D4',
      value: 'LATITUDE',
      cellStyle: headerCellStyle,
    );

    _addDataToColumnOrRow(
      sheet: sheet,
      cellIndex: 'E4',
      value: 'LONGITUDE',
      cellStyle: headerCellStyle,
    );
    // content data
    List<Img> data = await ImgDatabase.instance.index();
    for (var index = 0; index < data.length; index++) {
      _addDataToColumnOrRow(
          sheet: sheet,
          cellIndex: "A${index + 5}",
          value: data[index].timeStamps.toString());
      _addDataToColumnOrRow(
          sheet: sheet, cellIndex: "B${index + 5}", value: data[index].desc);
      _addDataToColumnOrRow(
          sheet: sheet, cellIndex: "C${index + 5}", value: data[index].img);
      _addDataToColumnOrRow(
          sheet: sheet,
          cellIndex: "D${index + 5}",
          value: data[index].latitude);
      _addDataToColumnOrRow(
          sheet: sheet,
          cellIndex: "E${index + 5}",
          value: data[index].longitude);
    }

    var bytesFiles = excel.save();
    var dir = await getExternalStorageDirectories();
    File(path.join("${dir?[0].path}/output_report.xlsx"))
      ..createSync(recursive: true)
      ..writeAsBytesSync(bytesFiles!);
  }
}