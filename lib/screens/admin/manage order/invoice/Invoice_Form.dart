// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
//
// class InvoiceForm extends StatefulWidget {
//   const InvoiceForm({super.key});
//
//   @override
//   _InvoiceFormState createState() => _InvoiceFormState();
// }
//
// class _InvoiceFormState extends State<InvoiceForm> {
//   final TextEditingController _controller = TextEditingController();
//
//   Future<void> _selectDate(BuildContext context) async {
//     final DateTime? selectedDate = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2101),
//     );
//
//     if (selectedDate != null && selectedDate != DateTime.now()) {
//       setState(() {
//         _controller.text = DateFormat('yyyy-MM-dd').format(selectedDate);
//       });
//     }
//   }
//
//   Future<void> _pickPDF() async {
//     try {
//       FilePickerResult? result = await FilePicker.platform.pickFiles(
//         type: FileType.custom,
//         allowedExtensions: ['pdf'],
//       );
//
//       if (result != null && result.files.isNotEmpty) {
//         PlatformFile file = result.files.first;
//         print('Selected file path: ${file.path}');
//       } else {
//         print('No file selected');
//       }
//     } catch (e) {
//       print('Error picking file: $e');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         backgroundColor: Colors.grey.shade50,
//         body:  NestedScrollView(
//           floatHeaderSlivers: true,
//           headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
//             return [
//               SliverAppBar(
//                 floating: true,
//                 snap: true,
//                 backgroundColor: Colors.grey.shade50,
//                 leading: IconButton(
//                   icon: const Icon(Icons.arrow_back),
//                   onPressed: () {},
//                 ),
//               )
//             ];
//           },
//           // appBar: AppBar(
//           //   backgroundColor: Colors.white,
//           //   leading: IconButton(
//           //     icon: const Icon(Icons.arrow_back),
//           //     onPressed: () {},
//           //   ),
//           // ),
//           body: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: SingleChildScrollView(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Center(
//                     child: Text(
//                       'Invoice Form',
//                       style: TextStyle(
//                         color: Colors.black,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 25,
//                         decoration: TextDecoration.underline,
//                       ),
//                       textAlign: TextAlign.center,
//                     ),
//                   ),
//                   const Text('From :',
//                       style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
//                   TextField(
//                     decoration: InputDecoration(
//                       hintText: 'Customer Name.........',
//                       filled: true,
//                       fillColor: Colors.white,
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10.0),
//                       ),
//                       enabledBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10.0),
//                         borderSide: BorderSide(
//                           color: Colors.grey[300]!,
//                           width: 2.0,
//                         ),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10.0),
//                       ),
//                       contentPadding: const EdgeInsets.symmetric(
//                           vertical: 10.0,
//                           horizontal: 15.0),
//                     ),
//                   ),
//                   const SizedBox(height: 10),
//                   TextField(
//                     decoration: InputDecoration(
//                       hintText: 'Customer Address.........',
//                       filled: true,
//                       fillColor: Colors.white,
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10.0),
//                       ),
//                       enabledBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10.0),
//                         borderSide: BorderSide(
//                             color: Colors.grey[300]!,
//                             width: 2.0),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10.0),
//                       ),
//                       contentPadding: const EdgeInsets.symmetric(
//                           vertical: 10.0,
//                           horizontal: 15.0),
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   const Text('To :',
//                       style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
//                   TextField(
//                     decoration: InputDecoration(
//                       hintText: 'Company Name.........',
//                       filled: true,
//                       fillColor: Colors.white,
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10.0),
//                       ),
//                       enabledBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10.0),
//                         borderSide: BorderSide(
//                             color: Colors.grey[300]!,
//                             width: 2.0),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10.0),
//                       ),
//                       contentPadding: const EdgeInsets.symmetric(
//                           vertical: 10.0,
//                           horizontal: 15.0),
//                     ),
//                   ),
//                   const SizedBox(height: 10),
//                   TextField(
//                     decoration: InputDecoration(
//                       hintText: 'Company Address.........',
//                       filled: true,
//                       fillColor: Colors.white,
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10.0),
//                       ),
//                       enabledBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10.0),
//                         borderSide: BorderSide(
//                             color: Colors.grey[300]!,
//                             width: 2.0),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10.0),
//                       ),
//                       contentPadding: const EdgeInsets.symmetric(
//                           vertical: 10.0,
//                           horizontal: 15.0),
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   const Text('Items Details :',
//                       style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
//                   const SizedBox(height: 10),
//
//                   const SizedBox(height: 10),
//                   const TextField(
//                     decoration: InputDecoration(
//                       hintText: 'Item Name',
//                       filled: false,
//                       enabledBorder: UnderlineInputBorder(
//                         borderSide: BorderSide(
//                           width: 2.0,
//                           color: Colors.black,
//                         ),
//                       ),
//                       focusedBorder: UnderlineInputBorder(
//                         borderSide: BorderSide(
//                           width: 2.0,
//                           color: Colors.black,
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 10),
//                   const TextField(
//                     decoration: InputDecoration(
//                       hintText: 'Quantity',
//                       filled: false,
//                       enabledBorder: UnderlineInputBorder(
//                         borderSide: BorderSide(
//                           width: 2.0,
//                           color: Colors.black,
//                         ),
//                       ),
//                       focusedBorder: UnderlineInputBorder(
//                         borderSide: BorderSide(
//                           width: 2.0,
//                           color: Colors.black,
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 10),
//                   const TextField(
//                     decoration: InputDecoration(
//                       hintText: 'Gst',
//                       filled: false,
//                       enabledBorder: UnderlineInputBorder(
//                         borderSide: BorderSide(
//                           width: 2.0,
//                           color: Colors.black,
//                         ),
//                       ),
//                       focusedBorder: UnderlineInputBorder(
//                         borderSide: BorderSide(
//                           width: 2.0,
//                           color: Colors.black,
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 10),
//                   const TextField(
//                     decoration: InputDecoration(
//                       hintText: 'HSN code',
//                       filled: false,
//                       enabledBorder: UnderlineInputBorder(
//                         borderSide: BorderSide(
//                           width: 2.0,
//                           color: Colors.black,
//                         ),
//                       ),
//                       focusedBorder: UnderlineInputBorder(
//                         borderSide: BorderSide(
//                           width: 2.0,
//                           color: Colors.black,
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 10),
//                   const TextField(
//                     decoration: InputDecoration(
//                       hintText: 'Discount',
//                       filled: false,
//                       enabledBorder: UnderlineInputBorder(
//                         borderSide: BorderSide(
//                           width: 2.0,
//                           color: Colors.black,
//                         ),
//                       ),
//                       focusedBorder: UnderlineInputBorder(
//                         borderSide: BorderSide(
//                           width: 2.0,
//                           color: Colors.black,
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 10),
//                   const TextField(
//                     decoration: InputDecoration(
//                       hintText: 'Unit price',
//                       filled: false,
//                       enabledBorder: UnderlineInputBorder(
//                         borderSide: BorderSide(
//                           width: 2.0,
//                           color: Colors.black,
//                         ),
//                       ),
//                       focusedBorder: UnderlineInputBorder(
//                         borderSide: BorderSide(
//                           width: 2.0,
//                           color: Colors.black,
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 24),
//                   Row(
//                     children: [
//                       Container(
//                         width: 196,
//                         height: 52,
//                         alignment: Alignment.center,
//                         decoration: BoxDecoration(
//                           border: Border.all(
//                               color: Colors.grey.shade300,
//                               width: 2.0),
//                           borderRadius: BorderRadius.circular(0),
//                         ),
//                         child: const Text(
//                           'Subtotal: ₹ 0.000',
//                           style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                           ),
//                           textAlign: TextAlign.center,
//                         ),
//                       ),
//                       const SizedBox(width: 30),
//                       GestureDetector(
//                         onTap: () {
//                           // Handle the tap event here
//                           print('Icon tapped');
//                         },
//                         child: Container(
//                           width: 70,
//                           height: 50,
//                           alignment: Alignment.center,
//                           decoration: BoxDecoration(
//                             border: Border.all(
//                               color: Colors.grey.shade300,
//                               width: 2.0,
//                             ),
//                             borderRadius: BorderRadius.circular(0),
//                           ),
//                           child: const Icon(
//                             Icons.edit,
//                             color: Colors.black,
//                             size: 28,
//                           ),
//                         ),
//                       )
//                     ],
//                   ),
//                   const SizedBox(height: 10),
//                   Center(
//                     child: InkWell(
//                       onTap: () {
//                         print('PDF icon clicked');
//                         _pickPDF(); // Call the PDF picker function
//                       },
//                       child: Container(
//                         width: 150,
//                         height: 50,
//                         alignment: Alignment.center,
//                         decoration: BoxDecoration(
//                           border: Border.all(color: Colors.grey.shade300, width: 2.0),
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                         child: const Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Text(
//                               'Get PDF',
//                               style: TextStyle(
//                                 color: Colors.black,
//                                 fontSize: 16,
//                               ),
//                             ),
//                             SizedBox(width: 8),
//                             Icon(
//                               Icons.picture_as_pdf,
//                               color: Colors.black,
//                               size: 28,
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   )
//                 ],
//               ),
//             ),
//           ),
//         ));
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../../utils/widgets/admin_app_bar.dart';

