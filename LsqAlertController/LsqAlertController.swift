//
//  LsqAlertController.swift
//  LsqAlertController
//
//  Created by lsq on 2017/9/21.
//  Copyright © 2017年 罗石清. All rights reserved.
//

import UIKit

public enum LsqAlertActionStyle: Int{
    case `default`
    case cancel
    case destructive
}

open class LsqAlertAction: NSObject{
    deinit {
        print("LsqAlertAction->释放")
    }
    
    fileprivate var myTitle: String?
    fileprivate var style: LsqAlertActionStyle!
    fileprivate var handler: ((LsqAlertAction) -> Swift.Void)?
    
    public convenience init(title: String?, style: LsqAlertActionStyle, handler: ((LsqAlertAction) -> Swift.Void)? = nil){
        self.init()
        
        self.myTitle = title
        self.style = style
        self.handler = handler
    }
}

public struct RangeColor {
    public let rangs: [NSRange]
    public let colors: [UIColor]
}

class LsqAlertController: UIViewController {

    deinit {
        print("LsqAlertViewController->释放")
    }
    /*
     如需要设置文本的颜色，只需要设置该值即可
     */
    public var titleRanges: RangeColor?
    public var msgRanges: RangeColor?
    
    fileprivate var myTitle: String?//标题
    fileprivate var message: String?//内容，消息
    fileprivate var actions = [LsqAlertAction]()//点击类数组
    
    //弹框宽度
    fileprivate var popViewWidth: CGFloat {
        let scale375 = UIScreen.main.bounds.width / 375.0
        let width = 275 * scale375
        return width
    }
    //背景视图
    fileprivate var popView: UIView?
    //标题以及消息文本的宽度
    fileprivate var textWidth: CGFloat {
        return self.popViewWidth - 15 * 2
    }
    //标题font
    fileprivate let titleFont = UIFont.systemFont(ofSize: 17)
    //message font
    fileprivate let messageFont = UIFont.systemFont(ofSize: 14)
    //标题、message分别距离上下左右的间距
    fileprivate let space: CGFloat = 15
    //标题、message之间的间距
    fileprivate let titleMessageSpace: CGFloat = 5
    //action的高度
    fileprivate let actionHeight: CGFloat = 48
    //默认颜色，蓝色
    fileprivate let normalColor = UIColor(red: 0/255.0, green: 107/255.0, blue: 252/255.0, alpha: 1)
    //destructive，确定颜色，红色
    fileprivate let destructiveColor = UIColor(red: 254/255.0, green: 38/255.0, blue: 7/255.0, alpha: 1)
    
    public convenience init(title: String?, message: String?){
        self.init(nibName: nil, bundle: nil)
        self.modalTransitionStyle = .crossDissolve//设置淡入淡出
        self.modalPresentationStyle = .custom//设置模态类型
        self.myTitle = title
        self.message = message
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)//设置透明
        
