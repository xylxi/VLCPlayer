//
//  PlayViewController.swift
//  VLCPlayer
//
//  Created by king on 16/7/16.
//  Copyright © 2016年 king. All rights reserved.
//

import UIKit
import SnapKit

class PlayViewController: UIViewController {
    
    /// 本地路径
    private(set) var path: String?
    /// 网络地址
    private(set) var url: NSURL?
    
    /// VLC 播放器
    private var vlcPlayer: VLCMediaPlayer!
    /// 播放源
    private var media: VLCMedia!
    /// 进度条
    private var playProgress: UISlider!
    /// 音量条
    private var volumeProgress: UISlider!
    /// 剩余时间
    private var remainingTime: UILabel!
    /// 播放时间
    private var playTime: UILabel!
    /// 底部工具栏
    private var bottomBar: UIView!
    /// 顶部部工具栏
    private var topBar: UIView!
    /// 播放按钮
    private var playBtn: UIButton!
    /// 快进
    private var forwardBtn: UIButton!
    /// 快退
    private var fallbackBtn: UIButton!
    /// 重播
    private var replayView: UIImageView!
    /// 音量图片
    private var volumeView: UIImageView!
    /// 全屏按钮
    private var fullScreenBtn: UIButton!
    /// 指示器
    private var activityView: UIActivityIndicatorView!
    /// 返回按钮
    private var backBtn: UIButton!
    /// 手势开始X,Y
    private var beginTouchX: CGFloat = 0
    private var beginTouchY: CGFloat = 0
    /// 手势偏移量
    private var offsetX: CGFloat = 0
    private var offsetY: CGFloat = 0
    /// 是否全屏
    private var isFullScreen:Bool {
        get {
            return UIApplication.sharedApplication().statusBarOrientation.isLandscape
        }
    }
    
    
    convenience init(filePath: String) {
        self.init()
        path = filePath
        media = VLCMedia(path: filePath)
        
    }
    
    convenience init(url: NSURL) {
        self.init()
        self.url = url
        media = VLCMedia(URL: url)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.blackColor()
        navigationController?.navigationBar.hidden = true

        setTopBar()
        setBottmBar()
        
        view.addTapGestureRecognizer { (simple) -> Void in
            simple.addTapOpertation({ [weak self] (gesture) ->  Void in
                if let wekSelf = self {
                    wekSelf.showControlPanel()
                }
            })
        }
        
        view.addPanGestureRecognizer { (simple) -> Void in
            simple.addBeganOpertation({ [weak self] (gesture) -> Void in
                if let wekSelf = self {
                    wekSelf.panBegan(gesture)
                }
            }).addChangedOpertation({ [weak self] (gesture) -> Void in
                if let wekSelf = self {
                    wekSelf.panMoved(gesture)
                }
            })
        }
        
        topBar.hidden = false
        bottomBar.hidden = false
        
        
        replayView = UIImageView()
        replayView.image = UIImage(named: "redial")
        replayView.hidden = true
        replayView.userInteractionEnabled = true
        view.addSubview(replayView)
        replayView.addTapGestureRecognizer { (simple) -> Void in
            simple.addTapOpertation({ [weak self] (gesture) -> Void in
                if let wekSelf = self {
                    wekSelf.replay()
                }
            })
        }
        
        replayView.snp_makeConstraints { (make) -> Void in
            make.size.equalTo(CGSize(width: 50, height: 50))
            make.center.equalTo(view)
        }
        
        activityView = UIActivityIndicatorView(activityIndicatorStyle: .White)
        UIApplication.sharedApplication().keyWindow?.addSubview(activityView)
        activityView.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        activityView.center   = (UIApplication.sharedApplication().keyWindow?.center)!
        
        initVLC()
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        fullScreenBtn.selected = isFullScreen
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        
        if size.width > size.height {
            
            topBar.snp_updateConstraints(closure: { (make) -> Void in
                make.height.equalTo(35)
            })
            
        } else {
            topBar.snp_updateConstraints(closure: { (make) -> Void in
                make.height.equalTo(40)
            })
        }
        fullScreenBtn.selected = isFullScreen
        view.layoutIfNeeded()
    }
    
    // MARK: -
    // MARK: 手势相关处理
    func panBegan(pan: UIPanGestureRecognizer) {
    
        let beginPoint = pan.translationInView(pan.view)
        beginTouchX = beginPoint.x
        beginTouchY = beginPoint.y
        
    }
    
    func panMoved(pan: UIPanGestureRecognizer) {
        
        let beginPoint = pan.translationInView(pan.view)
        
        offsetX = beginPoint.x - beginTouchX
        
        if offsetX != 0 {
            if vlcPlayer.playing {
                
                let deltaProgress = offsetX / UIScreen.mainScreen().bounds.width
                let progressInSec: Int32 = Int32(deltaProgress * 300.0)
                
                if progressInSec > 0 && ((vlcPlayer.remainingTime?.intValue)! + progressInSec * 1000) < 0 {
                    vlcPlayer.jumpForward(progressInSec)
                } else if progressInSec > 0 && ((vlcPlayer.time?.intValue)! + progressInSec * 1000) > 0 {
                    vlcPlayer.jumpBackward(progressInSec)
                }
            }
        }
    }
    
