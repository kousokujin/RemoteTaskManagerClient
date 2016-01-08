//
//  cpu_graph.swift
//  RemoteResourceManager
//
//  Created by MaedaTomonori on 2015/12/11.
//  Copyright © 2015年 tomonori. All rights reserved.
//

//import Cocoa
import UIKit

class graph: UIView {
    
    var value:[Int] = []
    var graph_color:UIColor = UIColor.redColor()
    
    init(frame: CGRect,inputdate:[Int],color:UIColor) {
        super.init(frame: frame)
        graph_color = color
        rewritedate(inputdate)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //let inputdate:[Int] = [0,0,0]
        //writedate(inputdate)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawRect(rect: CGRect) {
        
        //グリッド
        var lowline:[UIBezierPath] = []
        for(var i=0;i<5;i++)
        {
            let addline = UIBezierPath()
            lowline.append(addline)
            let x = CGFloat(0)
            let y = CGFloat(i*10)
            lowline[i].moveToPoint(CGPointMake(x,y))
            lowline[i].addLineToPoint(CGPointMake(self.bounds.width,y))
            let dashPattern:[CGFloat] = [ 1 , 4 ]
            UIColor.blackColor().setStroke()
            lowline[i].setLineDash(dashPattern, count: 1, phase: 0)
            lowline[i].stroke()
        }
        
        var lineline:[UIBezierPath] = []
        for(var i=0;i<10;i++)
        {
            let addline = UIBezierPath()
            lineline.append(addline)
            let x = CGFloat(i*10)
            let y = CGFloat(0)
            lineline[i].moveToPoint(CGPointMake(x,y))
            lineline[i].addLineToPoint(CGPointMake(x,self.bounds.height))
            let dashPattern:[CGFloat] = [ 1 , 4 ]
            UIColor.blackColor().setStroke()
            lineline[i].setLineDash(dashPattern, count: 1, phase: 0)
            lineline[i].stroke()
        }
        
        // UIBezierPath のインスタンス生成
        let line = UIBezierPath();
        
        if(value.count != 0)
        {
            for(var i=0;i<value.count;i++)
            {
                let x:CGFloat = CGFloat(i*5)
                let y:CGFloat = CGFloat(50-value[i]/2)
                if(i==0)
                {
                    line.moveToPoint(CGPointMake(x,y))
                }else
                {
                    line.addLineToPoint(CGPointMake(x,y))
                }
            }
        }
        
        // 色の設定
        //UIColor.redColor().setStroke()
        graph_color.setStroke()
        
        // ライン幅
        line.lineWidth = 3
        
        // 描画
        line.stroke();
        
    }
    
    func adddate(input:Int)
    {
        if(value.count < 21)
        {
            value.append(input)
        }else
        {
            var newvalue:[Int] = []
            
            for(var i=0;i<20;i++)
            {
                newvalue.append(value[i+1])
            }
            
            newvalue.append(input)
            value = newvalue
        }
    }
    
    func rewritedate(input:[Int])
    {
        value = input
    }
    
    func redraw()
    {
        [self .setNeedsDisplay()]
        //print("redraw")

    }

}
