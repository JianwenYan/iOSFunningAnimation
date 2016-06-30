//
//  ViewController.swift
//  CrossFadeLoginPage
//
//  Created by 颜建文 on 16/6/29.
//  Copyright © 2016年 颜建文. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var backgroundImageView: CrossfadingImageView!
    
    var musicPlayer = AVAudioPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        backgroundImageView.images =  [ UIImage.init(named: "TokyoStyle1")!,
                                        UIImage.init(named: "TokyoStyle2")!,
                                        UIImage.init(named: "TokyoStyle3")!,
                                        UIImage.init(named: "TokyoStyle4")!,
                                        UIImage.init(named: "TokyoStyle5")!,
                                        UIImage.init(named: "TokyoStyle6")!,
                                        UIImage.init(named: "TokyoStyle7")!,
                                      ];
        backgroundImageView.startCrossFading(6);
        playBackgroundMusic()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func playBackgroundMusic() {
        let musicURL:NSURL =  NSBundle.mainBundle().URLForResource("bg", withExtension: "mp3")!
        do {
            try musicPlayer = AVAudioPlayer(contentsOfURL: musicURL, fileTypeHint: "mp3")
            musicPlayer.numberOfLoops = -1
            musicPlayer.prepareToPlay()
            musicPlayer.play()
        } catch let error as NSError {
            print("Could not create audio player: \(error)")
        }
    }

}

