//
//  DrawingViewController.swift
//  FlitPics
//
//  Created by Emmanuel Shiferaw on 1/1/15.
//  Copyright (c) 2015 Emmanuel Shiferaw. All rights reserved.
//

import UIKit

class DrawingViewController: UIViewController {
   
    var myName:String = String()
    var userPhoto:UIImage = UIImage()
    var interestImageView:UIImageView = UIImageView()
    
    let vi = UIView(frame: UIScreen.mainScreen().bounds)
    let vi1 = UIImageView(frame: CGRectMake(30, 120, 130, 130))
    let vi2 = UIImageView(frame:CGRectMake(300, 340, 100, 100))
    
    var myRating:Float = 0.0
    
    var buttonView: UIButton!
    var mainView: UIView!
    var bottonView: UIView!
    var backButton: UIButton!
    var nameView: UILabel!
    var interestView: UILabel!
    
    @IBOutlet weak var rateLabel: UILabel!
    
    override func viewWillAppear(animated: Bool) {
        
        // MARK: ANIMATION
        UIView.animateWithDuration(3, delay: 0.4,
            options: [UIViewAnimationOptions.Repeat, UIViewAnimationOptions.Autoreverse], animations: {
            self.interestImageView.center.x -= self.view.bounds.width
            self.interestImageView.frame.size = CGSize(width: self.interestImageView.frame.width - 500, height: self.interestImageView.frame.height - 100)
        }, completion: nil)
        
        rateLabel.text = String(stringInterpolationSegment: myRating)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        rateLabel.text = String(stringInterpolationSegment: myRating)
    }
    
    override func viewDidLoad() {
     
        // MARK: LOADING FROM XIB
        super.viewDidLoad()
        switch myName {
            case "Emmanuel Shiferaw": emmanuelDraw()
            case "Hao Li": haoDraw()
            case "Weiqi Wei": weiqiDraw()
            default: defaultDraw()
        }
        
    }
    

    func buildImageView(image:UIImage) -> UIImageView {
        
        let imageView:UIImageView =  UIImageView()
        imageView.image = image
        return imageView
        
    }
    
    
    
