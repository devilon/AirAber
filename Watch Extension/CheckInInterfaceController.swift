//
//  CheckInInterfaceController.swift
//  AirAber
//
//  Created by Mic Pringle on 05/08/2015.
//  Copyright © 2015 Mic Pringle. All rights reserved.
//

import WatchKit

class CheckInInterfaceController: WKInterfaceController {
  
  @IBOutlet var backgroundGroup: WKInterfaceGroup!
  @IBOutlet var originLabel: WKInterfaceLabel!
  @IBOutlet var destinationLabel: WKInterfaceLabel!
  
  var flight: Flight? {
    didSet {
      if let flight = flight {
        originLabel.setText(flight.origin)
        destinationLabel.setText(flight.destination)
      }
    }
  }
  
  override func awakeWithContext(context: AnyObject?) {
    super.awakeWithContext(context)
    if let flight = context as? Flight { self.flight = flight }
  }
  
  @IBAction func checkInButtonTapped() {
    let duration = 0.35
    let delay = dispatch_time(DISPATCH_TIME_NOW, Int64((duration + 0.15) * Double(NSEC_PER_SEC)))
    backgroundGroup.setBackgroundImageNamed("progress")
    backgroundGroup.startAnimatingWithImagesInRange(NSRange(location: 0, length: 10), duration: duration, repeatCount: 1)
    dispatch_after(delay, dispatch_get_main_queue()) { () -> Void in
      self.flight?.checkedIn = true
      self.dismissController()
    }
  }
  
}