class InvoiceForm extends StatefulWidget {
  InvoiceForm({super.key});

  @override
  State<InvoiceForm> createState() => _InvoiceFormState();
}

late Size size;

class _InvoiceFormState extends State<InvoiceForm> {
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AdminAppBar(
        title: 'Invoice Form',
        menuIcon: Icons.arrow_back,
        onMenuTap: () {
          Get.back(); // This opens the drawer
        },
      ),
      // appBar: SalesmanAppBar(
      //   title: 'Invoice Form',
      // ),
      body: Padding(
        padding: const EdgeInsets.only(right: 15, left: 15),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("From :",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                const TextField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Customer Name")),
                const SizedBox(height: 12),
                const TextField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Customer Address")),
                const SizedBox(height: 20),
                const Text("To :",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                const TextField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Company Name")),
                const SizedBox(height: 12),
                const TextField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Company Address")),
                const SizedBox(height: 20),
                const Text("Items Details :",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Item Name",
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text("Add"),
                      style: ElevatedButton.styleFrom(
                          minimumSize: const Size(40, 48)),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const TextField(
                    decoration: InputDecoration(hintText: "Quantity")),
                const TextField(decoration: InputDecoration(hintText: "Gst")),
                const TextField(
                    decoration: InputDecoration(hintText: "HSN code")),
                const TextField(
                    decoration: InputDecoration(hintText: "Discount")),
                const TextField(
                    decoration: InputDecoration(hintText: "Unit price")),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Total",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Row(
                      children: [
                        const Text(":  ₹ 0.000",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(width: 8),
                        IconButton(
                            onPressed: () {}, icon: const Icon(Icons.edit))
                      ],
                    )
                  ],
                ),
                const SizedBox(height: 16),
                Center(
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.download),
                    label: const Text("Download PDF"),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
