# WUT - Wake Up There  

![Icon logo](WUT_logo.png)

## Table of contents  
* [General info](#General-info)
* [Technologies](#Technologies)
* [Current version](#Current-version)
    * [Description](#Description)
    * [Already implemented features](#Already-implemented-features)
    * [Main screen](#Main-screen)
    * [destination (second) screen](#destination-(second)-screen)
* [Acknowledgements](#Acknowledgements)
    * [API](#API)
    * [Inspiration](#Inspiration)
* [Contact](#Contact)

## General info
This project is a simple iOS app for notification or alarm when approaching a chosen destination, primarily based on location data.
	
## Technologies
Project is created with:
* Swift version: 5
* iOS version: 15.5
* Xcode version: 13.4.1

## Current version  

### Description  
The application is currently in the early developing stage with fundamental functionality. It is possible to select the mean of transport from 4 options (aeroplane, train, bus, boat), enter the destination (city or exact place in the city) and finally select the air distance when the app should notify you about approaching your destination.

#### Already implemented features  
- show the current position on the map
- always centre map based on your position
- zoom in or zoom out the map
- see the selected destination as a pin on the map
- a slider as user input for distance or number of minutes
- works in background
- plays a sound when approaching the final destination
- show scroll list of destinations based on text input
- calculate remaining distance
- support dark mode
- find flight based on flight number
- convert time between timezones
- shows estimated arrival time for flights
- remaining time/distance count down
- checker of the valid flight number

### Main screen :  
Selection of tranport type.

![iPhone 13 mini WUT app main screen](Screenshots/select_view.png)
![iPhone 13 mini WUT app main screen](Screenshots/select_view_black.png)

### destination (second) screen :  
Entering destination name, list of possible destination over the map.

![iPhone 13 mini WUT app selecting destination](Screenshots/destination_view.png)
![iPhone 13 mini WUT app selecting destination](Screenshots/destination_view_black.png)

Entering flight number.

![iPhone 13 mini WUT app enter flightnumber](Screenshots/flight_destination.png)
![iPhone 13 mini WUT app enter flightnumber](Screenshots/flight_destination_black.png)

Choosing the distance from the destination by entering number or using slider:

![iPhone 13 mini WUT app selecting perimeter](Screenshots/select_perimeter.png)
![iPhone 13 mini WUT app selecting perimeter](Screenshots/select_perimeter_black.png)

Choosing the number of minutes prior to arrival entering number or using slider:

![iPhone 13 mini WUT app selecting minutes airplane](Screenshots/flight_perimeter.png)
![iPhone 13 mini WUT app selecting minutes airplane](Screenshots/flight_perimeter_black.png)

Temporal alert showing entered input.

![iPhone 13 mini WUT app distance alert](Screenshots/show_distance.png)
![iPhone 13 mini WUT app distance alert](Screenshots/show_distance_black.png)

![iPhone 13 mini WUT app flight confirmation alert](Screenshots/flight_set.png)
![iPhone 13 mini WUT app flight confirmation alert](Screenshots/flight_set_black.png)

While traveling to the destination on the ground displaying remaining distance.

![iPhone 13 mini WUT app traveling to destination with remaining distance](Screenshots/destination_view_waiting.png)
![iPhone 13 mini WUT app traveling to destination with remaining distance](Screenshots/destination_view_waiting_black.png)

While traveling to the destination by airplane displaying remaining time.

![iPhone 13 mini WUT app traveling to destination with remaining distance](Screenshots/destination_view_waiting_airplane.png)
![iPhone 13 mini WUT app traveling to destination with remaining distance](Screenshots/destination_view_waiting_airplane_black.png)

Final alert notifying the user about entering the set perimeter.

![iPhone 13 mini WUT app final alert](Screenshots/alert.png)
![iPhone 13 mini WUT app final alert](Screenshots/alert_black.png)

### Error and warnings :  
These are possible error messages that you can get:

You have entered a destination location which couldn't be found, or you do not have an internet connection to find your entered location. Verify that input is not empty and location has the correct spelling.

![iPhone 13 mini WUT app error message](Screenshots/error_msg.png)
![iPhone 13 mini WUT app error message](Screenshots/error_msg_black.png)

## Acknowledgements  

### API  
[positionstack](https://positionstack.com) - used to get the coordinates from user input

[Flight Radar](https://rapidapi.com/apidojo/api/flight-radar1/details) - used to get flight information based on flight number

### Inspiration
This app is based on an idea of [Viktoria Husovska](https://www.linkedin.com/in/viktória-husovská-272528224/), which I would like to thank this way. 

## Contact  

author: Daniel Kosc

email: daniel.kosc@gmail.com

social: [linkedin](https://www.linkedin.com/in/daniel-košč-3b4983189/)