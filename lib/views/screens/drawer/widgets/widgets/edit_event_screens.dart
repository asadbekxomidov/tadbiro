import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tadbiro/models/tadbiro.dart';
import 'package:tadbiro/services/geocodeing_services.dart';
import 'package:tadbiro/services/my_event_firebase_services.dart';
import 'package:tadbiro/views/screens/drawer/my_tadbiro_screen.dart';

class EditEventWidgets extends StatefulWidget {
  final EventModel event;

  EditEventWidgets({required this.event});

  @override
  State<EditEventWidgets> createState() => _EditEventWidgetsState();
}

class _EditEventWidgetsState extends State<EditEventWidgets> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  late GoogleMapController myController;
  TimeOfDay? selectedTime;
  DateTime? selectedDate;
  String? locationName;
  LatLng? latLng;
  final currentUser = FirebaseAuth.instance.currentUser!.uid;
  final eventsFirebaseServices = MyEventFirebaseServices();
  final formKey = GlobalKey<FormState>();
  File? imageFile;
  LatLng curPlace = const LatLng(41.2856806, 69.2034646);
  MapType mapType = MapType.normal;
  Set<Marker> markers = {};
  // int amout = 0;

  @override
  void initState() {
    super.initState();
    titleController.text = widget.event.title;
    descriptionController.text = widget.event.description;
    latLng = LatLng(widget.event.lat.toDouble(), widget.event.lng.toDouble());
  }

  void onMapCreated(GoogleMapController controller) {
    myController = controller;
  }

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

  void submit() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
    }

    if (selectedDate != null && selectedTime != null && latLng != null) {
      try {
        await eventsFirebaseServices.editEvent(
          widget.event.id,
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
          locationName ?? "",
          // amout,
        );
        Navigator.pop(context);
      } catch (e) {
        print("Error editing event: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (ctx) => MyTadbiroScreen()),
            );
          },
          icon: Icon(Icons.arrow_back_ios_new, size: 22, color: Colors.black),
        ),
        centerTitle: true,
        title: Text("Tadbirni Tahrirlash"),
      ),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(5),
                height: 70,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.amber, width: 3),
                ),
                child: TextFormField(
                  controller: titleController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Tadbir Nomi",
                    hintStyle:
                        TextStyle(fontWeight: FontWeight.w400, fontSize: 18),
                  ),
                ),
              ),
              SizedBox(height: 10),
              InkWell(
                onTap: () => _selectDate(context),
                child: Container(
                  padding: EdgeInsets.all(20),
                  height: 80,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: Colors.grey.shade500),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      selectedDate != null
                          ? Text(
                              "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}")
                          : Text('Sanani Tanlang'),
                      Icon(Icons.calendar_today),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
              InkWell(
                onTap: () => _selectTime(context),
                child: Container(
                  padding: EdgeInsets.all(20),
                  height: 80,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: Colors.grey.shade500),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      selectedTime != null
                          ? Text(selectedTime!.format(context))
                          : SizedBox(width: 1),
                      Icon(Icons.access_time),
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
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.amber, width: 3),
                ),
                child: TextFormField(
                  controller: descriptionController,
                  expands: true,
                  minLines: null,
                  maxLines: null,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Tadbir Haqida Ma'lumot",
                    hintStyle:
                        TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Text('Rasm yoki Video yuklang'),
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
              if (imageFile != null)
                SizedBox(
                  height: 200,
                  width: double.infinity,
                  child: Image.file(
                    imageFile!,
                    fit: BoxFit.cover,
                  ),
                ),
              SizedBox(height: 20),
              Container(
                width: double.infinity,
                height: 300.h,
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.amber),
                ),
                child: Stack(
                  children: [
                    GoogleMap(
                      gestureRecognizers: Set()
                        ..add(Factory<EagerGestureRecognizer>(
                            () => EagerGestureRecognizer())),
                      onMapCreated: onMapCreated,
                      initialCameraPosition:
                          CameraPosition(target: latLng ?? curPlace, zoom: 15),
                      markers: markers,
                      mapType: mapType,
                      onTap: (LatLng location) async {
                        GeocodingService geocodingService = GeocodingService(
                            apiKey: "cc8ca831-bc74-4ae4-ad76-186813085a45");
                        String? locationNameLocal =
                            await geocodingService.getAddressFromCoordinates(
                          location.latitude,
                          location.longitude,
                        );
                        setState(() {
                          latLng = location;
                          locationName = locationNameLocal;
                          markers.clear();
                          markers.add(
                            Marker(
                              markerId: MarkerId("tadbiro"),
                              position: location,
                              icon: BitmapDescriptor.defaultMarker,
                            ),
                          );
                        });
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              InkWell(
                onTap: () {
                  submit();
                },
                child: Container(
                  height: 70,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      border:
                          Border.all(color: Colors.amber.shade900, width: 3),
                      color: Colors.amber.shade100,
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                    child: Text(
                      'Tadbirni Tahrirlash',
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
    );
  }
}
