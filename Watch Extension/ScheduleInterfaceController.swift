//
//  ScheduleInterfaceController.swift
//  AirAber
//
//  Created by Mic Pringle on 05/08/2015.
//  Copyright © 2015 Mic Pringle. All rights reserved.
//

import WatchKit

class ScheduleInterfaceController: WKInterfaceController {
  
  @IBOutlet var flightsTable: WKInterfaceTable!
  
  var flights = Flight.allFlights()
  var selectedIndex = 0
  
  override func awakeWithContext(context: AnyObject?) {
    super.awakeWithContext(context)
    
    flightsTable.setNumberOfRows(flights.count, withRowType: "FlightRow")
    for index in 0..<flightsTable.numberOfRows {
      if let controller = flightsTable.rowControllerAtIndex(index) as? FlightRowController {
        controller.flight = flights[index]
      }
    }
  }
  
  override func didAppear() {
    super.didAppear()
    if flights[selectedIndex].checkedIn, let controller = flightsTable.rowControllerAtIndex(selectedIndex) as? FlightRowController {
      animateWithDuration(0.35, animations: { () -> Void in
        controller.updateForCheckIn()
      })
    }
  }
  
  override func table(table: WKInterfaceTable, didSelectRowAtIndex rowIndex: Int) {
    let flight = flights[rowIndex]
    let controllers = flight.checkedIn ? ["Flight", "BoardingPass"] : ["Flight", "CheckIn"]
    selectedIndex = rowIndex
    presentControllerWithNames(controllers, contexts:[flight, flight])
  }
  
}
