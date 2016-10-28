//
//  ViewController.swift
//  Facelet
//
//  Created by Panpan Lin on 19/10/2016.
//  Copyright © 2016 IBM. All rights reserved.
//

import UIKit

class FaceViewController: UIViewController {
    
    // default value for facial expression
    // FacialExpression is a value type
    // if anything get change, didSet will get called
    // if FacialExpression is a class, then it will not.
    var expression = FacialExpression(eyes: .Open, eyeBrows: .Normal, mouth: .Smile) {
        didSet {
            updateUI()
        }
    }
    
    // controller handles the recognizer and changes the UI
    @IBOutlet weak var faceView: FaceView! {
        // update the view when our view is hooked up the first time,
        // shortly after iOS comes along and hook up our view
        didSet {
            faceView.addGestureRecognizer(UIPinchGestureRecognizer(
                    target: faceView, action: #selector(FaceView.changeScale(recognizer:))
            ))
            
            // swip gesture needs to be configured
            let happierSwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(FaceViewController.increaseHappiness))
            happierSwipeGestureRecognizer.direction = .up
            faceView.addGestureRecognizer(happierSwipeGestureRecognizer)
            
            let sadderSwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(FaceViewController.decreaseHappiness))
            sadderSwipeGestureRecognizer.direction = .down
            faceView.addGestureRecognizer(sadderSwipeGestureRecognizer)
            
            updateUI()
        }
    }
    
    @IBAction func toggleEyes(_ recognizer: UITapGestureRecognizer) {
        if recognizer.state == .ended {
            switch expression.eyes {
            case .Open: expression.eyes = .Closed
            case .Closed: expression.eyes = .Open
            case .Squinting: break
            }
        }
    }
    
    func increaseHappiness() {
        expression.mouth = expression.mouth.happierMouth()
    }
    
    func decreaseHappiness() {
        expression.mouth = expression.mouth.sadderMouth()
    }
    
    // a dictionary
    private var mouthCurvatures = [
        FacialExpression.Mouth.Frown: -1.0,
        .Grin: 0.5,
        .Smile: 1.0,
        .Smirk: -0.5,
        .Neutral: 0.0
    ]
    
    private var eyeBrowTilt = [
        FacialExpression.EyeBrows.Relaxed: 0.5,
        .Furrowed: -0.5,
        .Normal: 0.0
    ]

    private func updateUI(){
        if faceView != nil {
            switch expression.eyes {
            case .Open: faceView.eyesOpen = true
            case .Closed: faceView.eyesOpen = false
            case .Squinting: faceView.eyesOpen = false
            }
            faceView.mouthCurvature = mouthCurvatures[expression.mouth] ?? 0.0 // default to 0 if return nil
            faceView.eyeBrowTilt = eyeBrowTilt[expression.eyeBrows] ?? 0.0
        }
    }

}

