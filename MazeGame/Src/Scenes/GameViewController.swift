//
//  GameViewController.swift
//  MazeGame
//
//  Created by Richard Plesnik on 03/02/2020.
//  Copyright © 2020 Richard Plesnik. All rights reserved.
//

import GameplayKit
import SpriteKit
import UIKit


/// Game view controler class
class GameViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "MenuScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .resizeFill

                // Present the scene
                view.presentScene(scene)

                // view.safeAreaInsets
                // view.safeAreaLayoutGuide.
            }

            view.ignoresSiblingOrder = true
            view.translatesAutoresizingMaskIntoConstraints = false

            view.showsFPS = true

        }
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
