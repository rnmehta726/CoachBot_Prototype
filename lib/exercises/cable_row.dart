import 'dart:math';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

import '../vision_detector_views/painters/pose_painter.dart';
import '../pose_detector/pose_detector.dart';

class CableRow extends StatefulWidget {
  final List<CameraDescription> cameras;
  final String exercise;

  CableRow(this.cameras, this.exercise);
  @override
  State<StatefulWidget> createState() => _CableRowState();
}

class _CableRowState extends State<CableRow> {
  CustomPaint? _customPaint;
  String? _text;
  bool _canProcess = true;
  bool _isBusy = false;
  bool _up = true;
  int _reps = 0;
  bool _good = false;
  int bad = 0;
  final PoseDetector _poseDetector =
      PoseDetector(options: PoseDetectorOptions());

  @override
  Widget build(BuildContext context) {
    return PoseDetectorWidget(
        exercise: 'Cable Row',
        onImage: (inputImage) {
          processImage(inputImage);
        },
        customPaint: _customPaint,
        reps: _reps,
        bad: bad,
    );
  }

  Future<void> processImage(InputImage inputImage) async {
    if (!_canProcess) return;
    if (_isBusy) return;
    _isBusy = true;
    // setState(() {
    //   _text = '';
    // });
    final poses = await _poseDetector.processImage(inputImage);

    Map<String, double> angles = {};

    double calcAngle(PoseLandmark loc1, PoseLandmark loc2, PoseLandmark loc3) {
      // calculate angle between two vectors A(loc1-loc2) and B(loc2-loc3)
      double angle = acos(((loc2.x - loc1.x) * (loc3.x - loc2.x) +
              (loc2.y - loc1.y) * (loc3.y - loc2.y)) /
          (sqrt(pow((loc2.x - loc1.x), 2) + pow((loc2.y - loc1.y), 2)) *
              sqrt(pow((loc3.x - loc2.x), 2) + pow((loc3.y - loc2.y), 2))));

      // convert radians to degrees
      angle = angle * 180 / pi;

      // reflect the angles across 90 (bc 100 degrees is actually 80 etc.)
      if (angle > 90) {
        double tmp = angle - 90;
        angle = 90 - tmp;
      } else {
        double tmp = 90 - angle;
        angle = 90 + tmp;
      }

      return angle;
    }

    double calcSlope(PoseLandmark loc1, PoseLandmark loc2) {
      return (loc2.y - loc1.y) / (loc2.x - loc1.x);
    }

    if (poses.isNotEmpty) {
      angles['rightElbow'] = calcAngle(
          poses[0].landmarks[PoseLandmarkType.rightShoulder]!,
          poses[0].landmarks[PoseLandmarkType.rightElbow]!,
          poses[0].landmarks[PoseLandmarkType.rightWrist]!);
      angles['leftElbow'] = calcAngle(
          poses[0].landmarks[PoseLandmarkType.leftShoulder]!,
          poses[0].landmarks[PoseLandmarkType.leftElbow]!,
          poses[0].landmarks[PoseLandmarkType.leftWrist]!);
      angles['rightBack'] = calcAngle(
        poses[0].landmarks[PoseLandmarkType.rightShoulder]!,
        poses[0].landmarks[PoseLandmarkType.rightHip]!,
        poses[0].landmarks[PoseLandmarkType.rightKnee]!,
      );
      angles['leftBack'] = calcAngle(
        poses[0].landmarks[PoseLandmarkType.leftShoulder]!,
        poses[0].landmarks[PoseLandmarkType.leftHip]!,
        poses[0].landmarks[PoseLandmarkType.leftKnee]!,
      );

      if(angles['rightBack']! > 110 && angles['rightElbow']!>100){
        bad++;
      }
      // down 180-170
      // up 70
      if (angles['rightElbow']! > 150.0) {
        if (!_up) _up = true;
        _good = true;
      } else if (angles['rightElbow']! < 100) {
        if (_up) {
          _up = false;
          _reps += 1;
        }
        _good = true;
      } else {
        _good = false;
      }

      // dont think we need much feedback for this
    }

    if (inputImage.inputImageData?.size != null &&
        inputImage.inputImageData?.imageRotation != null &&
        poses.isNotEmpty) {
      // pass in if the person is good position and if the view is from side
      final painter = PosePainter(poses[0], inputImage.inputImageData!.size,
          inputImage.inputImageData!.imageRotation, _good, true, widget.exercise);
      _customPaint = CustomPaint(painter: painter);
    } else {
      _text = 'No poses found';
    }

    _isBusy = false;
    if (mounted) {
      setState(() {});
    }
  }
}
