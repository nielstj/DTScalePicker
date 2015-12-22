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
public class DTScalePicker: UIControl {
    
    @IBInspectable public var bgColor : UIColor = UIColor.lightGrayColor() {
        didSet { containerView.backgroundColor = bgColor }
    }
    
    @IBInspectable public var progressColor : UIColor = UIColor.whiteColor() {
        didSet { progressView.backgroundColor = progressColor }
    }
    
    @IBInspectable public var containerOffset : CGFloat = 0.0 {
        didSet {
            containerSizeConstraint.constant = containerOffset
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable public var value : CGFloat = 0.0 {
        didSet { refreshProgress() }
    }
    
    @IBInspectable public var sensitivity : CGFloat = 100
    
    @IBInspectable public weak var maskImage : UIImage? {
        didSet { refreshMask() }
    }
    
    @IBInspectable public var isTextHidden : Bool = false {
        didSet { textLbl.hidden = isTextHidden }
    }
    @IBInspectable public var fontSize : CGFloat = 20.0 {
        didSet { refreshLabel() }
    }
    @IBInspectable public var fontName : String? {
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
    
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    
    override public func drawRect(rect: CGRect) {
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


