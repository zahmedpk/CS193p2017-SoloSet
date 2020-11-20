//
//  GraphicalSoloSetViewController.swift
//  SoloSet
//
//  Created by Zubair Ahmed on 19/11/2020.
//  Copyright © 2020 Zubair Ahmed. All rights reserved.
//

import UIKit

class GraphicalSoloSetViewController: UIViewController {
    @IBOutlet var gridView: UIView! {
        didSet {
            gridView.backgroundColor = .red
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        print(#function, "grid view frame is \(gridView.frame) and bounds is \(gridView.bounds)")
    }
    
    func updateGameUI(){
        gridView.subviews.forEach { $0.removeFromSuperview() }
        var cellFrameCalculator = Grid(layout: .aspectRatio(5.0/8.0), frame: self.gridView.bounds)
        cellFrameCalculator.cellCount = 81
        for i in 0..<cellFrameCalculator.cellCount {
            let blueBox = UIView(frame: cellFrameCalculator[i]!.insetBy(dx: 10, dy: 10))
            blueBox.backgroundColor = .blue
            gridView.addSubview(blueBox)
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        updateGameUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateGameUI()
    }
}
