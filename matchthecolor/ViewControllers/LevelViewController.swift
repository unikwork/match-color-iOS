//
//  LevelViewController.swift
//  matchthecolor
//
//  Created by mymac on 11/04/24.
//

import UIKit
import Hero


class LevelViewController: UIViewController {
    //MARK: Outlet
    @IBOutlet weak var level1Button: UIButton!
    
    //MARK: View Controller Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //MARK: Button Action
    @IBAction func levelButtonTap(_ sender: UIButton){
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        let transition = CATransition()
        transition.duration = 1.0
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        self.navigationController?.view.layer.add(transition, forKey: nil)
        self.navigationController?.pushViewController(viewController, animated: false)
    }
    
    
}
