const String bicepCurl = "Bicep Curl";
const String benchPress = "Bench Press";
const String cableRow = "Cable Row";
const String incBench = "Incl. Bench Press";
const String latPulldown = "Lat Pulldown";
const String legPress = "Leg Press";
const String shoulderPress = "Shoulder Press";
const String skullcrusher = "Skullcrusher";
const String squat = "Squat";
const String tricepPulldown = "Tricep Pulldown";
const String latRaise = "Lat Raise";
const String romDeadlift = "Romanian Deadlift";

const Map<String,List<String>> comments = {
  bicepCurl:[
    "Try to prevent yourself from leaning and using your back to assist you "
        "with completing the rep. This will prevent you from isolating the bicep.",
    "Keep your elbows stationary and next to your body to prevent other muscles "
        "from assisting your bicep during the exercise. "
  ],
  benchPress:[
    "Do not flare your elbows outward at the bottom of the rep. This "
      "can lead to serious shoulder injuries such as a torn rotator cuff.",
  ],
  cableRow:[
    "Keep your back straight and perpendicular to the ground. Continue to drive "
        "your elbows back to target your lats.",
  ],
  incBench:[
    "Do not flare your elbows outward at the bottom of the rep. This "
        "can lead to serious shoulder injuries such as a torn rotator cuff.",
  ],
  latPulldown:[
    "Do not lean too far back on the way down. Try to lean between 95-105 degrees. "
        "Also try to prevent using momentum to help bring the weight down and just"
        " pull with your chest."
  ],
  legPress:[
    "Do not completely straighten your legs at the top of the rep. This puts a lot "
        "of stress on your knees and can potentially split your legs if the weight falls."
  ],
  shoulderPress:[
    "Do not bring the weight too far down. At the bottom of the rep, make sure your"
        " elbows are at a 90 degree angle and then push up."
  ],
  skullcrusher:[
    "Do not move your elbows forward during the exercise. This will keep pressure "
        "on the triceps and prevent assistance from the shoulder."
  ],
  squat:[
    "You must keep a straight back to prevent major injury to the lower back. An "
        "arched back will place the weight on the lower back instead of the legs "
        "and can lead to back pain."
  ],
  tricepPulldown:[
    "Do not move your shoulders while bringing down the weight. This will assist"
        " the tricep in completing the rep. Keep your elbows in front of you.",
  ],
};

const Map<String,String> images = {
  benchPress: "assets/images/Bench-press.png",
  bicepCurl: "assets/images/Biceps-curl.png",
  cableRow: "assets/images/Cable-seated-rows.png",
  incBench: "assets/images/Dumbbell-incline-bench-press.png",
  latPulldown: "assets/images/Lat-pulldown.png",
  legPress: "assets/images/Narrow-stance-leg-press.png",
  shoulderPress: "assets/images/Dumbbell-shoulder-press.png",
  skullcrusher: "assets/images/skull-crusher.png",
  squat: "assets/images/Squats.png",
  tricepPulldown: "assets/images/Triceps-pushdown.png",
};