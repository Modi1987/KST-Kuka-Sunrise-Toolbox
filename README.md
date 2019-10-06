

# KUKA Sunrise Toolbox for Matlab

A Toolbox used to control KUKA iiwa robots :robot:, the 7R800 and the 14R820, from an external computer using Matlab.

Using the KST the utilizer can control the iiwa robot from his/her computer using Matlab's simple syntax, without requiring any skills nor knowledge about programming the controller of the industerial manipulator.

A basic knowledge of using Matlab is required.

![cover photo 002](https://user-images.githubusercontent.com/23720527/42727096-161276d4-8798-11e8-8e6e-4af57383f0bf.jpg)

--------------------------------------

# Video tutorials on how to utilize the toolbox

* Video tutorials on KST version 1.7 are [available here](https://www.youtube.com/playlist?list=PLz558OYgHuZd-Gc2-OryITKEXefAmrvae)  :point_left: .
* Video tutorials on KST version 1.6 are [available here](https://www.youtube.com/watch?v=_yTK0Gi0p3g&list=PLz558OYgHuZdVzTaB79iM8Y8u6EjFe0d8)  :point_left: .

The newer version of KUKA Sunrise Toolbox (KST-1.7) provides a wrapper class that wraps the various functions of the earlier version (KST-1.6) in the file (KST.m). As such earlier version of KST works interchangeably with the newer version 1.7. And the user has the freedom of choice to utilize KST-1.7 or KST-1.6 according to his/her own preference.

--------------------------------------

# Video Gallery

Video demos where MATLAB and KST are used to control iiwa manipulator are :point_right: [available here](https://github.com/Modi1987/KST-Kuka-Sunrise-Toolbox/wiki/Videos)  :point_left: . 
The video examples range from pick & place applications where kinect camera is utilized for objects recognition and localization, to realtime collision avoidance with coworker/dynamic-obstacles in practical robotic cell. Other examples show how to control the manipulator from 3D simulation software or by using external hardware, and more.

--------------------------------------

# Useful Links

* Controlling KUKA iiwa from Python :point_right: [available here](https://github.com/Modi1987/iiwaPy).
* Controlling KUKA iiwa from Simulink :point_right: [available here](https://github.com/Modi1987/Simulink-iiwa-interface).
* If you do not have the Sunrise.Servoing library but you still want to use MATLAB for controlling KUKA iiwa you can use the package :point_right: [in here](https://github.com/Modi1987/IIWAContorlToolbox).
* Advanced examples on using KST for controlling KUKA iiwa :point_right: [available here](https://github.com/Modi1987/KST-advanced-examples).

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
[SunriseGUIinterface/][11]	         | Friendly GUI for controlling iiwa from MATLAB.
[iiwa_CNCPlotter/][12]	             | Use IIWA as CNC Plotter.



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
[12]: /iiwa_CNCPlotter

--------------------------------------



# Citations

Please cite the following article in your publications if it helps your research :pray: :


```javascript
@ARTICLE{Safeea2019,  
  Author={M. {Safeea} and P. {Neto}},  
  Journal={IEEE Robotics Automation Magazine},  
  Title={KUKA Sunrise Toolbox: Interfacing Collaborative Robots With MATLAB},  
  Year={2019},  
  Volume={26},  
  Number={1},  
  Pages={91-96},  
  doi={10.1109/MRA.2018.2877776},  
  ISSN={1070-9932},  
  Month={March},  
}
```

--------------------------------------

# Acknowledgments

This research was partially supported by:
The Portuguese Foundation for Science and Technology 
(FCT) SFRH/BD/131091/2017 and the European Union's Horizon
2020 research and innovation programme under grant agreement
No 688807 - ColRobot project.


