# LsqAlertController
自定义高仿系统alert弹框，有富文本哦

1.调用 便利构造器
let lsqAlert = LsqAlertController(title: "text", message: "hahah")
2.添加点击事件
lsqAlert.addAction(LsqAlertAction(title: "确定", style: .destructive, handler: { (act) in
    //无需使用[weak self]
    print("点击了确定")
    self.xxx = yyyy
 }))
 3.模态展示该控制器
 self.present(lsqAlert, animated: true, completion: nil)
 
 
  4.如需要使用标题或者消息使用 颜色字体
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
    
    
    
