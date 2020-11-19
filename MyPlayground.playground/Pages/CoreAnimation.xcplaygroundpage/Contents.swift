//: [Previous](@previous)

import Foundation
import UIKit
import PlaygroundSupport
import Masonry

PlaygroundPage.current.liveView = MyViewController()


extension UIImage {
    
    static func createRandomColorImage(imageSize:CGSize) -> UIImage{
        
        let randomColor = UIColor.init(red: CGFloat(arc4random()%256)/255.0, green: CGFloat(arc4random()%256)/255.0, blue: CGFloat(arc4random()%256)/255.0, alpha: 1)
        return createImageWith(color: randomColor, size:imageSize)
    }
    
    static func createImageWith(color:UIColor,size:CGSize = CGSize.init(width: 1, height: 1))->UIImage {
        let r = CGRect.init(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContext(r.size)
        let context:CGContext = UIGraphicsGetCurrentContext()!
        
        context.setFillColor(color.cgColor)
        context.fill(r)
        
        let img:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return img
    }
    
    static func createCircleImageWith(color:UIColor,radius:CGFloat,opaque:Bool = true)->UIImage {
        let circle = UIBezierPath.init(roundedRect: CGRect.init(x: 0, y: 0, width: radius * 2, height: radius * 2), cornerRadius: radius)
        
        UIGraphicsBeginImageContextWithOptions(circle.bounds.size, false, UIScreen.main.scale)
        let context:CGContext = UIGraphicsGetCurrentContext()!
        
        context.addPath(circle.cgPath)
        context.setFillColor(color.cgColor)
        context.fillPath()
        
        let img:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return img
    }
        
}


class MyViewController : UIViewController {
    