        self.loadSomeView()
    }
    //TODO:调用该方法添加点击按钮
    open func addAction(_ action: LsqAlertAction){
        self.actions.append(action)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        //屏幕旋转，还能完美的在中间
        self.popView?.center = self.view.center
    }
    
    fileprivate func loadSomeView(){
        
        let popH = self.getAllHeight()
        popView = UIView(frame: CGRect(x: 0, y: 0, width: self.popViewWidth, height: popH))
        popView?.center = self.view.center
        popView?.backgroundColor = UIColor.white
        popView?.layer.cornerRadius = 13
        popView?.layer.masksToBounds = true
        self.view.addSubview(popView!)
        
        let titleLabel = UILabel(frame: CGRect(x: space, y: space, width: textWidth, height: self.getTitleHeight()))
        titleLabel.numberOfLines = 0
        titleLabel.attributedText = self.getAtt(with: 0)
        titleLabel.textAlignment = .center
        popView?.addSubview(titleLabel)
        
        var isHaveTitle = true//是否有标题
        var messageY: CGFloat = 0
        //判断标题是否有
        if self.myTitle != nil && !(self.myTitle?.isEmpty)!{
            messageY = titleLabel.frame.height + titleLabel.frame.origin.y + titleMessageSpace
            isHaveTitle = true
        }else{
            messageY = space
            isHaveTitle = false
        }
        let messageLabel = UILabel(frame: CGRect(x: space, y: messageY, width: textWidth, height: self.getMessageHeight()))
        messageLabel.numberOfLines = 0
        messageLabel.attributedText = self.getAtt(with: 1)
        messageLabel.textAlignment = .center
        popView?.addSubview(messageLabel)
        
        var lineY: CGFloat = 0
        //判断message是否有
        if self.message != nil && !(self.message?.isEmpty)! {
            //有message
            lineY = messageLabel.frame.height + messageLabel.frame.origin.y + space
        }else{
            if isHaveTitle{//有标题
                lineY = messageLabel.frame.height + messageLabel.frame.origin.y + space
            }else{//木有标题，而且木有message
                lineY = space
            }
        }
        let lineView = UIView(frame: CGRect(x: 0, y: lineY, width: popViewWidth, height: 0.5))
        lineView.backgroundColor = UIColor.groupTableViewBackground
        popView?.addSubview(lineView)
        
        let y = lineView.frame.height + lineView.frame.origin.y
        self.loadActionsView(y: y)
    }
    
    fileprivate func loadActionsView(y: CGFloat){
        
        switch self.actions.count {
        case 0:
            let btn = UIButton(frame: CGRect(x: 0, y: y, width: popViewWidth, height: actionHeight))
            btn.setTitle("确定", for: .normal)
            btn.setTitleColor(self.normalColor, for: .normal)
            btn.setBackgroundImage(self.image(from: UIColor.white, size: btn.frame.size), for: .normal)
            btn.setBackgroundImage(self.image(from: UIColor.groupTableViewBackground, size: btn.frame.size), for: .highlighted)
            btn.tag = -1
            btn.addTarget(self, action: #selector(self.actionAct(_:)), for: .touchUpInside)
            self.popView?.addSubview(btn)
        case 1:
            let title = self.actions[0].myTitle
            let style = self.actions[0].style
            let color = self.getActionTitleColor(with: style)
            let btn = UIButton(frame: CGRect(x: 0, y: y, width: popViewWidth, height: actionHeight))
            btn.setTitle(title, for: .normal)
            btn.setTitleColor(color, for: .normal)
            btn.setBackgroundImage(self.image(from: UIColor.white, size: btn.frame.size), for: .normal)
            btn.setBackgroundImage(self.image(from: UIColor.groupTableViewBackground, size: btn.frame.size), for: .highlighted)
            btn.tag = 0
            btn.addTarget(self, action: #selector(self.actionAct(_:)), for: .touchUpInside)
            self.popView?.addSubview(btn)
        case 2:
            let lineW: CGFloat = 0.5
            let actionWidth = (popViewWidth - lineW) / 2.0
            for i in 0..<self.actions.count{
                
                let btnX = CGFloat(i) * (actionWidth + lineW)
                
                let alertAction = self.actions[i]
                let title = alertAction.myTitle
                let style = alertAction.style
                let color = self.getActionTitleColor(with: style)
                
                let btn = UIButton(frame: CGRect(x: btnX, y: y, width: actionWidth, height: actionHeight))
                btn.setTitle(title, for: .normal)
                btn.setTitleColor(color, for: .normal)
                btn.setBackgroundImage(self.image(from: UIColor.white, size: btn.frame.size), for: .normal)
                btn.setBackgroundImage(self.image(from: UIColor.groupTableViewBackground, size: btn.frame.size), for: .highlighted)
                btn.tag = i
                btn.addTarget(self, action: #selector(self.actionAct(_:)), for: .touchUpInside)
                self.popView?.addSubview(btn)
                
                //竖线(不是最后一个才添加)
                if i != self.actions.count - 1{
                    print(i)
                    let x = btn.frame.origin.x + btn.frame.width
                    let lineView = UIView(frame: CGRect(x: x, y: y, width: lineW, height: actionHeight))
                    lineView.backgroundColor = UIColor.groupTableViewBackground
                    self.popView?.addSubview(lineView)
                }
            }
            
        default:
            let lineH: CGFloat = 0.5
            
            for i in 0..<self.actions.count{
                let btnY = CGFloat(i) * (actionHeight + lineH) + y
                
                let alertAction = self.actions[i]
                let title = alertAction.myTitle
                let style = alertAction.style
                let color = self.getActionTitleColor(with: style)
                
                let btn = UIButton(frame: CGRect(x: 0, y: btnY, width: popViewWidth, height: actionHeight))
                btn.setTitle(title, for: .normal)
                btn.setTitleColor(color, for: .normal)
                btn.setBackgroundImage(self.image(from: UIColor.white, size: btn.frame.size), for: .normal)
                btn.setBackgroundImage(self.image(from: UIColor.groupTableViewBackground, size: btn.frame.size), for: .highlighted)
                btn.tag = i
                btn.addTarget(self, action: #selector(self.actionAct(_:)), for: .touchUpInside)
                self.popView?.addSubview(btn)
                
                //横线(不是最后一个才添加)
                if i != self.actions.count - 1{
                    let lineY = btn.frame.origin.y + btn.frame.height
                    let lineView = UIView(frame: CGRect(x: 0, y: lineY, width: popViewWidth, height: lineH))
                    lineView.backgroundColor = UIColor.groupTableViewBackground
                    self.popView?.addSubview(lineView)
                }
            }
        }
    }
    //TODO:点击回调
    @objc fileprivate func actionAct(_ send: UIButton){
        
        self.dismiss(animated: true) {
            let tag = send.tag
            if tag != -1 {
                let actionHandler = self.actions[tag]
                actionHandler.handler?(actionHandler)
            }
        }
    }
    //根据style获取action 标题颜色
    fileprivate func getActionTitleColor(with type: LsqAlertActionStyle?)->UIColor{
        guard let style = type else {
            return self.normalColor
        }
        switch style {
        case .cancel,.default:
            return self.normalColor
        default:
            return self.destructiveColor
        }
    }
    //获取所有视图的高度和
    fileprivate func getAllHeight()->CGFloat{
        
        let titleH = self.getTitleHeight()
        let messageH = self.getMessageHeight()
        let actionH = self.getActionsHeight()
        
        var allHeight: CGFloat = 0
        if titleH == 0 {
            allHeight = space + messageH + space + actionH
        }else{
            if messageH == 0 {
                allHeight = space + titleH + space + actionH
            }else{
                allHeight = space + titleH + titleMessageSpace + messageH + space + actionH
            }
        }
        return allHeight
    }
    
    //计算标题高度
    fileprivate func getTitleHeight()->CGFloat{
        if let t = self.myTitle{
            if t.isEmpty {
                return 0
            }else{
                let height = self.getStringHeight(string: t, width: self.textWidth, font: self.titleFont)
                return height
            }
        }else{
            return 0
        }
    }
    //计算message高度
    fileprivate func getMessageHeight()->CGFloat{
        if let m = self.message{
            if m.isEmpty{
                return 0
            }else{
                let height = self.getStringHeight(string: m, width: self.textWidth, font: self.messageFont)
                return height
            }
        }else{
            return 0
        }
    }
    //获取所有action的高度
    fileprivate func getActionsHeight()->CGFloat{
        
        switch self.actions.count {
        case 0,1,2:
            return self.actionHeight
        default:
            return CGFloat(self.actions.count) * self.actionHeight + CGFloat(self.actions.count - 1) * 0.5
        }
    }
    
    //获取富文本(Index=0，获取标题，1或其他获取msg)
    fileprivate func getAtt(with index: Int)->NSMutableAttributedString?{
        switch index {
        case 0:
            if let tR = self.titleRanges{//设置了range
                //判断是否有标题值
                if let t = self.myTitle{//有标题
                    
                    let ranges = tR.rangs
                    let colors = tR.colors
                    
                    let strCharctCount = t.characters.count
                    
                    let attrib = NSMutableAttributedString(string: t)
                    attrib.addAttribute(NSFontAttributeName, value: self.titleFont, range: NSMakeRange(0, t.characters.count))
                    
                    for i in 0..<ranges.count{
                        
                        let range = ranges[i]
                        let color = colors[i]
                        
                        let count = range.location + range.length
                        print("count:\(count)")
                        if count <= strCharctCount{
                            attrib.addAttribute(NSForegroundColorAttributeName, value: color, range: range)
                        }
                    }
                    return attrib
                }else{//没有标题，直接返回nil
                    return nil
                }
            }else{//没有设置rang
                if let t = self.myTitle{
                    let att = NSMutableAttributedString(string: t)
                    att.addAttribute(NSFontAttributeName, value: self.titleFont, range: NSMakeRange(0, t.characters.count))
                    return att
                }else{
                    return nil
                }
            }
        default:
            if let mR = self.msgRanges{
                //判断是否有标题值
                if let t = self.message{//有标题
                    let ranges = mR.rangs
                    let colors = mR.colors
                    
                    let strCharctCount = t.characters.count
                    
                    let attrib = NSMutableAttributedString(string: t)
                    let color = UIColor(red: 8/255.0, green: 27/255.0, blue: 37/255.0, alpha: 1)
                    attrib.addAttribute(NSForegroundColorAttributeName, value: color, range: NSMakeRange(0, t.characters.count))
                    attrib.addAttribute(NSFontAttributeName, value: self.messageFont, range: NSMakeRange(0, t.characters.count))
                    
                    for i in 0..<ranges.count{
                        let range = ranges[i]
                        let color = colors[i]
                        let count = range.location + range.length
                        if count <= strCharctCount{
                            attrib.addAttribute(NSForegroundColorAttributeName, value: color, range: range)
                        }
                    }
                    return attrib
                    
                }else{//没有标题，直接返回nil
                    return nil
                }
            }else{//没有设置rang
                if let m = self.message{
                    let att = NSMutableAttributedString(string: m)
                    att.addAttribute(NSFontAttributeName, value: self.messageFont, range: NSMakeRange(0, m.characters.count))
                    let color = UIColor(red: 8/255.0, green: 27/255.0, blue: 37/255.0, alpha: 1)
                    att.addAttribute(NSForegroundColorAttributeName, value: color, range: NSMakeRange(0, m.characters.count))
                    return att
                }else{
                    return nil
                }
            }
        }
    }
    
    //计算文字高度
    fileprivate func getStringHeight(string: String, width: CGFloat, font: UIFont) -> CGFloat{
        let string = string as NSString
        let origin = NSStringDrawingOptions.usesLineFragmentOrigin
        let lead = NSStringDrawingOptions.usesFontLeading
        let rect = string.boundingRect(with: CGSize(width: width, height: 0), options: [origin,lead], attributes: [NSFontAttributeName:font], context: nil)
        return rect.height
    }
    
    //UIColor转成颜色图片
    fileprivate func image(from color: UIColor, size: CGSize) -> UIImage{
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }

}
