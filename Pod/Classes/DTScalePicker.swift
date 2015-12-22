//
//  DateScalePicker.swift
//  ComponentsPlayground
//
//  Created by Daniel Tjuatja on 29/9/15.
//  Copyright © 2015 Daniel Tjuatja. All rights reserved.
//

import Foundation
import UIKit



@IBDesignable
class DTScalePicker: UIControl {
    
    @IBInspectable var bgColor : UIColor = UIColor.lightGrayColor() {
        didSet { containerView.backgroundColor = bgColor }
    }
    
    @IBInspectable var progressColor : UIColor = UIColor.whiteColor() {
        didSet { progressView.backgroundColor = progressColor }
    }
    
    @IBInspectable var containerOffset : CGFloat = 0.0 {
        didSet {
            containerSizeConstraint.constant = containerOffset
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable var value : CGFloat = 0.0 {
        didSet { refreshProgress() }
    }
    
    @IBInspectable var sensitivity : CGFloat = 100
    
    @IBInspectable weak var maskImage : UIImage? {
        didSet { refreshMask() }
    }
    
    @IBInspectable var isTextHidden : Bool = false {
        didSet { textLbl.hidden = isTextHidden }
    }
    @IBInspectable var fontSize : CGFloat = 20.0 {
        didSet { refreshLabel() }
    }
    @IBInspectable var fontName : String? {
        didSet { refreshLabel() }
    }
    
    
    
    
    
    
    @IBOutlet weak var progressHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerSizeConstraint : NSLayoutConstraint!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var iconImgView: UIImageView!
    @IBOutlet weak var progressView: UIView!
    @IBOutlet weak var textLbl: UILabel!
    
    
    var view : UIView!
    var startProgress : CGFloat = 0.0
    var startLoc : CGPoint = CGPointMake(0, 0)
    
    var indicator = ["Light","Moderate","Intense","Extreme"]
    
    
    func xibSetup() {
        self.backgroundColor = UIColor.clearColor()
        
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        addSubview(view)
        
        value = 0.0
        
        let panGesture = UIPanGestureRecognizer(target: self, action: "pan:")
        addGestureRecognizer(panGesture)
    }
    
    func loadViewFromNib() -> UIView {
        
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "DTScalePicker", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options : nil)[0] as! UIView
        
        return view
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    
    override func drawRect(rect: CGRect) {
        refreshMask()
        refreshProgress()
    }
    
    
    
    func startUpdate() {
        startProgress = value
    }
    func updateProgress(updateValue : CGFloat) {
        value = startProgress + (updateValue/sensitivity)
    }
    
    func pan(sender : UIPanGestureRecognizer) {
        
        if sender.state == .Began {
            startLoc = sender.locationInView(view)
            startUpdate()
        }
        
        if sender.state == .Changed {
            let currLoc = sender.locationInView(view)
            let deltaY = startLoc.y - currLoc.y
            updateProgress(deltaY)
        }
        
        if sender.state == .Ended {
            self.sendActionsForControlEvents(.ValueChanged)
        }
    }
    
    func refreshProgress() {
        if value > 1.0 { value = 1.0 }
        if value < 0.0 { value = 0.0 }
        progressHeightConstraint.constant = value * containerView.frame.height
        
        let index = Int(value * CGFloat(indicator.count - 1))
        textLbl.text = indicator[index]
    }
    
    
    func refreshMask() {
        containerView.maskView = nil
        if maskImage != nil {
            self.layoutIfNeeded()
            let mask = UIImageView(image: maskImage)
            mask.frame = containerView.bounds
            mask.contentMode = .ScaleAspectFit
            containerView.maskView = mask
        }
    }
    
    func refreshLabel() {
        if fontName == nil {
            textLbl.font = UIFont.systemFontOfSize(fontSize)
        }
        else {
            textLbl.font = UIFont(name: fontName!, size: fontSize)
        }
    }
    
    
}


