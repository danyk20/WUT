//
//  AlertView.swift
//  wakeUpThere
//
//  Created by Daniel Košč on 22/07/2022.
//

import SwiftUI

struct AlertView: View {
    @EnvironmentObject var travel: TravelModel // global storage
    @State private var loadView: ProgressView = ProgressView()
    @State private var timer: TimerModel?
    private var mapAPI: MapAPI = MapAPI.instance
    private var flightData: FlightData = FlightData.instance
    
    var body: some View {
        ZStack{
            if travel.loading{
                loadView
            }
            Text("")
                .onChange(of: travel.throwAlert, perform: { newValue in
                    if newValue && travel.alertCode == -10 && travel.vehicle == .Airplane{
                        timer = TimerModel(repeats: false, period: 10, travel: travel)
                        timer?.runTimerAlert()
                    }
                })
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
            return Alert(title: Text("Your expected arrival is \(flightData.getArrivalTime())"),
                         message: Text("You will get a notification \(Int(travel.perimeter)) min prior to the arrival."))
        }
        let distance = mapAPI.getRemainingDistance()
        
        if travel.alertCode == 10{
            return Alert(title: Text("Wrong flight number, chceck it and try again."))
        }
        else if travel.alertCode == 4{
            return Alert(title: Text("No information about future flight with this flight number have been found."))
        }
        else if travel.alertCode == 3{
            return Alert(title: Text("Cannot dowload flight data, check your internet connection!"))
        }
        else if travel.alertCode == 1{
            return Alert(title: Text("Your flight cannot be found, enter a valid flight number!"))
        }
        else if travel.alertCode == -1 {
            return Alert(title: Text("Enter a valid destination or check your internet connection!"))
        }
        else if travel.alertCode == -2{
            return Alert(title: Text("You have approached to your destination!"),
                         message: Text("Click Stop button to dismiss the notification."),
                         dismissButton:  .default(Text("Stop"), action: {
                SoundManager.instance.stop()
                travel.reset()
            }))
        }
        else if travel.alertCode == -10{
            return Alert(title: Text("Loading"))
        }
        else if distance == Double.infinity{
            return Alert(title: Text("Error ocurred try again later!"))
        }
        return Alert(title: Text("Remaining distance is: \(formatDistnace(distance:distance))"),
                     message: Text("You will be notified " + String(format: "%.1f", travel.perimeter) + " km before your destination!"),
                     primaryButton: .default(Text("OK")),
                     secondaryButton: .destructive(Text("Cancel"), action: {
            SoundManager.instance.stop()
            travel.reset()
        }))
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
