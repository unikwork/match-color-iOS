//
//  GameOverView.swift
//  matchthecolor
//
//  Created by mymac on 11/04/24.
//

import UIKit
import Foundation

protocol GameOverViewDelegate{
    func restartGame()
    func goToHome()
}

class GameOverView: UIView {
    
    @IBOutlet weak var bgView: UIImageView!
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var homeButton: UIButton!
    @IBOutlet weak var restrartButton: UIButton!
    
    let kCONTENT_XIB_NAME = "GameOverView"
    var delegate: GameOverViewDelegate?
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadViewFromNib()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib()
    }
    
    func loadViewFromNib() {
        Bundle.main.loadNibNamed(kCONTENT_XIB_NAME, owner: self, options: nil)
        contentView.fixInView(self)
        bgView.borderWidth = 5
        bgView.cornerRadius = 20
        homeButton.borderWidth = 2
        homeButton.cornerRadius = 5
        restrartButton.borderWidth = 2
        restrartButton.cornerRadius = 5
    }
    
    func addScore(score: Int){
        self.scoreLabel.text = "\(score)"
    }
    
    @IBAction func restartButtonAction(_ sender: UIButton){
        self.delegate?.restartGame()
    }
    
    @IBAction func hoToHomeButtonAction(_ sender: UIButton){
        self.delegate?.goToHome()
    }
}

extension UIView
{
    func fixInView(_ container: UIView!) -> Void{
        self.translatesAutoresizingMaskIntoConstraints = false;
        self.frame = container.frame;
        container.addSubview(self);
        NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: container, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: container, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
    }
}
