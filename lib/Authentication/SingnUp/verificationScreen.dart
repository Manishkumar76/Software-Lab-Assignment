import 'package:farmer_eats/Authentication/SingnUp/BusinessHoursScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';

import '../../Models/user_model.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({Key? key}) : super(key: key);

  @override
  _VerificationScreenState createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  String? selectedFile= null;
   var warning="";
  Future<void> _pickFile() async {
    setWarning("");
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      setState(() {
        selectedFile = result.files.single.name;
      });

      // Update the registration proof in UserData
      Provider.of<UserData>(context, listen: false).updateRegistrationProof(result.files.single.path!);
    }
  }

  void setWarning(String value){
    setState(() {
      warning=value;
    });
  }

  void submission(){
    if(selectedFile==null){
      setWarning("Any proof be required!");
    }
    else{
      Navigator.push(context, MaterialPageRoute(builder: (_)=>const BusinessHoursScreen()));
    }
  }



  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserData>(context);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 50),

            const SizedBox(height: 10),
            const Text(
              "Signup 3 of 4",
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey),
            ),
            const SizedBox(height: 10),
            const Text(
              "Verification",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600, color: Colors.black),
            ),
            const SizedBox(height: 10),
            const Text(
              "Attach proof of Department of Agriculture registrations i.e. Florida Fresh, USDA Approved, USDA Organic",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Attach proof of registration",
                  style: TextStyle(fontSize: 14, color: Colors.black),
                ),
                const SizedBox(width: 10,),
                GestureDetector(
                  onTap: _pickFile,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    padding: const EdgeInsets.all(15),
                    child: const Icon(
                      Icons.camera_alt_outlined,
                      color: Colors.orange,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(title:Text(
                selectedFile ?? '',
                style: const TextStyle(color: Colors.black),
              ),
              trailing: selectedFile != null?
                IconButton(
                icon: const Icon(Icons.close),
        onPressed: () {
          setState(() {
            selectedFile = null;
            userData.updateRegistrationProof('');
          });
        },
      ):null,
              )
            ),
           Center(child: warning==""?null:Text(warning,style: const TextStyle(fontSize: 12,color: Colors.red),),),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(onPressed: () {
                  Navigator.pop(context);
                }, icon: const Icon(Icons.arrow_back)),
                SizedBox(
                  width: 150,
                  child: ElevatedButton(
                    onPressed: () {
                      submission();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFDD6C48),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text(
                      'Submit',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
