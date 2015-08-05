//
//  BoardingPassInterfaceController.swift
//  AirAber
//
//  Created by Mic Pringle on 05/08/2015.
//  Copyright © 2015 Mic Pringle. All rights reserved.
//

import WatchKit
import WatchConnectivity

class BoardingPassInterfaceController: WKInterfaceController {
  
  @IBOutlet var originLabel: WKInterfaceLabel!
  @IBOutlet var destinationLabel: WKInterfaceLabel!
  @IBOutlet var boardingPassImage: WKInterfaceImage!
  
  var flight: Flight? {
    didSet {
      if let flight = flight {
        originLabel.setText(flight.origin)
        destinationLabel.setText(flight.destination)
        if let _ = flight.boardingPass {
          showBoardingPass()
        }
      }
    }
  }
  var session: WCSession? {
    didSet {
      if let session = session {
        session.delegate = self
        session.activateSession()
      }
    }
  }
  
  override func awakeWithContext(context: AnyObject?) {
    super.awakeWithContext(context)
    if let flight = context as? Flight { self.flight = flight }
  }
  
  override func didAppear() {
    super.didAppear()
    if let flight = flight where flight.boardingPass == nil && WCSession.isSupported() {
      session = WCSession.defaultSession()
      session!.sendMessage(["reference": flight.reference], replyHandler: { (response) -> Void in
        if let boardingPassData = response["boardingPassData"] as? NSData, boardingPass = UIImage(data: boardingPassData) {
          flight.boardingPass = boardingPass
          dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.showBoardingPass()
          })
        }
      }, errorHandler: { (error) -> Void in
        print(error)
      })
    }
  }
  
  private func showBoardingPass() {
    boardingPassImage.stopAnimating()
    boardingPassImage.setSize(CGSize(width: 120, height: 120))
    boardingPassImage.setImage(flight?.boardingPass)
  }
  
}

extension BoardingPassInterfaceController: WCSessionDelegate {
  
}
