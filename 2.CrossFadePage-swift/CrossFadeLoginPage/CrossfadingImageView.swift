//
//  CrossfadingImageView.swift
//  CrossFadeLoginPage
//
//  Created by 颜建文 on 16/6/29.
//  Copyright © 2016年 颜建文. All rights reserved.
//

import UIKit

class CrossfadingImageView: UIImageView {
    
    enum Direction {
        case Up,Down
    }
    
    var shouldLoopImages: Bool = true
    
    var currentIndex: NSInteger = NSNotFound {
        didSet {
            if oldValue == currentIndex {
                return;
            }
            
            if currentIndex < 0 || currentIndex >= images.count {
                return;
            }
            
            image = images[currentIndex]
            topView.alpha = 0;
            setTop()
        }
    }
    
    var images = [UIImage]() {
        didSet {
            currentIndex = 0
            direction = Direction.Up
        }
    }
    
    lazy var topView:UIImageView  = {
        let view = UIImageView()
        view.autoresizingMask = [UIViewAutoresizing.FlexibleBottomMargin, UIViewAutoresizing.FlexibleTopMargin, UIViewAutoresizing.FlexibleLeftMargin, UIViewAutoresizing.FlexibleRightMargin]
        return view
    }()
    
    var direction: Direction = Direction.Up {
        didSet {
            if oldValue != direction {
                setTop()
            }
        }
    }

    override var frame: CGRect {
        willSet {
            topView.frame = newValue;
        }
    }
    
    override var bounds: CGRect {
        willSet {
            topView.bounds = newValue;
        }
    }

    override var contentMode: UIViewContentMode {
        willSet {
            topView.contentMode = newValue;
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        currentIndex = NSNotFound;
        contentMode = UIViewContentMode.ScaleAspectFill;
        insertSubview(topView, atIndex: 0);
    }
    
    //tracking
    func up(percent:CGFloat) {
        if !shouldLoopImages && currentIndex == images.count - 1 {
            return;
        }
        
        direction = Direction.Up;
        topView.alpha = fmax(fmin(1.0, percent), 0.0)
    }
    
    func down(percent:CGFloat) {
        if !shouldLoopImages && currentIndex == 0 {
            return;
        }
        
        direction = Direction.Down
        topView.alpha = fmax(fmin(1.0, percent), 0.0)
        
    }
    
    //auto
    func startCrossFading(timeInterval:NSTimeInterval) {
        NSTimer.scheduledTimerWithTimeInterval(timeInterval, target: self, selector: #selector(crossFade) , userInfo: nil, repeats: true);
    }
    
    private func setTop() {
        switch direction {
        case Direction.Up:
            if currentIndex == images.count - 1 {
                topView.image = shouldLoopImages ? images.first : nil;
            } else {
                topView.image = images[currentIndex + 1]
            }
            break
        case Direction.Down:
            if currentIndex == 0 {
                topView.image = shouldLoopImages ? images.last : nil;
            } else {
                topView.image = images[currentIndex - 1]
            }
            break;
        }
       
    }
    
    @objc private func crossFade() {
        //...
        direction = Direction.Up
        self.topView.alpha = 0;
        UIView.animateWithDuration(
            2,
            delay: 0,
            options: UIViewAnimationOptions.CurveEaseInOut,
            animations: {
               self.topView.alpha =  1;
            }, completion: { finished in
              self.updateCurrenIndex()
        })

    }
    
    private func updateCurrenIndex() {
        switch direction {
        case Direction.Up:
            currentIndex = (currentIndex == images.count - 1) ? 0 : (currentIndex + 1)
            break
        case Direction.Down:
            currentIndex = (currentIndex == 0) ? (images.count - 1) : (currentIndex - 1)
            break;
        }
    }

}