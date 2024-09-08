import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../auth/auth_util.dart';
import '../exercise_mistake/exercise_mistake_widget.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_util.dart';
import '../gym_code/gym_code_widget.dart';
import '../weight_edit/weight_edit_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';

class Homepage2Widget extends StatefulWidget {
  const Homepage2Widget();

  @override
  _Homepage2WidgetState createState() => _Homepage2WidgetState();
}

class _Homepage2WidgetState extends State<Homepage2Widget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: FirebaseFirestore.instance.collection('users').doc(_auth.currentUser?.uid).get(),
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>?> snapshot){
          if(snapshot == null || !snapshot.hasData || snapshot.data?.data().toString() == "{}"){
            return CircularProgressIndicator();
          } else {
            print(_auth.currentUser?.uid);
            Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;

            List<Widget> exercises = [];
            for(int i = 0; i<data['exercises'].keys.length;i++){
              String exercise = data['exercises'].keys.toList()[i];
              Map<String, dynamic> stats = data['exercises'][exercise];
              exercises.add(_buildWeightRow(exercise, stats));
            }

            List<Widget> mistakes = [];
            for(int i = 0; i<data['mistakes'].keys.length;i++){
              if(i==20) break;
              String exercise = data['mistakes'].keys.toList()[i];
              List suggestions = data['mistakes'][exercise];
              mistakes.add(_buildMistakeRow(exercise, suggestions));
            }

            DateTime date = DateTime.now();
            DateTime sunday = DateTime(date.year, date.month, date.day - (date.weekday - 1));
            int workouts = 0;
            for(int i = 0; i<data['workouts'].length; i++){
              DateTime workout = DateTime.parse(data['workouts'][i].split(" ")[0]);
              if(workout.isAfter(sunday) || workout.isAtSameMomentAs(sunday)){
                workouts++;
              } else {
                break;
              }
            }

      return Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
          automaticallyImplyLeading: false,
          title: Text(
          'Hi, ' + data['name'],
          style: FlutterFlowTheme.of(context).title1,
          ),
          actions: [
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0, 0, 16, 0),
            child: Container(
                width: 50,
                height: 50,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: Image.network(
                  valueOrDefault<String>(
                    data['photoUrl'],
                    'https://upload.wikimedia.org/wikipedia/commons/a/ac/Default_pfp.jpg',
                  ),
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
        ],
        centerTitle: false,
        elevation: 0,
      ),
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      'This is your daily summary.',
                      style: FlutterFlowTheme.of(context).bodyText2,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 8, 0, 8),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 0,
                  alignment: WrapAlignment.start,
                  crossAxisAlignment: WrapCrossAlignment.start,
                  direction: Axis.horizontal,
                  runAlignment: WrapAlignment.start,
                  verticalDirection: VerticalDirection.down,
                  clipBehavior: Clip.none,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(2, 0, 2, 12),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.44,
                            height: 230,
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
                                  EdgeInsetsDirectional.fromSTEB(12, 8, 12, 8),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Weight Progress',
                                    style:
                                        FlutterFlowTheme.of(context).subtitle1,
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0, 6, 0, 6),
                                    child: Text(
                                      'Sets | Reps | Weight',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyText1
                                          .override(
                                            fontFamily: 'Overpass',
                                            fontSize: 10,
                                          ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0, 4, 0, 0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.end,
                                        children: [
                                          Expanded(
                                            child: ListView(
                                              padding: EdgeInsets.zero,
                                              shrinkWrap: false,
                                              scrollDirection: Axis.vertical,
                                              children: exercises,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(2, 0, 2, 12),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.44,
                            height: 200,
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
                                  EdgeInsetsDirectional.fromSTEB(12, 8, 12, 8),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0, 0, 0, 0),
                                    child: Text(
                                      'Mistakes',
                                      style: FlutterFlowTheme.of(context)
                                          .subtitle1,
                                    ),
                                  ),
                                  // Padding(
                                  //   padding: EdgeInsetsDirectional.fromSTEB(
                                  //       0, 4, 0, 0),
                                  //   child: Text(
                                  //     DateTime.now().,
                                  //     style: FlutterFlowTheme.of(context)
                                  //         .bodyText2,
                                  //   ),
                                  // ),
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0, 4, 0, 0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Expanded(
                                            child: ListView(
                                              padding: EdgeInsets.zero,
                                              shrinkWrap: false,
                                              scrollDirection: Axis.vertical,
                                              children: mistakes,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(2, 0, 2, 12),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.44,
                            height: 250,
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
                                  EdgeInsetsDirectional.fromSTEB(12, 8, 12, 8),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Last Workout',
                                    style:
                                        FlutterFlowTheme.of(context).subtitle1,
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0, 4, 0, 0),
                                    child: Text(
                                      data['workouts'].length == 0 ? "--" :
                                        data['workouts'][0].split('-')[1] + '/' +
                                            data['workouts'][0].split('-')[0],
                                      style: FlutterFlowTheme.of(context)
                                          .bodyText2,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0, 16, 0, 0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          data['workouts'].length == 0 ? "--" :
                                            data['workouts'][0].split('-')[2].split(" ")[0],
                                          style: FlutterFlowTheme.of(context)
                                              .subtitle1
                                              .override(
                                                fontFamily: 'Overpass',
                                                fontSize: 72,
                                                fontWeight: FontWeight.w500,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    'Time Spent',
                                    style:
                                        FlutterFlowTheme.of(context).bodyText2,
                                  ),
                                  Text(
                                    data['workouts'].length == 0 ? "--" :
                                      data['workouts'][0].split(' ')[1].split('.')[0],
                                    style:
                                        FlutterFlowTheme.of(context).subtitle1,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(2, 0, 2, 12),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.44,
                            height: 180,
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
                                  EdgeInsetsDirectional.fromSTEB(12, 8, 12, 8),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0, 0, 0, 0),
                                    child: Text(
                                      'Weekly tracker',
                                      style: FlutterFlowTheme.of(context)
                                          .subtitle1,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0, 8, 0, 0),
                                    child: Text(
                                      'Goals',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyText2,
                                    ),
                                  ),
                                  Expanded(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0, 4, 0, 0),
                                          child: Text(
                                            'Progress',
                                            style: FlutterFlowTheme.of(context)
                                                .bodyText2,
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0, 4, 10, 0),
                                          child: Text(
                                            workouts.toString() + '/' + data['goal'].toString(),
                                            style: FlutterFlowTheme.of(context)
                                                .bodyText2,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0, 0, 0, 0),
                                      child: LinearPercentIndicator(
                                        percent: workouts <= data['goal'] ? workouts/data['goal'] : 1,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.37,
                                        lineHeight: 8,
                                        animation: true,
                                        progressColor:
                                            FlutterFlowTheme.of(context)
                                                .primaryColor,
                                        backgroundColor:
                                            FlutterFlowTheme.of(context)
                                                .lineColor,
                                        barRadius: Radius.circular(8),
                                        padding: EdgeInsets.zero,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 12),
                child: InkWell(
                  onTap: () async {
                    await Navigator.push(
                      context,
                      PageTransition(
                        type: PageTransitionType.bottomToTop,
                        duration: Duration(milliseconds: 200),
                        reverseDuration: Duration(milliseconds: 200),
                        child: GymCodeWidget(),
                      ),
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).primaryColor,
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 8,
                          color: Color(0x34090F13),
                          offset: Offset(0, 4),
                        )
                      ],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(12, 8, 12, 12),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(0, 8, 0, 0),
                            child: Text(
                              'Daily Workout',
                              style:
                                  FlutterFlowTheme.of(context).title2.override(
                                        fontFamily: 'Overpass',
                                        color: FlutterFlowTheme.of(context)
                                            .primaryBtnText,
                                      ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                            child: Text(
                              'Start your daily workout routine',
                              style: FlutterFlowTheme.of(context)
                                  .bodyText2
                                  .override(
                                    fontFamily: 'Overpass',
                                    color: Color(0xC7FFFFFF),
                                  ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 8),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0, 12, 0, 0),
                                  child: Text(
                                    'Begin Session Now',
                                    style: FlutterFlowTheme.of(context)
                                        .subtitle1
                                        .override(
                                          fontFamily: 'Overpass',
                                          color: FlutterFlowTheme.of(context)
                                              .primaryBtnText,
                                        ),
                                  ),
                                ),
                                Icon(
                                  Icons.keyboard_arrow_right_rounded,
                                  color: FlutterFlowTheme.of(context)
                                      .primaryBtnText,
                                  size: 24,
                                ),
                              ],
                            ),
                          ),
                        ],
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
    },
      initialData: null
    );
  }
  
  Widget _buildWeightRow(String exercise, Map<String, dynamic> data){
    return Padding(
      padding: EdgeInsetsDirectional
          .fromSTEB(0, 0, 0, 8),
      child: Row(
        mainAxisSize:
        MainAxisSize.max,
        mainAxisAlignment:
        MainAxisAlignment
            .center,
        children: [
          InkWell(
            onTap: () async {
              Map<String,dynamic> data = await FirebaseFirestore.instance.collection('users').doc(_auth.currentUser!.uid).get().then((snapshot)=>snapshot.data()!);

              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      WeightEditWidget(exercise, data),
                ),
              );
            },
            child: Container(
              width: MediaQuery.of(context).size.width * 0.37,
              height: 20,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                BorderRadius.circular(8),
                shape: BoxShape.rectangle,
                border: Border.all(
                  color: FlutterFlowTheme.of(context).grayLines,
                  width: 2,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding:
                    EdgeInsetsDirectional.fromSTEB(5, 0, 0, 1),
                    child: Text(
                      exercise,
                      style: FlutterFlowTheme.of(context).bodyText1.override(
                        fontFamily:
                        'Lexend Deca',
                        color: Color(0xFF090F13),
                        fontSize: 10,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 0, 5, 0),
                      child: Text(
                        data['sets'].toString() + ' | ' + 
                            data['reps'][0].toString() + ' | ' +
                            data['weight'].toString(),
                        textAlign: TextAlign.end,
                        style: FlutterFlowTheme.of(context).bodyText1.override(
                          fontFamily: 'Lexend Deca',
                          color: Color(0xFF090F13),
                          fontSize: 8,
                          fontWeight: FontWeight.normal,
                        ),
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

  Widget _buildMistakeRow(String exercise, List suggestions){
    return Padding(
      padding: EdgeInsetsDirectional
          .fromSTEB(0, 0, 0, 12),
      child: Row(
        mainAxisSize:
        MainAxisSize.max,
        mainAxisAlignment:
        MainAxisAlignment
            .center,
        children: [
          InkWell(
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ExerciseMistakeWidget(suggestions: suggestions,exercise: exercise, pageBefore: 0, cameras: [],),
                ),
              );
            },
            child: Container(
              width: MediaQuery.of(
                  context)
                  .size
                  .width *
                  0.37,
              height: 20,
              decoration:
              BoxDecoration(
                color: Colors.white,
                borderRadius:
                BorderRadius
                    .circular(
                    8),
                shape: BoxShape
                    .rectangle,
                border: Border.all(
                  color: FlutterFlowTheme
                      .of(context)
                      .grayLines,
                  width: 2,
                ),
              ),
              child: Row(
                mainAxisSize:
                MainAxisSize
                    .max,
                mainAxisAlignment:
                MainAxisAlignment
                    .spaceBetween,
                children: [
                  Padding(
                    padding:
                    EdgeInsetsDirectional
                        .fromSTEB(
                        5,
                        0,
                        0,
                        1),
                    child: Text(
                      exercise,
                      style: FlutterFlowTheme.of(context).bodyText1.override(
                        fontFamily: 'Lexend Deca',
                        color: Color(0xFF090F13),
                        fontSize: 10,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 0, 5, 0),
                    child: Icon(
                      Icons.remove_red_eye_outlined,
                      color: Colors.black,
                      size: 12,
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
