//
//  ShapeView.swift
//  SoloSet
//
//  Created by Zubair Ahmed on 22/11/2020.
//  Copyright © 2020 Zubair Ahmed. All rights reserved.
//

import UIKit

@IBDesignable
class ShapeView: UIView {
    @IBInspectable var isFilled: Bool = false
    @IBInspectable var isStriped: Bool = true
    @IBInspectable var color: UIColor = .red
    @IBInspectable var showBlackBorder = false //for debugging only
    var shape: Kind = .Diamond
    @IBInspectable var kind: Int {
        get {
            return shape.rawValue
        }
        set {
            shape = Kind(rawValue: newValue)!
        }
    }
    override func draw(_ rect: CGRect) {
        var rect = rect
        let context = UIGraphicsGetCurrentContext()
        context?.saveGState()
        if showBlackBorder {
            self.layer.borderWidth = 3.0
            self.layer.borderColor = UIColor.black.cgColor
        }
        //give a 10 points padding
        if self.bounds.width > 100 {
            rect = rect.insetBy(dx: 10, dy: 10)
        } else {
            rect = rect.insetBy(dx: 1, dy: 1)
        }
        let path = makePath(for: shape, in: rect)
        color.setStroke()
        path.lineWidth = 0.02 * rect.width
        path.stroke()
        if isFilled {
            color.setFill()
            path.fill()
        }
        if isStriped {
            path.addClip()
            let xStart = rect.origin.x
            let xStop = rect.origin.x+rect.width
            for x in stride(from: xStart, to: xStop, by: 5) {
                path.move(to: CGPoint(x: x, y: rect.origin.y))
                path.addLine(to: CGPoint(x: x, y: rect.origin.y + rect.height))
                path.lineWidth = 1
                path.close()
                path.stroke()
            }
        }
        
        
        context?.restoreGState()
    }
    func pathForDiamond(in rect: CGRect) -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: rect.origin.x, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.midY - rect.height/2.0))
        path.addLine(to: CGPoint(x: rect.origin.x + rect.width, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.midY + rect.height/2.0))
        path.close()
        return path
    }
    func pathForStadium(in rect: CGRect) -> UIBezierPath {
        let path = UIBezierPath()
        let radius = rect.height/2.0
        path.move(to: CGPoint(rect.origin.x + radius, rect.origin.y + 2 * radius))
        path.addArc(withCenter: CGPoint(rect.origin.x + radius, rect.origin.y + radius), radius: radius, startAngle: CGFloat.pi/2.0, endAngle: 3 * CGFloat.pi/2.0, clockwise: true)
        path.addLine(to: CGPoint(rect.origin.x+rect.width-radius, rect.origin.y))
        path.addArc(withCenter: CGPoint(rect.origin.x+rect.width-radius, rect.origin.y+radius), radius: radius, startAngle: 3*CGFloat.pi/2.0, endAngle: CGFloat.pi/2.0, clockwise: true)
        path.close()
        return path
    }
    func pathForSquiggle(in rect: CGRect) -> UIBezierPath {
        let path = UIBezierPath()
        //made a squiggle in Inkscape and copied path data from SVG file
        path.move(to: CGPoint(13.576773,332.33159))
        path.addCurve(to: CGPoint(41.789788,291.62822), controlPoint1: CGPoint(13.799817,314.9104), controlPoint2: CGPoint(24.557266,296.8166))
        path.addCurve(to: CGPoint(67.870642,298.97905), controlPoint1: CGPoint(51.161354,289.67693), controlPoint2: CGPoint(59.630292,295.48662))
        path.addCurve(to: CGPoint(106.75827,303.04025), controlPoint1: CGPoint(79.852224,304.69547), controlPoint2: CGPoint(93.894192,307.34312))
        path.addCurve(to: CGPoint(133.38477,289.19251), controlPoint1: CGPoint(116.49158,300.25169), controlPoint2: CGPoint(124.80767,294.30383))
        path.addCurve(to: CGPoint(148.83809,291.54896), controlPoint1: CGPoint(138.11862,286.28233), controlPoint2: CGPoint(146.59563,284.94771))
        path.addCurve(to: CGPoint(147.00457,314.88122), controlPoint1: CGPoint(151.64063,299.1468), controlPoint2: CGPoint(149.0276,307.42691))
        path.addCurve(to: CGPoint(131.08741,341.89433), controlPoint1: CGPoint(143.74989,324.80075), controlPoint2: CGPoint(139.34089,335.12316))
        path.addCurve(to: CGPoint(89.675952,347.23901), controlPoint1: CGPoint(119.43864,350.73937), controlPoint2: CGPoint(103.21418,352.49159))
        path.addCurve(to: CGPoint(52.652095,344.11965), controlPoint1: CGPoint(77.763862,343.84611), controlPoint2: CGPoint(64.926547,340.79361))
        path.addCurve(to: CGPoint(24.476288,352.55436), controlPoint1: CGPoint(43.967695,348.5213), controlPoint2: CGPoint(34.564821,353.86756))
        path.addCurve(to: CGPoint(13.576773,332.33159), controlPoint1: CGPoint(15.179411,350.96073), controlPoint2: CGPoint(13.440216,340.1175))
        path.close()
        let scaleFactor = rect.width/path.bounds.width
        path.apply(CGAffineTransform(scaleX: scaleFactor, y: scaleFactor))
        let dx = rect.midX - path.bounds.midX
        let dy = rect.midY - path.bounds.midY
        path.apply(CGAffineTransform(translationX: dx, y: dy))
        return path
    }
    func makePath(for kind: Kind, in rect: CGRect) -> UIBezierPath {
        switch shape {
        case .Diamond:
            return pathForDiamond(in: rect)
        case .Stadium:
            return pathForStadium(in: rect)
        case .Squiggle:
            return pathForSquiggle(in: rect)
        }
    }
    enum Kind: Int {
        case Diamond = 0
        case Stadium = 1
        case Squiggle = 2
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
