//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport
import Masonry

class CustomView:UIView {
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        return super.hitTest(point, with: event)
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
    
    lazy var multiplyLabel: UILabel = {
        let label = UILabel.init()
        label.backgroundColor = UIColor.red
        label.text = "123\nadjliwai\nwodijaoji\nwoqiwejqio\nznxmxm\n"
        label.numberOfLines = 2
        return label
    }()
    
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white

        let label = UILabel()
        label.frame = CGRect(x: 150, y: 200, width: 200, height: 20)
        label.text = "Hello World!"
        label.textColor = .black
        label.textAlignment = .center

        view.addSubview(label)
        self.view = view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(button)
        view.addSubview(multiplyLabel)
        button.frame = CGRect.init(x: 150, y: 230, width: 200, height: 200)
//
        multiplyLabel.sizeToFit()
        multiplyLabel.mas_makeConstraints { (make) in
            make?.top.equalTo()(self.button.mas_bottom)?.offset()(10)
            make?.right.left().equalTo()
        }
        
//        testZPositionLayers()
//        testZPositionViews()
//        testResizeFilterForImages()
    }
    
    //测试layer.zPosition修改了，视图层级是否修改，还有显示效果。
    func testZPositionLayers() -> () {
        let firstLayer = CALayer.init()
        firstLayer.backgroundColor = UIColor.red.cgColor
        firstLayer.frame = CGRect.init(x: 20, y: 100, width: 50, height: 50)

        let secondLayer = CALayer.init()
        secondLayer.backgroundColor = UIColor.green.cgColor
        secondLayer.frame = CGRect.init(x: 40, y: 130, width: 50, height: 50)

        print("first layer is \(firstLayer),sencond layer is \(secondLayer),view‘s layer is \(view.layer)")
        button.layer.addSublayer(firstLayer)
        button.layer.addSublayer(secondLayer)


        for sublayerInfo in button.layer.sublayers!.enumerated() {
            if sublayerInfo.element === firstLayer {
                print(" firstLayer in view's layer's sublayers index is \(sublayerInfo.offset) ")
            }else  if sublayerInfo.element === secondLayer {
                print(" secondLayer in view's layer's sublayers index is \(sublayerInfo.offset) ")
            }
        }

        firstLayer.zPosition = 1

        for sublayerInfo in button.layer.sublayers!.enumerated() {
            if sublayerInfo.element === firstLayer {
                print(" after reset first layer's zposition firstLayer in view's layer's sublayers index is \(sublayerInfo.offset) ")
            }else  if sublayerInfo.element === secondLayer {
                print(" after reset first layer's zposition  secondLayer in view's layer's sublayers index is \(sublayerInfo.offset) ")
            }
        }
        
    }
    
    
    let imageWidth:CGFloat = 50
    
//    func testResizeFilterForImages() -> () {
//        let customView = UIView.init(frame: CGRect.init(x: 0, y: 20, width: 375, height: 500))
//        customView.backgroundColor = UIColor.init(white: 0.9, alpha: 1)
//        view.addSubview(customView)
//
//        let numberImage = UIImage.init(named: "Numbers")
////        var timeLayers = [CALayer].init()
////        for i in 0..<6 {
////            let layer = CALayer.init()
////            layer.frame = CGRect.init(x: CGFloat(i) * imageWidth, y: 100, width: imageWidth, height: 40)
//////            layer.backgroundColor = UIColor.red.cgColor
////            layer.contents = numberImage?.cgImage
////            print("cg image is \(UIImage.init(named: "Numbers")?.cgImage)")
////            layer.contentsGravity = .resizeAspect
////            layer.contentsRect = CGRect.init(x: 0.1, y: 0, width: 0.1, height: 1)
////            layer.minificationFilter = .nearest
////            layer.magnificationFilter = .nearest
////            customView.layer.addSublayer(layer)
////            timeLayers.append(layer)
////        }
//
//        //下面的效果和上面是一样的，也就是设置UIimageView.layer.contentRect也是可以的哦。
//        var imageVs = [UIImageView]()
//
//        for i in 0..<6 {
//            let view = UIImageView.init(image: numberImage)
//            view.frame = CGRect.init(x: CGFloat(i) * imageWidth, y: 100, width: imageWidth, height: 40)
//            view.contentMode = .scaleAspectFit
//            view.layer.contentsRect = CGRect.init(x: 0.1, y: 0, width: 0.1, height: 1)
//            view.layer.minificationFilter = .nearest
//            view.layer.magnificationFilter = .nearest
//            customView.addSubview(view)
//            imageVs.append(view)
//        }
//    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    @objc func buttonIsTapped(sender:UIButton) -> () {
        sender.isSelected = !sender.isSelected
        print("button is tapped, state is \(sender.state),")
        multiplyLabel.numberOfLines = sender.isSelected ? 0 : 3
//        UIView.animate(withDuration: 0.25) {
//            self.multiplyLabel.layoutIfNeeded()
//        }
    }
    
}

// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()
