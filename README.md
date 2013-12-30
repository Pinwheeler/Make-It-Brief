ChiroMatic
==========

ChiroMatic git repository for help making my code better

### Modified by Rob Ryan, 14 April 2013

- Completely removed scene from storyboard for `PrintContainerViewController`

- Removed container view from `PrintViewController` scene on the storyboard

- Copied the scrollview and its subviews (all of the labels and image view) to `PrintViewController` scene

- Added `IBOutlet` qualifier to appropriate `PrintViewController` properties and hooked up those outlets

- Simplified `PrintViewController` to not use `containerView` and got rid of the copying of properties from child controller

- NB: `PrintContainerViewController` is no longer needed, but I didn't delete it, but you could.

### Edits by Rob Ryan, 13 April 2013

- Recreated `PrintViewController` and `PrintContentViewController` scenes in the storyboard (keeping your original scenes there, for sake of comparison; you'll want to remove those old scenes to avoid confusion, but I was reticent to do so myself until you had a chance to review my changes; the segue names to your old scenes were renamed to avoid the app from going to your old scenes)

- In `PrintContentViewController`, let the view controller keep its standard `UIView` top level view, and put the `UIScrollView` within that; put the controls right in the `UIScrollView`, eliminating the intermediary `UIView`, which seems to me would defeat the purpose of the `UIScrollView`

- Moved the three frameworks into the framework folder

- Added logging message in `PrintContentViewController.m` method `viewDidAppear` so I could make sure everything was ok (which it is now)

- Moved the setting of the properties in `PrintViewController` out of `prepareForSegue` (as, in general, that's too early in the view creation process to be accessing a destination controller's controls); the `viewDidAppear` now calls the routine to make sure the properties are properly set
