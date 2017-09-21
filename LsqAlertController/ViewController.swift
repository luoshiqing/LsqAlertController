//
//  ViewController.swift
//  LsqAlertController
//
//  Created by lsq on 2017/9/21.
//  Copyright © 2017年 罗石清. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    deinit {
        print("ViewController->释放")
    }

    @IBOutlet weak var titleLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.navigationItem.title = "弹框玩耍"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //TODO:富文本弹框
    @IBAction func btnAction(_ sender: UIButton) {
        
        let t: String? = "提示你一下咯"
        let m: String? = "您有32个梨子，已经吃了6个了"
        
        let tR = [NSMakeRange(0, t!.characters.count)]
        let tC = [UIColor.blue]//00B075
        let tRangColor = RangeColor(rangs: tR, colors: tC)
        //写的死的，活的自己算range咯
        let mR = [NSMakeRange(2, 2),NSMakeRange(12, 1)]
        let mC = [UIColor.red,UIColor.red]//FC0000
        let mRangeColor = RangeColor(rangs: mR, colors: mC)
        
        let lsqAlert = LsqAlertController(title: t, message: m)
        lsqAlert.titleRanges = tRangColor
        lsqAlert.msgRanges = mRangeColor
        lsqAlert.addAction(LsqAlertAction(title: "确定", style: .destructive, handler: { (act) in
            print("点击了取消")
            self.titleLabel.text = "确定"
            self.view.backgroundColor = UIColor.yellow
        }))
        lsqAlert.addAction(LsqAlertAction(title: "取消", style: .default, handler: { (act) in
            print("点击了取消")
            self.view.backgroundColor = UIColor.white
        }))

        self.present(lsqAlert, animated: true, completion: nil)
        
    }

    //TODO:默认弹框
    @IBAction func btn2Act(_ sender: UIButton) {
        
        let t = "提示你一下咯"
        let m = "您有32个梨子，已经吃了6个了"
        
        let lsqAlert = LsqAlertController(title: t, message: m)

        lsqAlert.addAction(LsqAlertAction(title: "确定", style: .destructive, handler: { (act) in
            print("点击了取消")
            self.titleLabel.text = "确定"
            self.view.backgroundColor = UIColor.yellow
        }))
        lsqAlert.addAction(LsqAlertAction(title: "取消", style: .default, handler: { (act) in
            print("点击了取消")
            self.view.backgroundColor = UIColor.white
        }))
        
        self.present(lsqAlert, animated: true, completion: nil)
        
        
    }
    
    
    
}

