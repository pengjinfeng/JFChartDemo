//
//  ViewController.swift
//  JFChartDemo
//
//  Created by apple on 16/8/26.
//  Copyright © 2016年 pengjf. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let chart = JFChart.init(frame: CGRectMake(0, 10, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height/2))
        chart.xValues = [10,20,30,40,50]
        chart.yValues = [20,40,60,80,100,120,140]
        chart.dataValues = [30,20,80,65,120]
        chart.pointType = PointType.Rect
        chart.backgroundColor = UIColor.whiteColor()
        view.addSubview(chart)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

