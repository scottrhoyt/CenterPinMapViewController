CenterPinMapViewController
==========================

This is a view controller intended to be used to allow users to select a location on a map.  It places a pin annotation view at the center of the mapview and adjusts it's location and the annotations coordinate as the map region changes.  The public interface allows retrieving of the user's selected location.  The repository contains a simple Xcode 5 project using the view controller.

In order to use, simply wire up the view contoller to a mapview on the storyboard.  This relevant property is the mapview outlet in the private interface of the controller.  Alternatively, you could expose the mapview property to the public interface and set it programatically.
