import GameplayKit
import SpriteKit

class MenuScene: SKScene, SKPhysicsContactDelegate {
    // Получаем размер экрана
    let screenSize = UIScreen.main.bounds.size
    
    
    override func didMove(to view: SKView) {
        
        
        setHeader()
        
        let titles = ["training", "one ball", "two balls", "rating", "settings", "shop"]
        
        for (index, title) in titles.enumerated() {
            let button = ButtonNode(titled: title, backgroundName: "button")
           
            button.name = title
            button.label.name = title
            if UIDevice.current.userInterfaceIdiom == .phone{
                button.position = CGPoint(x: self.frame.midX, y: self.frame.midY + 50 - CGFloat(60 * index))
                button.scale(to: CGSize(width: frame.width * 0.55, height: frame.height * 0.06))
                button.label.fontSize = frame.width/4.5
            }else {
                button.scale(to: CGSize(width: frame.width * 0.55, height: frame.height * 0.07))
                button.position = CGPoint(x: self.frame.midX, y: self.frame.midY + 80 - CGFloat(110 * index))
                button.label.fontSize = frame.width/8
            }
            
            
            addChild(button)
        }
        
        let background = UIHelper.shared.createBackground()
        addChild(background)
    }
    func setHeader() {
        let airLogo = ButtonNode(titled: name, backgroundName: "Air logo")
        airLogo.scale(to: CGSize(width: frame.width * 0.55, height: frame.height * 0.095))
        airLogo.zPosition = 1
        let airLogoPosition = CGPoint(x: screenSize.width + airLogo.size.width/2, y: self.frame.maxY - 120)
        let footballLogo = ButtonNode(titled: name, backgroundName: "Football logo")
        footballLogo.zPosition = 0
        footballLogo.scale(to: CGSize(width: frame.width * 0.55, height: frame.height * 0.095))
        let footballLogoPosition = CGPoint(x: -footballLogo.size.width/2, y: airLogoPosition.y - footballLogo.frame.height)
        //header.position = CGPoint(x: self.frame.midX, y: self.frame.midY + 150)
        
        
        self.addChild(footballLogo)
        self.addChild(airLogo)
        slideInFromRight(sprite: airLogo, position: airLogoPosition, shift: -25)
        slideInFromRight(sprite: footballLogo, position: footballLogoPosition, shift: 25)
    }
    
    func slideInFromRight(sprite: SKSpriteNode, position: CGPoint, shift: CGFloat) {
       
        
        // Определяем начальное положение узла за пределами экрана
        let startingPosition = position
        sprite.position = startingPosition
        
        // Создаем действие анимации перемещения узла на центр экрана
        let moveAction = SKAction.move(to: CGPoint(x: screenSize.width/2 + shift, y: position.y ), duration: 0.3)
        
        let shakeAction = SKAction.sequence([
                SKAction.moveBy(x: 10, y: 0, duration: 0.05),
                SKAction.moveBy(x: -20, y: 0, duration: 0.1),
                SKAction.moveBy(x: 20, y: 0, duration: 0.1),
                SKAction.moveBy(x: -20, y: 0, duration: 0.1),
                SKAction.moveBy(x: 10, y: 0, duration: 0.05)
            ])
            
            // Создаем последовательность действий анимации
            let sequenceAction = SKAction.sequence([moveAction, shakeAction])
        
        // Запускаем анимацию
        sprite.run(sequenceAction)
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let location = touches.first!.location(in: self)
        let node = self.atPoint(location)
        
        if node.name == "training" {
            playAirHockey(gameScene: AirHockey1P())
            
        }  else if node.name == "one ball" {
            playAirHockey(gameScene: AirHockey2P())
           
        }  else if node.name == "two balls" {
            playAirHockey(gameScene: AirHockey2PMultiPuck())
          
        }else if node.name == "settings" {
            goToSttingsView()
          
        }else if node.name == "rating" {
            goToRatingView()
          
        }else if node.name == "shop" {
            goToShopView()
          
        }
    }
    func playAirHockey(gameScene: SKScene){
        var scene = gameScene
        scene.size = (view?.bounds.size)!
        
        // Configure the view.
        let skView = self.view!
        skView.isMultipleTouchEnabled = true
        
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        skView.ignoresSiblingOrder = true
        
        /* Set the scale mode to scale to fit the window */
        scene.scaleMode = .resizeFill
        let transition = SKTransition.doorsOpenHorizontal(withDuration: 0.75)
        skView.presentScene(scene, transition: transition)
    }
    
     func goToSttingsView(){
        let vc = SettingsViewController()
        
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        if let view = self.view {
            let currentViewController = view.window?.rootViewController
            currentViewController?.present(vc, animated: true, completion: nil)
        }
    }
    
    func goToRatingView(){
       let vc = RatingViewController()
       
       vc.modalTransitionStyle = .crossDissolve
       vc.modalPresentationStyle = .overFullScreen
       if let view = self.view {
           let currentViewController = view.window?.rootViewController
           currentViewController?.present(vc, animated: true, completion: nil)
       }
   }
    
    func goToShopView(){
       let vc = ShopViewController()
       
       vc.modalTransitionStyle = .crossDissolve
       vc.modalPresentationStyle = .overFullScreen
       if let view = self.view {
           let currentViewController = view.window?.rootViewController
           currentViewController?.present(vc, animated: true, completion: nil)
       }
   }
    
}

class ButtonNode: SKSpriteNode {
    
    let label: SKLabelNode = {
        let l = SKLabelNode(text: "")
        l.fontColor = .black
        l.fontName = "Palatino Bold"
        l.fontSize = 40
        l.horizontalAlignmentMode = .center
        l.verticalAlignmentMode = .center
        l.zPosition = 2
        
        return l
    }()
    
    init(titled title: String?, backgroundName: String) {
        let texture = SKTexture(imageNamed: backgroundName)
        super.init(texture: texture, color: .clear, size: texture.size())
        if let title = title {
            label.text = title.uppercased()
        }
        addChild(label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
