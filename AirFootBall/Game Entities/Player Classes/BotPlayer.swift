import SpriteKit

protocol BotPlayerDelegate : AnyObject
{
//    func botForce(_ force: CGVector, fromBotPlayer botPlayer: BotPlayer)
    func botTouchIsActive(_ botTouchIsActive: Bool, fromBotPlayer botPlayer: BotPlayer)
}

class BotPlayer: SKShapeNode
{
    //keep track of previous touch time (will use to calculate vector)
    var lastTouchTimeStamp: Double?
    
    //delegate will refer to class which will act on player force
    weak var delegate:BotPlayerDelegate?
    
    //this will determine the allowable area for the player
    let activeArea:CGRect
    
    var botTouchIsActive = false
    
    //define player size
    var radius:CGFloat
    
    //when we instantiate the class we will set the active area
    init(activeArea: CGRect)
    {
        let screenRect = UIScreen.main.bounds
        let screenWidth = screenRect.size.width
        
        if UserDefaults.standard.string(forKey: "Game") != "Air Hockey"
        {
            if screenWidth > 700
            {
                radius = screenWidth/15
            }
            else
            {
                radius = screenWidth/11
            }
        }
        else
        {
            if screenWidth > 700
            {
                radius = screenWidth/12
            }
            else
            {
                radius = screenWidth/9
            }
        }
        
        //set the active area variable this class with the variable passed in
        self.activeArea = activeArea
        
        //ensure we pass the init call to the base class
        super.init()
        
        //allow the player to handle touch events
        isUserInteractionEnabled = false
        
        //create a mutable path (later configured as a circle)
        let circularPath = CGMutablePath()
        
        //define pi as CGFloat (type π using alt-p)
        let π = CGFloat.pi
        
               
        //create the circle shape
        circularPath.addArc(center: CGPoint(x: 0, y:0), radius: radius, startAngle: 0, endAngle: 2*π, clockwise: true)
        
        //assign the path to this SKShapeNode's path property
        path = circularPath
        
        lineWidth = 0;
        
        fillColor = .white
        
        let randomNumber = Int.random(in: 1...10)
        let team = "team\(randomNumber)"
        fillTexture = SKTexture(imageNamed: team )
        
        
        //set physics properties (note physicsBody is an optional)
        physicsBody = SKPhysicsBody(circleOfRadius: radius)
        physicsBody!.mass = 500;
        physicsBody?.categoryBitMask = BodyType.player.rawValue
        physicsBody!.affectedByGravity = false;
        physicsBody?.linearDamping = 1
        physicsBody?.angularDamping = 1
        physicsBody?.friction = 1
        physicsBody?.usesPreciseCollisionDetection = true
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
}
