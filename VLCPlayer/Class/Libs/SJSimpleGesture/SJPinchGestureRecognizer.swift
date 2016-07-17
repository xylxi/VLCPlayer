//
//  SJPinchGestureRecognizer.swift
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

public typealias pinConfig = (simple: SJSimpleGesture<UIPinchGestureRecognizer>) -> Void

public class SJPinchGestureRecognizer: UIPinchGestureRecognizer {

    private var simpleGesture = SJSimpleGesture<UIPinchGestureRecognizer>()
    
    init(config: pinConfig) {
        super.init(target: simpleGesture, action: "gestureAction:")
        config(simple: simpleGesture)
    }
}
