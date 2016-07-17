//
//  SJSimpleGesture.swift
//  SJSimpleGestureDemoSwift
//
//  Created by king on 16/5/7.
//  Copyright © 2016年 king. All rights reserved.
//

//  The MIT License (MIT)
//
//  Copyright (c) 2016 king
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.



import UIKit

extension SJSimpleGesture {
    
    
    /**
     添加操作,此方法用于点按手势
     
     - parameter opertation: 操作
     
     - returns: self 可以继续掉后续方法
     */
    public func addTapOpertation(tapOpertation: OpertationBlock) -> SJSimpleGesture {
        self.tapOpertation = tapOpertation
        return self
    }
    /**
     添加开始操作
     
     - parameter beganOpertation: 操作
     
     - returns: self 可以继续掉后续方法
     */
    public func addBeganOpertation(beganOpertation: OpertationBlock) -> SJSimpleGesture {
        self.beganOpertation = beganOpertation
        return self
    }
    
    /**
     添加改变时的操作
     
     - parameter beganOpertation: 操作
     
     - returns: self 可以继续掉后续方法
     */
    public func addChangedOpertation(changedOpertation: OpertationBlock) -> SJSimpleGesture {
        self.changedOpertation = changedOpertation
        return self
    }
    
    /**
     添加取消时的操作
     
     - parameter cancelledOpertation: 操作
     
     - returns: self 可以继续掉后续方法
     */
    public func addCancelledOpertation(cancelledOpertation: OpertationBlock) -> SJSimpleGesture {
        self.cancelledOpertation = cancelledOpertation
        return self
    }
    
    /**
     添加结束时操作
     
     - parameter endOpertation: 操作
     
     - returns: self 可以继续掉后续方法
     */
    public func addEndOpertation(endOpertation: OpertationBlock) -> SJSimpleGesture {
        self.endOpertation = endOpertation
        return self
    }
    
    /**
     添加失败时的操作
     
     - parameter failedOpertation: 操作
     
     - returns: self 可以继续掉后续方法
     */
    public func addFailedOpertation(failedOpertation: OpertationBlock) -> SJSimpleGesture {
        self.failedOpertation = failedOpertation
        return self
    }
    ////////////////////////////// 以下API 只用于 轻扫手势 //////////////////////////////////
    /**
     添加向右轻扫时操作
     
     - parameter swipeRightOpertation: 操作
     
     - returns: self 可以继续掉后续方法
     */
    public func addSwipeRightOpertation(swipeRightOpertation: OpertationBlock) -> SJSimpleGesture {
        self.swipeRightOpertation = swipeRightOpertation
        return self
    }
    
    /**
     添加向左轻扫时操作
     
     - parameter swipeLeftOpertation: 操作
     
     - returns: self 可以继续掉后续方法
     */
    public func addSwipeLeftOpertation(swipeLeftOpertation: OpertationBlock) -> SJSimpleGesture {
        self.swipeLeftOpertation = swipeLeftOpertation
        return self
    }
    
    /**
     添加向上轻扫时操作
     
     - parameter swipeUpOpertation: 操作
     
     - returns: self 可以继续掉后续方法
     */
    public func addSwipeUpOpertation(swipeUpOpertation: OpertationBlock) -> SJSimpleGesture {
        self.swipeUpOpertation = swipeUpOpertation
        return self
    }
    
    /**
     添加向下轻扫时操作
     
     - parameter swipeDownOpertation: 操作
     
     - returns: self 可以继续掉后续方法
     */
    public func addSwipeDownOpertation(swipeDownOpertation: OpertationBlock) -> SJSimpleGesture {
        self.swipeDownOpertation = swipeDownOpertation
        return self
    }
}


public class SJSimpleGesture<T:UIGestureRecognizer>: NSObject {
    
    public typealias OpertationBlock = (gesture: T) -> Void
    
    private var tapOpertation: OpertationBlock?
    private var beganOpertation: OpertationBlock?
    private var changedOpertation: OpertationBlock?
    private var cancelledOpertation: OpertationBlock?
    private var endOpertation: OpertationBlock?
    private var failedOpertation: OpertationBlock?
    private var swipeRightOpertation: OpertationBlock?
    private var swipeLeftOpertation: OpertationBlock?
    private var swipeUpOpertation: OpertationBlock?
    private var swipeDownOpertation: OpertationBlock?
    
    @objc private func gestureAction(gesture: UIGestureRecognizer) {
        
        if tapOpertation != nil {
            tapOpertation!(gesture: gesture as! T)
            return
        }
        
        switch gesture.state {
        case .Began:
            if beganOpertation != nil {
                beganOpertation!(gesture: gesture as! T)
            }
        case .Changed:
            if changedOpertation != nil {
                changedOpertation!(gesture: gesture as! T)
            }
        case .Ended:
            if endOpertation != nil {
                endOpertation!(gesture: gesture as! T)
            }
        case .Cancelled:
            if cancelledOpertation != nil {
                cancelledOpertation!(gesture: gesture as! T)
            }
        case .Failed:
            if failedOpertation != nil {
                failedOpertation!(gesture: gesture as! T)
            }
        default:
            break
        }
    }
    
    @objc private func swipeGestureAction(gesture: UISwipeGestureRecognizer) {
        
        switch gesture.direction {
        case UISwipeGestureRecognizerDirection.Right:
            if swipeRightOpertation != nil {
                swipeRightOpertation!(gesture: gesture as! T)
            }
        case UISwipeGestureRecognizerDirection.Left:
            if swipeLeftOpertation != nil {
                swipeLeftOpertation!(gesture: gesture as! T)
            }
        case UISwipeGestureRecognizerDirection.Up:
            if swipeUpOpertation != nil {
                swipeUpOpertation!(gesture: gesture as! T)
            }
        case UISwipeGestureRecognizerDirection.Down:
            if swipeDownOpertation != nil {
                swipeDownOpertation!(gesture: gesture as! T)
            }
        default:
            break
        }
    }


}
