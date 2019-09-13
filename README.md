#  README

## TO-DO

- Modify the Pod I am using to get a full 10 day forecast instead of the default 7 day
- Change the color scheme, it's rather basic
- figure out how to incorporate the other weather info when more than one is returned.  Currently, I only use the first.
- Add a config menu to change units, language, colors, etc.
- add pull-to-refresh (currently, only refreshes upon restart)
- add persistent data in case of network loss
- add unit tests
- smooth animation for cell expansion/collapse
- icons / text seem a bit small, but that was the requested spec.  Talk to UX folks
- Figure out how to make 'Feels like' correct.  Right now it just mimics current temp.
- Night mode / differentiate between Night/Day?

## Build

- This app uses the Weathersama CocoaPod.  Please perform a pod install if it is not included in the package upon download.
- Unzip / download into a directory and load 'WeatherByJana.xcworkspace' into XCode.  
- Build using 10.2.1 or higher for iOS 12.3.1 or higher.

## Known Issues

- This app has not  been built or tested on any device other than an iPhone XS Max running iOS 12.3.1.  YMMV.  

