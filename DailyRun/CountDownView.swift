//
//  CtView.swift
//  CountDownView
//
//  Created by randy on 15/8/18.
//  Copyright (c) 2015年 randy. All rights reserved.
//

protocol CountDownDelegate
{
    func countDownFinished(countDownView:CountDownView)
}
import UIKit
class CountDownView: UIView {
    var numLabel:UILabel?
    var delegate:CountDownDelegate?
    override init(frame: CGRect) {
        super.init(frame: frame)
        numLabel = UILabel(frame: frame)
        numLabel?.textAlignment = NSTextAlignment.Center
        numLabel?.backgroundColor = UIColor.blackColor()
        numLabel?.alpha = 0.7
        self.backgroundColor = UIColor.blackColor()
        self.alpha = 0.7
        numLabel?.textColor = UIColor.whiteColor()
        numLabel?.font = UIFont.systemFontOfSize(50)
        numLabel?.text = "3"
        self.addSubview(numLabel!)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        numLabel = UILabel(frame: UIScreen.mainScreen().bounds)
        print(numLabel?.frame)
        numLabel?.textAlignment = NSTextAlignment.Center
        numLabel?.backgroundColor = UIColor.blackColor()
        numLabel?.alpha = 0.7
        numLabel?.textColor = UIColor.whiteColor()
        numLabel?.font = UIFont.systemFontOfSize(50)
        numLabel?.text = "3"
        self.addSubview(numLabel!)

    }
    
    func startCountDown()
    {
        numLabel?.transform = CGAffineTransformMakeScale(3, 3)
        numLabel?.font = UIFont.systemFontOfSize(70)

        numLabel?.text = "3"
        UIView.animateWithDuration(1.0, animations: {() in
            numLabel?.transform = CGAffineTransformMakeScale(0.1, 0.1)
            }, completion: {(d) in
                self.numLabel?.text = "2"
                self.numLabel?.transform = CGAffineTransformMakeScale(3, 3)
                self.numLabel?.font = UIFont.systemFontOfSize(70)

                UIView.animateWithDuration(1.0, animations: {() in
                    numLabel?.transform = CGAffineTransformMakeScale(0.1, 0.1)
                    }, completion: {(d) in
                        self.numLabel?.text = "1"
                        self.numLabel?.font = UIFont.systemFontOfSize(70)

                        self.numLabel?.transform = CGAffineTransformMakeScale(3, 3)
                        UIView.animateWithDuration(1.0, animations: {() in
                            numLabel?.transform = CGAffineTransformMakeScale(0.1, 0.1)
                            }, completion: {(d) in
                                self.numLabel?.text = "Start"
                                self.numLabel?.transform = CGAffineTransformMakeScale(1, 1)
                                self.numLabel?.font = UIFont.systemFontOfSize(50)
                                self.delegate?.countDownFinished(self)
                        })
                })
        })
    }
}
