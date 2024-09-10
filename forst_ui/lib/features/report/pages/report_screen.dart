import 'dart:io';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/strings/constants.dart';
import '../../../core/utils/snack_bar_message.dart';
import '../entities/category_model.dart';
import '../repositories/LocationHandler.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  ReportScreenState createState() => ReportScreenState();
}

class ReportScreenState extends State<ReportScreen> {
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController titleController = TextEditingController();

  String? address;
  LatLng userPosition = const LatLng(0, 0);
  LatLng actionPosition = const LatLng(0, 0);
  LatLng markedPosition = const LatLng(0, 0);
  File? _image;
  final ImagePicker _picker = ImagePicker();
  late GoogleMapController mapController;
  MapType _mapType = MapType.satellite;
  Category? _category = Category.FIRE;
  Set<Marker> markers = {};
  bool _isLoading = false;


  Future<void> _pickImage() async {
    setState(() {
      _isLoading = true;
    });
    final pickedFile = await _picker.pickImage(source: ImageSource.camera,preferredCameraDevice: CameraDevice.rear);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
      _isLoading = false;
    });
  }


  static Map<String?, dynamic>? decodeJwt(String? token) {
    if (token == null) return null;
    try {
      final jwt = JWT.decode(token);
      return jwt.payload;
    } catch (e) {
      print("Error decoding JWT: $e");
      return null;
    }
  }

  Future<http.MultipartFile?> createMultipartFile() async {
    if (_image != null) {
      return await http.MultipartFile.fromPath('image', _image!.path);
    }
    return null;
  }

  void report(String description, String title) async {
    try {
      if (description.isEmpty || _image == null || title.isEmpty) {
        SnackBarMessage().showErrorSnackBar(
            message: "All fields are mandatory", context: context);
        return;
      }

      if (actionPosition == const LatLng(0, 0)) {
        actionPosition = userPosition;
      }

      address = await LocationHandler.getAddressFromLatLng(actionPosition);
      final prefs = await SharedPreferences.getInstance();
      String? codedToken = prefs.getString('token');
      var token = decodeJwt(codedToken);
      String? email = token?['sub'];

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$apiUrl/reports/create'),
      );

      request.fields['category'] = _category!.name;
      request.fields['description'] = description;
      request.fields['title'] = title;
      request.fields['address'] = address.toString();
      request.fields['reporterId'] = email!;
      request.fields['lng'] = actionPosition.longitude.toString();
      request.fields['lat'] = actionPosition.latitude.toString();

      if (_image != null) {
        request.files
            .add(await http.MultipartFile.fromPath('image', _image!.path));
      }

      var response = await request.send();

      if (response.statusCode == 201) {
        SnackBarMessage().showSuccessSnackBar(
            message: "Report submitted successfully!", context: context);
      } else {
        SnackBarMessage().showErrorSnackBar(
            message: "Failed to submit report", context: context);
      }
    } catch (e) {
      print(e.toString());
      SnackBarMessage().showErrorSnackBar(
          message: "An error occurred. Please try again later.",
          context: context);
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void addMarker(LatLng latLng) {

    setState(() {
      markers.clear();
      markers.add(
        Marker(
          markerId: const MarkerId("tapped_marker"),
          position: latLng,
          onTap: () {
            setState(() {
              markedPosition = latLng;
              actionPosition = latLng;
            });
          },
        ),
      );
      actionPosition=latLng;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Report"),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      backgroundColor: Colors.grey[200],
      body: Stack(
        children: <Widget>[
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 300,
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              markers: markers,
              mapType: _mapType,
              initialCameraPosition:
                  const CameraPosition(target: LatLng(44, 444), zoom: 11.0),
              onTap: addMarker,
            ),
          ),
          Positioned(
            right: 10,
            top: 210,
            child: FloatingActionButton(
              onPressed: () async {
                Position? position =
                    await LocationHandler.getCurrentPosition(context);
                mapController.animateCamera(
                  CameraUpdate.newCameraPosition(
                    CameraPosition(
                      target: LatLng(position!.latitude, position.longitude),
                      zoom: 14.0,
                    ),
                  ),
                );
                markers.add(
                  Marker(
                    markerId: const MarkerId("my_location"),
                    position: LatLng(position.latitude, position.longitude),
                    infoWindow: const InfoWindow(title: "My position"),
                  ),
                );
                setState(() {
                  userPosition = LatLng(position.latitude, position.longitude);
                });
              },
              backgroundColor: Colors.deepPurpleAccent,
              child: const Icon(
                Icons.my_location,
                size: 24,
                color: Colors.white,
              ),
            ),
          ),
          Positioned(
            right: 10,
            top: 100,
            child: FloatingActionButton(
              backgroundColor: Colors.deepPurpleAccent,
              onPressed: () {
                setState(() {
                  _mapType = _mapType == MapType.normal
                      ? MapType.satellite
                      : MapType.normal; // Toggle between normal and satellite
                });
              },
              child: const Icon(
                Icons.satellite_rounded,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
          Positioned(
            top: 300,
            left: 0,
            right: 0,
            bottom: 0,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.deepPurpleAccent,
                        borderRadius:
                            BorderRadius.circular(20), // Rounded corners
                      ),
                      child: Center(
                        child: Text(
                          _image == null ? "Pick Image" : "Change Image",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (_image != null)
                    Container(
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.deepPurpleAccent,
                          width: 4, // Border width
                        ),
                      ),
                      child: SizedBox(
                        height: 200,
                        width: MediaQuery.of(context).size.width,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.file(
                            _image!,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(height: 20),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Title is mandatory';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: "Title",
                      labelText: "Title",
                      labelStyle: const TextStyle(fontSize: 25),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Colors.deepPurpleAccent, width: 3.5),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Colors.deepPurple, width: 5),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    controller: titleController,
                  ),
                  const SizedBox(height: 20),
                  ListTile(
                    title: const Text(
                      "Fire",
                      style: TextStyle(
                          fontSize: 30,
                          color: Colors.deepPurpleAccent,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Arial Black"),
                    ),
                    leading: Radio<Category>(
                      value: Category.FIRE,
                      groupValue: _category,
                      onChanged: (Category? value) {
                        setState(() {
                          _category = value;
                        });
                      },
                    ),
                  ),
                  ListTile(
                    title: const Text(
                      "Tree Cutting",
                      style: TextStyle(
                          fontSize: 30,
                          color: Colors.deepPurpleAccent,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Arial Black"),
                    ),
                    leading: Radio<Category>(
                      value: Category.TREE_CUTTING,
                      groupValue: _category,
                      onChanged: (Category? value) {
                        setState(() {
                          _category = value;
                        });
                      },
                    ),
                  ),
                  ListTile(
                    title: const Text(
                      "Trash",
                      style: TextStyle(
                          fontSize: 30,
                          color: Colors.deepPurpleAccent,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Arial Black"),
                    ),
                    leading: Radio<Category>(
                      value: Category.TRASH,
                      groupValue: _category,
                      onChanged: (Category? value) {
                        setState(() {
                          _category = value;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    maxLines: 5,
                    controller: descriptionController,
                    decoration: InputDecoration(
                      hintText:
                          "Please write a detailed description here to help us out",
                      labelText: "Description",
                      labelStyle: const TextStyle(fontSize: 25),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Colors.deepPurpleAccent, width: 3.5),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.deepPurple,
                          width: 5,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      report(descriptionController.text, titleController.text);
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.deepPurple,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      backgroundColor: Colors.deepPurpleAccent,
                    ),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: const Text(
                      'Submit Report',
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.black
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
