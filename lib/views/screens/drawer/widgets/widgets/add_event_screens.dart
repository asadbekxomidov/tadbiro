import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tadbiro/services/geocodeing_services.dart';
import 'package:tadbiro/services/my_event_firebase_services.dart';
import 'package:tadbiro/views/screens/drawer/my_tadbiro_screen.dart';

class AddEventWidgets extends StatefulWidget {
  const AddEventWidgets({super.key});

  @override
  State<AddEventWidgets> createState() => _AddEventWidgetsState();
}

class _AddEventWidgetsState extends State<AddEventWidgets> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  // int amout = 0;

  late GoogleMapController myController;
  final textController = TextEditingController();
  Map<PolylineId, Polyline> polylines = {};
  TimeOfDay? selectedTime;
  DateTime? selectedDate;
  String? locationName;
  // double? lat;
  // double? lng;
  LatLng curPlace = const LatLng(41.2856806, 69.2034646);
  MapType mapType = MapType.normal;
  Set<Marker> markers = {};
  LatLng? latLng;
  final currentUser = FirebaseAuth.instance.currentUser!.uid;

  void onMapCreated(GoogleMapController controller) {
    myController = controller;
  }

  bool isLoading = false;
  final eventsFirebaseServies = MyEventFirebaseServices();
  final formKey = GlobalKey<FormState>();

  void sumbit() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
    }
    if (selectedDate != null && selectedTime != null && latLng != null) {
      try {
        await eventsFirebaseServies.addEvent(
          currentUser,
          titleController.text,
          descriptionController.text,
          selectedDate.toString(),
          "${selectedTime!.hour}:${selectedTime!.minute}",
          imageFile,
          [],
          [],
          latLng!.latitude,
          latLng!.longitude,
          locationName!,
          // amout,
        );
        Navigator.pop(context);
      } catch (e) {
        print("Event qo'shishda xatolik: $e");
      }
    }
  }

  List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
    );
    if (pickedTime != null && pickedTime != selectedTime) {
      setState(() {
        selectedTime = pickedTime;
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(
        Duration(days: 1000),
      ),
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  File? imageFile;

  void openGallery() async {
    final imagePicker = ImagePicker();
    final XFile? pickedImage = await imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
      requestFullMetadata: false,
    );

    if (pickedImage != null) {
      setState(() {
        imageFile = File(pickedImage.path);
      });
    }
  }

  void openCamera() async {
    final imagePicker = ImagePicker();
    final XFile? pickedImage = await imagePicker.pickImage(
      source: ImageSource.camera,
      requestFullMetadata: false,
    );

    if (pickedImage != null) {
      setState(() {
        imageFile = File(pickedImage.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (ctx) => MyTadbiroScreen()));
          },
          icon: Icon(Icons.arrow_back_ios_new_rounded,
              size: 22, color: Colors.black),
        ),
        title: Text("Tadbir Qo'shish"),
        centerTitle: true,
      ),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: titleController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.person),
                    border: const OutlineInputBorder(),
                    labelText: "Nomi",
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12.5)),
                      borderSide: BorderSide(
                        color: Colors.amber.shade900,
                        width: 3.w,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12.5)),
                      borderSide: BorderSide(
                        color: Colors.amber.shade900,
                        width: 3.w,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isNotEmpty) {
                      return 'Nomni kiriting';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                InkWell(
                  onTap: () {
                    _selectDate(context);
                  },
                  child: Container(
                    padding: EdgeInsets.all(20),
                    height: 70,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: Colors.amber.shade900, width: 3.w)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        selectedDate != null
                            ? Text(
                                "${months[selectedDate!.month - 1]} ${selectedDate!.day} ${selectedDate!.year}")
                            : Text(
                                'Date',
                                style: TextStyle(fontSize: 16.h),
                              ),
                        Icon(Icons.calendar_month)
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10),
                InkWell(
                  onTap: () {
                    _selectTime(context);
                  },
                  child: Container(
                    padding: EdgeInsets.all(20),
                    height: 70,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border:
                            Border.all(color: Colors.amber.shade900, width: 3)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        selectedTime != null
                            ? Text(selectedTime!.format(context))
                            : Text('Time'),
                        Icon(Icons.watch_later_outlined)
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.all(5),
                  height: 120,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border:
                          Border.all(color: Colors.amber.shade900, width: 3)),
                  child: TextFormField(
                    style: TextStyle(fontSize: 14.h),
                    controller: descriptionController,
                    expands: true,
                    minLines: null,
                    maxLines: null,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Tadbir haqida ma'lumot",
                        hintStyle: TextStyle(
                            fontWeight: FontWeight.w300, fontSize: 14.h)),
                  ),
                ),
                SizedBox(height: 10.h),
                Text('Rasm yoki video yuklash'),
                SizedBox(height: 10.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: openCamera,
                      child: Container(
                        height: 100,
                        width: 140,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.amber.shade900,
                              width: 3.w,
                            )),
                        child: Center(
                          child: Icon(
                            Icons.camera_alt,
                            size: 40,
                            color: Colors.amber.shade900,
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: openGallery,
                      child: Container(
                        height: 100,
                        width: 140,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.amber.shade900,
                              width: 3.w,
                            )),
                        child: Center(
                          child: Icon(
                            Icons.image,
                            size: 40,
                            color: Colors.amber.shade900,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15.h),
                if (imageFile != null)
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    height: 200,
                    width: double.infinity,
                    child: Image.file(
                      imageFile!,
                      fit: BoxFit.cover,
                    ),
                  ),
                SizedBox(height: 20.h),
                Container(
                  width: double.infinity,
                  height: 300.h,
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.amber.shade900,
                        width: 3.w,
                      )),
                  child: Stack(
                    children: [
                      GoogleMap(
                        gestureRecognizers: Set()
                          ..add(Factory<EagerGestureRecognizer>(
                              () => EagerGestureRecognizer())),
                        onTap: (LatLng location) async {
                          GeocodingService geocodingService = GeocodingService(
                              apiKey: "cc8ca831-bc74-4ae4-ad76-186813085a45");
                          String? locationNameLocal =
                              await geocodingService.getAddressFromCoordinates(
                                  location.latitude, location.longitude);
                          setState(() {
                            latLng =
                                LatLng(location.latitude, location.longitude);
                            locationName = locationNameLocal;
                            markers.clear();
                            markers.add(
                              Marker(
                                markerId: const MarkerId("tadbiro"),
                                position: LatLng(
                                    location.latitude, location.longitude),
                                icon: BitmapDescriptor.defaultMarker,
                              ),
                            );
                          });
                        },
                        polylines: Set<Polyline>.of(polylines.values),
                        markers: markers,
                        mapType: mapType,
                        initialCameraPosition:
                            CameraPosition(target: curPlace, zoom: 10),
                        onMapCreated: onMapCreated,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10.h),
                InkWell(
                  onTap: () {
                    sumbit();
                  },
                  child: Container(
                    height: 70,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.amber.shade900,
                          width: 3.w,
                        ),
                        color: Colors.amber.shade100,
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(
                      child: Text(
                        "Qo'shish",
                        style: TextStyle(
                          fontSize: 18.h,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
