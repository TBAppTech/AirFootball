import SpriteKit

class Ball: SKSpriteNode {
    init(multiBall: Bool) {
        let ballTexture = SKTexture(imageNamed: "ball1") // указать имя изображения шарика
        var width = CGFloat()
        if deviceType.contains("iPad"){
            width = screenWidth / 20
        }else{
            width = screenWidth / 15
        }
        super.init(texture: ballTexture, color: .clear, size: CGSize(width: width, height: width))
        
        //set ball physics properties
        physicsBody = SKPhysicsBody(circleOfRadius: size.width / 2.0)
        physicsBody!.mass = 0.015
        physicsBody?.friction = 0.10
        physicsBody!.affectedByGravity = false
        physicsBody!.restitution = 1.00
        physicsBody!.linearDamping = 0.90
        physicsBody!.angularDamping = 0.90
        physicsBody?.categoryBitMask = BodyType.ball.rawValue
        physicsBody?.fieldBitMask = 640
        physicsBody?.contactTestBitMask = BodyType.player.rawValue
        
        if multiBall == false {
            let ySpawnsArray = [screenHeight * 0.35, screenHeight * 0.65]
            position = CGPoint(x: screenWidth/2, y: ySpawnsArray.randomElement()!)
            physicsBody!.velocity = CGVector(dx: 0, dy: 0)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func clearBall() {
        position = CGPoint(x: -200, y: -200)
        physicsBody!.velocity = CGVector(dx: 0, dy: 0)
    }
    
    func resetBallTopPlayerBallStart() {
        position = CGPoint(x: screenWidth/2, y: screenHeight * (0.65))
        physicsBody!.velocity = CGVector(dx: 0, dy: 0)
    }
    
    func resetBallBottomPlayerBallStart() {
        position = CGPoint(x: screenWidth/2, y: screenHeight * 0.35)
        physicsBody!.velocity = CGVector(dx: 0, dy: 0)
    }
}
