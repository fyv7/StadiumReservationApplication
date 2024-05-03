import 'package:flutter/material.dart';
import '../data/DatabaseHelper.dart';
import 'package:image_picker/image_picker.dart';
import '../data/ImageService.dart';
import '../data/stadium_model.dart';
import '../main.dart';
import 'dart:io';


class StadiumCreationUpdateScreen extends StatefulWidget {
  final bool isUpdate;
  final Stadium? stadium;

  const StadiumCreationUpdateScreen(
      {super.key, required this.isUpdate, this.stadium});

  @override
  State<StadiumCreationUpdateScreen> createState() =>
      _StadiumCreationUpdateScreenState();
}

class _StadiumCreationUpdateScreenState
    extends State<StadiumCreationUpdateScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _placeController = TextEditingController();
  final _playersNoController = TextEditingController();
  final _imageController = TextEditingController();
  final _ticketPriceController = TextEditingController();
  final _latitudeController = TextEditingController();
  final _longitudeController = TextEditingController();
  File? _selectedImage;
  final _imageNameController = TextEditingController(); // Controller for renaming the image
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
        // Set default image name based on the original file name
        _imageNameController.text = image.name.split('/').last;
      });
    }
  }
  Future<void> _uploadImage() async {
    if (_selectedImage != null && _imageNameController.text.isNotEmpty) {
      String fileName = '${_imageNameController.text}';
      try {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Uploading.. please wait')));

        // Use your existing ImageService or Firebase Storage logic here to upload the image
        String downloadUrl = await ImageService.uploadImage(_selectedImage!, fileName);

        // If upload is successful
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Upload successful! Image URL: $downloadUrl')));
      } catch (e) {
        // If an error occurs
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Upload failed: $e')));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please select an image and name it.')));
    }
  }


  @override
  void initState() {
    super.initState();
    if (widget.isUpdate && widget.stadium != null) {
      _nameController.text = widget.stadium!.stadiumData?.name ?? '';
      _placeController.text = widget.stadium!.stadiumData?.place ?? '';
      _playersNoController.text =
          widget.stadium!.stadiumData?.playersNumber.toString() ?? '';
      _imageController.text = widget.stadium!.stadiumData?.imagePath ?? '';
      _ticketPriceController.text =
          widget.stadium!.stadiumData?.ticketPrice.toString() ?? '';
      _latitudeController.text =
          widget.stadium!.stadiumData?.latitude.toString() ?? '';
      _longitudeController.text =
          widget.stadium!.stadiumData?.longitude.toString() ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create New Stadium")),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: <Widget>[
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Stadium Name',
                prefixIcon: Icon(Icons.stadium),
              ),
              keyboardType: TextInputType.text,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter stadium name';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _placeController,
              decoration: const InputDecoration(
                labelText: 'Location',
                prefixIcon: Icon(Icons.location_on),
              ),
              keyboardType: TextInputType.text,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the location';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _playersNoController,
              decoration: const InputDecoration(
                labelText: 'Players',
                prefixIcon: Icon(Icons.calendar_today),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the number of players';
                }
                if (int.tryParse(value) == null ||
                    (int.tryParse(value)!) <= 0) {
                  return 'Please enter a valid number';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _imageController,
              decoration: const InputDecoration(
                labelText: 'Image URL',
                prefixIcon: Icon(Icons.image),
              ),
              keyboardType: TextInputType.text,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an image URL';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _ticketPriceController,
              decoration: const InputDecoration(
                labelText: 'Ticket Price',
                prefixIcon: Icon(Icons.money),
              ),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a ticket price';
                }
                if ((double.tryParse(value)!) <= 0) {
                  return 'Please enter a valid price';
                }
                return null;
              },
            ),
            // Latitude TextFormField
            TextFormField(
              controller: _latitudeController,
              decoration: const InputDecoration(
                labelText: 'Latitude',
                prefixIcon: Icon(Icons.map),
              ),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the latitude';
                }

                return null;
              },
            ),

            // Longitude TextFormField
            TextFormField(
              controller: _longitudeController,
              decoration: const InputDecoration(
                labelText: 'Longitude',
                prefixIcon: Icon(Icons.map),
              ),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the longitude';
                }

                return null;
              },
            ),
            ElevatedButton(
                onPressed: _submitForm,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Icon(Icons.update),
                    SizedBox(width: 8,),
                    Text("Submit")],
                )),
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text('Add Image to firebase'),
            ),
            if (_selectedImage != null)
              Column(
                children: [
                  Image.file(_selectedImage!),
                  TextField(
                    controller: _imageNameController,
                    decoration: const InputDecoration(
                      label: Text.rich(
                        TextSpan(
                          text: 'Image Name(', // First part of the text
                          children: <TextSpan>[
                            TextSpan(
                              text: '**you need to remember the name/type for your stadium', // The part you want to style differently
                              style: TextStyle(color: Colors.red), // Styling for 'important'
                            ),
                            TextSpan(text: ')'), // Closing part of the text
                          ],
                        ),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _uploadImage,
                    child: const Text('click here to start uploading Image'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      StadiumData stadiumData = StadiumData(
        _imageController.text,
        _nameController.text,
        _placeController.text,
        int.tryParse(_playersNoController.text),
        double.tryParse(_ticketPriceController.text),
        double.tryParse(_latitudeController.text),
        double.tryParse(_longitudeController.text),
        0.0,
      );

      if (widget.isUpdate) {
        DatabaseHelper.updateStadiumData(
            widget.stadium!.key!, stadiumData, context);
      } else {
        DatabaseHelper.addNewStadium(stadiumData);
      }

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const MyHomePage(initialIndex: 1,)),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Stadium added successfully!')),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _placeController.dispose();
    _playersNoController.dispose();
    _imageController.dispose();
    _ticketPriceController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    super.dispose();
  }
}
