import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_live_motion/flutter_live_motion.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  final _flutterLiveMotionPlugin = FlutterLiveMotion();
  String _status = 'Idle';
  
  String? _imagePath;
  String? _videoPath;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    String platformVersion;
    try {
      platformVersion =
          await _flutterLiveMotionPlugin.getPlatformVersion() ?? 'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _imagePath = image.path;
          _status = 'Image selected: ${image.path.split('/').last}';
        });
      }
    } catch (e) {
      setState(() {
        _status = 'Error picking image: $e';
      });
    }
  }

  Future<void> _pickVideo() async {
    try {
      final XFile? video = await _picker.pickVideo(source: ImageSource.gallery);
      if (video != null) {
        setState(() {
          _videoPath = video.path;
          _status = 'Video selected: ${video.path.split('/').last}';
        });
      }
    } catch (e) {
      setState(() {
        _status = 'Error picking video: $e';
      });
    }
  }

  Future<void> _generateLivePhoto() async {
    if (_imagePath == null || _videoPath == null) {
      setState(() {
        _status = 'Please select both image and video first.';
      });
      return;
    }

    // Check if Android image is JPG
    if (Platform.isAndroid) {
      if (!_imagePath!.toLowerCase().endsWith('.jpg') && !_imagePath!.toLowerCase().endsWith('.jpeg')) {
        setState(() {
          _status = 'Warning: Android Motion Photos require JPG images. Selected: ${_imagePath!.split('.').last}';
        });
        // We continue anyway, but it might fail in the plugin if it's not a valid JPEG structure
      }
    }

    setState(() {
      _status = 'Generating...';
    });

    try {
      final result = await _flutterLiveMotionPlugin.generate(
        imagePath: _imagePath!,
        videoPath: _videoPath!,
      );

      setState(() {
        if (Platform.isIOS) {
          _status = result == true 
              ? 'Success! Saved to Photos Library.' 
              : 'Failed to save to Library.';
        } else {
          _status = 'Success! Saved to: $result';
        }
      });
    } catch (e) {
      setState(() {
        _status = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Live/Motion Photo Plugin Demo'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Running on: $_platformVersion',
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              
              // Platform Info
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.blue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  Platform.isIOS 
                      ? 'iOS Mode: Generates Live Photo and saves to Photos App.'
                      : 'Android Mode: Generates Motion Photo (JPG+MP4) in cache.',
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 30),

              // Image Selection
              ElevatedButton.icon(
                onPressed: _pickImage,
                icon: const Icon(Icons.image),
                label: const Text('Pick Image (JPG)'),
              ),
              if (_imagePath != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    'Selected Image: ${_imagePath!.split('/').last}',
                    style: const TextStyle(fontSize: 12, color: Colors.green),
                    textAlign: TextAlign.center,
                  ),
                ),
              const SizedBox(height: 20),

              // Video Selection
              ElevatedButton.icon(
                onPressed: _pickVideo,
                icon: const Icon(Icons.videocam),
                label: const Text('Pick Video (MOV/MP4)'),
              ),
              if (_videoPath != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    'Selected Video: ${_videoPath!.split('/').last}',
                    style: const TextStyle(fontSize: 12, color: Colors.green),
                    textAlign: TextAlign.center,
                  ),
                ),
              const SizedBox(height: 40),

              // Generate Button
              ElevatedButton(
                onPressed: (_imagePath != null && _videoPath != null) 
                    ? _generateLivePhoto 
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('GENERATE LIVE PHOTO'),
              ),
              
              const SizedBox(height: 20),
              
              // Status
              Text(
                'Status: $_status',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: _status.startsWith('Error') ? Colors.red : Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
