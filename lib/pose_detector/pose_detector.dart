import 'dart:math' as math;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:coach_bot/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:camera/camera.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import '../main.dart';
import '../util.dart';

typedef void Callback(List<dynamic> list, int h, int w);

class PoseDetectorWidget extends StatefulWidget {

  final String exercise;

  final Function(InputImage inputImage) onImage;
  final CustomPaint? customPaint;
  final int reps;
  final CameraLensDirection initialDirection;
  final int bad;

  PoseDetectorWidget(
      {required this.exercise,
      required this.onImage,
      required this.customPaint,
      required this.reps,
      this.bad = 0,
      this.initialDirection = CameraLensDirection.front});

  @override
  _PoseDetectorState createState() => _PoseDetectorState();
}

class _PoseDetectorState extends State<PoseDetectorWidget> {
  CameraController? controller;
  String toggleText = "Start";
  bool isChanged = true;
  List<int> repList = [];
  int _cameraIndex = 0;
  FirebaseAuth _auth = FirebaseAuth.instance;
  int sets = 0;

  @override
  void initState() {
    super.initState();

    if (cameras.any(
          (element) =>
      element.lensDirection == widget.initialDirection &&
          element.sensorOrientation == 90,
    )) {
      _cameraIndex = cameras.indexOf(
        cameras.firstWhere((element) =>
        element.lensDirection == widget.initialDirection &&
            element.sensorOrientation == 90),
      );
    } else {
      _cameraIndex = cameras.indexOf(
        cameras.firstWhere(
              (element) => element.lensDirection == widget.initialDirection,
        ),
      );
    }

    final camera = cameras[_cameraIndex];
    controller = CameraController(
      camera,
      ResolutionPreset.medium,
      enableAudio: false,
    );
    controller?.initialize().then((_) {
      if (!mounted) {
        return;
      }
      controller?.startImageStream(_processCameraImage);
      setState(() {});
    });
  }

  @override
  void dispose() {
    _stopLiveFeed();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null || !controller!.value.isInitialized) {
      return Container();
    }

    Size? tmp = MediaQuery.of(context).size;
    var screenH = 0.72 * math.max(tmp.height, tmp.width);
    var screenW = 0.72 * math.min(tmp.height, tmp.width);
    tmp = controller!.value.previewSize;
    var previewH = 0.72 * math.max(tmp!.height, tmp.width);
    var previewW = 0.72 * math.min(tmp.height, tmp.width);
    var screenRatio = screenH / screenW;
    var previewRatio = previewH / previewW;
    Size screen = MediaQuery.of(context).size;

    final size = MediaQuery.of(context).size;
    // calculate scale depending on screen and camera ratios
    // this is actually size.aspectRatio / (1 / camera.aspectRatio)
    // because camera preview size is received as landscape
    // but we're calculating for portrait orientation
    var scale = size.aspectRatio * controller!.value.aspectRatio;

    // to prevent scaling down, invert the value
    if (scale < 1) scale = 1 / scale;

