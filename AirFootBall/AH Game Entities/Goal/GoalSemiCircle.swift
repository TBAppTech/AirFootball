import SpriteKit

class GoalSemiCircle: SKSpriteNode
{
    init(topGoal: Bool)
    {
        var textureImage: String
        
        if topGoal == true
        {
            textureImage = "semiCircleTop.png"
        }
        else
        {
            textureImage = "semiCircleBottom.png"
        }
        
        super.init(texture: SKTexture(imageNamed: textureImage), color: UIColor.clear, size: CGSize(width: screenWidth * 0.60, height: (screenWidth * 0.60) * 0.48))
       
        if UIDevice.current.userInterfaceIdiom == .phone{
            if topGoal == true
            {
                position = CGPoint(x: screenWidth/2, y: topGoalEdgeBottom - (self.size.height / 2) + 25)
            }
            else
            {
                position = CGPoint(x: screenWidth/2, y: bottomGoalEdgeTop + (self.size.height/2) - 25)
            }
        }else {
            if topGoal == true
            {
                position = CGPoint(x: screenWidth/2, y: topGoalEdgeBottom - (self.size.height / 2) + 35)
            }
            else
            {
                position = CGPoint(x: screenWidth/2, y: bottomGoalEdgeTop + (self.size.height/2) - 35)
            }
        }
        
        
        zPosition = -15
        colorBlendFactor = 0.5
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
}
