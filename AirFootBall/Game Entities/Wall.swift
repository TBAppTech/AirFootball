import SpriteKit


// Should have children classes comprised of different walls.
class Wall: SKSpriteNode
{
    
    let wallTexture = SKTexture(imageNamed: "BG_1")
    init(wallSize: CGSize, wallPosition: CGPoint, sideWall: Bool)
    {
        super.init(texture: wallTexture, color: UIColor.darkGray, size: wallSize)

        position = wallPosition
        //setup physics for this edge
        physicsBody = SKPhysicsBody(rectangleOf: self.size)
        physicsBody!.isDynamic = false
        physicsBody?.fieldBitMask = 30
        physicsBody?.restitution = 1.0
        physicsBody?.friction = 0.0
        physicsBody?.linearDamping = 0.0
        physicsBody?.angularDamping = 0.0
        blendMode = .replace
        physicsBody?.contactTestBitMask = 512
        if sideWall == true
        {
            physicsBody?.categoryBitMask = BodyType.sideWalls.rawValue
            zPosition = 100
        }
        else
        {
            physicsBody?.categoryBitMask = BodyType.topBottomWalls.rawValue
            zPosition = -5
        }
    }

    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
}