    func initVLC() {
        
        vlcPlayer = VLCMediaPlayer(options: nil)
        vlcPlayer.drawable = view
        vlcPlayer.media = media
        vlcPlayer.delegate = self
    }
    
    func replay() {
        
        vlcPlayer.media = nil
        vlcPlayer.media = media
        play()
    }
    
    
    deinit {
        print("播放控制器释放了")
        activityView.removeFromSuperview()
    }
}

extension PlayViewController {
    
    // MARK: -
    // MARK: UI相关处理
    func setTopBar() {
       
        topBar                  = UIView()
        topBar.backgroundColor  = UIColor.whiteColor()
        
        
        remainingTime           = UILabel()
        remainingTime.textColor = UIColor.whiteColor()
        playTime                = UILabel()
        playTime.textColor      = UIColor.whiteColor()
        
        remainingTime.text      = "00:00:00"
        playTime.text           = "00:00:00"
        playTime.font           = UIFont.systemFontOfSize(12)
        remainingTime.font      = UIFont.systemFontOfSize(12)
        
        playProgress = UISlider()
        playProgress.setThumbImage(UIImage(named: "Oval"), forState: .Normal)
        playProgress.minimumTrackTintColor = UIColor.whiteColor()
        
        fullScreenBtn = UIButton(type: .Custom)
        fullScreenBtn.setImage(UIImage(named: "FullScreen"), forState: .Normal)
        fullScreenBtn.setImage(UIImage(named: "FullScreen2"), forState: .Selected)
        fullScreenBtn.addTarget(self, action: "fullScreen", forControlEvents: .TouchUpInside)
        
        backBtn                 = UIButton(type: .Custom)
        backBtn.setTitle("完成", forState: .Normal)
        backBtn.addTarget(self, action: "back", forControlEvents: .TouchUpInside)
        backBtn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        backBtn.titleLabel?.font = UIFont.systemFontOfSize(15)
        backBtn.addTarget(self, action: "back", forControlEvents: .TouchUpInside)
        
        view.addSubview(topBar)
        topBar.addSubview(backBtn)
        topBar.addSubview(playTime)
        topBar.addSubview(playProgress)
        topBar.addSubview(remainingTime)
        topBar.addSubview(fullScreenBtn)
        
        addTopBarConstraint()
    }
    
    func addTopBarConstraint() {
        
        let effect = UIBlurEffect(style: .Dark)
        let effectView = UIVisualEffectView(effect: effect)
        topBar.insertSubview(effectView, atIndex: 0)
        
        topBar.snp_makeConstraints { (make) -> Void in
            make.leading.top.trailing.equalTo(view)
            make.height.equalTo(isFullScreen ? 35 : 40)
        }
        effectView.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(topBar)
        }
        
        backBtn.snp_makeConstraints { (make) -> Void in
            make.leading.equalTo(view).offset(10)
            make.bottom.equalTo(topBar.snp_bottom).offset(-5)
            make.size.equalTo(CGSize(width: 30, height: 30))
        }
        
        playTime.snp_makeConstraints { (make) -> Void in
            make.leading.equalTo(backBtn.snp_trailing).offset(5)
            make.centerY.equalTo(backBtn)
        }
        
        fullScreenBtn.snp_makeConstraints { (make) -> Void in
            make.trailing.equalTo(topBar).offset(-10)
            make.centerY.equalTo(backBtn)
            make.size.equalTo(backBtn)
        }
        
        remainingTime.snp_makeConstraints { (make) -> Void in
            make.trailing.equalTo(fullScreenBtn.snp_leading).offset(-5)
            make.centerY.equalTo(backBtn)
        }
        