    func buildAndReturnGraphicsContextImage() -> UIImage{
        
        // MARK: begin GC
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 150, height: 1000), true, CGFloat(1.0))
        
        // MARK: OTHER TOPIC - PATH
        let coolPath = UIBezierPath()
        coolPath.lineWidth = 5.0
        coolPath.moveToPoint(CGPoint(x: 10, y: 10))
        coolPath.addLineToPoint(CGPoint(x: 1000 , y: 1000))
        UIColor.whiteColor().setStroke()
        UIColor.greenColor().setFill()
        coolPath.fill()
        coolPath.stroke()
        return UIGraphicsGetImageFromCurrentImageContext()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func defaultDraw() {
        let myGCImageView:UIImageView = buildImageView(buildAndReturnGraphicsContextImage())
        self.view.addSubview(myGCImageView)
        myGCImageView.center = CGPoint(x: 190, y:200)
        myGCImageView.frame = CGRectMake(200,200,150, 1000)

    }
    
    //MARK: Drawings
    func emmanuelDraw() {
        
        //Loading View from nib, adding to subview
        let arr = NSBundle.mainBundle().loadNibNamed("View", owner: nil, options: nil)
        let v = arr[0] as! UIView
        print(v.subviews.count, terminator: "")
        v.backgroundColor = UIColor.whiteColor()
        let centerPoint = CGPoint(x: 100, y: 350)
        v.center = centerPoint
        self.view.addSubview(v)
        
        //Loading photo image
        interestImageView = buildImageView(userPhoto)
        self.view.addSubview(interestImageView)
        interestImageView.center = CGPoint(x:400, y:600)
        interestImageView.frame = CGRectMake(165, 50, 636, 266)
        
        //Build view from graphic context
        defaultDraw()
        
    }
    
    func haoDraw() {
        // first
        let bas = UIImage(named: "basketball.png")
        let basket = CIImage(image: bas!)
        let basextent = basket!.extent
        let center = CIVector(x: basextent.width/2.0, y: basextent.height/2.0)
        let smallerDimension = min(basextent.width, basextent.height)
        let largerDimension = max(basextent.width, basextent.height)
        // first filter
        let grad = CIFilter(name: "CIRadialGradient")
        grad!.setValue(center, forKey: "inputCenter")
        grad!.setValue(smallerDimension/2.0 * 0.85, forKey: "inputRadius0")
        grad!.setValue(largerDimension/2.0, forKey: "inputRadius1")
        let gradimage = grad!.outputImage
        // second filter
        let blendimage = basket!.imageByApplyingFilter("CIBlendWithMask", withInputParameters: ["inputMaskImage": gradimage!])
        let basicg = CIContext(options: nil).createCGImage(blendimage, fromRect: basextent)
        vi1.image = UIImage(CGImage: basicg)
        self.view.addSubview(vi1)
        
        // second
        let movies = UIImage(named: "movies.png")
        let sz = movies!.size
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(sz.width, sz.height), false, 0)
        _ = UIGraphicsGetCurrentContext()
        movies?.drawAtPoint(CGPointMake(0, 0))
        let im = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        vi2.image = im
        self.view.addSubview(vi2)
        vi2.frame = CGRectMake(30, 305, 240, 230)
        
        // third
        let dv = drawingView(frame: CGRectMake(160, 120, 130, 130))
        dv.backgroundColor = UIColor.whiteColor()
        
        self.view.addSubview(dv)
        
        let path = UIBezierPath()
        path.moveToPoint(CGPoint(x: 170,y: 239))
        path.addCurveToPoint(CGPoint(x: 301, y: 239), controlPoint1: CGPoint(x: 136, y: 373), controlPoint2: CGPoint(x: 178, y: 110))
        
        let anim = CAKeyframeAnimation(keyPath: "position")
        anim.path = path.CGPath
        anim.rotationMode = kCAAnimationRotateAuto
        anim.repeatCount = Float.infinity
        anim.duration = 5.0
        dv.layer.addAnimation(anim, forKey: "animate position along path")
    }
    
    func weiqiDraw() {
        bottonView = self.view
        nameView = UILabel()
        nameView.text = "My Photo:"
        nameView.frame = CGRectMake(10, 41, 120, 30)
        nameView.textColor = UIColor.blackColor()
        bottonView.addSubview(nameView)
        
        
        let imageView = UIImageView(frame: CGRectMake(10, 75, 160, 160))
        
        
        let myImage = UIImage(named:"Weiqi Wei.JPG")
        let myCIimage = CIImage(image:myImage!)
        let imageExtent = myCIimage!.extent
        let center = CIVector(x: imageExtent.width/2.0, y: imageExtent.height/2.0)
        let smallerDimension = min(imageExtent.width, imageExtent.height)
        let largerDimension = max(imageExtent.width, imageExtent.height)
        // first filter, old way: form filter, set values, get output
        let grad = CIFilter(name: "CIRadialGradient")
        grad!.setValue(center, forKey:"inputCenter")
        grad!.setValue(smallerDimension/2.0 * 0.95, forKey:"inputRadius0")
        grad!.setValue(largerDimension/2.0, forKey:"inputRadius1")
        let gradimage = grad!.outputImage
        // second filter, new iOS 8 way: turn one CIImage into another
        let blendimage = myCIimage!.imageByApplyingFilter(
            "CIBlendWithMask", withInputParameters: [
                "inputMaskImage":gradimage!
            ])
        
        let picCG = CIContext(options: nil)
            .createCGImage(blendimage, fromRect: imageExtent)
        imageView.image = UIImage(CGImage: picCG)
        bottonView.addSubview(imageView)
        
        
        interestView = UILabel()
        interestView.text = "Interests:"
        interestView.frame = CGRectMake(10, 240, 100, 30)
        interestView.textColor = UIColor.blackColor()
        bottonView.addSubview(interestView)
        
        // draw with graphic context
        let drawView = UIImageView(frame: CGRectMake(10, 280, 300, 150))
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(100, 100), false, 0)
        let p = UIBezierPath(roundedRect: CGRectMake(0, 0, 100, 100),cornerRadius:1.0)
        UIColor.redColor().setStroke()
        p.stroke()
        let im = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        drawView.image = im
        bottonView.addSubview(drawView)
        
        
        let interest1Name = "soccer.png"
        let interest1 = UIImage(named: interest1Name)
        let interest1View = UIImageView(image: interest1!)
        interest1View.frame = CGRectMake(11, 281, 148, 148)
        bottonView.addSubview(interest1View)
        
        let interest2Name = "table_tennis.png"
        let interest2 = UIImage(named: interest2Name)
        let interest2View = UIImageView(image: interest2!)
        interest2View.frame = CGRectMake(160, 295, 148, 113)
        bottonView.addSubview(interest2View)
    }
    @IBAction func unwindToDrawing(segue: UIStoryboardSegue) {
        let source = segue.sourceViewController as! RateViewController
        myRating = source.rateSlider.value
        print("Unwinding")
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "RateSegue" {
            let destination = (segue.destinationViewController as! RateViewController)
            destination.startingRate = myRating
        }
        
    }
}
