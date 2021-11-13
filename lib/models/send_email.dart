import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:path_provider/path_provider.dart';

Future sendEmail(
    {
    required User user,
    required String emailRecipient}) async {
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  final GoogleSignInAuthentication? googleAuth =
      await googleUser?.authentication;

  String? emailFrom = user.email;
  String? token = googleAuth?.accessToken;

  final smtpServer = gmailSaslXoauth2('$emailFrom', '$token');

  var dir = await getExternalStorageDirectories();

  final message = Message()
    ..from = Address('$emailFrom', '${user.displayName}')
    ..recipients.add(emailRecipient)
    ..subject =
        'Laporan survey dari $emailFrom :: ${DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.now())}'
    ..text = 'Laporan tempat survey'
    ..attachments = [
      FileAttachment(File(path.join("${dir?[0].path}/output_report.xlsx")))
        ..location = Location.inline
        ..cid = '<myimg@3.141>'
    ];

  try {
    final sendReport = await send(message, smtpServer);
    print('Message sent: ' + sendReport.toString());
  } on MailerException catch (e) {
    print('Message not sent.');
    for (var p in e.problems) {
      print('Problem: ${p.code}: ${p.msg}');
    }
  }
}