        playProgress.snp_makeConstraints { (make) -> Void in
            make.leading.equalTo(playTime.snp_trailing).offset(5)
            make.centerY.equalTo(backBtn)
            make.trailing.equalTo(remainingTime.snp_leading).offset(-5)
        }
        
    }

    
    func setBottmBar() {
        
        bottomBar = UIView()
        bottomBar.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        
        playBtn = UIButton(type: .Custom)
        playBtn.setImage(UIImage(named: "play"), forState: .Normal)
        playBtn.setImage(UIImage(named: "pause"), forState: .Selected)
        playBtn.addTarget(self, action: "play", forControlEvents: .TouchUpInside)
        volumeProgress = UISlider()
        volumeProgress.setThumbImage(UIImage(named: "Oval"), forState: .Normal)
        volumeProgress.minimumTrackTintColor = UIColor.whiteColor()
        
        
        forwardBtn = UIButton(type: .Custom)
        forwardBtn.setImage(UIImage(named: "forward"), forState: .Normal)
        forwardBtn.addTarget(self, action: "forwardClick", forControlEvents: .TouchUpInside)
        
        fallbackBtn = UIButton(type: .Custom)
        fallbackBtn.setImage(UIImage(named: "fallback"), forState: .Normal)
        fallbackBtn.addTarget(self, action: "fallbackClick", forControlEvents: .TouchUpInside)
        
        volumeView = UIImageView()
        volumeView.image = UIImage(named: "volume")
        
        view.addSubview(bottomBar)
        bottomBar.addSubview(playBtn)
        bottomBar.addSubview(fallbackBtn)
        bottomBar.addSubview(forwardBtn)
        bottomBar.addSubview(volumeView)
        bottomBar.addSubview(volumeProgress)
        
        
        addBottomBarConstraint()
    }
    
    func addBottomBarConstraint() {
        
        let effect = UIBlurEffect(style: .Dark)
        let effectView = UIVisualEffectView(effect: effect)
        bottomBar.insertSubview(effectView, atIndex: 0)
        bottomBar.snp_makeConstraints { (make) -> Void in
            make.leading.bottom.trailing.equalTo(view)
            make.height.equalTo(40)
        }
        
        effectView.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(bottomBar)
        }
        
        playBtn.snp_makeConstraints { (make) -> Void in
            make.leading.equalTo(bottomBar).offset(10)
            make.size.equalTo(backBtn)
            make.centerY.equalTo(bottomBar)
        }
        
        fallbackBtn.snp_makeConstraints { (make) -> Void in
            make.leading.equalTo(playBtn.snp_trailing).offset(10)
            make.size.equalTo(playBtn)
            make.centerY.equalTo(playBtn)
        }
        
        forwardBtn.snp_makeConstraints { (make) -> Void in
            make.leading.equalTo(fallbackBtn.snp_trailing).offset(10)
            make.size.equalTo(fallbackBtn)
            make.centerY.equalTo(fallbackBtn)
        }
        
        volumeView.snp_makeConstraints { (make) -> Void in
            make.leading.equalTo(forwardBtn.snp_trailing).offset(10)
            make.size.equalTo(CGSize(width: 18, height: 18))
            make.centerY.equalTo(forwardBtn)
        }
        
        volumeProgress.snp_makeConstraints { (make) -> Void in
            make.leading.equalTo(volumeView.snp_trailing).offset(10)
            make.centerY.equalTo(forwardBtn)
            make.trailing.equalTo(bottomBar.snp_trailing).offset(-15)
        }
    }
    
    // MARK: -
    // MARK: 事件相关
    func play() {
        
        if !playBtn.selected {
            vlcPlayer.play()
        } else {
            vlcPlayer.pause()
        }
        playBtn.selected = !playBtn.selected
        replayView.hidden = true
        
        
    }
    
    func forwardClick() {
        vlcPlayer.jumpForward(30)
    }
    
    func fallbackClick() {
        vlcPlayer.jumpBackward(30)
    }
    
    func showControlPanel() {
        
        view.bringSubviewToFront(topBar)
        view.bringSubviewToFront(bottomBar)
        
        if topBar.hidden {
            topBar.hidden = false
            bottomBar.hidden = false
        } else {
            topBar.hidden = true
            bottomBar.hidden = true
        }
    }
    
    
    func back() {
        if vlcPlayer.playing {
            vlcPlayer.pause()
        }
        if navigationController != nil {
            navigationController?.popViewControllerAnimated(true)
        } else {
            dismissViewControllerAnimated(true, completion: nil)
        }
    }
    func fullScreen() {
        
        if isFullScreen {
            UIDevice.currentDevice().setValue(UIInterfaceOrientation.Portrait.rawValue, forKey: "orientation")
            UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: UIStatusBarAnimation.Fade)
            UIApplication.sharedApplication().setStatusBarOrientation(UIInterfaceOrientation.Portrait, animated: false)
        } else {
            UIDevice.currentDevice().setValue(UIInterfaceOrientation.LandscapeRight.rawValue, forKey: "orientation")
            UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: UIStatusBarAnimation.Fade)
            UIApplication.sharedApplication().setStatusBarOrientation(UIInterfaceOrientation.LandscapeRight, animated: false)
        }
        
        fullScreenBtn.selected = !fullScreenBtn.selected
    }
    
}

extension PlayViewController : VLCMediaPlayerDelegate {
    
    // MARK: -
    // MARK: VLCMediaPlayerDelegate
    func mediaPlayerTimeChanged(aNotification: NSNotification!) {
        
        playTime.text      = vlcPlayer.time?.stringValue
        remainingTime.text = vlcPlayer.remainingTime?.stringValue
        playProgress.value = vlcPlayer.position
        if playProgress.value == 1.0 {
            print("播放完毕")
            playBtn.selected = false
            replayView.hidden = false
            view.bringSubviewToFront(replayView)
        }
        
    }
    
    func mediaPlayerStateChanged(aNotification: NSNotification!) {
        
        if vlcPlayer.playing {
            activityView.stopAnimating()
            print("播放中")
        } else if vlcPlayer.state == .Buffering {
            activityView.startAnimating()
            print("缓冲中")
        } else if vlcPlayer.state == .Ended {
            print("播放完毕")
            playBtn.selected = false
            replayView.hidden = false
        } else if vlcPlayer.state == .Error {
            print("播放错误")
            playBtn.selected = false
            activityView.stopAnimating()
        }
    }
}