    return Scaffold(
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      appBar: AppBar(
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        automaticallyImplyLeading: false,
        leading: InkWell(
          onTap: () async {
            Map<String, dynamic> data = await FirebaseFirestore.instance
                .collection("users")
                .doc(_auth.currentUser!.uid)
                .get()
                .then((snapshot) => snapshot.data()!);
            data['exercises'][widget.exercise] = {
              "reps": repList.length == 0 ? [0] : repList,
              "sets": sets,
              "weight": 0
            };
            if(widget.bad >= 30) {
              try{
                data['mistakes'][widget.exercise].insert(0,{
                  "reps": repList.length == 0 ? [0] : repList,
                  "sets": sets,
                  "weight": 0,
                  "time":DateTime.now().month.toString() + "/" + DateTime.now().day.toString() + "/" + DateTime.now().year.toString(),
                  "comment": comments[widget.exercise]![0]
                });
              } on NoSuchMethodError {
                data['mistakes'][widget.exercise] = [];
                data['mistakes'][widget.exercise].add({
                  "reps": repList.length == 0 ? [0] : repList,
                  "sets": sets,
                  "weight": 0,
                  "time":DateTime.now().month.toString() + "/" + DateTime.now().day.toString() + "/" + DateTime.now().year.toString(),
                  "comment": comments[widget.exercise]![0]
                });
              }
            }
            await FirebaseFirestore.instance
                .collection("users")
                .doc(_auth.currentUser!.uid)
                .update(data);
            Navigator.pop(context);
          },
          child: Icon(
            Icons.check_rounded,
            color: Colors.black,
            size: 24,
          ),
        ),
        title: Text(
          widget.exercise,
          style: FlutterFlowTheme.of(context).bodyText1.override(
                fontFamily: "Lexend Deca",
                color: Color(0xFF14181B),
                fontSize: 24,
                fontWeight: FontWeight.w500,
              ),
        ),
        actions: [],
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
          child: Column(
              children:[ConstrainedBox(
                constraints: BoxConstraints(
                    maxWidth: screenRatio > previewRatio
                        ? screenH / previewH * previewW
                        : screenW,
                    maxHeight: screenRatio > previewRatio
                        ? screenH
                        : screenW / previewW * previewH),
                child: Stack(
                    fit: StackFit.expand,
                    children: [
                      CameraPreview(controller!),

                      // CameraPreview(_controller!),
                      // Transform.scale(
                      //   scale: scale,
                      //   child: Center(
                      //     child: CameraPreview(_controller!),
                      //   ),
                      // ),
                      if (widget.customPaint != null && !isChanged) widget.customPaint!,
                    ]),
              ),  Wrap(
                spacing: 8,
                direction: Axis.horizontal,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(12, 12, 5, 8),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.44,
                            height: 100,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 4,
                                  color: Color(0x34090F13),
                                  offset: Offset(0, 2),
                                )
                              ],
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Padding(
                              padding:
                              EdgeInsetsDirectional.fromSTEB(12, 12, 12, 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Reps',
                                    style: FlutterFlowTheme.of(context).subtitle1,
                                  ),
                                  Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          12, 8, 12, 0),
                                      child: Text(countReps().toString(),
                                          style: FlutterFlowTheme.of(context)
                                              .title1))
                                ],
                              ),
                            ),
                          ))
                    ],
                  ),
                  Column(mainAxisSize: MainAxisSize.max, children: [
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(5, 12, 12, 8),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.44,
                        height: 100,
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).secondaryBackground,
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 4,
                              color: Color(0x34090F13),
                              offset: Offset(0, 2),
                            )
                          ],
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                            padding:
                            EdgeInsetsDirectional.fromSTEB(12, 12, 12, 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Sets",
                                  style: FlutterFlowTheme.of(context).subtitle1,
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      12, 9, 12, 0),
                                  child: FFButtonWidget(
                                    text: toggleText,
                                    onPressed: () {
                                      isChanged = !isChanged;
                                      setState(() {
                                        if (isChanged) {
                                          toggleText = "Start";
                                          repList.add(countReps());
                                          sets += 1;
                                        } else {
                                          toggleText = "Stop";
                                        }
                                      });
                                    },
                                    options: FFButtonOptions(
                                      height: 35,
                                      color: isChanged == true
                                          ? Colors.green
                                          : Colors.red,
                                      textStyle: FlutterFlowTheme.of(context)
                                          .subtitle1
                                          .override(
                                        fontFamily: "Lexend Deca",
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.normal,
                                      ),
                                      elevation: 2,
                                      borderSide: BorderSide(
                                        color: Colors.transparent,
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                              ],
                            )),
                      ),
                    )
                  ]),
                ],
              ),
              ]
          )
        // ],
      ),
    );
  }

  Future _stopLiveFeed() async {
    await controller?.stopImageStream();
    await controller?.dispose();
    controller = null;
  }

  Future _processCameraImage(CameraImage image) async {
    final WriteBuffer allBytes = WriteBuffer();
    for (final Plane plane in image.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();

    final Size imageSize =
        Size(image.width.toDouble(), image.height.toDouble());

    final camera = cameras[_cameraIndex];
    final imageRotation =
        InputImageRotationValue.fromRawValue(camera.sensorOrientation);
    if (imageRotation == null) return;

    final inputImageFormat =
        InputImageFormatValue.fromRawValue(image.format.raw);
    if (inputImageFormat == null) return;

    final planeData = image.planes.map(
      (Plane plane) {
        return InputImagePlaneMetadata(
          bytesPerRow: plane.bytesPerRow,
          height: plane.height,
          width: plane.width,
        );
      },
    ).toList();

    final inputImageData = InputImageData(
      size: imageSize,
      imageRotation: imageRotation,
      inputImageFormat: inputImageFormat,
      planeData: planeData,
    );

    final inputImage =
        InputImage.fromBytes(bytes: bytes, inputImageData: inputImageData);
    if (!isChanged){
      widget.onImage(inputImage);
    }
  }

  int countReps() {
    int temp = widget.reps;
    for (int i = 0; i < repList.length; i++) {
      temp -= repList[i];
    }
    return temp;
  }
}
