//
//  JFChart.swift
//  JFkLine
//
//  Created by apple on 16/8/25.
//  Copyright © 2016年 pengjf. All rights reserved.
//

import UIKit

//间距
let kMargin:CGFloat = 30.0
//上间距
let kTopsMargin:CGFloat = 10.0

let kScreen = UIScreen.mainScreen().bounds.size
//划线距离箭头顶端的距离
let kEndMargin:CGFloat = 30.0


enum PointType:Int{
    case Rect = 0
    case Circle
}

class JFChart: UIView {

    //X轴的数值
    var xValues:NSArray?
    //y轴的数值
    var yValues:NSArray?
    //点的风格
    var pointType:PointType?{
        didSet{
            self.setNeedsDisplay()
        }
    }
    //数值数组
    var dataValues:NSArray?
    
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawRect(rect: CGRect) {
    
        let con = UIGraphicsGetCurrentContext()
        drawXYLine(rect, con: con!)
        drawLines(rect, con: con!)
        drawNumbers(rect, con: con!)
        drawDot(rect,con: con!)
        drawLineWithStyle(rect, con: con!, style: 1)
    }
 //绘制xy轴
    func drawXYLine(rect:CGRect,con:CGContextRef) {
        
        let path = UIBezierPath.init()
        //坐标的原点
        path.moveToPoint(CGPointMake(kMargin, rect.size.height - kMargin))
        path.addLineToPoint(CGPointMake(kMargin, kTopsMargin))
        
        path.moveToPoint(CGPointMake(kMargin, rect.size.height - kMargin))
        path.addLineToPoint(CGPointMake(rect.size.width  - kTopsMargin, rect.size.height - kMargin))
        
        //绘制X箭头
        path.moveToPoint(CGPointMake(kMargin - 5, kTopsMargin + 10))
        path.addLineToPoint(CGPointMake(kMargin, kTopsMargin))
        path.addLineToPoint(CGPointMake(kMargin + 5, kTopsMargin + 10))
        
        //绘制Y箭头
        path.moveToPoint(CGPointMake(rect.size.width  - kTopsMargin - 10, rect.size.height - kMargin - 5))
        path.addLineToPoint(CGPointMake(rect.size.width  - kTopsMargin, rect.size.height - kMargin))
        path.addLineToPoint(CGPointMake(rect.size.width  - kTopsMargin - 10, rect.size.height - kMargin + 5))
        
        //将路径关联到上下文中
        CGContextAddPath(con, path.CGPath)
        UIColor.brownColor().set()
        CGContextSetLineWidth(con, 2.0)
        CGContextStrokePath(con)
        
    }
  //绘制网格
    func drawLines(rect:CGRect,con:CGContextRef) {
        
        if xValues == nil || yValues == nil{
            assert(false, "X,Y轴数据数组不可以为空")
        }
        //每个格子的宽度
        let linesWidth = (rect.width - kMargin - kTopsMargin - kEndMargin)/CGFloat((xValues?.count)!)
        //每个格子的高度
         let linesHeight = (rect.height - kTopsMargin - kMargin - kEndMargin)/CGFloat((yValues?.count)!)
        
        let path = UIBezierPath.init()
        //画竖线
        
       for i in 0 ... (xValues?.count)!{
            path.moveToPoint(CGPointMake(kMargin + linesWidth * CGFloat(i),  rect.size.height - kMargin))
            path.addLineToPoint(CGPointMake(kMargin + linesWidth * CGFloat(i), kTopsMargin + kEndMargin))
      
        }
        //划横线
       for i in 0 ... (yValues?.count)!{
           path.moveToPoint(CGPointMake(kMargin, rect.size.height - kMargin - linesHeight * CGFloat(i)))
            path.addLineToPoint(CGPointMake(rect.width - kTopsMargin - kEndMargin, rect.size.height - kMargin - linesHeight * CGFloat(i)))
        }
        
        CGContextAddPath(con, path.CGPath)
        CGContextSetLineWidth(con, 0.5)
        UIColor.grayColor().set()
        CGContextStrokePath(con)
    }
    
