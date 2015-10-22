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
    //@IBOutlet weak var maintableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //let performance_text:[String] = performance!.componentsSeparatedByString(",")
        //print(performance_text[1])
        core_lab.text = "CPU Thread:"+String(core)
        mem_lab.text = "MaxMem"+String(mem)
        
        net?.sendCommand("OK\n")
        print(core)
       
        var timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "tick", userInfo: nil, repeats: true)

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
            allmemory_label.text = performance_text[0] + "MB"
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    func maintableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return core
    }
    
    func maintableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "Cell")
        
        //ell.textLabel?.text = texts[indexPath.row]
        return cell
    }

    */
    
}