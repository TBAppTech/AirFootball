import SpriteKit

class UIHelper
{
    static let shared = UIHelper()

    func createEdges() -> (SKSpriteNode, SKSpriteNode, SKSpriteNode, SKSpriteNode)
    {
        let edgeWidth = screenWidth * 0.03
        let notchOffset = screenHeight * 0.0625
        
        let leftEdge = SKSpriteNode(color: UIColor.systemBlue, size: CGSize(width: edgeWidth, height: screenHeight))
        let rightEdge = SKSpriteNode(color: UIColor.systemBlue, size: CGSize(width: edgeWidth, height: screenHeight))
        let bottomEdge = SKSpriteNode(color: UIColor.systemBlue, size: CGSize(width: screenWidth, height: edgeWidth))
        let topEdge = SKSpriteNode(color: UIColor.systemBlue, size: CGSize(width: screenWidth, height: edgeWidth))
        
        leftEdge.position = CGPoint(x: 0 + edgeWidth/2, y: screenHeight/2)
        leftEdge.zPosition = 100
        rightEdge.position = CGPoint(x: screenWidth - edgeWidth/2, y: screenHeight/2)
        rightEdge.zPosition = 100

        if screenHeight > 800 && screenWidth < 500
        {
            bottomEdge.size.height = notchOffset
            topEdge.size.height = notchOffset
            bottomEdge.position = CGPoint(x: screenWidth * 0.5, y: 0 + notchOffset/2)
            topEdge.position = CGPoint(x: screenWidth * 0.5, y: screenHeight - notchOffset/2)
        }
        else
        {
            bottomEdge.size.height = edgeWidth
            topEdge.size.height = edgeWidth
            bottomEdge.position = CGPoint(x: screenWidth * 0.5, y: 0 + edgeWidth/2)
            topEdge.position = CGPoint(x: screenWidth * 0.5, y: screenHeight - edgeWidth/2)
        }
        bottomEdge.zPosition = -5
        topEdge.zPosition = -5
        return (leftEdge, rightEdge, bottomEdge, topEdge)
    }
    func createBackground() -> (SKSpriteNode)
    {
        let background = SKSpriteNode(imageNamed: "background")
        background.blendMode = .replace
        background.position = CGPoint(x: screenWidth/2, y: screenHeight/2)
        background.scale(to: CGSize(width: screenWidth, height: screenHeight))
        background.colorBlendFactor = 0
        background.zPosition = -100
        return background
    }
    
    func createTopBackgroundEmitter(emitter: SKEmitterNode, scale: CGFloat, image: SKTexture) -> (SKEmitterNode)
    {
        emitter.particleTexture = image
        emitter.particlePositionRange = CGVector(dx: screenWidth * 7/8, dy: 0)
        emitter.particleScale = scale
        emitter.particlePosition = CGPoint(x: screenWidth/2, y: -2/50 * screenHeight)
        emitter.particleLifetime = 6
        emitter.particleBirthRate = 0.65
        emitter.particleSpeed = 30
        emitter.yAcceleration = 60
        emitter.zPosition = -6
        emitter.particleColorBlendFactor = 0.50
        emitter.particleColorBlendFactorSpeed = 0.20
        emitter.advanceSimulationTime(1.5)
        return (emitter)
    }
    
    func createBottomBackgroundEmitter(emitter: SKEmitterNode, scale: CGFloat, image: SKTexture) -> (SKEmitterNode)
    {
        emitter.particleTexture = image
        emitter.particlePositionRange = CGVector(dx: screenWidth * 7/8, dy: 0)
        emitter.particleScale = scale
        emitter.particlePosition = CGPoint(x: screenWidth/2, y: 51/50 * screenHeight)
        emitter.particleLifetime = 6
        emitter.particleBirthRate = 0.65
        emitter.particleSpeed = 30
        emitter.yAcceleration = -60
        emitter.zPosition = -6
        emitter.particleColorBlendFactor = 0.50
        emitter.particleColorBlendFactorSpeed = 0.20
        emitter.advanceSimulationTime(1.5)
        return (emitter)
    }
    
    func createBackToMenuButton(menuButton: SKSpriteNode) -> (SKSpriteNode)
    {
        menuButton.blendMode = .replace
        menuButton.position = CGPoint(x: screenWidth/2, y: screenHeight * 0.17)
        menuButton.scale(to: CGSize(width: screenWidth * 2/3, height: screenHeight/10))
        menuButton.colorBlendFactor = 0
        
        return (menuButton)
    }
    
    
    func createBackToMenuLabel(menuLabel: SKLabelNode) -> (SKLabelNode)
    {
        menuLabel.fontSize = screenWidth/17.5
        menuLabel.fontColor = .black
        menuLabel.horizontalAlignmentMode = .center
        menuLabel.verticalAlignmentMode = .center
        menuLabel.position = CGPoint(x: screenWidth/2, y: screenHeight * 0.17)
        menuLabel.zPosition = 2
        menuLabel.text = "Back to Menu"
        menuLabel.fontName = "Palatino Bold"
    
        return (menuLabel)
    }
    
    func createText(textName: SKLabelNode, text: String, position: CGPoint, iPhoneFontSize: CGFloat, iPadFontSize: CGFloat, color: SKColor, zPos: CGFloat) -> SKLabelNode
    {
        // set size, color, position and text of the gameWinnerLabel
        if screenWidth < 600
        {
            textName.fontSize = iPhoneFontSize
        }
        else
        {
            textName.fontSize = iPadFontSize
        }
        textName.fontColor = color
        textName.horizontalAlignmentMode = .center
        textName.verticalAlignmentMode = .center
        textName.position = position
        textName.zPosition = zPos
        textName.text = text
        return textName
    }
}
