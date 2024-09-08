import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coach_bot/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../exercise_mistake/exercise_mistake_widget.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import '../util.dart';
import 'package:flutter/material.dart';
import 'package:coach_bot/flutter_flow/flutter_flow_widgets.dart';
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

class ExcercisesListWidget extends StatefulWidget {
  final String day;
  const ExcercisesListWidget(this.day);

  @override
  _ExcercisesListWidgetState createState() => _ExcercisesListWidgetState();
}

class _ExcercisesListWidgetState extends State<ExcercisesListWidget>
    with TickerProviderStateMixin {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late List<CameraDescription> cameras;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  late DateTime beg;

  @override
  void initState() {
    super.initState();
    beg = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> exercises = [];

    return FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('backend')
            .doc(widget.day.toLowerCase())
            .get(),
        builder: (BuildContext context,
            AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot == null ||
              !snapshot.hasData ||
              snapshot.data!.data().toString() == "{}") {
            return Center(
              child: SizedBox(
                width: 50,
                height: 50,
                child: SpinKitFadingCircle(
                  color: FlutterFlowTheme.of(context).primaryColor,
                  size: 50,
                ),
              ),
            );
          }
          Map data = snapshot.data!.data() as Map<String, dynamic>;
          for (String key in data.keys) {
            exercises.add(_buildExercise(key, data[key]));
          }
          exercises.add(_buildFinishButton());
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
              automaticallyImplyLeading: false,
              title: Text(
                widget.day + ' Day Exercises',
                style: FlutterFlowTheme.of(context).title2,
              ),
              actions: [],
              centerTitle: false,
              elevation: 0,
            ),
            backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
            body: SafeArea(
              child: GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 12, 0, 44),
                        child: ListView(
                            padding: EdgeInsets.zero,
                            primary: false,
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            children: exercises),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
    );
  }

  Widget _buildExercise(String exercise, String link) {
    // Function onImage = functions[exercise]!;
    return Padding(
        padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 12),
        child: Container(
          width: 100,
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
            boxShadow: [
              BoxShadow(
                blurRadius: 5,
                color: Color(0x1F000000),
                offset: Offset(0, 2),
              )
            ],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(0),
                  bottomRight: Radius.circular(0),
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                child: Image.asset(
                  images[exercise]!,
                  // width: double.infinity,
                  height: 240,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(16, 12, 16, 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        exercise,
                        style: FlutterFlowTheme.of(context).title2,
                      ),
                      InkWell(
                        onTap: () async {
                          cameras = await availableCameras();
                          Map<String,dynamic> data = await FirebaseFirestore.instance.collection('users').doc(_auth.currentUser!.uid).get().then((snapshot)=>snapshot.data()!);
                          Map<String, Widget> objects = {
                            benchPress: new BenchPress(cameras, benchPress),
                            bicepCurl: new BicepCurl(cameras, bicepCurl),
                            cableRow: new CableRow(cameras, cableRow),
                            incBench: new IncBenchPress(cameras, incBench),
                            latPulldown: new LatPulldown(cameras, latPulldown),
                            legPress: new LegPress(cameras, legPress),
                            shoulderPress: new ShoulderPress(cameras, shoulderPress),
                            skullcrusher: new Skullcrusher(cameras, skullcrusher),
                            squat: new Squat(cameras, squat),
                            tricepPulldown: new TricepPulldown(cameras, tricepPulldown),
                          };
                          Widget c = objects[exercise]!;
                          if (data["mistakes"][exercise] != null){
                            await Navigator.push(context,
                                MaterialPageRoute(builder: (context) => ExerciseMistakeWidget(suggestions: data["mistakes"][exercise], exercise: exercise, pageBefore: 1, cameras: cameras)));
                          } else {
                            await Navigator.push(context, MaterialPageRoute(builder: (context) => c));
                          }
                        },
                        child: Text(
                          'Start',
                          style: FlutterFlowTheme.of(context)
                              .subtitle1
                              .override(
                                fontFamily: 'Overpass',
                                color:
                                    FlutterFlowTheme.of(context).primaryColor,
                              ),
                        ),
                      ),
                    ],
                  )),
              Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 16),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'sets | reps | lbs.',
                        style: FlutterFlowTheme.of(context).bodyText2,
                      ),
                      // Padding(
                      //   padding: EdgeInsetsDirectional.fromSTEB(5, 0, 0, 0),
                      //   child: InkWell(
                      //     onTap: () async {
                      //       await Navigator.push(
                      //         context,
                      //         MaterialPageRoute(
                      //           builder: (context) => WeightEditWidget(exercise),
                      //         ),
                      //       );
                      //     },
                      //     child: Icon(
                      //       Icons.edit_rounded,
                      //       color: FlutterFlowTheme.of(context).grayDark,
                      //       size: 14,
                      //     ),
                      //   ),
                      // ),
                    ],
                  )),
            ],
          ),
        ));
  }

  Widget _buildFinishButton() {
    return Padding(
        padding: EdgeInsetsDirectional.fromSTEB(16, 12, 16, 0),
        child: FFButtonWidget(
            onPressed: () async {
              Duration dif = DateTime.now().difference(beg);
              Map<String, dynamic> data = await FirebaseFirestore.instance
                  .collection("users")
                  .doc(_auth.currentUser?.uid)
                  .get()
                  .then((snapshot) => snapshot.data() as Map<String, dynamic>);
              String month = DateTime.now().month < 10
                  ? "0" + DateTime.now().month.toString()
                  : DateTime.now().month.toString();
              String day = DateTime.now().day < 10
                  ? "0" + DateTime.now().day.toString()
                  : DateTime.now().day.toString();
              data['workouts'].insert(
                  0,
                  DateTime.now().year.toString() +
                      "-" +
                      month +
                      "-" +
                      day +
                      " " +
                      dif.toString());
              await FirebaseFirestore.instance
                  .collection("users")
                  .doc(_auth.currentUser?.uid)
                  .update(data);
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => NavBarPage("homepage2")));
            },
            text: "Finish Workout",
            options: FFButtonOptions(
              width: 270,
              height: 50,
              color: FlutterFlowTheme.of(context).primaryColor,
              textStyle: FlutterFlowTheme.of(context).subtitle1.override(
                    fontFamily: "Overpass",
                    color: Colors.white,
                  ),
              elevation: 3,
              borderSide: BorderSide(
                color: Colors.transparent,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(8),
            )));
  }
}
