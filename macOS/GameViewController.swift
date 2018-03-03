//
//  GameViewController.swift
//  macOS
//
//  Created by david padawer on 3/3/18.
//  Copyright © 2018 DPad Studios. All rights reserved.
//

import Cocoa
import SpriteKit
import GameplayKit

class GameViewController: NSViewController {

    var restart : (() -> Void)!

    override func viewDidLoad() {
        super.viewDidLoad()
        let scene = GameScene(size: CGSize(width: 800, height: 600))
        // Present the scene
        let skView = self.view as! SKView

        self.restart = {[unowned self] () in
            skView.presentScene(nil)
            let scene = GameScene(size: CGSize(width: 800, height: 600))
            skView.presentScene(scene)
            scene.restart = self.restart
        }

        scene.restart = self.restart



        skView.presentScene(scene)
        skView.ignoresSiblingOrder = true
        skView.showsFPS = true
        skView.showsNodeCount = true
    }

}

