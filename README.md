# UNISA EASY DETECT v2.0

The idea of Unisa Easy Detect evolved from the necessity to make the attendance recording in University’s classes more efficient in terms of time and reliability.  

The actual attendance system setup consists in one or more magnetic stripe readers in every class, and all the students must have an ID card. 
Since the attendance is obligatory for many University courses, and a class can comprise of more than 200 students, this system is really inefficient in terms of speed, because every student must swipe their card and queue to do it, wasting a lot of time. It is also unreliable because students often give their card to others in order to prove their attendance.

The starting point was to provide the students with a different technology to record their attendance, and professors decided that beacons would be the solution to our problem. 

![alt text](https://github.com/MallyDev/Unisa-Easy-Detect-v2.0/blob/master/BeaconDetectorAPP/Assets.xcassets/AppIcon.appiconset/BeaconDetector_logo.001-29%402x.png) 

With the first version of the iOS application the attendance process did not include the authentication of the user, and every record was identified by the Universally unique identifier (UUID) of the installed app on the phone. Thus, was impossible to know who was in the class. 

To solve this problem, I’ve introduced a WebView to use the University’s SSO, and a view to show the user details and make possible to logout. 
The User Interface had also been changed following the Apple Human Interface Guidelines and the theory of colours.

This is only the application code. 
For more information about the web services and the database check 

[ml-b.it/UnisaEasyDetect](http://www.ml-b.it/UnisaEasyDetect)
