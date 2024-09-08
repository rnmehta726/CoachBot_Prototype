import 'package:coach_bot/index.dart';
import 'package:camera/camera.dart';
import 'package:coach_bot/util.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';

import 'package:coach_bot/exercises/bicep_curl.dart';
import 'package:coach_bot/exercises/inclined_bench_press.dart';
import 'package:coach_bot/exercises/lat_pulldown.dart';
import 'package:coach_bot/exercises/shoulder_press.dart';
import 'package:coach_bot/exercises/skullcrusher.dart';
import 'package:coach_bot/exercises/squat.dart';
import 'package:coach_bot/exercises/tricep_pulldown.dart';
import 'package:coach_bot/exercises/bench_press.dart';
import 'package:coach_bot/exercises/cable_row.dart';
import 'package:coach_bot/exercises/leg_press.dart';

class ExerciseMistakeWidget extends StatefulWidget {
  final List<CameraDescription> cameras;
  final int pageBefore;
  final List suggestions;
  final String exercise;
  const ExerciseMistakeWidget({required this.exercise, required this.suggestions, required this.pageBefore, required this.cameras});

  @override
  _ExerciseMistakeWidgetState createState() => _ExerciseMistakeWidgetState();
}

class _ExerciseMistakeWidgetState extends State<ExerciseMistakeWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        automaticallyImplyLeading: false,
        leading: InkWell(
          onTap: () async {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.chevron_left_rounded,
            color: FlutterFlowTheme.of(context).primaryText,
            size: 32,
          ),
        ),
        title: Text(
          'Mistakes',
          style: FlutterFlowTheme.of(context).title2,
        ),
        actions: [],
        centerTitle: false,
        elevation: 0,
      ),
      backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Image.asset(
                  images[widget.exercise]!,
                  width: MediaQuery.of(context).size.width,
                  height: 350,
                  fit: BoxFit.cover,
                ),
              ],
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(20, 12, 20, 0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Text(
                      widget.exercise,
                      style: FlutterFlowTheme.of(context).title2,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(20, 4, 20, 0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Text(
                      widget.suggestions[0]['time'],
                      style: FlutterFlowTheme.of(context).subtitle1.override(
                            fontFamily: 'Overpass',
                            color: FlutterFlowTheme.of(context).primaryColor,
                          ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(20, 12, 20, 0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Text(
                      widget.suggestions[0]['comment'],
                      style: FlutterFlowTheme.of(context).bodyText2,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(20, 12, 20, 0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Text(
                      widget.suggestions[0]['sets'].toString() + ' | ' +
                        widget.suggestions[0]['reps'].toString() + ' | ' +
                        widget.suggestions[0]['weight'].toString(),
                      style: FlutterFlowTheme.of(context).bodyText1.override(
                            fontFamily: 'Overpass',
                            color: FlutterFlowTheme.of(context).primaryColor,
                          ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 24),
              child: FFButtonWidget(
                onPressed: () async {
                  Map<String, Widget> objects = {
                    benchPress: new BenchPress(widget.cameras, benchPress),
                    bicepCurl: new BicepCurl(widget.cameras, bicepCurl),
                    cableRow: new CableRow(widget.cameras, cableRow),
                    incBench: new IncBenchPress(widget.cameras, incBench),
                    latPulldown: new LatPulldown(widget.cameras, latPulldown),
                    legPress: new LegPress(widget.cameras, legPress),
                    shoulderPress: new ShoulderPress(widget.cameras, shoulderPress),
                    skullcrusher: new Skullcrusher(widget.cameras, skullcrusher),
                    squat: new Squat(widget.cameras, squat),
                    tricepPulldown: new TricepPulldown(widget.cameras, tricepPulldown),
                  };
                  Widget c = objects[widget.exercise]!;
                  if (widget.pageBefore == 0) {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => GymCodeWidget()
                    ));
                  } else {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => c));
                  }
                },
                text: 'Continue to Workout',
                options: FFButtonOptions(
                  width: 300,
                  height: 60,
                  color: FlutterFlowTheme.of(context).primaryColor,
                  textStyle: FlutterFlowTheme.of(context).title3.override(
                        fontFamily: 'Overpass',
                        color: Colors.white,
                      ),
                  elevation: 3,
                  borderSide: BorderSide(
                    color: Colors.transparent,
                    width: 1,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
