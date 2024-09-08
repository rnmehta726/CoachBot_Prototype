import 'package:flutter/material.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

import '../../util.dart';
import 'coordinates_translator.dart';

class PosePainter extends CustomPainter {
  PosePainter(this.pose, this.absoluteImageSize, this.rotation, this.correct, this.side, this.exercise);

  final Pose pose;
  final Size absoluteImageSize;
  final InputImageRotation rotation;
  final bool correct;
  // determines to draw only right side or entire body
  final bool side;
  final String exercise;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..color = correct ? Colors.green : Colors.red;

    // final leftPaint = Paint()
    //   ..style = PaintingStyle.stroke
    //   ..strokeWidth = 3.0
    //   ..color = Colors.yellow;
    //
    // final rightPaint = Paint()
    //   ..style = PaintingStyle.stroke
    //   ..strokeWidth = 3.0
    //   ..color = Colors.blueAccent;


    // pose.landmarks.forEach((_, landmark) {
    //   canvas.drawCircle(
    //       Offset(
    //         translateX(landmark.x, rotation, size, absoluteImageSize),
    //         translateY(landmark.y, rotation, size, absoluteImageSize),
    //       ),
    //       1,
    //       paint);
    // });

    void paintLine(
        PoseLandmarkType type1, PoseLandmarkType type2, Paint paintType) {
      final PoseLandmark joint1 = pose.landmarks[type1]!;
      final PoseLandmark joint2 = pose.landmarks[type2]!;
      canvas.drawLine(
          Offset(translateX(joint1.x, rotation, size, absoluteImageSize),
              translateY(joint1.y, rotation, size, absoluteImageSize)),
          Offset(translateX(joint2.x, rotation, size, absoluteImageSize),
              translateY(joint2.y, rotation, size, absoluteImageSize)),
          paintType);
    }

    switch(exercise){
      case(benchPress):
        paintLine(
            PoseLandmarkType.rightShoulder, PoseLandmarkType.rightElbow, paint);
        paintLine(
            PoseLandmarkType.rightElbow, PoseLandmarkType.rightWrist, paint);
        paintLine(
            PoseLandmarkType.rightShoulder, PoseLandmarkType.rightHip, paint);
        break;
      case(bicepCurl):
        paintLine(
            PoseLandmarkType.rightShoulder, PoseLandmarkType.rightElbow, paint);
        paintLine(
            PoseLandmarkType.rightElbow, PoseLandmarkType.rightWrist, paint);
        break;
      case(cableRow):
        paintLine(
            PoseLandmarkType.rightShoulder, PoseLandmarkType.rightElbow, paint);
        paintLine(
            PoseLandmarkType.rightElbow, PoseLandmarkType.rightWrist, paint);
        paintLine(
            PoseLandmarkType.rightShoulder, PoseLandmarkType.rightHip, paint);
        break;
      case(incBench):
        paintLine(
            PoseLandmarkType.rightShoulder, PoseLandmarkType.rightElbow, paint);
        paintLine(
            PoseLandmarkType.rightElbow, PoseLandmarkType.rightWrist, paint);
        paintLine(
            PoseLandmarkType.rightShoulder, PoseLandmarkType.rightHip, paint);
        paintLine(
            PoseLandmarkType.rightHip, PoseLandmarkType.rightKnee, paint);
        break;
      case(latPulldown):
        paintLine(
            PoseLandmarkType.rightShoulder, PoseLandmarkType.rightElbow, paint);
        paintLine(
            PoseLandmarkType.rightElbow, PoseLandmarkType.rightWrist, paint);
        paintLine(
            PoseLandmarkType.rightShoulder, PoseLandmarkType.rightHip, paint);
        break;
      case(legPress):
        paintLine(
            PoseLandmarkType.rightHip, PoseLandmarkType.rightKnee, paint);
        paintLine(
            PoseLandmarkType.rightKnee, PoseLandmarkType.rightAnkle, paint);
        break;
      case(shoulderPress):
        paintLine(
            PoseLandmarkType.rightShoulder, PoseLandmarkType.rightElbow, paint);
        paintLine(
            PoseLandmarkType.rightElbow, PoseLandmarkType.rightWrist, paint);
        paintLine(
            PoseLandmarkType.leftShoulder, PoseLandmarkType.leftElbow, paint);
        paintLine(
            PoseLandmarkType.leftElbow, PoseLandmarkType.leftWrist, paint);
        break;
      case(skullcrusher):
        paintLine(
            PoseLandmarkType.rightShoulder, PoseLandmarkType.rightElbow, paint);
        paintLine(
            PoseLandmarkType.rightElbow, PoseLandmarkType.rightWrist, paint);
        paintLine(
            PoseLandmarkType.rightShoulder, PoseLandmarkType.rightHip, paint);
        break;
      case(squat):
        paintLine(
            PoseLandmarkType.rightShoulder, PoseLandmarkType.rightHip, paint);
        paintLine(
            PoseLandmarkType.rightHip, PoseLandmarkType.rightKnee, paint);
        paintLine(
            PoseLandmarkType.rightKnee, PoseLandmarkType.rightAnkle, paint);
        break;
      case(tricepPulldown):
        paintLine(
            PoseLandmarkType.rightShoulder, PoseLandmarkType.rightElbow, paint);
        paintLine(
            PoseLandmarkType.rightElbow, PoseLandmarkType.rightWrist, paint);
        break;
    }
    // //Draw arms
    //
    // paintLine(
    //     PoseLandmarkType.rightShoulder, PoseLandmarkType.rightElbow, paint);
    // paintLine(
    //     PoseLandmarkType.rightElbow, PoseLandmarkType.rightWrist, paint);
    //
    // //Draw Body
    //
    // paintLine(
    //     PoseLandmarkType.rightShoulder, PoseLandmarkType.rightHip, paint);
    //
    // //Draw legs
    //
    // paintLine(
    //     PoseLandmarkType.rightHip, PoseLandmarkType.rightKnee, paint);
    // paintLine(
    //     PoseLandmarkType.rightKnee, PoseLandmarkType.rightAnkle, paint);
    //
    //
    // if (!side){
    //   paintLine(
    //       PoseLandmarkType.leftHip, PoseLandmarkType.leftKnee, paint);
    //   paintLine(
    //       PoseLandmarkType.leftKnee, PoseLandmarkType.leftAnkle, paint);
    //   paintLine(
    //       PoseLandmarkType.leftShoulder,PoseLandmarkType.rightShoulder, paint);
    //   paintLine(
    //       PoseLandmarkType.leftHip,PoseLandmarkType.rightHip, paint);
    //   paintLine(
    //       PoseLandmarkType.leftShoulder, PoseLandmarkType.leftHip, paint);
    //   paintLine(
    //       PoseLandmarkType.leftShoulder, PoseLandmarkType.leftElbow, paint);
    //   paintLine(
    //       PoseLandmarkType.leftElbow, PoseLandmarkType.leftWrist, paint);
    // }

  }

  @override
  bool shouldRepaint(covariant PosePainter oldDelegate) {
    return oldDelegate.absoluteImageSize != absoluteImageSize ||
        oldDelegate.pose != pose;
  }
}
