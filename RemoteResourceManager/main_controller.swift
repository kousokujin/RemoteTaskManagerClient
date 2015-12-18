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
    
    //CPUコア別ラベル(使用率)　そろそろいらなくなりそう(2015.12.17)
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
    
    //CPUコア別ラベル(名前) そろそろいらなくなりそう(2015.12.17)
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
    
    //CPUコア
    var CPUlabel:[UILabel] = []
    var CPUlabelname:[UILabel] = []
    var CPUcoreEnable:[Bool] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        core_lab.text = "CPU Thread:"+String(core)
        mem_lab.text = "maxMEM:"+mem_convertstr(String(mem))
        
        net?.sendCommand("OK\n")
       
        //CPUcoreEnable配列設定
        for(var i=0;i<core;i++)
        {
            CPUcoreEnable.append(true)
        }
        for(var i=core;i<16;i++)
        {
            CPUcoreEnable.append(false)
        }
        
        //タイマー
        let timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "tick", userInfo: nil, repeats: true)
        
        //CPUlabel,CPUlabelname配列に追加
        for(var i=100;i<116;i++){
            let newcpulabel = self.view.viewWithTag(i) as! UILabel
            CPUlabel.append(newcpulabel)
        }
        for(var i=200;i<216;i++)
        {
            let newcpunamelabel = self.view.viewWithTag(i) as! UILabel
            CPUlabelname.append(newcpunamelabel)
        }
        
        //コアごとの表示設定
        settingcorelabel_2(core)
        
        
        //CPUグラフ作成
        var cpu_lab_x = CGRectGetMidX(allcpu_progress.frame)
        cpu_g = graph(frame: CGRectMake(CGFloat(self.view.center.x-120), 176, 100, 50),inputdate:value)
        cpu_g.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(cpu_g)
        
        //メモリグラフ作成
        var mem_lab_x=CGRectGetMidX(allmem_progress.frame)
        mem_g = graph(frame: CGRectMake(CGFloat(self.view.center.x+20), 176, 100, 50),inputdate:value)
        mem_g.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(mem_g)
    }
    
    func tick()
    {
        let res_str:String = net!.receive()
        if(res_str != "none")
        {
            //受信
            let performance_text:[String] = res_str.componentsSeparatedByString(",")
            
            //いろいろ更新
            allcpu_label.text = performance_text[1] + "%"
            allmemory_label.text = mem_convertstr(performance_text[0])
            
            //割合に変換
            let cpuprogress:Float = (Float(performance_text[1])!)/100
            let memprogress:Float = (Float(performance_text[0])!)/Float(mem)
            
            //CPUグラフ描画
            cpu_g.adddate(Int(performance_text[1])!)
            cpu_g.redraw()
            
            //割合をプログレスバーに適応
            allcpu_progress.progress = cpuprogress
            allmem_progress.progress = memprogress
            progress_changeColor(allcpu_progress)
            progress_changeColor(allmem_progress)
            
            //割合に応じてラベルの色を変える
            allcpu_label.textColor = parcent_to_UIColor(cpuprogress)
            allmemory_label.textColor = parcent_to_UIColor(memprogress)
            
            //メモリグラフ描画
            mem_g.adddate(Int(memprogress*100))
            mem_g.redraw()
            
            //CPUコアごとのラベル更新
            //tick_core(performance_text)
            tickcore_2(performance_text)
        }
        
    }
    
    func tickcore_2(coretext:[String])
    {
        for(var i=0;i<CPUlabel.count;i++)
        {
            if(CPUcoreEnable[i] == true)
            {
                let per:Float = (Float(coretext[i+1])!)/100 //i+2だとなぜかうまくいかない
                CPUlabel[i].text = coretext[i+2]
                CPUlabel[i].textColor = parcent_to_UIColor(per)
            }
        }
    }
    

    
    func settingcorelabel_2(corecount:Int)
    {
        allhidden_2(true)
        for(var i=0;i<corecount;i++)
        {
            print(i)
            //CPUlabel[i].hidden = false
            //CPUlabelname[i].hidden = false
            CPUlabel[i].textColor = UIColor(red:1.0,green:1.0,blue:1.0,alpha:1.0)
            CPUlabelname[i].textColor = UIColor(red:1.0,green:1.0,blue:1.0,alpha:1.0)
        }
    }
    
    
    func allhidden_2(hid:Bool)  //全てのコアを隠す->全てのコアをのラベルをグレーに変更
    {
        for(var i=0;i<CPUlabel.count;i++)
        {
            //CPUlabel[i].hidden = true
            //CPUlabelname[i].hidden = true
            CPUlabel[i].textColor = UIColor(red:1.0,green:1.0,blue:1.0,alpha:0.4)
            CPUlabelname[i].textColor = UIColor(red:1.0,green:1.0,blue:1.0,alpha:0.4)
        }
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
    
    func parcent_to_UIColor(per:Float) -> UIColor
    {
        if(per < 0.5)
        {
            let red_float:CGFloat = CGFloat(0.5+per)
            let green_float:CGFloat = CGFloat(0.5+per)
            
            let outputcolor:UIColor = UIColor(red:red_float,green:green_float,blue:1.0,alpha:1.0)
            return outputcolor
        }
        if(per > 0.5){
            
            let green_float:CGFloat = CGFloat(1.5-per)
            let blue_float:CGFloat = CGFloat(1.5-per)
            
            let outputcolor:UIColor = UIColor(red:1.0,green:green_float,blue:blue_float,alpha:1.0)
            return outputcolor
        }
        
        let outputcolor:UIColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        return outputcolor
    }
    
    func progress_changeColor(progresber:UIProgressView)
    {
        if(progresber.progress > 0.8)
        {
            let color:UIColor = UIColor(red:1.0,green:0.5,blue:0,alpha:1.0)
            progresber.tintColor = color
            
        }else
        {
            let color:UIColor = UIColor(red:0,green:0.48,blue:1.0,alpha:1.0)
            progresber.tintColor = color
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

}