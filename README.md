# FitnessTrackerApp
[toc]
## Description
This app has two functions. Doing workouts and achieving goals. The app tracks steps in real time and associates the steps and durations by goal day! If no goals are created for a week, the app will create empty goals for the week. You can create new goals in advance up to 10 weeks ahead. The default step goal per day is 10000 steps. However this can be changed if required. 
## Design
The app is made up of FitnessTracker app which is the main iOS app
The app has two Swift packages

1. WorkoutTracker
1. GoalManager

### WorkoutTracker
This package is built on HealthKit. It hides the HealthKit APIs behind a WorkoutManger. This is a singleton that wraps the calls needed to authorise access to HealthKit data and start and stop a workout session. 

### GoalManager
The purpose of GoalManager is to use SwiftData to manage Goals that the app can use to store and retrieve Goal data for pairing with Workouts! 

### FitnessTrackerApp
The FitnessTrackerApp uses a MVVM type model with SwiftUI. It also provides the ModelContext for use by the GoalManager's GoalDataService when creating, editing and updating goals.

## Unit Tests 
The app retains the built in Unit and UI tests that come when the project is created.

The app also includes a set of unit tests for the **GoalDataService**

The unit tests use the **latest** Swift Unit test paradigm using *#expect*

## Access Control Decisions
### Goal Manager
GoalManager only has three useful classes. The models, ***Goal*** and ***GoalWeek***, and the service, ***GoalDataService***.

Since the interface is fairly flat and there is no need or purpose for a singleton or other design patterns there was no need for special encapsulation. Thus the entire package is essentially public. 

### WorkoutTracker
The WorkoutTracker has basically two public facing classes. ***WorkoutManager*** and ***Workout***.

The manager manages a workout and has three methods:

	func requestAuthorisation() async throws 
	func startWorkout() async
	func stopWorkout() async -> Workout
The class itself is a singleon and hides the implementation of the HealthKitWorker acting like a proxy design pattern for the worker itself which is internal. 

The ***HealthKitWorker*** has the same methods as the manager but keeps them internal. It also manages reading the step count using a live observer to ensure the most accurate step count is retrieved. 

This implementation is hidden from the manager. 

_***Small caveat:***_ The WorkoutManager has MockHealtKitWorker that does nothing. This initiates when running unit tests since the unit tests do not need the HealthKit code to run and it delivers errors when the Unit tests run. This code could be altered or optimised and moved to the main app but time constraints meant it was put here for now. 

## Trade-offs
I have noticed a hanging issue in the debugger that may require more work to track down. 

### Threading
SwiftData runs on the main thread but HealthKit needs to run on a background thread. Managing that difference did cause some issues and there is certainly better ways of getting the two parts of the functionality to co-exist. 

### UI
There are a number of places where UI code was duplicated. A better solution given more time would be to create reusable components and perhaps even put them in their own package. 

### Data
I chose to use SwiftData to save the goals but a future app with a proper backend would allow API calls to save the data to the backend. 

Another option is to use iCloud to persist the goal data. Unfortunately that seems to require a paid Apple Developer account so I didn't get to that.

### Background use
Something I wanted to add but didn't have time for was live updates. That would allow the workout to happen in the background and use the lock screen and the dynamic island to display the duration of the workout. 

That would have been a fun addition. 

### Testing
I am not sure if testing WorkoutTracker makes sense but given time that possibility could have been investigated. 

Also some UI changes might have been required to make the UI properly testable. Less tight integration may have been helpful. 

### Submodules
The app uses local packages but they are independant. An improvement might have been to use submodules which would allow the app to run immediatedly with a single checkout. At the moment three clones will be required. 

### Additional Data
I originally wanted to track calories burned (some of that code is still there) but didn't have time to figure out how to build it in with the live tracking of steps!

## How To Build
The project currently uses local packages. The packages are not currently distributed as submodules or as remote packages so extra work is needed to get the app running. 

Obviously you start with 
	
	git clone git@github.com:rleclus/FitnessTrackerApp.git

Then
	
	cd FitnessTrackerApp
	
Then 

	git clone git@github.com:rleclus/WorkoutTracker.git
	git clone git@github.com:rleclus/GoalManager.git
	
Once these are done you can run 

	open FitnessTrackerWorkspace.xcworkspace
	
Or open the workspace from Finder (or via Xcode itself)
	
In Xcode, you will need to update the ***Team*** selection in Signing and Capabilities, to match your team and update the ***Bundle Identifier*** to correctly run the application.

## Final Thoughts 

Since HealthKit data is only really on the iPhone, you do need to run the app on a real device to see it in action. 

The Unit Tests can be run on simulator though. 