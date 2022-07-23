//
//  AlertView.swift
//  wakeUpThere
//
//  Created by Daniel Košč on 22/07/2022.
//

import SwiftUI

struct AlertView: View {
    @EnvironmentObject var travel: TravelModel // global storage
    var mapAPI: MapAPI = MapAPI.instance
    private var flightData: FlightData = FlightData.instance // selected flight info
    //@State var currentAlert: Alert = Alert(title: Text("Default"))
    
    var body: some View {
        ZStack{
            Text("")
            .alert(isPresented: self.$travel.throwAlert,
                   content: {
                getAlert()
            })
        }
    }
    
    /// Helper function to create a correctly formatted alert.
    /// - Returns: Alert object with remaining distance and triggered distance info message or error message in case of worng input
    private func getAlert() -> Alert{
        
        if (travel.vehicle == .Airplane && travel.alertCode == 0){
            if flightData.isProblem(){
                return Alert(title: Text("Enter a valid flight number or check your internet connection!"))
            }
            return Alert(title: Text("Your expected arrival is \(flightData.getArrivalTime())"),
                         message: Text("You will get a notification \(Int(travel.perimeter)) min prior to the arrival."))
        }
        else{
            let distance = mapAPI.getRemainingDistance()

            if travel.alertCode == -1 {
                return Alert(title: Text("Enter a valid destination or check your internet connection!"))
            }
            else if travel.alertCode == -2{
                return NotificationController.getAlert(title: "You have approached to your destination!",
                                                message: "Click Stop button to dismiss the notification.")
            }
            else if distance == Double.infinity{
                return Alert(title: Text("Error ocurred try again later!"))
            }
            return Alert(title: Text("Remaining distance is: \(formatDistnace(distance:distance))"),
                         message: Text("You will be notified " + String(format: "%.1f", travel.perimeter) + " km before your destination!"),
                         primaryButton: .default(Text("OK")),
                         secondaryButton: .destructive(Text("Cancel"), action: {
                SoundManager.instance.stop()
                NotificationController.instance.setPerimeter(perimeter: 0.0)
            }))

        }
    }
    
    /// Helper function to correctly format distance based on value. Smaller than 10 km will remain in m the bigger will be converted to the km.
    /// - Parameter distance: value in meters
    /// - Returns: formated String
    private func formatDistnace(distance: Double) -> String{
        var formatedDistance = ""
        if distance > 10000{
            formatedDistance =  String(format: "%d", locale: Locale.current, Int(round(distance/1000))) +  " km"
        }
        else {
            formatedDistance =  String(format: "%d", locale: Locale.current, Int(round(distance))) +  " m"
        }
        return formatedDistance
    }
}

struct AlertView_Previews: PreviewProvider {
    static var previews: some View {
        AlertView()
    }
}
