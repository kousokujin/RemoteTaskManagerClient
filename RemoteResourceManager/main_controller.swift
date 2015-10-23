//
//  main_controller.swift
//  RemoteResourceManager
//
//  Created by kousokujin on 2015/10/08.
//  Copyright © 2015年 kousokujin. All rights reserved.
//

import Foundation
import UIKit

class main_controller: UIViewController{
    
    var net:Connection?
    //var performance:String?
    
    var core:Int = 0
    var mem:Int = 0
    
    @IBOutlet weak var core_lab: UILabel!
    @IBOutlet weak var mem_lab: UILabel!
    @IBOutlet var mem_label: UIView!
    @IBOutlet weak var allcpu_label: UILabel!
    @IBOutlet weak var allmemory_label: UILabel!
    //@IBOutlet var allcpu_progress: UIView!
    //@IBOutlet var allmemory_progress: UIView!
    //@IBOutlet weak var maintableview: UITableView!
    @IBOutlet weak var allcpu_progress: UIProgressView!
    @IBOutlet weak var allmem_progress: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //let performance_text:[String] = performance!.componentsSeparatedByString(",")
        //print(performance_text[1])
        core_lab.text = "CPU Thread:"+String(core)
        //mem_lab.text = "MaxMem:"+String(mem)+"MB"
        mem_lab.text = "maxMEM:"+mem_convertstr(String(mem))
        
        net?.sendCommand("OK\n")
        print(core)
       
        let timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "tick", userInfo: nil, repeats: true)

        //maintableview.delegate = self
        //maintableview.dataSource = self
        
    }
    
    func tick()
    {
        let res_str:String = net!.receive()
        if(res_str != "none")
        {
            let performance_text:[String] = res_str.componentsSeparatedByString(",")
            allcpu_label.text = performance_text[1] + "%"
            //allmemory_label.text = performance_text[0] + "MB"
            allmemory_label.text = mem_convertstr(performance_text[0])
            let cpuprogress:Float = (Float(performance_text[1])!)/100
            let memprogress:Float = (Float(performance_text[0])!)/Float(mem)
            
            allcpu_progress.progress = cpuprogress
            allmem_progress.progress = memprogress
            
        }
        
    }
    
    func mem_convertstr(inputstr:String) -> String
    {
        var outputint:Double
        var input:Int = Int(inputstr)!
        var inputdouble:Double = Double(input)
        
        print(inputstr)
        
        if(input >= 2000){
            outputint = Double(inputdouble/1000)
            return (NSString(format: "%.2f",outputint) as String)+"GB"
        }else
        {
            return String(input)+"MB"
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}