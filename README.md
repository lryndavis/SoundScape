# SoundScape

SoundScape is a currently in progress music discovery app that uses the Spotify API to create immersive, location-based listening experiences. 

### Tech

* [Spotify-iOS-SDK] - Streaming audio via Spotify
* [Cocoapods] - Dependancy manager 
* [Firebase] - Realtime database 
* [Geofire] - Realtime location queries with Firebase
* [Alamofire] - Networking library 
* [Bolts-Swift] - Async operations 


### Installation

Because this app uses the Spotify SDK for streaming audio, you will need a valid Spotify account to successfully use the app. 

First, install the necessary gems for use with the Sinatra dev server. 
```sh
$ gem install sinatra encrypted_strings
```
Next, begin the Sinatra dev server for Spotify auth token refresh/swap.  

```sh
$ ruby spotify_token_swap.rb
```
When running the app in the Xcode, you will be prompted to input your Spotify login info. Upon successful login, you will need to simulate a location in the Xcode simulator. 
* Navigate to Debug > Simulate Location > nepdx

### Todos

 - Improved error handling and login flow
 - Production server environment 
 - Flesh out UI/UX/overall aesthetic 
 - Tests!
 - Add ability to favorite songs and create playlists
 - Add feature for generating roadtrip playlists using location based tracks between start and end destinations
 - Overall clean up and refactor
 - And more!
