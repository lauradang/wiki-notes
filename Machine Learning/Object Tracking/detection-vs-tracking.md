# Object Detection vs. Object Tracking

https://www.quora.com/What-is-the-difference-between-object-detection-and-object-tracking - I liked the 2nd answer shown below:

Object detection is simply about identifying and locating all known objects in a scene.

Object tracking is about locking onto a particular moving object(s) in real-time.

The two are similar, however.

- Object detection can occur on still **photos** while object tracking needs **video feed.**
- Object detection can be used as object tracking if we run object detection **every frame per second.**
- Object **tracking need not identify the objects**. Objects can be tracked based solely on motion features without knowing the actual objects being tracked. Thus pure object tracking can be extremely efficient if it leverages the temporal relationship between video frames.
- Running object **detection as tracking can be computationally expensive** and it can **only track known objects.**

Thus object detection requires a form of classification and localization.

While for object tracking, classification can be unnecessary depending on the problem.

In practice, real-time object detection can be sped up by employing object tracking and running classification once a few frames. Object detection can run on a slow thread looking for objects to lock onto and once those objects are locked on then object tracking, running in a faster thread, can takeover.

