//
//  ViewController.swift
//  RemoteResourceManager
//
//  Created by kousokujin on 2015/10/08.
//  Copyright © 2015 kousokujin. All rights reserved.
//  aaaaaaa

import UIKit

class ViewController: UIViewController {
    
    var net:Connection = Connection()
    var core:Int = 0
    var mem:Int = 0
    
    @IBOutlet weak var ip_add_box: UITextField!
    @IBOutlet weak var port_box: UITextField!
    @IBOutlet weak var now_connecting: UILabel!
    @IBOutlet weak var now_activity: UIActivityIndicatorView!
    @IBOutlet weak var password_textbox: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        ip_add_box.text = "192.168.173.1"
        port_box.text = "1000"
        
        now_connecting.hidden = true
        now_activity.hidden = true
        
        // ユーザーに対して通知の許可確認
        UIApplication.sharedApplication().registerUserNotificationSettings(UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        if(segue.identifier == "next_segue")
        {
            let main : main_controller = segue.destinationViewController as! main_controller
            main.net = self.net
            //main.performance = self.performance
            
            main.core = self.core
            main.mem = self.mem
        }
    }
    
    func rec()
    {
        
        net.sendCommand((password_textbox.text!)+"\n")
        
        var res_str:String = "none"
        while(res_str == "none")
        {
            res_str = net.receive()
        }
        
        if(res_str == "password_error\n")
        {
            let alertController = UIAlertController(title: "接続失敗", message: "パスワードが違います", preferredStyle: .Alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(defaultAction)
            
            presentViewController(alertController, animated: true, completion: nil)
            
        }
        else{
            print(res_str)
            let performance_text:[String] = res_str.componentsSeparatedByString(",")
            print(performance_text[1])
        
            core = Int(performance_text[0])!
            mem = Int(performance_text[1])!
        }
        
        
    }
    
    @IBAction func connect_button(sender: AnyObject) {
        
        //now_connecting.hidden = false
        //now_activity.hidden = false
        
        if((ip_add_box.text! == "") && (port_box.text! != ""))
        {
            let alertController = UIAlertController(title: "", message: "アドレスを入力してください", preferredStyle: .Alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(defaultAction)
            
            presentViewController(alertController, animated: true, completion: nil)
            
            return
        }
        
        if((ip_add_box.text! != "") && (port_box.text! == ""))
        {
            let alertController = UIAlertController(title: "", message: "ポート番号を入力してください", preferredStyle: .Alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(defaultAction)
            
            presentViewController(alertController, animated: true, completion: nil)
            
            return
        }
        
        if((ip_add_box.text! == "") && (port_box.text! == ""))
        {
            let alertController = UIAlertController(title: "", message: "アドレスとポート番号を入力してください", preferredStyle: .Alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(defaultAction)
            
            presentViewController(alertController, animated: true, completion: nil)
            
            return
        }
        
        self.view.endEditing(true)
        
        let p_int:Int?=(Int(port_box.text!))
        let p:UInt32=UInt32(p_int!)
        
        net.setup(p, a: ip_add_box.text!)
        net.conect()
        
        rec()
        performSegueWithIdentifier("next_segue",sender: nil)
        
        //NSThread.detachNewThreadSelector("threadFunc", toTarget: self, withObject: nil)
        //非同期処理でサーバに接続して画面遷移したいが、画面遷移後の画面で画面が更新しない
    }
    
    @IBAction func tapScreen(sender: AnyObject) {
        self.view.endEditing(true)
    }
    
    func threadFunc()   //非同期処理メソッド
    {
        self.view.endEditing(true)
        
        let p_int:Int?=(Int(port_box.text!))
        let p:UInt32=UInt32(p_int!)
        
        net.setup(p, a: ip_add_box.text!)
        net.conect()
        
        rec()
        
        performSegueWithIdentifier("next_segue",sender: nil)
    }
}

class Connection : NSObject,NSStreamDelegate{
    var add:CFString = "none";
    var port:UInt32 = 1000;
    
    private var inputStream:NSInputStream!
    private var outputStream:NSOutputStream!
    
    func setup(p:UInt32,a:CFString){
        add=a
        port=p
    }
    
    func conect()
    {
        
        var readStream: Unmanaged<CFReadStream>?
        var writeStream: Unmanaged<CFWriteStream>?
        //println(add)
        //println(port)
        
        CFStreamCreatePairWithSocketToHost(nil, self.add,self.port, &readStream, &writeStream)
        
        self.inputStream=readStream!.takeRetainedValue()
        self.outputStream=writeStream!.takeRetainedValue()
        
        self.inputStream.delegate = self
        self.outputStream.delegate = self
        
        self.inputStream.scheduleInRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)
        self.outputStream.scheduleInRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)
        
        self.inputStream.open()
        self.outputStream.open()
        
        //println("conect")
        
    }
    
    func stream(aStream: NSStream, handleEvent eventCode: NSStreamEvent) {
        
    }
    
    func sendCommand(command:String)
    {
        var ccommand=command.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion:false)!
        self.outputStream.write(UnsafePointer(ccommand.bytes), maxLength: ccommand.length)
    }
    
    func receive() -> String
    {
        while(inputStream.hasBytesAvailable)
        {
            let bufferSize = 1024
            var buffer = Array<UInt8>(count:bufferSize,repeatedValue:0)
            let bytesRead = inputStream.read(&buffer,maxLength:bufferSize)
            if(bytesRead>=0)
            {
                buffer.removeRange(Range(start:bytesRead,end:bufferSize))
                var read = String(bytes:buffer,encoding:NSUTF8StringEncoding)!
                return read
            }
            
        }
        
        return "none"
    }
}


