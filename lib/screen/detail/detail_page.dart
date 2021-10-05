import 'package:flutter/material.dart';
import 'package:kumpulin/constant/theme.dart';
import 'package:kumpulin/models/form_provider.dart';
import 'package:kumpulin/widgets/build_button.dart';
import 'package:provider/provider.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({Key? key}) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  TextEditingController descController = TextEditingController(text: '');

  @override
  void dispose() {
    descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
      ),
      body: ChangeNotifierProvider<FormProvider>(
        create: (_) => FormProvider(),
        child: Consumer<FormProvider>(builder: (_, formProvider, __) {
          return SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
              child: Column(
                children: [
                  Card(
                    margin: const EdgeInsets.all(10.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Image.asset(
                        'assets/place.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30.0),
                  SizedBox(
                    height: 200,
                    child: TextFormField(
                      controller: descController,
                      readOnly: formProvider.isEdit,
                      expands: true,
                      maxLines: null,
                      decoration: InputDecoration(
                        hintText: 'type something...',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(color: primaryColor)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30.0),
                  InkWell(
                    borderRadius: BorderRadius.circular(10.0),
                    onTap: () => formProvider.isEdit = !formProvider.isEdit,
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
                      builder: (_) => AlertDialog(
                        title: const Text('Delete Data'),
                        content: const Text('This action can delete the data'),
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
                      btnText: 'Delete',
                      btnTextStyle: bodyTextStyle.copyWith(
                          color: primaryColor, fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
