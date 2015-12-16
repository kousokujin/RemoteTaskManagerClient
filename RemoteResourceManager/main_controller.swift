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
    var value:[Int] = []
    var corenamelabel:[UILabel]?
    var corelabel:[UILabel]?
    
    var cpu_g = graph(frame: CGRectMake(47, 176, 100, 50))
    var mem_g = graph(frame: CGRectMake(47,176,100,50))
    
    @IBOutlet weak var core_lab: UILabel!
    @IBOutlet weak var mem_lab: UILabel!
    @IBOutlet var mem_label: UIView!
    @IBOutlet weak var allcpu_label: UILabel!
    @IBOutlet weak var allmemory_label: UILabel!
    @IBOutlet weak var allcpu_progress: UIProgressView!
    @IBOutlet weak var allmem_progress: UIProgressView!
    
    //CPUコア別ラベル(使用率)
    @IBOutlet weak var CPU0: UILabel!
    @IBOutlet weak var CPU1: UILabel!
    @IBOutlet weak var CPU2: UILabel!
    @IBOutlet weak var CPU3: UILabel!
    @IBOutlet weak var CPU4: UILabel!
    @IBOutlet weak var CPU5: UILabel!
    @IBOutlet weak var CPU6: UILabel!
    @IBOutlet weak var CPU7: UILabel!
    @IBOutlet weak var CPU8: UILabel!
    @IBOutlet weak var CPU9: UILabel!
    @IBOutlet weak var CPU10: UILabel!
    @IBOutlet weak var CPU11: UILabel!
    @IBOutlet weak var CPU12: UILabel!
    @IBOutlet weak var CPU13: UILabel!
    @IBOutlet weak var CPU14: UILabel!
    @IBOutlet weak var CPU15: UILabel!
    
    //CPUコア別ラベル(名前)
    @IBOutlet weak var CPUlabel0: UILabel!
    @IBOutlet weak var CPUlabel1: UILabel!
    @IBOutlet weak var CPUlabel2: UILabel!
    @IBOutlet weak var CPUlabel3: UILabel!
    @IBOutlet weak var CPUlabel4: UILabel!
    @IBOutlet weak var CPUlabel5: UILabel!
    @IBOutlet weak var CPUlabel6: UILabel!
    @IBOutlet weak var CPUlabel7: UILabel!
    @IBOutlet weak var CPUlabel8: UILabel!
    @IBOutlet weak var CPUlabel9: UILabel!
    @IBOutlet weak var CPUlabel10: UILabel!
    @IBOutlet weak var CPUlabel11: UILabel!
    @IBOutlet weak var CPUlabel12: UILabel!
    @IBOutlet weak var CPUlabel13: UILabel!
    @IBOutlet weak var CPUlabel14: UILabel!
    @IBOutlet weak var CPUlabel15: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        core_lab.text = "CPU Thread:"+String(core)
        mem_lab.text = "maxMEM:"+mem_convertstr(String(mem))
        
        net?.sendCommand("OK\n")
        print(core)
       
        //タイマー
        let timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "tick", userInfo: nil, repeats: true)
        
        settingcorelabel(core)
        
        
        //CPUグラフ作成
        var cpu_lab_x = CGRectGetMidX(allcpu_progress.frame)
        cpu_g = graph(frame: CGRectMake(CGFloat(cpu_lab_x-43), 176, 100, 50),inputdate:value)
        cpu_g.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(cpu_g)
        
        //メモリグラフ作成
        var mem_lab_x=CGRectGetMidX(allmem_progress.frame)
        mem_g = graph(frame: CGRectMake(CGFloat(mem_lab_x-50), 176, 100, 50),inputdate:value)
        mem_g.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(mem_g)
    }
    
    func tick()
    {
        let res_str:String = net!.receive()
        if(res_str != "none")
        {
            let performance_text:[String] = res_str.componentsSeparatedByString(",")
            allcpu_label.text = performance_text[1] + "%"
            allmemory_label.text = mem_convertstr(performance_text[0])
            let cpuprogress:Float = (Float(performance_text[1])!)/100
            let memprogress:Float = (Float(performance_text[0])!)/Float(mem)
            
            //CPUグラフ描画
            cpu_g.adddate(Int(performance_text[1])!)
            cpu_g.redraw()
            
            allcpu_progress.progress = cpuprogress
            allmem_progress.progress = memprogress
            
            //メモリグラフ描画
            mem_g.adddate(Int(memprogress*100))
            mem_g.redraw()
            
            //CPUコアごとのラベル更新
            tick_core(performance_text)
        }
        
    }
    
    
    func tick_core(coretext:[String])
    {
        if(CPU0.hidden == false)
        {
            CPU0.text = coretext[2]
        }
        if(CPU1.hidden == false)
        {
            CPU1.text = coretext[3]
        }
        if(CPU2.hidden == false)
        {
            CPU2.text = coretext[4]
        }
        if(CPU3.hidden == false)
        {
            CPU3.text = coretext[5]
        }
        
        if(CPU4.hidden == false)
        {
            CPU4.text = coretext[6]
        }
        if(CPU5.hidden == false)
        {
            CPU5.text = coretext[7]
        }
        if(CPU6.hidden == false)
        {
            CPU6.text = coretext[8]
        }
        if(CPU7.hidden == false)
        {
            CPU7.text = coretext[9]
        }
        
        if(CPU8.hidden == false)
        {
            CPU8.text = coretext[10]
        }
        if(CPU9.hidden == false)
        {
            CPU9.text = coretext[11]
        }
        if(CPU10.hidden == false)
        {
            CPU10.text = coretext[12]
        }
        if(CPU11.hidden == false)
        {
            CPU11.text = coretext[13]
        }
        
        if(CPU12.hidden == false)
        {
            CPU12.text = coretext[14]
        }
        if(CPU13.hidden == false)
        {
            CPU13.text = coretext[15]
        }
        if(CPU14.hidden == false)
        {
            CPU14.text = coretext[16]
        }
        if(CPU15.hidden == false)
        {
            CPU15.text = coretext[17]
        }
    }
    func settingcorelabel(corecount:Int)
    {
        allhidden(true)
        
        //ひどすぎる実装
        switch(corecount)
        {
        case 1:
            CPU0.hidden = false
            CPUlabel0.hidden = false
            break
        case 2:
            CPU0.hidden = false
            CPUlabel0.hidden = false
            CPU1.hidden = false
            CPUlabel1.hidden = false
            break
        case 3:
            CPU0.hidden = false
            CPUlabel0.hidden = false
            CPU1.hidden = false
            CPUlabel2.hidden = false
            CPU2.hidden = false
            CPUlabel2.hidden = false
            break
        case 4:
            CPU0.hidden = false
            CPUlabel0.hidden = false
            CPU1.hidden = false
            CPUlabel1.hidden = false
            CPU2.hidden = false
            CPUlabel2.hidden = false
            CPU3.hidden = false
            CPUlabel3.hidden = false
            break
        case 5:
            CPU0.hidden = false
            CPUlabel0.hidden = false
            CPU1.hidden = false
            CPUlabel1.hidden = false
            CPU2.hidden = false
            CPUlabel2.hidden = false
            CPU3.hidden = false
            CPUlabel3.hidden = false
            CPU4.hidden = false
            CPUlabel4.hidden = false
            break
        case 6:
            CPU0.hidden = false
            CPUlabel0.hidden = false
            CPU1.hidden = false
            CPUlabel1.hidden = false
            CPU2.hidden = false
            CPUlabel2.hidden = false
            CPU3.hidden = false
            CPUlabel3.hidden = false
            CPU4.hidden = false
            CPUlabel4.hidden = false
            CPU5.hidden = false
            CPUlabel5.hidden = false
            break
        case 7:
            CPU0.hidden = false
            CPUlabel0.hidden = false
            CPU1.hidden = false
            CPUlabel1.hidden = false
            CPU2.hidden = false
            CPUlabel2.hidden = false
            CPU3.hidden = false
            CPUlabel3.hidden = false
            CPU4.hidden = false
            CPUlabel4.hidden = false
            CPU5.hidden = false
            CPUlabel5.hidden = false
            CPU6.hidden = false
            CPUlabel6.hidden = false
            break
        case 8:
            CPU0.hidden = false
            CPUlabel0.hidden = false
            CPU1.hidden = false
            CPUlabel1.hidden = false
            CPU2.hidden = false
            CPUlabel2.hidden = false
            CPU3.hidden = false
            CPUlabel3.hidden = false
            CPU4.hidden = false
            CPUlabel4.hidden = false
            CPU5.hidden = false
            CPUlabel5.hidden = false
            CPU6.hidden = false
            CPUlabel6.hidden = false
            CPU7.hidden = false
            CPUlabel7.hidden = false
            break
        case 9:
            CPU0.hidden = false
            CPUlabel0.hidden = false
            CPU1.hidden = false
            CPUlabel1.hidden = false
            CPU2.hidden = false
            CPUlabel2.hidden = false
            CPU3.hidden = false
            CPUlabel3.hidden = false
            CPU4.hidden = false
            CPUlabel4.hidden = false
            CPU5.hidden = false
            CPUlabel5.hidden = false
            CPU6.hidden = false
            CPUlabel6.hidden = false
            CPU7.hidden = false
            CPUlabel7.hidden = false
            CPU8.hidden = false
            CPUlabel8.hidden = false
            break
        case 10:
            CPU0.hidden = false
            CPUlabel0.hidden = false
            CPU1.hidden = false
            CPUlabel1.hidden = false
            CPU2.hidden = false
            CPUlabel2.hidden = false
            CPU3.hidden = false
            CPUlabel3.hidden = false
            CPU4.hidden = false
            CPUlabel4.hidden = false
            CPU5.hidden = false
            CPUlabel5.hidden = false
            CPU6.hidden = false
            CPUlabel6.hidden = false
            CPU7.hidden = false
            CPUlabel7.hidden = false
            CPU8.hidden = false
            CPUlabel8.hidden = false
            CPU9.hidden = false
            CPUlabel9.hidden = false
            break
        case 11:
            CPU0.hidden = false
            CPUlabel0.hidden = false
            CPU1.hidden = false
            CPUlabel1.hidden = false
            CPU2.hidden = false
            CPUlabel2.hidden = false
            CPU3.hidden = false
            CPUlabel3.hidden = false
            CPU4.hidden = false
            CPUlabel4.hidden = false
            CPU5.hidden = false
            CPUlabel5.hidden = false
            CPU6.hidden = false
            CPUlabel6.hidden = false
            CPU7.hidden = false
            CPUlabel7.hidden = false
            CPU8.hidden = false
            CPUlabel8.hidden = false
            CPU9.hidden = false
            CPUlabel9.hidden = false
            CPU10.hidden = false
            CPUlabel10.hidden = false
            break
        case 12:
            CPU0.hidden = false
            CPUlabel0.hidden = false
            CPU1.hidden = false
            CPUlabel1.hidden = false
            CPU2.hidden = false
            CPUlabel2.hidden = false
            CPU3.hidden = false
            CPUlabel3.hidden = false
            CPU4.hidden = false
            CPUlabel4.hidden = false
            CPU5.hidden = false
            CPUlabel5.hidden = false
            CPU6.hidden = false
            CPUlabel6.hidden = false
            CPU7.hidden = false
            CPUlabel7.hidden = false
            CPU8.hidden = false
            CPUlabel8.hidden = false
            CPU9.hidden = false
            CPUlabel9.hidden = false
            CPU10.hidden = false
            CPUlabel10.hidden = false
            CPU11.hidden = false
            CPUlabel10.hidden = false
            break
        case 13:
            CPU0.hidden = false
            CPUlabel0.hidden = false
            CPU1.hidden = false
            CPUlabel1.hidden = false
            CPU2.hidden = false
            CPUlabel2.hidden = false
            CPU3.hidden = false
            CPUlabel3.hidden = false
            CPU4.hidden = false
            CPUlabel4.hidden = false
            CPU5.hidden = false
            CPUlabel5.hidden = false
            CPU6.hidden = false
            CPUlabel6.hidden = false
            CPU7.hidden = false
            CPUlabel7.hidden = false
            CPU8.hidden = false
            CPUlabel8.hidden = false
            CPU9.hidden = false
            CPUlabel9.hidden = false
            CPU10.hidden = false
            CPUlabel10.hidden = false
            CPU11.hidden = false
            CPUlabel11.hidden = false
            CPU12.hidden = false
            CPUlabel12.hidden = false
            break
        case 14:
            CPU0.hidden = false
            CPUlabel0.hidden = false
            CPU1.hidden = false
            CPUlabel1.hidden = false
            CPU2.hidden = false
            CPUlabel2.hidden = false
            CPU3.hidden = false
            CPUlabel3.hidden = false
            CPU4.hidden = false
            CPUlabel4.hidden = false
            CPU5.hidden = false
            CPUlabel5.hidden = false
            CPU6.hidden = false
            CPUlabel6.hidden = false
            CPU7.hidden = false
            CPUlabel7.hidden = false
            CPU8.hidden = false
            CPUlabel8.hidden = false
            CPU9.hidden = false
            CPUlabel9.hidden = false
            CPU10.hidden = false
            CPUlabel10.hidden = false
            CPU11.hidden = false
            CPUlabel11.hidden = false
            CPU12.hidden = false
            CPUlabel12.hidden = false
            CPU13.hidden = false
            CPUlabel13.hidden = false
            break
        case 15:
            CPU0.hidden = false
            CPUlabel0.hidden = false
            CPU1.hidden = false
            CPUlabel1.hidden = false
            CPU2.hidden = false
            CPUlabel2.hidden = false
            CPU3.hidden = false
            CPUlabel3.hidden = false
            CPU4.hidden = false
            CPUlabel4.hidden = false
            CPU5.hidden = false
            CPUlabel5.hidden = false
            CPU6.hidden = false
            CPUlabel6.hidden = false
            CPU7.hidden = false
            CPUlabel7.hidden = false
            CPU8.hidden = false
            CPUlabel8.hidden = false
            CPU9.hidden = false
            CPUlabel9.hidden = false
            CPU10.hidden = false
            CPUlabel10.hidden = false
            CPU11.hidden = false
            CPUlabel11.hidden = false
            CPU12.hidden = false
            CPUlabel12.hidden = false
            CPU13.hidden = false
            CPUlabel13.hidden = false
            CPU14.hidden = false
            CPUlabel14.hidden = false
            break
        case 16:
            allhidden(false)
            break

        default:
            allhidden(true)

        }
    }
    
    func allhidden(hid:Bool)
    {
        CPU0.hidden = hid
        CPU1.hidden = hid
        CPU2.hidden = hid
        CPU3.hidden = hid
        CPU4.hidden = hid
        CPU5.hidden = hid
        CPU6.hidden = hid
        CPU7.hidden = hid
        CPU8.hidden = hid
        CPU9.hidden = hid
        CPU10.hidden = hid
        CPU11.hidden = hid
        CPU12.hidden = hid
        CPU13.hidden = hid
        CPU14.hidden = hid
        CPU15.hidden = hid
        
        CPUlabel0.hidden = hid
        CPUlabel1.hidden = hid
        CPUlabel2.hidden = hid
        CPUlabel3.hidden = hid
        CPUlabel4.hidden = hid
        CPUlabel5.hidden = hid
        CPUlabel6.hidden = hid
        CPUlabel7.hidden = hid
        CPUlabel8.hidden = hid
        CPUlabel9.hidden = hid
        CPUlabel10.hidden = hid
        CPUlabel11.hidden = hid
        CPUlabel12.hidden = hid
        CPUlabel13.hidden = hid
        CPUlabel14.hidden = hid
        CPUlabel15.hidden = hid
        
    }
    
    //メモリ単位換算
    func mem_convertstr(inputstr:String) -> String
    {
        var outputint:Double
        var input:Int = Int(inputstr)!
        var inputdouble:Double = Double(input)
        
        //print(inputstr)
        
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