    lazy var button: UIButton = {
        let bt = UIButton.init(type: .custom)
        bt.setTitle("按钮-normal", for: .normal)
        bt.setTitle("按钮-被选中", for: .selected)
        bt.setTitleColor(UIColor.blue, for: .normal)
        bt.setTitleColor(UIColor.red, for: .selected)
        bt.addTarget(self, action: #selector(buttonIsTapped(sender:)), for: .touchUpInside)
        return bt
    }()
    
    lazy var viewContainer: UIView = {
        let view = UIView.init()
        view.backgroundColor = UIColor.init(white: 0.9, alpha: 0.9)
        return view
    }()
    
    lazy var containerLayer: CALayer = {
        let layer = CALayer.init()
        return layer
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(button)
        view.addSubview(viewContainer)
//        testZPositionLayers()
//        testZPositionViews()
//        testResizeFilterForImages()
        
        button.mas_makeConstraints { (make) in
            make?.top.offset()(20)
            make?.centerX.equalTo()
        }
        
        viewContainer.mas_makeConstraints { (make) in
            make?.top.equalTo()(self.button.mas_bottom)?.offset()(20)
            make?.centerX.equalTo()
            make?.size.equalTo()(CGSize.init(width: 200, height: 200))
        }
        view.layoutIfNeeded()
        viewContainer.layer.addSublayer(containerLayer)
        containerLayer.frame = viewContainer.bounds
//        testSimpleTransform3D()
//        testTransformLayerCube()
        //此处无法测试动画，动画无效。
//        testAnimation()
//        testRoundedRectFromImage()
        testOffScreenRender()
    }
    
    //测试layer.zPosition修改了，视图层级是否修改，还有显示效果。
 
    let imageWidth:CGFloat = 50
    
    func testResizeFilterForImages() -> () {
        let customView = UIView.init(frame: CGRect.init(x: 0, y: 20, width: 375, height: 500))
        customView.backgroundColor = UIColor.init(white: 0.9, alpha: 1)
        view.addSubview(customView)
        
        let numberImage = UIImage.init(named: "Numbers")
        
        //下面的效果和上面是一样的，也就是设置UIimageView.layer.contentRect也是可以的哦。
        var imageVs = [UIImageView]()
        
        for i in 0..<6 {
            let view = UIImageView.init(image: numberImage)
            view.frame = CGRect.init(x: CGFloat(i) * imageWidth, y: 100, width: imageWidth, height: 40)
            view.contentMode = .scaleAspectFit
            view.layer.contentsRect = CGRect.init(x: 0.1, y: 0, width: 0.1, height: 1)
            view.layer.minificationFilter = .nearest
            view.layer.magnificationFilter = .nearest
            customView.addSubview(view)
            imageVs.append(view)
        }
    }
    
    func testSimpleTransform3D() -> () {
        
        let showViews:[UIView] = {
            var views = [UIView]()
            let count:Int = 5
            for i in 0...count {
                let newView = UILabel.init()
                newView.text = "\(i)"
                newView.textAlignment = .center
                newView.textColor = UIColor.black
                newView.layer.borderColor = UIColor.black.cgColor
                newView.layer.borderWidth = 1
                newView.font = UIFont.systemFont(ofSize: 16)
                newView.backgroundColor = UIColor.white
                newView.frame = CGRect.init(x: viewContainer.bounds.width / 2, y:  viewContainer.bounds.height / 2, width: 50, height: 50)
                views.append(newView)
            }
            return views
        }()
        
        showViews.forEach { (view) in
            viewContainer.addSubview(view)
        }
        
        //简单的看旋转
//        let firstView = showViews[0]
//        firstView.center = CGPoint.init(x: 50, y: 50)
//        var transform = CATransform3DIdentity
//        transform.m34 = -1/300
//        transform = CATransform3DRotate(transform, CGFloat.pi/4, 0, 1, 0)
//        firstView.layer.transform = transform
//
//        //父layer和sublayer做相反的变换，结果没有抵消。
//        transform = CATransform3DIdentity
//        transform.m34 = -1/300
//        transform = CATransform3DRotate(transform, -CGFloat.pi/4, 0, 1, 0)
//        viewContainer.layer.transform = transform
//
//        let secondView = showViews[1]
//        secondView.center = CGPoint.init(x: 50, y: 100)
//        transform = CATransform3DIdentity
//        transform.m34 = -1/300
//        transform =  CATransform3DRotate(transform, CGFloat.pi/4, 0, 1, 0)
//
//
//        let thirdView = showViews[2]
//        thirdView.center = CGPoint.init(x: 150, y: 100)
//        transform = CATransform3DIdentity
//        transform.m34 = -1/1000
//        transform =  CATransform3DRotate(transform, -CGFloat.pi/4, 0, 1, 0)
//        thirdView.layer.transform = transform
//
//        let fourthView = showViews[3]
//        fourthView.center = CGPoint.init(x: 150, y: 150)
//        transform = CATransform3DIdentity
//        transform.m34 = -1/1000
//        transform =  CATransform3DRotate(transform, CGFloat.pi/2, 0, 1, 0)
//        fourthView.layer.transform = transform
        
        var perspective = CATransform3DIdentity
        perspective.m34 = -1 / 300
        perspective = CATransform3DRotate(perspective, CGFloat.pi / 4, 0, 1, 0)
        perspective = CATransform3DRotate(perspective, CGFloat.pi / 4, 1, 0, 0)
        viewContainer.layer.sublayerTransform = perspective
//        看6面体
        let firstView = showViews[0]
        firstView.layer.transform = CATransform3DMakeTranslation(0, 0, 25)

        let secondView = showViews[1]
        var transform = CATransform3DIdentity
        transform = CATransform3DTranslate(transform, -25, 0, 0)
        secondView.layer.transform = CATransform3DRotate(transform, -CGFloat.pi/2, 0, 1, 0)
//        viewContainer.layer.transform = perspective
        
        let thirdView = showViews[2]
        transform = CATransform3DIdentity
        transform = CATransform3DTranslate(transform, 25, 0, 0)
        thirdView.layer.transform = CATransform3DRotate(transform, CGFloat.pi/2, 0, 1, 0)

        let fourthView = showViews[3]
        transform = CATransform3DIdentity
        transform = CATransform3DTranslate(transform, 0, 25, 0)
        fourthView.layer.transform = CATransform3DRotate(transform, CGFloat.pi/2, 1, 0, 0)

        let fiveView = showViews[4]
        transform = CATransform3DIdentity
        transform = CATransform3DTranslate(transform, 0, -25, 0)
        fiveView.layer.transform = CATransform3DRotate(transform, -CGFloat.pi/2, 1, 0, 0)
    }
    
    
    func cubeLayer(with cubeTransform:CATransform3D) -> CALayer {
        let cubeLayer = CATransformLayer.init()
        cubeLayer.frame = CGRect.init(x: 50, y: 50, width: 100, height: 100)

        var allTransforms = [CATransform3D]()
        
        allTransforms.append(CATransform3DIdentity)
        
        var transform = CATransform3DIdentity
        transform = CATransform3DTranslate(transform, 0, 0, 25)
        allTransforms.append(transform)
        
        transform = CATransform3DIdentity
        transform = CATransform3DTranslate(transform, -25, 0, 0)
        transform = CATransform3DRotate(transform, -CGFloat.pi/2, 0, 1, 0)
        allTransforms.append(transform)
       
        transform = CATransform3DIdentity
        transform = CATransform3DTranslate(transform, 25, 0, 0)
        transform = CATransform3DRotate(transform, CGFloat.pi/2, 0, 1, 0)
        allTransforms.append(transform)
        
        transform = CATransform3DIdentity
        transform = CATransform3DTranslate(transform, 0, 25, 0)
        transform = CATransform3DRotate(transform, CGFloat.pi/2, 1, 0, 0)
        allTransforms.append(transform)
        
        transform = CATransform3DIdentity
        transform = CATransform3DTranslate(transform, 0, -25, 0)
        transform = CATransform3DRotate(transform, -CGFloat.pi/2, 1, 0, 0)
        allTransforms.append(transform)
        
        
        for i in 0...5 {
            let layer = CALayer.init()
            layer.frame = CGRect.init(x: cubeLayer.bounds.width / 2, y: cubeLayer.bounds.height / 2, width: 50, height: 50)
            layer.backgroundColor = UIColor.init(red: CGFloat(arc4random() % 256) / 256, green: CGFloat(arc4random() % 256) / 256, blue: CGFloat(arc4random() % 256) / 256, alpha: 1).cgColor
            layer.transform = allTransforms[i]
            cubeLayer.addSublayer(layer)
        }
        
        cubeLayer.transform = cubeTransform
//        cubeLayer.sublayerTransform  = cubeTransform
        return cubeLayer
    }
    
    func testTransformLayerCube() -> () {
        
        containerLayer.backgroundColor = UIColor.init(white: 0.5, alpha: 0.5).cgColor
        containerLayer.frame = CGRect.init(x: 0, y: 0, width: 200, height: 200)
        
        var perspective = CATransform3DIdentity
        perspective.m34 = -1 / 500
        perspective = CATransform3DRotate(perspective, CGFloat.pi / 4, 0, 1, 0)
        containerLayer.transform = perspective
        
        var firstCubeTransfrom = CATransform3DIdentity
//        firstCubeTransfrom.m34 =  -1 / 1000
        firstCubeTransfrom = CATransform3DTranslate(firstCubeTransfrom, -50, -50, 0)
        firstCubeTransfrom = CATransform3DRotate(firstCubeTransfrom, CGFloat.pi / 4, 0, 1, 0)
        firstCubeTransfrom = CATransform3DRotate(firstCubeTransfrom, CGFloat.pi / 4, 1, 1, 0)
        containerLayer.addSublayer(cubeLayer(with: firstCubeTransfrom))
        
        var secondCubeTransfrom = CATransform3DIdentity
//        secondCubeTransfrom.m34 =  -1 / 750
        secondCubeTransfrom = CATransform3DTranslate(secondCubeTransfrom, 50, 50, 0)
        secondCubeTransfrom = CATransform3DRotate(secondCubeTransfrom, CGFloat.pi / 4, 0, 1, 0)
        secondCubeTransfrom = CATransform3DRotate(secondCubeTransfrom, CGFloat.pi / 4, 1, 0, 0)
        secondCubeTransfrom = CATransform3DRotate(secondCubeTransfrom, CGFloat.pi / 4, 0, 0, 1)
        containerLayer.addSublayer(cubeLayer(with: secondCubeTransfrom))
        
    }
    
    func testAnimation() -> () {
//        let animation = CABasicAnimation.init()
//        animation.autoreverses
//        animation.byValue
//        let keyFrameAnimation = CAKeyframeAnimation.init()
//
//        let transition = CATransition.init()
        viewContainer.isUserInteractionEnabled = true
        viewContainer.addGestureRecognizer(UIPanGestureRecognizer.init(target: self, action: #selector(viewIsPanned(sender:))))
//        viewContainer.layer.speed = 0
                
        var perspective = CATransform3DIdentity
        perspective.m34 = -1 / 500
        containerLayer.sublayerTransform = perspective
        
        let doorLayer = CALayer.init()
        doorLayer.frame = CGRect.init(x: 0, y: 50, width: 60, height: 80)
        doorLayer.backgroundColor = UIColor.brown.cgColor
        doorLayer.anchorPoint = CGPoint.init(x: 0, y: 0.5)
        containerLayer.addSublayer(doorLayer)
        
        let animation = CABasicAnimation.init()
        animation.keyPath = "transform.rotation.y"
        animation.toValue = -CGFloat.pi / 2
////        animation.keyPath = "backgroundColor"
////        animation.toValue = UIColor.red.cgColor
//        animation.keyPath = "position"
//        animation.toValue = CGPoint.zero
        animation.repeatCount = 10
        animation.autoreverses = true
        animation.duration = 1
        animation.timingFunction = CAMediaTimingFunction.init(controlPoints: 1, 0, 0.75, 1)
//
        doorLayer.add(animation, forKey: "position ")
        print("")
    }
    
    func testOffScreenRender() -> () {
        containerLayer.allowsGroupOpacity = true
        containerLayer.backgroundColor = UIColor.red.cgColor
        containerLayer.opacity = 0.5
        
        let greenLayer = CALayer.init()
        greenLayer.frame  = CGRect.init(x: 0, y: 0, width: containerLayer.bounds.width/2, height: containerLayer.bounds.height/3)
        greenLayer.backgroundColor = UIColor.green.cgColor
        greenLayer.opacity = 0.3
        containerLayer.addSublayer(greenLayer)
        
        let yellowLayer = CALayer.init()
        yellowLayer.frame  = CGRect.init(x: containerLayer.bounds.width/3, y: 0, width: containerLayer.bounds.width/2, height: containerLayer.bounds.height/3)
        yellowLayer.backgroundColor = UIColor.yellow.cgColor
        yellowLayer.opacity = 0.4
        containerLayer.addSublayer(yellowLayer)
        
    }
    
    func testRoundedRectFromImage() -> () {
        let cirCleImage = UIImage.createCircleImageWith(color: UIColor.red, radius: 25)
        
        let layer = CALayer.init()
        layer.frame = CGRect.init(x: 0, y: 0, width: 100, height: 100)
        layer.backgroundColor = UIColor.white.cgColor
        layer.contentsCenter = CGRect.init(x: 0.4, y: 0.4, width: 0.2, height: 0.2)
        layer.contents = cirCleImage.cgImage
        layer.contentsScale = UIScreen.main.scale
        
        containerLayer.addSublayer(layer)
    }
        
    @objc func buttonIsTapped(sender:UIButton) -> () {
        sender.isSelected = !sender.isSelected
        print("button is tapped, state is \(sender.state),")
        //测试隐式动画
//        CATransaction.begin()
//        CATransaction.setAnimationDuration(2)
//        containerLayer.transform = CATransform3DIdentity
//        CATransaction.commit()
        //测试显式动画
        testAnimation()
    }
    
    @objc func viewIsPanned(sender:UIPanGestureRecognizer) {
        
        var translation = sender.translation(in: sender.view).x
        translation = translation / 100
        var  timeOffset = viewContainer.layer.timeOffset
        timeOffset = min(0.999, max(0, timeOffset - Double(translation)))
        viewContainer.layer.timeOffset = timeOffset
//        sender.setTranslation(CGPoint.zero, in: sender.view)
    }
}












