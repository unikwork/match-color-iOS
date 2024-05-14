//
//  ViewController.swift
//  matchthecolor
//
//  Created by mymac on 08/03/24.
//

import UIKit
import Sica


class ViewController: UIViewController {
    
    //MARK: Outlet
    @IBOutlet weak var bgView: UIImageView!
    @IBOutlet weak var controllView: UIView!
    @IBOutlet weak var leftTouchableView: UIView!
    @IBOutlet weak var rightTouchableView: UIView!
    @IBOutlet weak var scorlabel: UILabel!
    
    //MARK: Variables
    let goView = GameOverView()
    var score: Int = 00{
        didSet{
            scorlabel.text = "\(score)"
            if score % 10 == 0{
                increaseSpeed()
            }
        }
    }
    var ballSpeed: Double = 2
    var ballColors: [UIColor] = [.yellow, .red, .orange, .green]
    var controllarRange: [CGFloat] = []
    var ballView: UIView!
    var displayLink: CADisplayLink!
    var rotatedAngle: Int = 0{
        didSet{
            if rotatedAngle == 360 || rotatedAngle == -360{
                rotatedAngle = 0
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        drawRectangle()
        addGestures()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.setHidesBackButton(true, animated: true)
    }
    override func viewDidAppear(_ animated: Bool) {
        self.startGame()
    }
    //MARK: Views
    
    private func addBallView(){
        ballView = UIView(frame: CGRect(x: 100, y: 0, width: 50, height: 50))
        ballView.layer.cornerRadius = 25
        ballView.layer.masksToBounds = true
        ballView.backgroundColor = ballColors.randomElement()
        bgView.addSubview(ballView)
        self.view.sendSubviewToBack(ballView)
    }
    
    private func removeBallView(){
        self.ballView.removeFromSuperview()
        
    }
    
    private func startGame(){
        addBallView()
        controllView.isHidden = false
        //Count Controller Range for Balls - X
        controllarRange.append(controllView.frame.origin.x + (ballView.frame.size.width/2))
        repeat{
            let lastMember = Float(controllarRange.last ?? 0.0)
            controllarRange.append(CGFloat(lastMember+0.5))
        }while controllarRange.last ?? 0.0 <= ((controllView.frame.size.width + controllView.frame.origin.x)-(ballView.frame.size.width/2))
        displayLink = CADisplayLink(target: self, selector: #selector(update))
        displayLink.add(to: .main, forMode: .default)
        displayLink.isPaused = false
    }
    

    
    private func stopGame(){
        displayLink.isPaused = true
        controllView.isHidden = true
        removeBallView()
        self.ballSpeed = 2
    }
    
    
    private func drawRectangle() {
        let length = self.view.frame.size.width*0.75
        let pointA = CGPoint(x:0, y:0)
        let pointB = CGPoint(x: length, y: 0)
        let pointC = CGPoint(x: length, y: length)
        let pointD = CGPoint(x: 0, y: length)
        let centerPoint = CGPoint(x: length/2, y: length/2)
        //Triangle1
        let path1 = UIBezierPath()
        path1.move(to: pointA)
        path1.addLine(to: pointB)
        path1.addLine(to: centerPoint)
        path1.addLine(to: pointA)
        let shapeLayer1 = CAShapeLayer()
        shapeLayer1.path = path1.cgPath
        shapeLayer1.strokeColor = UIColor.clear.cgColor
        shapeLayer1.fillColor = UIColor.orange.cgColor
        shapeLayer1.lineWidth = 0.5
        controllView.layer.addSublayer(shapeLayer1)
        //Triangle2
        let path2 = UIBezierPath()
        path2.move(to: pointA)
        path2.addLine(to: pointD)
        path2.addLine(to: centerPoint)
        path2.addLine(to: pointA)
        let shapeLayer2 = CAShapeLayer()
        shapeLayer2.path = path2.cgPath
        shapeLayer2.strokeColor = UIColor.clear.cgColor
        shapeLayer2.fillColor = UIColor.yellow.cgColor
        shapeLayer2.lineWidth = 0.5
        controllView.layer.addSublayer(shapeLayer2)
        //Triangle3
        let path3 = UIBezierPath()
        path3.move(to: pointD)
        path3.addLine(to: pointC)
        path3.addLine(to: centerPoint)
        path3.addLine(to: pointD)
        let shapeLayer3 = CAShapeLayer()
        shapeLayer3.path = path3.cgPath
        shapeLayer3.strokeColor = UIColor.clear.cgColor
        shapeLayer3.fillColor = UIColor.green.cgColor
        shapeLayer3.lineWidth = 0.5
        controllView.layer.addSublayer(shapeLayer3)
        //Triangle4
        let path4 = UIBezierPath()
        path4.move(to: pointC)
        path4.addLine(to: pointB)
        path4.addLine(to: centerPoint)
        path4.addLine(to: pointC)
        let shapeLayer4 = CAShapeLayer()
        shapeLayer4.path = path4.cgPath
        shapeLayer4.strokeColor = UIColor.clear.cgColor
        shapeLayer4.fillColor = UIColor.red.cgColor
        shapeLayer4.lineWidth = 0.5
        controllView.layer.addSublayer(shapeLayer4)
    }
    
    func addGestures(){
        leftTouchableView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.handleLeftTap(_:))))
        rightTouchableView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.handleRightTap(_:))))
    }
    
    func getUpperView() -> StageColors{
        switch rotatedAngle{
        case 0:
            return .Orange
        case 90,-270:
            return .Yellow
        case 180,-180:
            return .Green
        case 270,-90:
            return .Red
        default:
            return .Orange
        }
    }
    
    func isCorrectTouch() -> Bool{
        return ballView.backgroundColor == getUpperView().color()
    }
    
    func increaseSpeed(){
        ballSpeed += 0.5
    }
    
    func resetBall(completion: () -> Void){
        ballView.frame.origin.y = 0
        ballView.frame.origin.x = controllarRange.randomElement() ?? 100
        ballView.backgroundColor = ballColors.randomElement()
        completion()
    }
    
    func kickTheBall(completion: () -> Void){
        UIView.animate(withDuration:1.0,
                       delay: 0.0,
                       usingSpringWithDamping: .pi,
                       initialSpringVelocity: 1.0,
                       options: [.transitionCrossDissolve],
                       animations: {
            //Do all animations here
            self.ballView.frame.origin.y = self.view.frame.height
            self.ballView.frame.origin.x = 0
        }, completion: {
            //Code to run after animating
            (value: Bool) in
        })
    }
    
    
   
    
    func animateToCloseDoor(completion: @escaping () -> Void){
        completion()
    }
    
    func animateGameOver(){
        let transition:CATransition = CATransition()
          transition.duration = 0.5
          transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
          transition.type = CATransitionType.reveal
          transition.subtype = CATransitionSubtype.fromBottom
          self.navigationController?.view.layer.add(transition, forKey: kCATransition)
          self.navigationController?.popViewController(animated: false)
    }
    
    func addGameOverView(){
        goView.frame.size = CGSize(width: self.view.frame.width*0.75, height: self.view.frame.height*0.75)
        goView.center = self.view.center
        goView.addScore(score: self.score)
        goView.delegate = self
        self.view.addSubview(goView)
    }
    
    //MARK: Actions
    
    @objc func update() {
        // Move ball down
        ballView.frame.origin.y += CGFloat(ballSpeed)
        // If ball is at the bottom, reset its position and change color
        if ballView.frame.origin.y + ballView.frame.size.height >= controllView.frame.origin.y {
            if isCorrectTouch(){
                if ballView.frame.origin.y >= (controllView.frame.origin.y + ballView.frame.size.height){
                    ballView.backgroundColor = .clear
                    resetBall{
                        score += 1
                    }
                }
            }else{
                resetBall{
                    animateToCloseDoor {
                        self.stopGame()
                        self.addGameOverView()
                    }
                }
            }
        }
    }
    
    @objc func handleLeftTap(_ sender: UITapGestureRecognizer? = nil) {
        rotatedAngle -= 90
        rotateView(angle: -90)
    }
    
    @objc func handleRightTap(_ sender: UITapGestureRecognizer? = nil) {
        rotatedAngle += 90
        rotateView(angle: 90)
    }
    
    func rotateView(angle: CGFloat){
        self.controllView.rotate(angle: angle)
//        let convetedAngle = angle > 0.0 ? (Double.pi/2) : (-Double.pi/2)
//        self.rotateAnimation(theView: controllView, speed: 0.1, toValue: convetedAngle)
    }
    
    func rotateAnimation(theView: UIView, speed: Float, duration: CFTimeInterval = 0.1, fromValue: CGFloat = CGFloat(0.0), toValue: Double, option: CAMediaTimingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)) {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = fromValue
        rotateAnimation.toValue = toValue
        rotateAnimation.duration = duration
        rotateAnimation.speed = speed
        rotateAnimation.repeatCount = 1
        rotateAnimation.timingFunction = option
        theView.layer.add(rotateAnimation, forKey: nil)
    }
}

extension ViewController: GameOverViewDelegate{
    func restartGame() {
        self.goView.removeFromSuperview()
        self.score = 0
        self.ballSpeed = 2
        self.startGame()
    }
    
    func goToHome() {
        self.goView.removeFromSuperview()
        self.score = 0
        self.ballSpeed = 2
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.moveIn
        transition.subtype = CATransitionSubtype.fromLeft
        self.navigationController?.view.layer.add(transition, forKey: nil)
        self.navigationController?.popViewController(animated: false)
    }
    
    
}


extension UIView{
    func rotate(angle: CGFloat) {
        let radians = angle / 180.0 * CGFloat.pi
        let rotation = CGAffineTransformRotate(self.transform, radians)
        self.transform = rotation
    }
}
