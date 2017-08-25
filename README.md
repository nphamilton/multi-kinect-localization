# multi-kinect-localization
A system for use with StarL to provide localization information from multiple Kinects.

To learn more about StarL check out its GitHub page [here.](https://github.com/verivital/starl "StarL's GitHub Page")

# Message Labels, Types, and Structures
Here is a comprehensive list of all the messages being passed around in this system. It is broken into two (2) categories: **Messages Sent by Central Command** and **Messages Sent by Robot Observer(s)**

The *Label* refers to message name used in ROS.

The *Type* referes to the message structure. Most of the message types used in this system are String.

The *Format* refers to how the message is set up for parsing purposes.

The *Specifications* refers to necessities required for the message.

## Messages Sent by Central Command
Label | Type | Format | Specifications
------|------|--------|---------------
/botID_list	| String | 'robot_name:robot_type:color,robot_name:robot_type:color,...' | Must include all of the robots. The order will be maintained and each robot's number will be determined by its index in the botArray.
/shutdown | Byte | 0 \| 1 | 0 to continue, 1 to shutdown
/kinect#/bot_list | String | 'robot_number,robot_number,...' | This list contains only the robots to appear under Kinect#.
/kinect#/incoming | String | 'robot_number:search_area:previous_kinect_number,robot_number...' | List is empty string if no incoming robots.

## Messages Sent by Robot Observer(s)
Label | Type | Format | Specifications
------|------|--------|---------------
/kinect#/locations | String | 'kinect_number,robot_number:radius:X:Y:Z:yaw:hysteresis,robot_number...' | Separate robots with "," and the robot's individual location components with ":". Only list robots that are present. If no robots present, message will be 'kinect_number'.
/kinect#/response | String | 'kinect_number,robot_number:status:previous_kinect_number,robot_number...' | This a response to the incoming message and will not be sent if incoming is an empty string.
