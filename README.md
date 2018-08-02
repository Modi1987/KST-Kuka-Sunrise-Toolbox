

# KUKA Sunrise Toolbox for Matlab

A Toolbox used to control KUKA iiwa robots, the 7R800 and the 14R820, from an external computer using Matlab.

Using the KST the utilizer can control the iiwa robot from his/her computer without a need for programming  the industerial manipulator.

A basic knowledge of using Matlab is required.

![cover photo 002](https://user-images.githubusercontent.com/23720527/42727096-161276d4-8798-11e8-8e6e-4af57383f0bf.jpg)

--------------------------------------

# Video tutorials on how to utilize the toolbox

* Video tutorials on KST version 1.7 are [available here](https://www.youtube.com/playlist?list=PLz558OYgHuZd-Gc2-OryITKEXefAmrvae).
* Video tutorials on KST version 1.6 are [available here](https://www.youtube.com/watch?v=_yTK0Gi0p3g&list=PLz558OYgHuZdVzTaB79iM8Y8u6EjFe0d8)

The newer version of KUKA Sunrise Toolbox (KST-1.7) provides a wrapper class that wraps the various functions of the earlier version (KST-1.6) in the file (KST.m). As such earlier version of KST works interchangeably with the newer version 1.7. And the user has the freedom of choice to utilize KST-1.7 or KST-1.6 according to his/her own preference.

--------------------------------------

# Video Gallery

Video demos where MATLAB and KST are used to control iiwa manipulator are [available here](https://github.com/Modi1987/KST-Kuka-Sunrise-Toolbox/wiki/Videos). 
The video examples range from pick & place applications where kinect camera is utilized for objects recognition and localization, to realtime collision avoidance with coworker/dynamic-obstacles in practical robotic cell, to controlling the manipulator from 3D simulation software or by using external hardware, and more.

--------------------------------------

# Package Content

Path                                 | Content description
-------------------------------------| ----------------------------------------------------------
[KUKA_Sunrise_server_source_code/][1]| Java source code for IIWA controller.
[Matlab_client/][2]                  | Matlab code for KST.
[OtherFlavours/][3]                  | Other versions of KST.
[Other_MATLAB_functionalities/][4]   | Hand-guiding/Physical-interaction functions.
[Tips and tricks/][5]                | Documentation for enhancing network performance on PC.
[realTimeControlDrawCircle/][6]      | Demo on trajectory generation/IK/on-the-fly control.
[realTimeControlDrawEllipse/][7]     | Demo on trajectory generation/IK/on-the-fly control.
[realTimeControl_iiwa_from_Vrep/][8] | Demo, using KST with V-rep to control iiwa robot.
[realtimeControlOfEEFGamePad/][9]    | Teleoperation, control EEF from GamePad.
[realtimeControlOfJoint...../][10]   | Teleoperation, control joints from GamePad.
[SunriseGUIinterface/][11]	     | Friendly GUI for controlling iiwa from MATLAB.


<!-- --------------------------------------------------------------------------------- -->

<!-- Links in GitHub, -->
[1]: /KUKA_Sunrise_server_source_code
[2]: /Matlab_client
[3]: /OtherFlavours
[4]: /Other_MATLAB_functionalities
[5]: /Tips%20and%20tricks
[6]: /realTimeControlDrawCircle
[7]: /realTimeControlDrawEllipse
[8]: /realTimeControl_iiwa_From_Vrep
[9]: /realtimeControlOfEEFGamePad
[10]: /realtimeControlOfJointSpaceUsingGamePad
[11]: /SunriseGUIinterface

--------------------------------------


# Citations

Please cite the following paper in your publications if it helps your research 

Paper in the link: https://arxiv.org/abs/1709.01438

@inproceedings{safeea2017,

  author = {Mohammad Safeea and Pedro Neto},
  
  title = {KUKA Sunrise Toolbox: Interfacing Collaborative Robots with
  
MATLAB},

  year = {2017}
  
  }


--------------------------------------

# Acknowledgments

This research was partially supported by:
The Portuguese Foundation for Science and Technology 
(FCT) SFRH/BD/131091/2017 and the European Union's Horizon
2020 research and innovation programme under grant agreement
No 688807 - ColRobot project.



