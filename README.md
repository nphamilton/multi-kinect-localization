# multi-kinect-localization
A system for use with StarL to provide localization information from multiple Kinects.

# Message Labels, Types, and Structures
Here is a comprehensive list of all the messages being passed around in this system. It is broken into two (2) categories: **Messages Sent by Central Command** and **Messages Sent by Robot Observer(s)**
The *Label* refers to **FIGURE THIS OUT**
The *Type* referes to the message structure. Most of the message types used in this system are String.
The *Structure* refers to how the message is set up for parsing purposes.

## Messages Sent by Central Command
Label				Type		Structure
/botID_list			String		p
/shutdown			Byte		0 | 1
/kinect#/bot_list	String		p
/kinect#/incoming	String		p

## Messages Sent by Robot Observer(s)
Label				Type		Structure
/kinect#/locations	String		p
/kinect#/response	String		p