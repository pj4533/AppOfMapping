//
//  GameViewController.swift
//  Slaad
//
//  Created by PJ Gray on 4/29/19.
//  Copyright © 2019 Say Goodnight. All rights reserved.
//

import UIKit
import os.log
import SpriteKit
import GameplayKit
import WebKit
import FontAwesome_swift

class GameViewController: UIViewController, DungeonDelegate, SettingsDelegate, MapInfoDelegate {
    
    var map : DungeonMap?
    var scene : Dungeon?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var skview: SKView!
    override func viewDidLoad() {
        super.viewDidLoad()

//        for family: String in UIFont.familyNames {
//            print(family)
//            for names: String in UIFont.fontNames(forFamilyName: family) {
//                print("== \(names)")
//            }
//        }
        
        self.titleLabel.isHidden = true
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.backgroundColor = .clear

        let cog = UIImage.fontAwesomeIcon(name: .cog, style: .solid, textColor: .white, size: CGSize(width: 25.0, height: 25.0))
        let recycle = UIImage.fontAwesomeIcon(name: .syncAlt, style: .solid, textColor: .white, size: CGSize(width: 25.0, height: 25.0))
        let info = UIImage.fontAwesomeIcon(name: .infoCircle, style: .solid, textColor: .white, size: CGSize(width: 25.0, height: 25.0))
        let paw = UIImage.fontAwesomeIcon(name: .paw, style: .solid, textColor: .white, size: CGSize(width: 25.0, height: 25.0))

        self.navigationItem.setRightBarButtonItems([
            UIBarButtonItem(image: cog, style: .plain, target: self, action: #selector(tappedSettings)),
            UIBarButtonItem(image: paw, style: .plain, target: self, action: #selector(tappedMonsterFilters)),
            UIBarButtonItem(image: info, style: .plain, target: self, action: #selector(tappedEncounters))
            ], animated:false)

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: recycle, style: .plain, target: self, action: #selector(tappedRefresh))


    }

    override func viewDidAppear(_ animated: Bool) {
        if self.map == nil {
            self.addScene(nil)
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
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        self.updateMapName()
        self.updateCamera()
        
        if let nav = self.presentedViewController as? UINavigationController, nav.modalPresentationStyle == .popover {
            if self.traitCollection.horizontalSizeClass == .compact {
                let times = UIImage.fontAwesomeIcon(name: .times, style: .solid, textColor: .white, size: CGSize(width: 25.0, height: 25.0))
                nav.viewControllers.first?.navigationItem.leftBarButtonItem = UIBarButtonItem(image: times, style: .plain, target: self, action: #selector(tappedHide))
            } else {
                nav.viewControllers.first?.navigationItem.leftBarButtonItem = nil
            }
        }
    }
    
    func updateMapName() {
        if self.traitCollection.horizontalSizeClass == .compact {
            self.titleLabel.text = self.map?.name?.uppercased()
            self.titleLabel.isHidden = false
            self.title = nil
        } else {
            self.titleLabel.isHidden = true
            self.title = self.map?.name?.uppercased()
            self.navigationController?.navigationBar.titleTextAttributes = [
                NSAttributedString.Key.foregroundColor: UIColor.white,
                NSAttributedString.Key.font: UIFont(name: "Poppins-Bold", size: 25)!
            ]
        }
    }
    
    func addScene(_ map: DungeonMap?) {
        self.scene = Dungeon(size: self.skview.frame.size)
        // Set the scale mode to scale to fit the window
        self.scene?.scaleMode = .aspectFill
        self.scene?.dungeonDelegate = self
        
        let presentSceneClosure = {
            self.scene?.map = self.map
            
            // Present the scene
            self.skview.presentScene(self.scene)
            
            self.scene?.addCamera()
            
            self.updateCamera()
            
            self.skview.ignoresSiblingOrder = true
            
            self.skview.showsFPS = false
            self.skview.showsNodeCount = false
        }
        let finalizeClosure = {
            self.updateMapName()
        }
        if let map = map {
            self.map = map
            presentSceneClosure()
            finalizeClosure()
        } else {
            // Create the map for the dungeon
            self.map = DungeonMap()
            self.map?.generateMap()
            presentSceneClosure()
            self.map?.generateEncounters(success: {
                finalizeClosure()
            }, failure: nil)
        }
    }
    
    func updateCamera() {
        if self.traitCollection.horizontalSizeClass == .compact {
            self.scene?.cam?.setScale(2062.5 / (self.scene?.size.width ?? 375.0))//(5.5)
        } else {
            self.scene?.cam?.setScale(2732 / (self.scene?.size.width ?? 1366.0))//2.0
        }
    }
    
    // MARK: Actions
    
    @objc func tappedHide() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func tappedRefresh() {
        self.skview.scene?.removeFromParent()

        self.addScene(nil)
    }
    
    @objc func tappedMonsterFilters() {
        if self.presentedViewController != nil {
            self.dismiss(animated: true, completion: nil)
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let vc = storyboard.instantiateViewController(withIdentifier: "GroupsViewController") as? GroupsViewController {
                let nav = UINavigationController(rootViewController: vc)
                
                nav.modalPresentationStyle = UIModalPresentationStyle.popover
                nav.preferredContentSize = CGSize(width: 400, height: 2000)
                
                if self.traitCollection.horizontalSizeClass == .compact {
                    let times = UIImage.fontAwesomeIcon(name: .times, style: .solid, textColor: .white, size: CGSize(width: 25.0, height: 25.0))
                    vc.navigationItem.leftBarButtonItem = UIBarButtonItem(image: times, style: .plain, target: self, action: #selector(tappedHide))
                }
                
                self.present(nav, animated: true, completion: nil)
                
                let popoverPresentationController = nav.popoverPresentationController
                popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItems?[1]
            }
        }
    }
    
    @objc func tappedSettings() {
        if self.presentedViewController != nil {
            self.dismiss(animated: true, completion: nil)
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let vc = storyboard.instantiateViewController(withIdentifier: "SettingsViewController") as? SettingsViewController {
                vc.map = self.map
                vc.delegate = self
                
                let nav = UINavigationController(rootViewController: vc)
                
                nav.modalPresentationStyle = UIModalPresentationStyle.popover
                nav.preferredContentSize = CGSize(width: 400, height: 2000)
                
                if self.traitCollection.horizontalSizeClass == .compact {
                    let times = UIImage.fontAwesomeIcon(name: .times, style: .solid, textColor: .white, size: CGSize(width: 25.0, height: 25.0))
                    vc.navigationItem.leftBarButtonItem = UIBarButtonItem(image: times, style: .plain, target: self, action: #selector(tappedHide))
                }
                
                self.present(nav, animated: true, completion: nil)
                
                let popoverPresentationController = nav.popoverPresentationController
                popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItems?.first
            }
        }
    }
    
    @objc func tappedEncounters() {
        if self.presentedViewController != nil {
            self.dismiss(animated: true, completion: nil)
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let vc = storyboard.instantiateViewController(withIdentifier: "MapInfoViewController") as? MapInfoViewController {
                vc.map = self.map
                vc.delegate = self
                
                let nav = UINavigationController(rootViewController: vc)
                nav.modalPresentationStyle = UIModalPresentationStyle.popover
                nav.preferredContentSize = CGSize(width: 420, height: 2000)
                
                if self.traitCollection.horizontalSizeClass == .compact {
                    let times = UIImage.fontAwesomeIcon(name: .times, style: .solid, textColor: .white, size: CGSize(width: 25.0, height: 25.0))
                    vc.navigationItem.leftBarButtonItem = UIBarButtonItem(image: times, style: .plain, target: self, action: #selector(self.tappedHide))
                }
                
                self.present(nav, animated: true, completion: nil)
                
                let popoverPresentationController = nav.popoverPresentationController
                popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItems?[2]
            }
        }
    }

    // MARK: DungeonDelegate
    
    func didTapRoom(_ room: Room?) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "RoomViewController") as? RoomViewController {
            vc.room = room
            vc.isModal = true
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .formSheet
            self.present(nav, animated: true, completion: nil)
        }
    }
    
    // MARK: MapInfoDelegate
    
    func didUpdateMapName(_ map: DungeonMap?) {
        self.updateMapName()
    }
    
    // MARK: SettingsDelegate
    
    func didUpdateMap(_ map: DungeonMap?) {
        self.addScene(map)
    }
}