    //画数字
    func drawNumbers(rect:CGRect,con:CGContextRef) {
        //每个格子的宽度
        let linesWidth = (rect.width - kMargin - kTopsMargin - kEndMargin)/CGFloat((xValues?.count)!)
        //每个格子的高度
        let linesHeight = (rect.height - kTopsMargin - kMargin - kEndMargin)/CGFloat((yValues?.count)!)
        var string:NSString?
        
       for i in 0 ..< (xValues?.count)!{
            string = "\(xValues![i])"
            let size = getStringSize(string!)
            CGContextSetTextDrawingMode(con, .Fill)
            string!.drawAtPoint(CGPointMake(kMargin + linesWidth * CGFloat(i+1) - size.width/2,  rect.size.height - kMargin), withAttributes: [NSFontAttributeName:UIFont.systemFontOfSize(12.0)])
        }
        
        for i in 0 ..< (yValues?.count)! {
            string = "\(yValues![i])"
            let size = getStringSize(string!)
            CGContextSetTextDrawingMode(con, .Fill)
            string!.drawAtPoint(CGPointMake(kMargin - size.width, rect.size.height - kMargin - linesHeight * CGFloat(i+1)), withAttributes: [NSFontAttributeName:UIFont.systemFontOfSize(12.0)])
        }

    }
    //计算string的size
    func getStringSize(cuart:NSString) -> CGRect {
        let size = cuart.boundingRectWithSize(CGSizeMake(CGFloat(MAXFLOAT), CGFloat(MAXFLOAT)), options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.systemFontOfSize(12.0)], context: nil)
        return size
    }
    
    //画点
    func drawDot(rect:CGRect,con:CGContextRef) {
        
       
        //每个格子的宽度
        let linesWidth = (rect.width - kMargin - kTopsMargin - kEndMargin)/CGFloat((xValues?.count)!)
        //每个格子的高度
//        let linesHeight = (rect.height - kTopsMargin - kMargin - kEndMargin)/CGFloat((yValues?.count)!)
//        
        for i in 0 ..< (dataValues?.count)! {
            
            if pointType == PointType.Rect {
                //方形
                CGContextAddRect(con, CGRectMake(kMargin + linesWidth * CGFloat(i+1) - 4,rect.height - kMargin - 4 - getHeightFromValue(Float(dataValues![i] as! NSNumber), rect: rect), 8, 8))
            }else{
                //圆形
                CGContextAddEllipseInRect(con, CGRectMake(kMargin + linesWidth * CGFloat(i+1) - 4,rect.height - kMargin - 4 - getHeightFromValue(Float(dataValues![i] as! NSNumber), rect: rect), 8, 8))
            }
            
        }
        
        UIColor.redColor().set()
        CGContextDrawPath(con, .FillStroke)
        
    }
    
    //计算高度
    func getHeightFromValue(num:Float,rect:CGRect) -> CGFloat {
        
        let H = rect.height - kTopsMargin - kMargin - kEndMargin
        let value:CGFloat = CGFloat((yValues?.lastObject)! as! NSNumber)
        return CGFloat(num)/CGFloat(value) * CGFloat(H)
    }
    //划线
    func drawLineWithStyle(rect:CGRect,con:CGContextRef,style:Int) {
         let linesWidth = (rect.width - kMargin - kTopsMargin - kEndMargin)/CGFloat((xValues?.count)!)
         for i in 0  ..< (dataValues?.count)! - 1{
        CGContextMoveToPoint(con, kMargin + linesWidth * CGFloat(i+1),rect.height - kMargin - getHeightFromValue(Float(dataValues![i] as! NSNumber), rect: rect))
        CGContextAddLineToPoint(con, kMargin + linesWidth * CGFloat(i+2),rect.height - kMargin - getHeightFromValue(Float(dataValues![i+1] as! NSNumber), rect: rect))
        
       
        }
        CGContextSetLineWidth(con, 2)
        CGContextStrokePath(con)
    }
    
//    //画柱状图
//    func drawPillar(rect:CGRect,con:CGContextRef) {
//        
//    }

}
