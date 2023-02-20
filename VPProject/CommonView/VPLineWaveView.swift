//
//  VPLineWaveView.swift
//  VPProject
//
//  Created by 刘伟 on 2023/2/20.
//

import UIKit

class VPLineWaveView: UIView {

    private let firstLinePath:UIBezierPath = UIBezierPath.init()
    private let firstLineAnimatePath:UIBezierPath = UIBezierPath.init()
    private let firstShapeLayer:CAShapeLayer = {
        let shapeLayer = CAShapeLayer.init()
        shapeLayer.strokeColor = UIColor.white.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 2
        return shapeLayer
    }()
    
    private let secondLinePath:UIBezierPath = UIBezierPath.init()
    private let secondLineAnimatePath:UIBezierPath = UIBezierPath.init()
    private let secondShapeLayer:CAShapeLayer = {
        let shapeLayer = CAShapeLayer.init()
        shapeLayer.strokeColor = UIColor.white.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 2
        return shapeLayer
    }()
    
    private let thirdLinePath:UIBezierPath = UIBezierPath.init()
    private let thirdLineAnimatePath:UIBezierPath = UIBezierPath.init()
    private let thirdShapeLayer:CAShapeLayer = {
        let shapeLayer = CAShapeLayer.init()
        shapeLayer.strokeColor = UIColor.white.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 2
        return shapeLayer
    }()
    
    private var displayLink:CADisplayLink?
    private var index = 0
    //MARK: —— View life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        displayLink = CADisplayLink.init(target: self, selector: #selector(displayLinkAction))
        if #available(iOS 15.0, *) {
            displayLink?.preferredFrameRateRange = CAFrameRateRange(minimum: 60, maximum: 120, __preferred: 120)
        } else {
            displayLink?.preferredFramesPerSecond = 120
        }
        displayLink?.isPaused = true
        displayLink?.add(to: RunLoop.current, forMode: RunLoop.Mode.common)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("VPLineWaveView deinit")
    }
    
    //MARK: —— Public method
    func invalidateDisplayLink() {
        displayLink?.invalidate()
    }
    
    //MARK: —— Private method
    @objc private func displayLinkAction() {
        index += 1
        print("displayLinkAction index = ",index)
    }
}
