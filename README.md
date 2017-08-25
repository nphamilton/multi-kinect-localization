# multi-kinect-localization
A system for use with StarL to provide localization information from multiple Kinects.

To learn more about StarL check out its GitHub page [here.](https://github.com/verivital/starl "StarL's GitHub Page")

# Message Labels, Types, and Structures
Here is a comprehensive list of all the messages being passed around in this system. It is broken into two (2) categories: **Messages Sent by Central Command** and **Messages Sent by Robot Observer(s)**

The *Label* refers to **FIGURE THIS OUT**

The *Type* referes to the message structure. Most of the message types used in this system are String.

The *Format* refers to how the message is set up for parsing purposes.

## Messages Sent by Central Command
Label | Type | Format
------|------|-------
/botID_list	| String | robot_name:robot_type:color,robot_name:robot_type:color,...
/shutdown | Byte | 0 | 1
/kinect#/bot_list | String | robot_number,robot_number,...
/kinect#/incoming | String | robot_number:search_area:previous_kinect_number,robot_number...

## Messages Sent by Robot Observer(s)
Label | Type | Format
------|------|-------
/kinect#/locations | String | kinect_number,robot_number:radius:X:Y:Z:yaw:hysteresis,robot_number...
/kinect#/response | String | kinect_number,robot_number:status:previous_kinect_number,robot_number...