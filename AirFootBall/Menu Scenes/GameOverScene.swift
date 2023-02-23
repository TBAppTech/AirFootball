import SpriteKit


class GameOverScene: SKScene {
    var backToMenuButton = SKSpriteNode()
    var backToMenuButtonLabel = SKLabelNode(fontNamed: "Palatino Bold")
    override func didMove(to view: SKView) {
        
        let background = UIHelper.shared.createBackground()
        background.zPosition = 0
        addChild(background)
        
        // Create cup image
        let cupImage = SKSpriteNode(imageNamed: "cup")
        cupImage.position = CGPoint(x: frame.width / 2, y: frame.height / 2)
        cupImage.zPosition = 1
        //cupImage.setScale(0.5)
        if UIDevice.current.userInterfaceIdiom == .phone{
            cupImage.setScale(0.5)
        }else {
            cupImage.setScale(1)
        }
        addChild(cupImage)
        
        // Create label
        let whoWonGame = UserDefaults.standard.string(forKey: "whoWonGame")

      
        let rating = UserDefaults.standard.value(forKey: "rating") as! Bool
        
        let winLabel = SKLabelNode(text: "Win \(whoWonGame!)")
        winLabel.fontName = "Palatino Bold"
        if UIDevice.current.userInterfaceIdiom == .phone{
            winLabel.fontSize = 30
        }else {
            winLabel.fontSize = 50
        }
        //winLabel.fontSize = 30
        winLabel.fontColor = .white
        winLabel.position = CGPoint(x: frame.width / 2, y: cupImage.position.y + cupImage.size.height/2 + 100)
        winLabel.zPosition = 2
        addChild(winLabel)
        
        let plus100Label = SKLabelNode(fontNamed: "Palatino Bold")
        if whoWonGame! == "Enemy Bot" {
            plus100Label.text = "-50"
        }else {
            plus100Label.text = "+100"
        }
        
        if UIDevice.current.userInterfaceIdiom == .phone{
            plus100Label.fontSize = 32
        }else {
            plus100Label.fontSize = 52
        }
        //plus100Label.fontSize = 32
        plus100Label.fontColor = .yellow

        let goldsImage = SKSpriteNode(imageNamed: "golds")
        goldsImage.size = CGSize(width: plus100Label.frame.size.height, height: plus100Label.frame.size.height)

        let totalWidth = plus100Label.frame.width + goldsImage.size.width + 20
        let startX = cupImage.position.x - totalWidth/2 + plus100Label.frame.width/2

        plus100Label.position = CGPoint(x: startX, y: cupImage.position.y + cupImage.size.height/2 + 20)
        plus100Label.zPosition = 3
        plus100Label.isHidden = !rating
        addChild(plus100Label)

        goldsImage.position = CGPoint(x: plus100Label.position.x + plus100Label.frame.width/2 + 20, y: plus100Label.position.y + 10)
        goldsImage.zPosition = 3
        goldsImage.isHidden = !rating
        addChild(goldsImage)
        
        createBackToMenuButton()
    }
    
    func createBackToMenuButton(){
        backToMenuButton = SKSpriteNode(imageNamed: "button")
        backToMenuButton.position = CGPoint(x: frame.width/2, y: frame.height * 0.20)
        if UIDevice.current.userInterfaceIdiom == .phone{
            backToMenuButton.scale(to: CGSize(width: frame.width * 0.60, height: frame.height * 0.1))
            backToMenuButtonLabel.fontSize = frame.width/17.5
        }else {
            backToMenuButton.scale(to: CGSize(width: frame.width * 0.40, height: frame.height * 0.1))
            backToMenuButtonLabel.fontSize = frame.width/20.5
        }
       // backToMenuButton.scale(to: CGSize(width: frame.width * 0.60, height: frame.height * 0.1))
        backToMenuButton.zPosition = 1
        addChild(backToMenuButton)
        let button = SKSpriteNode(color: .red, size: CGSize(width: 100, height: 50))
        button.position = CGPoint(x: size.width/2, y: size.height/2)
        addChild(button)
        // set size, color, position and text of the tapStartLabel
        
        backToMenuButtonLabel.horizontalAlignmentMode = .center
        backToMenuButtonLabel.verticalAlignmentMode = .center
        backToMenuButtonLabel.position = CGPoint(x: backToMenuButton.position.x, y: backToMenuButton.position.y)
        backToMenuButtonLabel.zPosition = 2
        backToMenuButtonLabel.text = "Back to Menu"
        backToMenuButtonLabel.fontColor = .black
        backToMenuButtonLabel.fontName = "Palatino Bold"
       // backToMenuButtonLabel.fontSize = frame.width/17.5
        addChild(backToMenuButtonLabel)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // Check if menu button was touched
        for touch in touches {
            let location = touch.location(in: self)
            let nodes = self.nodes(at: location)
            for node in nodes {
                if node is SKLabelNode {
                    let menuScene = MenuScene(size: size)
                    menuScene.scaleMode = scaleMode
                    let transition = SKTransition.doorsCloseHorizontal(withDuration: 0.75)
                    view?.presentScene(menuScene, transition: transition)
                }
            }
        }
    }
}
