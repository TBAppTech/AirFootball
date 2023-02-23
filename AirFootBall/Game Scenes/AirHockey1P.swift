import SpriteKit

class AirHockey1P: SKScene, SKPhysicsContactDelegate, BottomPlayerDelegate, BotPlayerDelegate
{
    
    let screenSize = UIScreen.main.bounds.size
    var ball : Ball?
    var ballRadius = CGFloat(0.0)
    var playerRadius = CGFloat(0.0)
    var maxBallSpeed = CGFloat(0.0)
    var centerLineWidth = CGFloat(0.0)
    var playerLosesBackground = SKSpriteNode()
    var playerWinsBackground = SKSpriteNode()
    var pauseBackground = SKSpriteNode()
    var xMark = SKSpriteNode()
    var checkMark = SKSpriteNode()
    var ballInSouthGoal = false
    var ballInNorthGoal = false
    var ballSoundControl = true
    var pauseButton = SKSpriteNode()
    var pauseButtonSprite = SKSpriteNode()
    var backToMenuButton = SKSpriteNode()
    let backToMenuButtonLabel = SKLabelNode(fontNamed: "Palatino Bold")
    let pauseTitleLabel1 = SKSpriteNode(imageNamed: "Air logo")
    let pauseTitleLabel2 = SKSpriteNode(imageNamed: "Football logo")
    let pauseLogo1 = SKLabelNode(fontNamed: "Palatino Bold")
    let pauseLogo2 = SKLabelNode(fontNamed: "Palatino Bold")
    
    var pauseTitleBackground1 = SKSpriteNode()
    var pauseTitleBackground2 = SKSpriteNode()
    var soundButton = SKSpriteNode()
    var soundButtonSprite = SKSpriteNode()
    var soundButtonOffSprite = SKSpriteNode()
    var playButtonSprite = SKSpriteNode()
    var touchedPauseButton = false
    var touchedBackToMenuButton = false
    var touchedSoundOff = false
    var southPlayer : BottomPlayer?
    var botPlayer : BotPlayer?
    var southPlayerArea = CGRect()
    var botPlayerArea = CGRect()
    var southPlayerScore = 0
    var botPlayerScore = 0
    var expectedBallXPos = CGFloat(0.0)
    var desiredBotXPosToSave = CGFloat(0.0)
    var bottomPlayerForceForCollision = CGVector()
    var botPlayerForceForCollision = CGVector()
    let botPlayerScoreText = SKLabelNode(fontNamed: "Palatino Bold")
    let southPlayerScoreText = SKLabelNode(fontNamed: "Palatino Bold")
    var whoWonGame = ""
    var topPlayerWinsRound = false
    var bottomPlayerWinsRound = false
    var gameOver = false
    var bottomTouchForCollision = false
    var northTouchForCollision = false
    var repulsionMode = false
    var botDefendSwitch = false
    var botAttackSwitch = false
    var botMirrorSwitch = false
    var botCoverPostSwitch = false
    var madeItToExpectedBallPosAtPlayerHeight = false
    var numberRounds = 3
    var pixelsInGameFrame = CGFloat(0.0)
    var recoverySpeed = CGFloat(0.0)
    var tempBallVelocity = CGVector(dx: 0, dy: 0)
    var tempBotVelocity = CGVector(dx: 0, dy: 0)
    var tempResetBallPosition = CGPoint(x: 0, y: 0)
    let playerHitBallSound = SKAction.playSoundFileNamed("ballHitsWall2.mp3", waitForCompletion: false)
    let ballHitWallSound = SKAction.playSoundFileNamed("ballHitsWall.mp3", waitForCompletion: false)
    let goalSound = SKAction.playSoundFileNamed("Goal3.mp3", waitForCompletion: false)
    let buttonSound = SKAction.playSoundFileNamed("ChangeRounds.mp3", waitForCompletion: false)
    
    
    func bottomTouchIsActive(_ bottomTouchIsActive: Bool, fromBottomPlayer bottomPlayer: BottomPlayer)
    {
        bottomTouchForCollision = bottomTouchIsActive
    }
    
    func botTouchIsActive(_ botTouchIsActive: Bool, fromBotPlayer botPlayer: BotPlayer) {
        
    }
    
    func createPlayers()
    {
        let edgeWidth = frame.width * 0.03
        let notchOffset = frame.height * 0.0625
        
        if frame.height > 800 && frame.width < 500
        {
            southPlayerArea = CGRect(x: 0 + edgeWidth, y: (frame.height * 0.00) + notchOffset, width: frame.width - (edgeWidth * 2), height: (frame.height * 0.50) - (notchOffset - centerLineWidth))
            botPlayerArea = CGRect(x: 0 + edgeWidth, y: frame.height/2 - centerLineWidth, width: frame.width - (edgeWidth * 2), height: frame.height * 0.50 - (notchOffset - centerLineWidth))
        }
        else
        {
            southPlayerArea = CGRect(x: 0 + edgeWidth, y: (frame.height * 0.00) + edgeWidth, width: frame.width - (edgeWidth * 2), height: (frame.height * 0.50) - (edgeWidth - centerLineWidth))
            botPlayerArea = CGRect(x: 0 + edgeWidth, y: frame.height/2 - centerLineWidth, width: frame.width - (edgeWidth * 2), height: frame.height * 0.50 - (edgeWidth - centerLineWidth))
        }
        
        if frame.height >= 812 && frame.height <= 900 && frame.width < 500
        {
            let southPlayerStartPoint = CGPoint(x: frame.midX, y: frame.height * 0.22)
            let botPlayerStartPoint = CGPoint(x: frame.width * 0.505, y: frame.height * 0.78)
            southPlayer = bottomPlayer(at: southPlayerStartPoint, boundary: southPlayerArea)
            botPlayer = botPlayer(at: botPlayerStartPoint, boundary: botPlayerArea)
        }
        else if frame.height == 926 && frame.width < 500
        {
            let southPlayerStartPoint = CGPoint(x: frame.midX, y: frame.height * 0.225)
            let botPlayerStartPoint = CGPoint(x: frame.width * 0.505, y: frame.height * 0.775)
            southPlayer = bottomPlayer(at: southPlayerStartPoint, boundary: southPlayerArea)
            botPlayer = botPlayer(at: botPlayerStartPoint, boundary: botPlayerArea)
        }
        else
        {
            let southPlayerStartPoint = CGPoint(x: frame.midX, y: frame.height * 0.185)
            let botPlayerStartPoint = CGPoint(x: frame.width * 0.505, y: frame.height * 0.815)
            southPlayer = bottomPlayer(at: southPlayerStartPoint, boundary: southPlayerArea)
            botPlayer = botPlayer(at: botPlayerStartPoint, boundary: botPlayerArea)
        }
        
        southPlayer?.physicsBody?.categoryBitMask = BodyType.player.rawValue
        botPlayer?.physicsBody?.categoryBitMask = BodyType.player.rawValue
        southPlayer?.physicsBody?.contactTestBitMask = 25
        botPlayer?.physicsBody?.contactTestBitMask = 75
        southPlayer?.physicsBody?.fieldBitMask = 45
        southPlayer?.physicsBody?.fieldBitMask = 50
        southPlayer?.physicsBody?.usesPreciseCollisionDetection = true
        botPlayer?.physicsBody?.usesPreciseCollisionDetection = true
        playerRadius = southPlayer!.radius
    }
    
    func bottomPlayer(at position: CGPoint, boundary:CGRect) -> BottomPlayer
    {
        let bottomPlayer = BottomPlayer(activeArea: boundary)
        bottomPlayer.position = position
        bottomPlayer.delegate = self
        
        addChild(bottomPlayer)
        return bottomPlayer;
    }
    
    func botPlayer(at position: CGPoint, boundary:CGRect) -> BotPlayer
    {
        let botPlayer = BotPlayer(activeArea: boundary)
        botPlayer.position = position
        botPlayer.delegate = self
        addChild(botPlayer)
        return botPlayer;
    }
    

    
    func createEdges()
    {
        let edgeWidth = frame.width * 0.03
        let notchOffset = frame.height * 0.0625

        let leftEdge = Wall(wallSize: CGSize(width: edgeWidth + playerRadius * 2, height: frame.height),
                            wallPosition: CGPoint(x: 0 + (edgeWidth/2) - playerRadius, y: frame.height/2),
                            sideWall: true)

        addChild(leftEdge)
        
        let rightEdge = Wall(wallSize: CGSize(width: edgeWidth + playerRadius * 2, height: frame.height),
                             wallPosition: CGPoint(x: frame.width - (edgeWidth/2) + (playerRadius), y: frame.height/2),
                             sideWall: true)
        
        addChild(rightEdge)
        let bottomRightEdge = Wall(wallSize: CGSize(width: frame.width, height: edgeWidth + playerRadius*2),
                                   wallPosition: CGPoint(x: frame.width - (edgeWidth/2) + (playerRadius), y: frame.height/2),
                                   sideWall: false)

        if frame.height > 800 && frame.width < 500{
            bottomRightEdge.size.height = notchOffset + playerRadius*2
            bottomRightEdge.position = CGPoint(x: frame.width * 0.90, y: 0 + notchOffset/2 - playerRadius)
            pixelsInGameFrame = (frame.width * frame.height) - ((frame.height * edgeWidth) * 2) - ((frame.width * notchOffset) * 2)
            recoverySpeed = pixelsInGameFrame / 1000
        }else{
            bottomRightEdge.size.height = edgeWidth + playerRadius*2
            bottomRightEdge.position = CGPoint(x: frame.width * 0.90, y: 0 + edgeWidth/2 - playerRadius)
            pixelsInGameFrame = (frame.width * frame.height) - ((frame.height * edgeWidth) * 2) - ((frame.width * edgeWidth) * 2)
            recoverySpeed = pixelsInGameFrame / 1250
            
        }

        bottomRightEdge.physicsBody?.mass = 10000000

        addChild(bottomRightEdge)
        
        let bottomLeftEdge = Wall(wallSize: CGSize(width: frame.width, height: edgeWidth + playerRadius*2),
                                  wallPosition: CGPoint(x: frame.width - (edgeWidth/2) + (playerRadius), y: frame.height/2),
                                  sideWall: false)
        
    
        if frame.height > 800 && frame.width < 500{
            bottomLeftEdge.size.height = notchOffset + playerRadius*2
            bottomLeftEdge.position = CGPoint(x: frame.width * 0.10, y: 0 + notchOffset/2 - playerRadius)
        }
        else{
            bottomLeftEdge.size.height = edgeWidth + playerRadius*2
            bottomLeftEdge.position = CGPoint(x: frame.width * 0.10, y: 0 + edgeWidth/2 - playerRadius)
        }

        bottomLeftEdge.physicsBody?.mass = 10000000

        addChild(bottomLeftEdge)
        
        let topRightEdge = Wall(wallSize: CGSize(width: frame.width, height: edgeWidth + playerRadius*2),
                                wallPosition: CGPoint(x: frame.width - (edgeWidth/2) + (playerRadius), y: frame.height/2),
                                sideWall: false)
        

        if frame.height > 800 && frame.width < 500{
            topRightEdge.size.height = notchOffset + playerRadius*2
            topRightEdge.position = CGPoint(x: frame.width * 0.90, y: frame.height - notchOffset/2 + playerRadius)
        }else{
            topRightEdge.size.height = edgeWidth + playerRadius*2
            topRightEdge.position = CGPoint(x: frame.width * 0.90, y: frame.height - edgeWidth/2 + playerRadius)
        }

        addChild(topRightEdge)
        
        let topLeftEdge = Wall(wallSize: CGSize(width: frame.width, height: edgeWidth + playerRadius*2),
                               wallPosition: CGPoint(x: frame.width - (edgeWidth/2) + (playerRadius), y: frame.height/2),
                               sideWall: false)

        if frame.height > 800 && frame.width < 500{
            topLeftEdge.size.height = notchOffset + playerRadius*2
            topLeftEdge.position = CGPoint(x: frame.width * 0.10, y: frame.height - notchOffset/2 + playerRadius)
        }else{
            topLeftEdge.size.height = edgeWidth + playerRadius*2
            topLeftEdge.position = CGPoint(x: frame.width * 0.10, y: frame.height - edgeWidth/2 + playerRadius)
        }

        addChild(topLeftEdge)
        
        let bottomGoalEdge = SKSpriteNode(imageNamed: "goalGradientBottom.png")
        if frame.height > 800 && frame.width < 500
        {
            bottomGoalEdge.scale(to: CGSize(width: frame.width * 0.60, height: notchOffset + playerRadius*2))
            bottomGoalEdge.position = CGPoint(x: frame.width * 0.5, y: 0 + notchOffset/2 - playerRadius)
        }
        else
        {
            bottomGoalEdge.scale(to: CGSize(width: frame.width * 0.60, height: edgeWidth + playerRadius*2))
            bottomGoalEdge.position = CGPoint(x: frame.width * 0.5, y: 0 + edgeWidth/2 - playerRadius)
        }
        bottomGoalEdge.zPosition = -100
        bottomGoalEdge.blendMode = .replace
        //setup physics for this edge
        bottomGoalEdge.physicsBody = SKPhysicsBody(rectangleOf: bottomGoalEdge.size)
        bottomGoalEdge.physicsBody!.isDynamic = false
        bottomGoalEdge.physicsBody?.mass = 10000000
        bottomGoalEdge.physicsBody?.categoryBitMask = 4
        bottomGoalEdge.physicsBody?.collisionBitMask = 256
        bottomGoalEdge.physicsBody?.restitution = 0.0
        bottomGoalEdge.physicsBody?.friction = 0.0
        bottomGoalEdge.physicsBody?.linearDamping = 0.0
        bottomGoalEdge.physicsBody?.angularDamping = 0.0
        addChild(bottomGoalEdge)
        
        let topGoalEdge = SKSpriteNode(imageNamed: "goalGradient.png")
        topGoalEdge.color = .green
        if frame.height > 800 && frame.width < 500
        {
            topGoalEdge.scale(to: CGSize(width: frame.width * 0.60, height: notchOffset + playerRadius*2))
            topGoalEdge.position = CGPoint(x: frame.width * 0.5, y: frame.height - notchOffset/2 + playerRadius)
        }
        else
        {
            topGoalEdge.scale(to: CGSize(width: frame.width * 0.60, height: edgeWidth + playerRadius*2))
            topGoalEdge.position = CGPoint(x: frame.width * 0.5, y: frame.height - edgeWidth/2 + playerRadius)
        }
        
        topGoalEdgeBottom = topGoalEdge.position.y - (topGoalEdge.size.height * 0.5)
        bottomGoalEdgeTop = bottomGoalEdge.position.y + (bottomGoalEdge.size.height * 0.5)
        if UIDevice.current.userInterfaceIdiom == .phone{
            topGoalEdgeBottom = topGoalEdge.position.y - (topGoalEdge.size.height * 0.5) - 25
            bottomGoalEdgeTop = bottomGoalEdge.position.y + (bottomGoalEdge.size.height * 0.5) + 25
        }else {
            topGoalEdgeBottom = (topGoalEdge.position.y - (topGoalEdge.size.height * 0.5)) - 35
            bottomGoalEdgeTop = (bottomGoalEdge.position.y + (bottomGoalEdge.size.height * 0.5)) + 35
        }
        
        topGoalEdge.zPosition = -100
        topGoalEdge.blendMode = .replace
        //setup physics for this edge
        topGoalEdge.physicsBody = SKPhysicsBody(rectangleOf: topGoalEdge.size)
        topGoalEdge.physicsBody!.isDynamic = false
        topGoalEdge.physicsBody?.mass = 10000000
        topGoalEdge.physicsBody?.categoryBitMask = 4
        topGoalEdge.physicsBody?.collisionBitMask = 256
        topGoalEdge.physicsBody?.restitution = 0.0
        topGoalEdge.physicsBody?.friction = 0.0
        topGoalEdge.physicsBody?.linearDamping = 0.0
        topGoalEdge.physicsBody?.angularDamping = 0.0
        addChild(topGoalEdge)
        var background = SKSpriteNode(imageNamed: "BG_1")
        if let field = UserDefaults.standard.value(forKey: "field"){
            background = SKSpriteNode(imageNamed: "BG_\(field)")
        }
        background.blendMode = .replace
        background.position = CGPoint(x: screenWidth/2, y: screenHeight/2)
        background.scale(to: CGSize(width: screenWidth, height: screenHeight))
        background.colorBlendFactor = 0
        background.zPosition = -110
        addChild(background)
    }
    
    
    
    func createUICircles()
    {
        addChild(GoalSemiCircle(topGoal: true))
        addChild(GoalSemiCircle(topGoal: false))
        addChild(CenterCircle(AirHockey: true))
    }
    
    func createPauseAndPlayButton()
    {
        pauseButton = SKSpriteNode(imageNamed: "pauseButtonBackground.png")
        pauseButton.position = CGPoint(x: frame.width * 0.90, y: frame.height * 0.50)
        pauseButton.scale(to: CGSize(width: frame.width * 0.09, height: frame.width * 0.09))
        pauseButton.colorBlendFactor = 0.40
        pauseButton.zPosition = 106
        addChild(pauseButton)
        
        playButtonSprite = SKSpriteNode(imageNamed: "playButtonSprite.png")
        playButtonSprite.position = CGPoint(x: frame.width * 0.90, y: frame.height * 0.50)
        playButtonSprite.scale(to: CGSize(width: frame.width * 0.08, height: frame.width * 0.08))
        playButtonSprite.colorBlendFactor = 0
        playButtonSprite.zPosition = 107
        playButtonSprite.isHidden = true
        addChild(playButtonSprite)
        
        pauseButtonSprite = SKSpriteNode(imageNamed: "pauseButtonVertical.png")
        pauseButtonSprite.position = CGPoint(x: frame.width * 0.90, y: frame.height * 0.50)
        pauseButtonSprite.scale(to: CGSize(width: frame.width * 0.08, height: frame.width * 0.08))
        pauseButtonSprite.colorBlendFactor = 0
        pauseButtonSprite.zPosition = 107
        addChild(pauseButtonSprite)
    }
    
    func clearPauseButton()
    {
        pauseBackground.isHidden = true
        pauseButton.isHidden = true
        pauseButtonSprite.isHidden = true
        playButtonSprite.isHidden = true
    }
    
    func resetPauseButton()
    {
        pauseBackground.isHidden = false
        pauseButton.isHidden = false
        if GameIsPaused != true
        {
            pauseButtonSprite.isHidden = false
        }
        else
        {
            playButtonSprite.isHidden = true
        }
    }
    
    func createBackToMenuButton()
    {
        backToMenuButton = SKSpriteNode(imageNamed: "button")
        backToMenuButton.position = CGPoint(x: frame.width/2, y: frame.height * 0.20)
        backToMenuButton.scale(to: CGSize(width: frame.width * 0.60, height: frame.height * 0.1))
        backToMenuButton.isHidden = true
        backToMenuButton.zPosition = 125
        addChild(backToMenuButton)
        
        // set size, color, position and text of the tapStartLabel
      
        backToMenuButtonLabel.horizontalAlignmentMode = .center
        backToMenuButtonLabel.verticalAlignmentMode = .center
        backToMenuButtonLabel.position = CGPoint(x: backToMenuButton.position.x, y: backToMenuButton.position.y)
        backToMenuButtonLabel.zPosition = 126
        backToMenuButtonLabel.text = "Back to Menu"
        backToMenuButtonLabel.isHidden = true
        backToMenuButtonLabel.fontColor = .black
        backToMenuButtonLabel.fontName = "Palatino Bold"
        backToMenuButtonLabel.fontSize = frame.width/17.5
        addChild(backToMenuButtonLabel)
    }
    
    func createSoundButton()
    {
        soundButton = SKSpriteNode(imageNamed: "SquareGreenButton")
        soundButton.position = CGPoint(x: frame.width * 0.50, y: frame.height * 0.35)
        soundButton.zPosition = 125
        if frame.height > 800 && frame.width < 600{
            soundButton.scale(to: CGSize(width: frame.width * 0.2, height: frame.width * 0.2))
        }else {
            soundButton.scale(to: CGSize(width: frame.width * 0.15, height: frame.width * 0.15))
        }
        soundButton.colorBlendFactor = 0
        soundButton.isHidden = true
        addChild(soundButton)
        
        soundButtonSprite = SKSpriteNode(imageNamed: "soundOn.png")
        soundButtonSprite.position = CGPoint(x: soundButton.position.x, y: soundButton.position.y)
        soundButtonSprite.zPosition = 126
        if frame.height > 800 && frame.width < 600
        {
            soundButtonSprite.scale(to: CGSize(width: frame.width * 0.1125, height: frame.width * 0.1125))
        }
        else
        {
            soundButtonSprite.scale(to: CGSize(width: frame.width * 0.09, height: frame.width * 0.09))
        }
        soundButtonSprite.colorBlendFactor = 0
        soundButtonSprite.isHidden = true
        addChild(soundButtonSprite)
        
        soundButtonOffSprite = SKSpriteNode(imageNamed: "soundOff.png")
        soundButtonOffSprite.position = CGPoint(x: soundButton.position.x, y: soundButton.position.y)
        soundButtonOffSprite.zPosition = 126
        if frame.height > 800 && frame.width < 600
        {
            soundButtonOffSprite.scale(to: CGSize(width: frame.width * 0.1125, height: frame.width * 0.1125))
        }
        else
        {
            soundButtonOffSprite.scale(to: CGSize(width: frame.width * 0.09, height: frame.width * 0.09))
        }
        soundButtonOffSprite.colorBlendFactor = 0
        soundButtonOffSprite.isHidden = true
        addChild(soundButtonOffSprite)
    }
    
    func showPauseMenuButton()
    {
        backToMenuButton.isHidden = false
        backToMenuButtonLabel.isHidden = false
        soundButton.isHidden = false
        pauseTitleBackground1.isHidden = false
        pauseTitleBackground2.isHidden = false
        pauseTitleLabel1.isHidden = false
        pauseTitleLabel2.isHidden = false
        
        if UserDefaults.standard.string(forKey: "Sound") == "On"
        {
            soundButtonSprite.isHidden = false
            soundButtonOffSprite.isHidden = true
        }
        else if UserDefaults.standard.string(forKey: "Sound") == "Off"
        {
            soundButtonSprite.isHidden = true
            soundButtonOffSprite.isHidden = false
        }
        else
        {
            let save = UserDefaults.standard
            save.set("On", forKey: "Sound")
            save.synchronize()
            soundButtonSprite.isHidden = false
            soundButtonOffSprite.isHidden = true
        }
    }
    
    func hidePauseMenuButtons()
    {
        backToMenuButton.isHidden = true
        backToMenuButtonLabel.isHidden = true
        soundButton.isHidden = true
        soundButtonSprite.isHidden = true
        soundButtonOffSprite.isHidden = true
        pauseTitleBackground1.isHidden = true
        pauseTitleBackground2.isHidden = true
        pauseTitleLabel1.isHidden = true
        pauseTitleLabel2.isHidden = true
    }
    

    func getMaxBallSpeed()
    {
        if frame.width > 700
        {
            maxBallSpeed = (frame.height * frame.width) / 370
        }
        else if frame.width < 700 && frame.height > 800
        {
            maxBallSpeed = (frame.height * frame.width) / 222.5
        }
        else
        {
            maxBallSpeed = (frame.height * frame.width) / 185
        }
    }
    
    
    func createPauseBackground()
    {
        pauseBackground = SKSpriteNode(imageNamed: "background")
        pauseBackground.scale(to: CGSize(width: frame.width, height: frame.height))
        pauseBackground.zPosition = -10
        pauseBackground.colorBlendFactor = 0.05
        pauseBackground.position = CGPoint(x: -1000, y: -1000)
        addChild(pauseBackground)
    }
    
    func createPauseGameTitle(){
        // set size, color, position and text of the tapStartLabel
        if frame.width < 600 && frame.height > 800
        {
            //pauseTitleLabel1.fontSize = frame.width/6.5
            pauseTitleLabel1.position = CGPoint(x: frame.width * 0.50, y: frame.height * 0.79)
            pauseTitleBackground1.position = CGPoint(x: frame.width/2, y: frame.height * 0.79)
        }
        else
        {
            //pauseTitleLabel1.fontSize = frame.width/7.5
            pauseTitleLabel1.position = CGPoint(x: frame.width * 0.49, y: frame.height * 0.80)
            pauseTitleBackground1.position = CGPoint(x: frame.width/2, y: frame.height * 0.80)
        }
        pauseTitleLabel1.isHidden = true
        pauseTitleLabel1.scale(to: CGSize(width: frame.width * 0.55, height: frame.height * 0.095))
        pauseTitleLabel1.zPosition = 106
        addChild(pauseTitleLabel1)
        
        // set size, color, position and text of the tapStartLabel
        if frame.width < 600 && frame.height > 800{
            //pauseTitleLabel2.fontSize = frame.width/6.5
            pauseTitleLabel2.position = CGPoint(x: frame.width/2, y: frame.height * 0.68)
            pauseTitleBackground2.position = CGPoint(x: frame.width/2, y: frame.height * 0.68)
        }else{
           // pauseTitleLabel2.fontSize = frame.width/7.5
            pauseTitleLabel2.position = CGPoint(x: frame.width/2, y: frame.height * 0.67)
            pauseTitleBackground2.position = CGPoint(x: frame.width/2, y: frame.height * 0.67)
        }

        pauseTitleLabel2.isHidden = true
        pauseTitleLabel2.scale(to: CGSize(width: frame.width * 0.55, height: frame.height * 0.095))
        pauseTitleLabel2.zPosition = 106
        addChild(pauseTitleLabel2)
    }
    func updatePlayerLoseWinBackgroundsBottomPlayerWinsRound()
    {
//        playerLosesBackground.position = CGPoint(x: frame.width/2, y: frame.height * (3/4))
//        playerWinsBackground.position = CGPoint(x: frame.width/2, y: frame.height/4)
//        checkMark.position = CGPoint(x: frame.width/2, y: frame.height * 0.30)
//        xMark.position = CGPoint(x: frame.width/2, y: frame.height * 0.70)
//        checkMark.zRotation = 0
        pulseAndRotateLabel()
        //clearPauseButton()
    }
    
    func updatePlayerLoseWinBackgroundsTopPlayerWinsRound()
    {
//        playerWinsBackground.position = CGPoint(x: frame.width/2, y: frame.height * (3/4))
//        playerLosesBackground.position = CGPoint(x: frame.width/2, y: frame.height/4)
//        xMark.position = CGPoint(x: frame.width/2, y: frame.height * 0.30)
//        checkMark.position = CGPoint(x: frame.width/2, y: frame.height * 0.70)
//        checkMark.zRotation = .pi

        pulseAndRotateLabel()
       // clearPauseButton()
    }
    
    func pulseAndRotateLabel() {
        // Создаем лейбл
        let label = SKLabelNode(text: "Goal")
        label.fontColor = .white
        label.fontSize = 50
        label.fontName = "Palatino Bold"
        // Устанавливаем начальное положение
        label.position = CGPoint(x: frame.midX, y: frame.midY)
        
        // Поворачиваем на 90 градусов
        label.zRotation = -.pi/2
        
        // Увеличиваем размер в два раза
        label.setScale(2)
        
        // Добавляем лейбл на сцену
        addChild(label)
        
        // Создаем действие для пульсации и вращения
        let pulseAndRotateAction = SKAction.group([
            SKAction.sequence([
                SKAction.scale(to: 1.5, duration: 1.0),
                SKAction.scale(to: 1.0, duration: 1.0)
            ]),
            SKAction.rotate(byAngle: .pi*2, duration: 2.0)
        ])
        
        // Создаем последовательность действий для анимации
        let sequenceAction = SKAction.sequence([
            pulseAndRotateAction,
            SKAction.fadeOut(withDuration: 0.3),
            SKAction.removeFromParent()
        ])
        
        // Запускаем анимацию
        label.run(sequenceAction)
    }


    
    func updatePauseBackground()
    {
        pauseBackground.position = CGPoint(x: frame.width/2, y: frame.height/2)
        pauseBackground.zPosition = 105
    }
    
    func resetPlayerLoseWinBackground()
    {
        playerWinsBackground.position = CGPoint(x: -1000, y: -1000)
        playerLosesBackground.position = CGPoint(x: -1000, y: -1000)
        xMark.position = CGPoint(x: -1000, y: -1000)
        checkMark.position = CGPoint(x: -1000, y: -1000)
        resetPauseButton()
    }
    
    func resetPauseBackground()
    {
        pauseBackground.position = CGPoint(x: -1000, y: -1000)
    }
    
    
    
    override func didMove(to view: SKView)
    {
        GameIsPaused = false
        
        self.physicsWorld.contactDelegate = self
        backgroundColor = SKColor.systemTeal
        
        if UserDefaults.standard.integer(forKey: "Rounds") > 0
        {
            numberRounds = UserDefaults.standard.integer(forKey: "Rounds")
        }
        else
        {
            numberRounds = 3
            UserDefaults.standard.set(3, forKey: "Rounds")
            UserDefaults.standard.synchronize()
        }
        
        createPlayers()
        createEdges()
        drawCenterLine()
        getMaxBallSpeed()
        createUICircles()
        createPauseAndPlayButton()
        createBall()
        //createPlayerLoseWinBackgrounds()
        createPauseBackground()
        createPauseGameTitle()
        createBackToMenuButton()
        createSoundButton()
        createBotPlayerScore()
        createSouthPlayerScore()
       // createPlayerLoseWinBackgrounds()
        
            repulsionMode = true
        
    }
    
    func drawCenterLine()
    {
        let centerLine = CenterLine()
        addChild(centerLine)
        centerLineWidth = centerLine.size.height/2
    }
    
    func createBall()
    {
        ball = Ball(multiBall: false)
        ball?.physicsBody?.collisionBitMask = 1 | 2 | 128
        addChild(ball!)
    }
    
    func clearBall()
    {
        ball!.position = CGPoint(x: -200, y: -200)
        ball!.physicsBody!.velocity = CGVector(dx: 0, dy: 0)
    }
    
    func clearPlayer()
    {
        southPlayer?.isHidden = true
        botPlayer?.isHidden = true
    }
    
    func resetPlayer()
    {
        
        if frame.height >= 812  && frame.height <= 900 && frame.width < 500
        {
            southPlayer?.position = CGPoint(x: frame.midX, y: frame.height * 0.22)
            botPlayer?.position = CGPoint(x: frame.width * 0.501, y: frame.height * 0.78)
        }
        else if frame.height == 926 && frame.width < 500
        {
            southPlayer?.position = CGPoint(x: frame.midX, y: frame.height * 0.225)
            botPlayer?.position = CGPoint(x: frame.width * 0.501, y: frame.height * 0.775)
        }
        else
        {
            southPlayer?.position = CGPoint(x: frame.midX, y: frame.height * 0.185)
            botPlayer?.position = CGPoint(x: frame.width * 0.501, y: frame.height * 0.815)
        }
        southPlayer?.isHidden = false
        botPlayer?.isHidden = false
    }
    
    func pausePhysics()
    {
        tempBallVelocity = ball!.physicsBody!.velocity
        ball?.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        
        tempBotVelocity = botPlayer!.physicsBody!.velocity
        botPlayer?.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
    }
    
    func resumePhysics()
    {
        ball?.physicsBody?.velocity = tempBallVelocity
        tempBallVelocity = CGVector(dx: 0, dy: 0)
        
        botPlayer?.physicsBody?.velocity = tempBotVelocity
        tempBotVelocity = CGVector(dx: 0, dy: 0)
    }
    
    func isOffScreen(node: SKSpriteNode) -> Bool
    {
        return !frame.contains(node.position)
    }
    
    func didBegin(_ contact: SKPhysicsContact)
    {
        if (contact.bodyA.categoryBitMask == BodyType.ball.rawValue && contact.bodyB.categoryBitMask == BodyType.player.rawValue) && (contact.bodyA.contactTestBitMask == 25 || contact.bodyB.contactTestBitMask == 25) && bottomTouchForCollision == true && ((southPlayer!.position.y < (frame.height * 0.5) - playerRadius) || (ball!.position.y <= southPlayer!.position.y))
        {
            let vmallet = CGVector(dx: CGFloat(UserDefaults.standard.float(forKey: "BottomForceDX")), dy: CGFloat(UserDefaults.standard.float(forKey: "BottomForceDY")))
            let vball = CGVector(dx: 0, dy: 0)
            let vrelativedx = vball.dx - vmallet.dx
            let vrelativedy = vball.dy - vmallet.dy
            let vrelative = CGVector(dx: vrelativedx, dy: vrelativedy)
            let c = (vrelative.dx * contact.contactNormal.dx) + (vrelative.dy * contact.contactNormal.dy)
            let vperpendicular = CGVector(dx: contact.contactNormal.dx * c, dy: contact.contactNormal.dy * c)
            let vtangential = CGVector(dx: vrelative.dx - vperpendicular.dx, dy: vrelative.dy - vperpendicular.dy)
            // vtangential is unchanged in the collision, vperpendicular reflects
            let newvrelative = CGVector(dx: vtangential.dx - vperpendicular.dx, dy: vtangential.dy - vperpendicular.dy)
            let newvball = CGVector(dx: newvrelative.dx + vmallet.dx, dy: newvrelative.dy + vmallet.dy)
            
            ball!.physicsBody!.applyImpulse(newvball)
            
            if ballSoundControl == true && topPlayerWinsRound == false && bottomPlayerWinsRound == false
            {
                ballSoundControl = false
                if UserDefaults.standard.string(forKey: "Sound") != "Off" {run(playerHitBallSound)}
                Timer.scheduledTimer(withTimeInterval: 0.05, repeats: false, block: { timer in
                    self.ballSoundControl = true
                })
            }
            madeItToExpectedBallPosAtPlayerHeight = false
            botCoverPostSwitch = false
        }
        if (contact.bodyA.categoryBitMask == BodyType.ball.rawValue && contact.bodyB.categoryBitMask == BodyType.player.rawValue) && (contact.bodyA.contactTestBitMask == 25 || contact.bodyB.contactTestBitMask == 25) && bottomTouchForCollision == false && ((southPlayer!.position.y < (frame.height * 0.5) - playerRadius) || (ball!.position.y <= southPlayer!.position.y))
        {
            if ballSoundControl == true && topPlayerWinsRound == false && bottomPlayerWinsRound == false
            {
                ballSoundControl = false
                if UserDefaults.standard.string(forKey: "Sound") != "Off" {run(playerHitBallSound)}
                Timer.scheduledTimer(withTimeInterval: 0.05, repeats: false, block: { timer in
                    self.ballSoundControl = true
                })
            }
            madeItToExpectedBallPosAtPlayerHeight = false
            botCoverPostSwitch = false
            
        }
        
        if (contact.bodyA.categoryBitMask == BodyType.player.rawValue && contact.bodyB.categoryBitMask == BodyType.ball.rawValue) && (contact.bodyA.contactTestBitMask == 25 || contact.bodyB.contactTestBitMask == 25) && bottomTouchForCollision == true && ((southPlayer!.position.y < (frame.height * 0.5) - playerRadius) || (ball!.position.y <= southPlayer!.position.y))
        {
            let vmallet = CGVector(dx: CGFloat(UserDefaults.standard.float(forKey: "BottomForceDX")), dy: CGFloat(UserDefaults.standard.float(forKey: "BottomForceDY")))
            let vball = CGVector(dx: 0, dy: 0)
            let vrelativedx = vball.dx - vmallet.dx
            let vrelativedy = vball.dy - vmallet.dy
            let vrelative = CGVector(dx: vrelativedx, dy: vrelativedy)
            let c = (vrelative.dx * contact.contactNormal.dx) + (vrelative.dy * contact.contactNormal.dy)
            let vperpendicular = CGVector(dx: contact.contactNormal.dx * c, dy: contact.contactNormal.dy * c)
            let vtangential = CGVector(dx: vrelative.dx - vperpendicular.dx, dy: vrelative.dy - vperpendicular.dy)
            // vtangential is unchanged in the collision, vperpendicular reflects
            let newvrelative = CGVector(dx: vtangential.dx - vperpendicular.dx, dy: vtangential.dy - vperpendicular.dy)
            let newvball = CGVector(dx: newvrelative.dx + vmallet.dx, dy: newvrelative.dy + vmallet.dy)
            // set ball velocity to newvball
            ball!.physicsBody!.applyImpulse(newvball)
            
            if ballSoundControl == true && topPlayerWinsRound == false && bottomPlayerWinsRound == false
            {
                ballSoundControl = false
                if UserDefaults.standard.string(forKey: "Sound") != "Off" {run(playerHitBallSound)}
                Timer.scheduledTimer(withTimeInterval: 0.05, repeats: false, block: { timer in
                    self.ballSoundControl = true
                })
            }
            madeItToExpectedBallPosAtPlayerHeight = false
            botCoverPostSwitch = false
            
        }
        
        if (contact.bodyA.categoryBitMask == BodyType.player.rawValue && contact.bodyB.categoryBitMask == BodyType.ball.rawValue) && (contact.bodyA.contactTestBitMask == 25 || contact.bodyB.contactTestBitMask == 25) && bottomTouchForCollision == false && ((southPlayer!.position.y < (frame.height * 0.5) - playerRadius) || (ball!.position.y <= southPlayer!.position.y))
        {
            if ballSoundControl == true && topPlayerWinsRound == false && bottomPlayerWinsRound == false
            {
                ballSoundControl = false
                if UserDefaults.standard.string(forKey: "Sound") != "Off" {run(playerHitBallSound)}
                Timer.scheduledTimer(withTimeInterval: 0.05, repeats: false, block: { timer in
                    self.ballSoundControl = true
                })
            }
            madeItToExpectedBallPosAtPlayerHeight = false
            botCoverPostSwitch = false
        }
        
        if (contact.bodyA.categoryBitMask == BodyType.ball.rawValue && contact.bodyB.categoryBitMask == BodyType.player.rawValue) && (contact.bodyA.contactTestBitMask == 75 || contact.bodyB.contactTestBitMask == 75) && northTouchForCollision == true && ((botPlayer!.position.y > (frame.height * 0.5) + playerRadius) || (ball!.position.y >= botPlayer!.position.y))
        {
            let vmallet = CGVector(dx: CGFloat(UserDefaults.standard.float(forKey: "NorthForceDX")), dy: CGFloat(UserDefaults.standard.float(forKey: "NorthForceDY")))
            let vball = CGVector(dx: 0, dy: 0)
            let vrelativedx = vball.dx - vmallet.dx
            let vrelativedy = vball.dy - vmallet.dy
            let vrelative = CGVector(dx: vrelativedx, dy: vrelativedy)
            let c = (vrelative.dx * contact.contactNormal.dx) + (vrelative.dy * contact.contactNormal.dy)
            let vperpendicular = CGVector(dx: contact.contactNormal.dx * c, dy: contact.contactNormal.dy * c)
            let vtangential = CGVector(dx: vrelative.dx - vperpendicular.dx, dy: vrelative.dy - vperpendicular.dy)
            // vtangential is unchanged in the collision, vperpendicular reflects
            let newvrelative = CGVector(dx: vtangential.dx - vperpendicular.dx, dy: vtangential.dy - vperpendicular.dy)
            let newvball = CGVector(dx: newvrelative.dx + vmallet.dx, dy: newvrelative.dy + vmallet.dy)
            // set ball velocity to newvball
            ball!.physicsBody!.applyImpulse(newvball)
            madeItToExpectedBallPosAtPlayerHeight = false
            botCoverPostSwitch = false
            
            if ballSoundControl == true && topPlayerWinsRound == false && bottomPlayerWinsRound == false
            {
                ballSoundControl = false
                if UserDefaults.standard.string(forKey: "Sound") != "Off" {run(playerHitBallSound)}
                Timer.scheduledTimer(withTimeInterval: 0.05, repeats: false, block: { timer in
                    self.ballSoundControl = true
                })
            }
        }
        if (contact.bodyA.categoryBitMask == BodyType.ball.rawValue && contact.bodyB.categoryBitMask == BodyType.player.rawValue) && (contact.bodyA.contactTestBitMask == 75 || contact.bodyB.contactTestBitMask == 75) && northTouchForCollision == false && (botPlayer!.position.y > ((frame.height * 0.5) + playerRadius))
        {
            if ballSoundControl == true && topPlayerWinsRound == false && bottomPlayerWinsRound == false
            {
                ballSoundControl = false
                if UserDefaults.standard.string(forKey: "Sound") != "Off" {run(playerHitBallSound)}
                Timer.scheduledTimer(withTimeInterval: 0.05, repeats: false, block: { timer in
                    self.ballSoundControl = true
                })
            }
            madeItToExpectedBallPosAtPlayerHeight = false
            botCoverPostSwitch = false
        }
        
        if (contact.bodyA.categoryBitMask == BodyType.player.rawValue && contact.bodyB.categoryBitMask == BodyType.ball.rawValue) && (contact.bodyA.contactTestBitMask == 75 || contact.bodyB.contactTestBitMask == 75) && northTouchForCollision == true && (botPlayer!.position.y > ((frame.height * 0.5) + playerRadius))
        {
            let vmallet = CGVector(dx: CGFloat(UserDefaults.standard.float(forKey: "NorthForceDX")), dy: CGFloat(UserDefaults.standard.float(forKey: "NorthForceDY")))
            let vball = CGVector(dx: 0, dy: 0)
            let vrelativedx = vball.dx - vmallet.dx
            let vrelativedy = vball.dy - vmallet.dy
            let vrelative = CGVector(dx: vrelativedx, dy: vrelativedy)
            let c = (vrelative.dx * contact.contactNormal.dx) + (vrelative.dy * contact.contactNormal.dy)
            let vperpendicular = CGVector(dx: contact.contactNormal.dx * c, dy: contact.contactNormal.dy * c)
            let vtangential = CGVector(dx: vrelative.dx - vperpendicular.dx, dy: vrelative.dy - vperpendicular.dy)
            // vtangential is unchanged in the collision, vperpendicular reflects
            let newvrelative = CGVector(dx: vtangential.dx - vperpendicular.dx, dy: vtangential.dy - vperpendicular.dy)
            let newvball = CGVector(dx: newvrelative.dx + vmallet.dx, dy: newvrelative.dy + vmallet.dy)
            // set ball velocity to newvball
            ball!.physicsBody!.applyImpulse(newvball)
            madeItToExpectedBallPosAtPlayerHeight = false
            botCoverPostSwitch = false
            
            if ballSoundControl == true && topPlayerWinsRound == false && bottomPlayerWinsRound == false
            {
                ballSoundControl = false
                if UserDefaults.standard.string(forKey: "Sound") != "Off" {run(playerHitBallSound)}
                Timer.scheduledTimer(withTimeInterval: 0.05, repeats: false, block: { timer in
                    self.ballSoundControl = true
                })
            }
        }
        if (contact.bodyA.categoryBitMask == BodyType.player.rawValue && contact.bodyB.categoryBitMask == BodyType.ball.rawValue) && (contact.bodyA.contactTestBitMask == 75 || contact.bodyB.contactTestBitMask == 75) && northTouchForCollision == false && (botPlayer!.position.y > ((frame.height * 0.5) + playerRadius))
        {
            if ballSoundControl == true && topPlayerWinsRound == false && bottomPlayerWinsRound == false
            {
                ballSoundControl = false
                if UserDefaults.standard.string(forKey: "Sound") != "Off" {run(playerHitBallSound)}
                Timer.scheduledTimer(withTimeInterval: 0.05, repeats: false, block: { timer in
                    self.ballSoundControl = true
                })
            }
            madeItToExpectedBallPosAtPlayerHeight = false
            botCoverPostSwitch = false
            
        }
        
        // Ball Collision detect with wall to prevent sticking (SpriteKit Issue)
        if (contact.bodyA.categoryBitMask == BodyType.ball.rawValue && contact.bodyB.categoryBitMask == BodyType.sideWalls.rawValue)
        {
            let strength = 1.0 * ((ball?.position.x)! < frame.width / 2 ? 1 : -1)
            let body = ball?.physicsBody
            body!.applyImpulse(CGVector(dx: strength, dy: 0))
            if UserDefaults.standard.string(forKey: "Sound") != "Off" {run(ballHitWallSound)}
        }
        else if (contact.bodyA.categoryBitMask == BodyType.sideWalls.rawValue && contact.bodyB.categoryBitMask == BodyType.ball.rawValue)
        {
            let strength = 1.0 * ((ball?.position.x)! < frame.width / 2 ? 1 : -1)
            let body = ball?.physicsBody
            body!.applyImpulse(CGVector(dx: strength, dy: 0))
            if UserDefaults.standard.string(forKey: "Sound") != "Off" {run(ballHitWallSound)}
        }
        
        if (contact.bodyA.categoryBitMask == BodyType.ball.rawValue && contact.bodyB.categoryBitMask == BodyType.topBottomWalls.rawValue)
        {
            let strength = 1.0 * ((ball?.position.y)! < frame.height / 2 ? 1 : -1)
            let body = ball?.physicsBody
            body!.applyImpulse(CGVector(dx: 0, dy: strength))
            if UserDefaults.standard.string(forKey: "Sound") != "Off" {run(ballHitWallSound)}
        }
        else if (contact.bodyA.categoryBitMask == BodyType.topBottomWalls.rawValue && contact.bodyB.categoryBitMask == BodyType.ball.rawValue)
        {
            let strength = 1.0 * ((ball?.position.y)! < frame.height / 2 ? 1 : -1)
            let body = ball?.physicsBody
            body!.applyImpulse(CGVector(dx: 0, dy: strength))
            if UserDefaults.standard.string(forKey: "Sound") != "Off" {run(ballHitWallSound)}
        }
    }
    
    func createBotPlayerScore()
    {
        botPlayerScoreText.text = String(botPlayerScore)
        botPlayerScoreText.zRotation =  .pi / 2
        
        if frame.width > 700
        {
            botPlayerScoreText.position = CGPoint(x: frame.width/11, y: frame.height/2 + frame.height/30)
            botPlayerScoreText.fontSize = 60
        }
        else
        {
            botPlayerScoreText.position = CGPoint(x: frame.width/9, y: frame.height/2 + frame.height/30)
            botPlayerScoreText.fontSize = 42
        }
        addChild(botPlayerScoreText)
        addChild(southPlayerScoreText)
    }
    func updateBotPlayerScore()
    {
        botPlayerScoreText.text = String(botPlayerScore)
    }
    
    func createSouthPlayerScore()
    {
        southPlayerScoreText.text = String(southPlayerScore)
        southPlayerScoreText.zRotation = .pi / 2
        
        if frame.width > 700
        {
            southPlayerScoreText.position = CGPoint(x: frame.width/11, y: frame.height/2 - frame.height/30)
            southPlayerScoreText.fontSize = 60
        }
        else
        {
            southPlayerScoreText.position = CGPoint(x: frame.width/9, y: frame.height/2 - frame.height/30)
            southPlayerScoreText.fontSize = 42
        }
        
        
    }
    
    func updateSouthPlayerScore()
    {
        southPlayerScoreText.text = String(southPlayerScore)
    }
    
    
    
    
    func gameOverIsTrue(){
        var currentGold = 0
        if let gold = UserDefaults.standard.integer(forKey: "gold") as? Int{
            currentGold = gold
        }
        
        if southPlayerScore < botPlayerScore{
            whoWonGame = "Enemy Bot"
            if currentGold > 0 {
                currentGold -= 50
                UserDefaults.standard.set(currentGold, forKey: "gold")
            }
        }else{
            whoWonGame = "Player"
            currentGold += 100
            UserDefaults.standard.set(currentGold, forKey: "gold")
        }
        let fb = FirebaseManager()
        fb.saveCoins(currentGold)
        
        UserDefaults.standard.set(whoWonGame, forKey: "whoWonGame")
        UserDefaults.standard.set(true, forKey: "rating")
        
        gameOverScene()
    }
    
    func scoring(){
        if ballInSouthGoal == true{
            ball?.isHidden = true
            ball!.position = CGPoint(x: frame.width * 2, y: -frame.height)
            if UserDefaults.standard.string(forKey: "Sound") == "On" {run(goalSound)}
            else if UserDefaults.standard.string(forKey: "Sound") == "Off" {}
            else{run(goalSound)}
            ballInSouthGoal = false
            botPlayerScore += 1
            ball?.physicsBody?.isDynamic = false
            updatePlayerLoseWinBackgroundsTopPlayerWinsRound()
            updateBotPlayerScore()
            clearPauseButton()
            clearPlayer()
            topPlayerWinsRound = true
            if (botPlayerScore) < numberRounds{
                Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { timer in
                    self.ball!.resetBallBottomPlayerBallStart()
                    self.ball?.isHidden = false
                    self.resetPauseButton()
                    self.resetPlayer()
                    self.resetPlayerLoseWinBackground()
                    self.ball?.physicsBody?.isDynamic = true
                    self.topPlayerWinsRound = false
                })
            }
        }
        
        else if ballInNorthGoal == true{
            ball?.isHidden = true
            ball!.position = CGPoint(x: frame.width * 2, y: -frame.height)
            if UserDefaults.standard.string(forKey: "Sound") == "On" {run(goalSound)}
            else if UserDefaults.standard.string(forKey: "Sound") == "Off" {}
            else{run(goalSound)}
            ballInNorthGoal = false
            ball?.physicsBody?.isDynamic = false
            updatePlayerLoseWinBackgroundsBottomPlayerWinsRound()
            southPlayerScore += 1
            clearPauseButton()
            updateSouthPlayerScore()
            bottomPlayerWinsRound = true
            clearPlayer()
            if (southPlayerScore) < numberRounds{
                Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { timer in
                    self.ball!.resetBallTopPlayerBallStart()
                    self.ball?.isHidden = false
                    self.resetPauseButton()
                    self.resetPlayer()
                    self.resetPlayerLoseWinBackground()
                    self.ball?.physicsBody?.isDynamic = true
                    self.bottomPlayerWinsRound = false
                })
            }
        }
        
        if ((southPlayerScore >= numberRounds) || botPlayerScore >= numberRounds) && (gameOver == false){
            gameOver = true
            clearPauseButton()
            gameOverIsTrue()

        }
    }
    
    func gameOverScene(){
        let scene = GameOverScene()
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
    
    override func update(_ currentTime: TimeInterval)
    {
  
        if botPlayer!.position.y > frame.height * 0.50 && GameIsPaused == false
        {
            botDefend()
            botMirror()
            botAttack()
        }
        else
        {
            botPlayer?.physicsBody?.velocity.dy = 0
            botPlayer?.physicsBody?.velocity.dy += 1
        }
        
        if ball!.position.y > (frame.height * 0.50) + ballRadius + centerLineWidth
        {
            southPlayer?.physicsBody?.categoryBitMask = 600
        }
        else
        {
            southPlayer?.physicsBody?.categoryBitMask = BodyType.player.rawValue
        }
        if ball!.position.y < (frame.height * 0.50) - ballRadius - centerLineWidth
        {
            botPlayer?.physicsBody?.categoryBitMask = 601
        }
        else
        {
            botPlayer?.physicsBody?.categoryBitMask = BodyType.player.rawValue
        }
        
        if ball!.physicsBody!.velocity.dy < 0
        {
            madeItToExpectedBallPosAtPlayerHeight = false
            botCoverPostSwitch = false
        }
        if bottomTouchForCollision == false
        {
            southPlayer?.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        }
        
        
        if (ball!.position.x <= frame.width * 0.2 || ball!.position.x >= frame.width * 0.8) && isOffScreen(node: ball!) && (bottomPlayerWinsRound != true && topPlayerWinsRound != true)
        {
            ball?.position = tempResetBallPosition
        }
        else
        {
            tempResetBallPosition = ball!.position
        }
        
        if GameIsPaused == true
        {
            ball?.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        }
        
        if topGoalEdgeBottom != 0 && bottomGoalEdgeTop != 0
        {
            if (((ball!.position.x > frame.width * 0.2) && (ball!.position.x < frame.width * 0.8)) && ball!.position.y > topGoalEdgeBottom)
            {
                ballInNorthGoal = true
            }
            
            if (((ball!.position.x > frame.width * 0.2) && (ball!.position.x < frame.width * 0.8)) && ball!.position.y < bottomGoalEdgeTop)
            {
                ballInSouthGoal = true
            }
        }
        else
        {
            if frame.height > 800 && frame.width < 500
            {
                if (((ball!.position.x > frame.width * 0.2) && (ball!.position.x < frame.width * 0.8)) && ball!.position.y > frame.height * 0.93)
                {
                    ballInNorthGoal = true
                }
            }
            else
            {
                if (((ball!.position.x > frame.width * 0.2) && (ball!.position.x < frame.width * 0.8)) && ball!.position.y > frame.height)
                {
                    ballInNorthGoal = true
                }
            }
            
            if frame.height > 800 && frame.width < 500
            {
                if (((ball!.position.x > frame.width * 0.2) && (ball!.position.x < frame.width * 0.8)) && ball!.position.y < frame.height * 0.045)
                {
                    ballInSouthGoal = true
                }
            }
            else
            {
                if (((ball!.position.x > frame.width * 0.2) && (ball!.position.x < frame.width * 0.8)) && ball!.position.y < 100)
                {
                    ballInSouthGoal = true
                }
            }
        }
        
        scoring()
        
        if sqrt(pow((ball?.physicsBody?.velocity.dx)!, 2) + pow((ball?.physicsBody?.velocity.dy)!, 2)) > CGFloat(maxBallSpeed)
        {
            ball?.physicsBody?.velocity.dx = (ball?.physicsBody?.velocity.dx)! * (maxBallSpeed / (sqrt(pow((ball?.physicsBody?.velocity.dx)!, 2) + pow((ball?.physicsBody?.velocity.dy)!, 2))))
            ball?.physicsBody?.velocity.dy = (ball?.physicsBody?.velocity.dy)! * (maxBallSpeed / (sqrt(pow((ball?.physicsBody?.velocity.dx)!, 2) + pow((ball?.physicsBody?.velocity.dy)!, 2))))
        }
        
        if sqrt(pow((botPlayer?.physicsBody?.velocity.dx)!, 2) + pow((botPlayer?.physicsBody?.velocity.dy)!, 2)) > CGFloat(maxBallSpeed)
        {
            botPlayer?.physicsBody?.velocity.dx = (botPlayer?.physicsBody?.velocity.dx)! * (maxBallSpeed / (sqrt(pow((botPlayer?.physicsBody?.velocity.dx)!, 2) + pow((botPlayer?.physicsBody?.velocity.dy)!, 2))))
            botPlayer?.physicsBody?.velocity.dy = (botPlayer?.physicsBody?.velocity.dy)! * (maxBallSpeed / (sqrt(pow((botPlayer?.physicsBody?.velocity.dx)!, 2) + pow((botPlayer?.physicsBody?.velocity.dy)!, 2))))
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        let touch = touches.first
        if let location = touch?.location(in: self)
        {
            let nodesArray = self.nodes(at: location)
            
            if nodesArray.contains(pauseButton)
            {
                pauseButton.colorBlendFactor = 0
                touchedPauseButton = true
            }
            else if nodesArray.contains(backToMenuButton)
            {
                backToMenuButton.colorBlendFactor = 0.50
                touchedBackToMenuButton = true
            }
            else if nodesArray.contains(soundButton)
            {
                soundButton.colorBlendFactor = 0.5
                touchedSoundOff = true
            }
            
        }
    }
    
    func ballIsOnTarget() -> Bool
    {
        let ballVectorSlope = (ball!.physicsBody!.velocity.dy) / (ball!.physicsBody!.velocity.dx)
        let goalHeight = topGoalEdgeBottom
        let goalDifferenceFromBall = goalHeight - ball!.position.y
        let botDifferenceFromBall = (botPlayer!.position.y - botPlayer!.radius) - (ball!.position.y + ballRadius)
        
        let changeOfX = goalDifferenceFromBall / ballVectorSlope
        let changeOfXForSave = botDifferenceFromBall / ballVectorSlope
        
        let goalLeftXBound = frame.width * 0.20
        let goalRightXBound = frame.width * 0.80
        expectedBallXPos = round(ball!.position.x + changeOfX)
        desiredBotXPosToSave = round(ball!.position.x + changeOfXForSave)
        
        if (expectedBallXPos >= goalLeftXBound) && (expectedBallXPos <= goalRightXBound) && (ball!.physicsBody!.velocity.dy > 0) && (ball?.physicsBody?.velocity.dy.magnitude)! >= goalDifferenceFromBall
        {
            return true
        }
        else
        {
            return false
        }
    }
    
    func ballCanReachTarget() -> Bool
    {
        let goalHeight = topGoalEdgeBottom
        let goalYDifferenceFromBall = goalHeight - ball!.position.y
        var goalXDifferenceFromBall: CGFloat
        if ball!.position.x < frame.width * 0.20
        {
            goalXDifferenceFromBall = abs((frame.width * 0.20) - ball!.position.x)
        }
        else if ball!.position.x > frame.width * 0.80
        {
            goalXDifferenceFromBall = abs((frame.width * 0.80) - ball!.position.x)
        }
        else
        {
            goalXDifferenceFromBall = 0
        }
        if (ball?.physicsBody?.velocity.dy.magnitude)! >= goalYDifferenceFromBall && (ball?.physicsBody?.velocity.dx.magnitude)! >= goalXDifferenceFromBall
        {
            return true
        }
        else
        {
            return false
        }
    }
    
    func botDefend()
    {
        //If ball is above bot on bot's side, trigger defend mode
        if ball!.position.y > frame.height * 0.5 && botPlayer!.position.y <= ball!.position.y && botDefendSwitch == false && botAttackSwitch == false && botMirrorSwitch == false
        {
            botDefendSwitch = true
            botAttackSwitch = false
            botMirrorSwitch = false
            botCoverPostSwitch = false
            botPlayer?.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        }
        
        else if botDefendSwitch == true
        {
            let distanceFromCenterX = abs((botPlayer?.position.x)! - (frame.width * 0.5))
            
            if distanceFromCenterX > frame.width * 0.2 && (botPlayer?.position.x)! < frame.width * 0.5
            {
                botPlayer!.physicsBody?.velocity.dx += 10
            }
            else if distanceFromCenterX > frame.width * 0.2 && (botPlayer?.position.x)! > frame.width * 0.5
            {
                botPlayer!.physicsBody?.velocity.dx -= 10
            }
            else
            {
                botPlayer!.physicsBody?.velocity.dx = 0
            }
            
            if botPlayer!.position.y < ball!.position.y || botPlayer!.position.y < frame.height * 0.85
            {
                botPlayer!.physicsBody?.velocity.dy += 10
            }
            else
            {
                botPlayer!.physicsBody?.velocity.dy = 0
                botDefendSwitch = false
            }
        }
        else
        {
            botDefendSwitch = false
        }
        
    }
    
    func botAttack()
    {
        let playerPosBelowTopGoalEdge = topGoalEdgeBottom - botPlayer!.radius
        let playerGoalDefenseHigherYBound = playerPosBelowTopGoalEdge - frame.height * 0.01
        let playerGoalDefenseLowerYBound = playerPosBelowTopGoalEdge - frame.height * 0.02
        
        //If bot is above ball on bot's side trigger attack mode. Consider the balls velocity vector while going for attack
        if ball!.position.y > frame.height * 0.5 && (botPlayer!.position.y >= ball!.position.y) && botAttackSwitch == false && botMirrorSwitch == false
        {
            botDefendSwitch = false
            botAttackSwitch = true
            botMirrorSwitch = false
            botPlayer?.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        }
        
        
        else if ball!.position.y > frame.height * 0.50 && (((botPlayer!.position.y >= ball!.position.y) && (ballIsOnTarget() || ballCanReachTarget())) || (ballIsOnTarget() && ballCanReachTarget())) && botAttackSwitch == true
        {
            //mirror ball to play defensive
            if ballIsOnTarget() == false && ballCanReachTarget() == true
            {
                // returned to mirror Y zone
                if botPlayer!.position.y >= playerGoalDefenseLowerYBound && botPlayer!.position.y <= playerGoalDefenseHigherYBound
                {
                    botPlayer!.physicsBody?.velocity.dy = 0
                    
                    //in playable mirror x zone .10 to .90
                    if ((botPlayer!.position.x >= frame.width * 0.35 && botPlayer!.position.x <= frame.width * 0.65) || (ball!.position.x > frame.width * 0.35 && ball!.position.x < frame.width * 0.65))
                    {
                        if botPlayer!.position.x < ball!.position.x && abs(botPlayer!.position.x - ball!.position.x) > 10
                        {
                            if botPlayer!.physicsBody!.velocity.dx < recoverySpeed
                            {
                                botPlayer!.physicsBody?.velocity.dx += recoverySpeed/5
                            }
                        }
                        else if botPlayer!.position.x > ball!.position.x && abs(botPlayer!.position.x - ball!.position.x) > 10
                        {
                            if botPlayer!.physicsBody!.velocity.dx > -recoverySpeed
                            {
                                botPlayer!.physicsBody?.velocity.dx -= recoverySpeed/5
                            }
                        }
                        else if abs(botPlayer!.position.x - ball!.position.x) <= 10
                        {
                            if botPlayer!.physicsBody!.velocity.dx < 0 && abs(botPlayer!.position.x - ball!.position.x) > 2
                            {
                                botPlayer!.physicsBody?.velocity.dx += 10
                            }
                            else if botPlayer!.physicsBody!.velocity.dx < 0 && abs(botPlayer!.position.x - ball!.position.x) <= 2
                            {
                                botPlayer!.physicsBody?.velocity.dx = round(botPlayer!.physicsBody!.velocity.dx)
                                botPlayer!.physicsBody?.velocity.dx += 1
                            }
                            if botPlayer!.physicsBody!.velocity.dx > 0 && abs(botPlayer!.position.x - ball!.position.x) > 2
                            {
                                botPlayer!.physicsBody?.velocity.dx -= 10
                            }
                            else if botPlayer!.physicsBody!.velocity.dx > 0 && abs(botPlayer!.position.x - ball!.position.x) >= 2
                            {
                                botPlayer!.physicsBody?.velocity.dx = round(botPlayer!.physicsBody!.velocity.dx)
                                botPlayer!.physicsBody?.velocity.dx -= 1
                            }
                        }
                    }
                    
                    //in unplayable mirror x zone < frame.width * .20
                    if (botPlayer!.position.x < frame.width * 0.35) && ball!.position.x >= frame.width * 0.35
                    {
                        if botPlayer!.physicsBody!.velocity.dx <= recoverySpeed
                        {
                            botPlayer?.physicsBody?.velocity.dx += recoverySpeed/5
                        }
                        else if botPlayer!.physicsBody!.velocity.dx > recoverySpeed
                        {
                            botPlayer?.physicsBody?.velocity.dx = recoverySpeed
                            
                        }
                    }
                    else if (botPlayer!.position.x < frame.width * 0.35) && ball!.position.x < frame.width * 0.35
                    {
                        let distanceOutOfBounds = abs(botPlayer!.position.x - (frame.width * 0.35))
                        botPlayer?.physicsBody?.velocity.dx = distanceOutOfBounds
                    }
                    else if (botPlayer!.position.x == frame.width * 0.35) && ball!.position.x <= frame.width * 0.35
                    {
                        botPlayer!.physicsBody?.velocity.dx = 0
                    }
                    
                    //in uplayable mirror x zone .70
                    if (botPlayer!.position.x > frame.width * 0.65) && ball!.position.x <= frame.width * 0.65
                    {
                        if botPlayer!.physicsBody!.velocity.dx >= -recoverySpeed
                        {
                            botPlayer?.physicsBody?.velocity.dx -= recoverySpeed/5
                        }
                        else if botPlayer!.physicsBody!.velocity.dx < -recoverySpeed
                        {
                            botPlayer?.physicsBody?.velocity.dx = -recoverySpeed
                            
                        }
                    }
                    else if (botPlayer!.position.x > frame.width * 0.65) && ball!.position.x > frame.width * 0.65
                    {
                        let distanceOutOfBounds = abs(botPlayer!.position.x - (frame.width * 0.65))
                        botPlayer?.physicsBody?.velocity.dx = -distanceOutOfBounds
                    }
                    else if (botPlayer!.position.x == frame.width * 0.65) && ball!.position.x >= frame.width * 0.65
                    {
                        botPlayer!.physicsBody?.velocity.dx = 0
                    }
                }
                
                //below mirroring y-zone for passive defending
                else if botPlayer!.position.y < playerGoalDefenseLowerYBound
                {
                    botPlayer!.physicsBody?.velocity.dy = recoverySpeed
                    
                    //in playable mirror x zone .10 to .90
                    if ((botPlayer!.position.x >= frame.width * 0.35 && botPlayer!.position.x <= frame.width * 0.65) || (ball!.position.x > frame.width * 0.35 && ball!.position.x < frame.width * 0.65))
                    {
                        if botPlayer!.position.x < ball!.position.x && abs(botPlayer!.position.x - ball!.position.x) > 10
                        {
                            if botPlayer!.physicsBody!.velocity.dx < recoverySpeed
                            {
                                botPlayer!.physicsBody?.velocity.dx += recoverySpeed/5
                            }
                        }
                        else if botPlayer!.position.x > ball!.position.x && abs(botPlayer!.position.x - ball!.position.x) > 10
                        {
                            if botPlayer!.physicsBody!.velocity.dx > -recoverySpeed
                            {
                                botPlayer!.physicsBody?.velocity.dx -= recoverySpeed/5
                            }
                        }
                        else if abs(botPlayer!.position.x - ball!.position.x) <= 10
                        {
                            if botPlayer!.physicsBody!.velocity.dx < 0 && abs(botPlayer!.position.x - ball!.position.x) > 2
                            {
                                botPlayer!.physicsBody?.velocity.dx += 10
                            }
                            else if botPlayer!.physicsBody!.velocity.dx < 0 && abs(botPlayer!.position.x - ball!.position.x) <= 2
                            {
                                botPlayer!.physicsBody?.velocity.dx = round(botPlayer!.physicsBody!.velocity.dx)
                                botPlayer!.physicsBody?.velocity.dx += 1
                            }
                            if botPlayer!.physicsBody!.velocity.dx > 0 && abs(botPlayer!.position.x - ball!.position.x) > 2
                            {
                                botPlayer!.physicsBody?.velocity.dx -= 10
                            }
                            else if botPlayer!.physicsBody!.velocity.dx > 0 && abs(botPlayer!.position.x - ball!.position.x) >= 2
                            {
                                botPlayer!.physicsBody?.velocity.dx = round(botPlayer!.physicsBody!.velocity.dx)
                                botPlayer!.physicsBody?.velocity.dx -= 1
                            }
                        }
                    }
                    
                    //in unplayable mirror x zone < frame.width * .20
                    if (botPlayer!.position.x < frame.width * 0.35) && ball!.position.x >= frame.width * 0.35
                    {
                        if botPlayer!.physicsBody!.velocity.dx <= recoverySpeed
                        {
                            botPlayer?.physicsBody?.velocity.dx += recoverySpeed/5
                        }
                        else if botPlayer!.physicsBody!.velocity.dx > recoverySpeed
                        {
                            botPlayer?.physicsBody?.velocity.dx = recoverySpeed
                            
                        }
                    }
                    else if (botPlayer!.position.x < frame.width * 0.35) && ball!.position.x < frame.width * 0.35
                    {
                        let distanceOutOfBounds = abs(botPlayer!.position.x - (frame.width * 0.35))
                        botPlayer?.physicsBody?.velocity.dx = distanceOutOfBounds
                    }
                    else if (botPlayer!.position.x == frame.width * 0.35) && ball!.position.x <= frame.width * 0.35
                    {
                        botPlayer!.physicsBody?.velocity.dx = 0
                    }
                    
                    //in uplayable mirror x zone .70
                    if (botPlayer!.position.x > frame.width * 0.65) && ball!.position.x <= frame.width * 0.65
                    {
                        if botPlayer!.physicsBody!.velocity.dx >= -recoverySpeed
                        {
                            botPlayer?.physicsBody?.velocity.dx -= recoverySpeed/5
                        }
                        else if botPlayer!.physicsBody!.velocity.dx < -recoverySpeed
                        {
                            botPlayer?.physicsBody?.velocity.dx = -recoverySpeed
                            
                        }
                    }
                    else if (botPlayer!.position.x > frame.width * 0.65) && ball!.position.x > frame.width * 0.65
                    {
                        let distanceOutOfBounds = abs(botPlayer!.position.x - (frame.width * 0.65))
                        botPlayer?.physicsBody?.velocity.dx = -distanceOutOfBounds
                    }
                    else if (botPlayer!.position.x == frame.width * 0.65) && ball!.position.x >= frame.width * 0.65
                    {
                        botPlayer!.physicsBody?.velocity.dx = 0
                    }
                }
                
                //above mirroring y-zone for passive defending
                else if botPlayer!.position.y > playerGoalDefenseHigherYBound
                {
                    botPlayer!.physicsBody?.velocity.dy = -recoverySpeed
                    
                    //in playable mirror x zone .25 to .80
                    if ((botPlayer!.position.x >= frame.width * 0.35 && botPlayer!.position.x <= frame.width * 0.65) || (ball!.position.x > frame.width * 0.35 && ball!.position.x < frame.width * 0.65))
                    {
                        if botPlayer!.position.x < ball!.position.x && abs(botPlayer!.position.x - ball!.position.x) > 10
                        {
                            if botPlayer!.physicsBody!.velocity.dx < recoverySpeed
                            {
                                botPlayer!.physicsBody?.velocity.dx += recoverySpeed/5
                            }
                        }
                        else if botPlayer!.position.x > ball!.position.x && abs(botPlayer!.position.x - ball!.position.x) > 10
                        {
                            if botPlayer!.physicsBody!.velocity.dx > -recoverySpeed
                            {
                                botPlayer!.physicsBody?.velocity.dx -= recoverySpeed/5
                            }
                        }
                        else if abs(botPlayer!.position.x - ball!.position.x) <= 10
                        {
                            if botPlayer!.physicsBody!.velocity.dx < 0 && abs(botPlayer!.position.x - ball!.position.x) > 2
                            {
                                botPlayer!.physicsBody?.velocity.dx += 10
                            }
                            else if botPlayer!.physicsBody!.velocity.dx < 0 && abs(botPlayer!.position.x - ball!.position.x) <= 2
                            {
                                botPlayer!.physicsBody?.velocity.dx = round(botPlayer!.physicsBody!.velocity.dx)
                                botPlayer!.physicsBody?.velocity.dx += 1
                            }
                            if botPlayer!.physicsBody!.velocity.dx > 0 && abs(botPlayer!.position.x - ball!.position.x) > 2
                            {
                                botPlayer!.physicsBody?.velocity.dx -= 10
                            }
                            else if botPlayer!.physicsBody!.velocity.dx > 0 && abs(botPlayer!.position.x - ball!.position.x) >= 2
                            {
                                botPlayer!.physicsBody?.velocity.dx = round(botPlayer!.physicsBody!.velocity.dx)
                                botPlayer!.physicsBody?.velocity.dx -= 1
                            }
                        }
                    }
                    
                    //in unplayable mirror x zone < frame.width * .20
                    if (botPlayer!.position.x < frame.width * 0.35) && ball!.position.x >= frame.width * 0.35
                    {
                        if botPlayer!.physicsBody!.velocity.dx <= recoverySpeed
                        {
                            botPlayer?.physicsBody?.velocity.dx += recoverySpeed/5
                        }
                        else if botPlayer!.physicsBody!.velocity.dx > recoverySpeed
                        {
                            botPlayer?.physicsBody?.velocity.dx = recoverySpeed
                            
                        }
                    }
                    else if (botPlayer!.position.x < frame.width * 0.35) && ball!.position.x < frame.width * 0.35
                    {
                        let distanceOutOfBounds = abs(botPlayer!.position.x - (frame.width * 0.35))
                        botPlayer?.physicsBody?.velocity.dx = distanceOutOfBounds
                    }
                    else if (botPlayer!.position.x == frame.width * 0.35) && ball!.position.x <= frame.width * 0.35
                    {
                        botPlayer!.physicsBody?.velocity.dx = 0
                    }
                    
                    //in uplayable mirror x zone .70
                    if (botPlayer!.position.x > frame.width * 0.65) && ball!.position.x <= frame.width * 0.65
                    {
                        if botPlayer!.physicsBody!.velocity.dx >= -recoverySpeed
                        {
                            botPlayer?.physicsBody?.velocity.dx -= recoverySpeed/5
                        }
                        else if botPlayer!.physicsBody!.velocity.dx < -recoverySpeed
                        {
                            botPlayer?.physicsBody?.velocity.dx = -recoverySpeed
                            
                        }
                    }
                    else if (botPlayer!.position.x > frame.width * 0.65) && ball!.position.x > frame.width * 0.65
                    {
                        let distanceOutOfBounds = abs(botPlayer!.position.x - (frame.width * 0.70))
                        botPlayer?.physicsBody?.velocity.dx = -distanceOutOfBounds
                    }
                    else if (botPlayer!.position.x == frame.width * 0.65) && ball!.position.x >= frame.width * 0.65
                    {
                        botPlayer!.physicsBody?.velocity.dx = 0
                    }
                }
            }
            
            else if ballIsOnTarget() == true && botPlayer!.position.y > ball!.position.y && botCoverPostSwitch == false
            {
                // returned to mirror Y zone
                if botPlayer!.position.y >= playerGoalDefenseLowerYBound && botPlayer!.position.y <= playerGoalDefenseHigherYBound && madeItToExpectedBallPosAtPlayerHeight == false
                {
                    botPlayer!.physicsBody?.velocity.dy = 0
                }
                //below mirroring y-zone for passive defending
                else if botPlayer!.position.y < playerGoalDefenseLowerYBound && madeItToExpectedBallPosAtPlayerHeight == false
                {
                    botPlayer!.physicsBody?.velocity.dy = recoverySpeed
                }
                //above mirroring y-zone for passive defending
                else if botPlayer!.position.y > playerGoalDefenseHigherYBound && madeItToExpectedBallPosAtPlayerHeight == false
                {
                    botPlayer!.physicsBody?.velocity.dy = -recoverySpeed
                }
                
                if madeItToExpectedBallPosAtPlayerHeight == false
                {
                    let botDistanceFromSave = abs((botPlayer!.position.x - desiredBotXPosToSave))
                    let ballDistanceFromGoal = abs((ball!.position.y - topGoalEdgeBottom))
                    let velocityScalar = 1.5
                    
                    if (botPlayer!.position.x - desiredBotXPosToSave < -10)
                    {
                        botPlayer?.physicsBody?.velocity.dx = (abs((botDistanceFromSave/ballDistanceFromGoal) * ball!.physicsBody!.velocity.dy)) * velocityScalar
                    }
                    else if (botPlayer!.position.x - desiredBotXPosToSave > 10)
                    {
                        botPlayer?.physicsBody?.velocity.dx = (abs((botDistanceFromSave/ballDistanceFromGoal) * ball!.physicsBody!.velocity.dy)) * -velocityScalar
                    }
                    else if (botPlayer!.position.x - desiredBotXPosToSave >= -10) && (botPlayer!.position.x - desiredBotXPosToSave <= 10) && (botPlayer!.position.y > ball!.position.y) && (botPlayer!.position.y) >= playerGoalDefenseLowerYBound && (ball!.physicsBody!.velocity.dy > 0)
                    {
                        botPlayer?.physicsBody?.velocity.dx = 0
                        madeItToExpectedBallPosAtPlayerHeight = true
                    }
                }
                if madeItToExpectedBallPosAtPlayerHeight == true
                {
                    let randScalar = Float.random(in: 0.50..<2.0)
                    botPlayer?.physicsBody?.velocity = CGVector(dx: -ball!.physicsBody!.velocity.dx * CGFloat(randScalar), dy: -ball!.physicsBody!.velocity.dy * CGFloat(randScalar))
                }
            }
            else if ballIsOnTarget() == true && botPlayer!.position.y <= ball!.position.y && botPlayer!.position.y >= playerGoalDefenseLowerYBound && botPlayer!.position.y <= playerGoalDefenseHigherYBound && botCoverPostSwitch == false
            {
                botCoverPostSwitch = true
            }
            
            else if ballIsOnTarget() == true && botPlayer!.position.y <= ball!.position.y && botPlayer!.position.y >= playerGoalDefenseLowerYBound && botPlayer!.position.y <= playerGoalDefenseHigherYBound && botCoverPostSwitch == true
            {

                if madeItToExpectedBallPosAtPlayerHeight == false
                {
                    var botDistanceFromSaveX: CGFloat
                    let ballDistanceFromGoalX: CGFloat
                    var botDistanceFromSaveY: CGFloat
                    let ballDistanceFromGoalY: CGFloat
                    let velocityScalar = 1.0
                    let leftGoalPost = frame.width * 0.20
                    let rightGoalPost = frame.width * 0.80
                    
                    if (ball!.position.x <= leftGoalPost)
                    {
                        botDistanceFromSaveX = abs(botPlayer!.position.x - leftGoalPost)
                        ballDistanceFromGoalX = abs(ball!.position.x - leftGoalPost)
                        botDistanceFromSaveY = abs((botPlayer!.position.y + botPlayer!.radius) - topGoalEdgeBottom)
                        ballDistanceFromGoalY = abs(ball!.position.y - topGoalEdgeBottom)
                        botPlayer?.physicsBody?.velocity.dx = (abs((botDistanceFromSaveX/ballDistanceFromGoalX) * ball!.physicsBody!.velocity.dy)) * -velocityScalar
                        botPlayer?.physicsBody?.velocity.dy = (abs((botDistanceFromSaveY/ballDistanceFromGoalY) * ball!.physicsBody!.velocity.dx)) * velocityScalar
                        if (botDistanceFromSaveX >= -5) && (botDistanceFromSaveX <= 5)
                        {
                            botPlayer?.physicsBody?.velocity.dx = 0
                        }
                        if (botDistanceFromSaveY >= -5) && (botDistanceFromSaveY <= 5)
                        {
                            botPlayer?.physicsBody?.velocity.dy = 0
                        }
                        if (botDistanceFromSaveX >= -5) && (botDistanceFromSaveX <= 5) && (botDistanceFromSaveY >= -5) && (botDistanceFromSaveY <= 5)
                        {
                            madeItToExpectedBallPosAtPlayerHeight = true
                        }
                    }
                    else if (ball!.position.x >= rightGoalPost)
                    {
                        botDistanceFromSaveX = abs(botPlayer!.position.x - rightGoalPost)
                        ballDistanceFromGoalX = abs(ball!.position.x - rightGoalPost)
                        botDistanceFromSaveY = abs((botPlayer!.position.y + botPlayer!.radius) - topGoalEdgeBottom)
                        ballDistanceFromGoalY = abs(ball!.position.y - topGoalEdgeBottom)
                        botPlayer?.physicsBody?.velocity.dx = (abs((botDistanceFromSaveX/ballDistanceFromGoalX) * ball!.physicsBody!.velocity.dy)) * velocityScalar
                        botPlayer?.physicsBody?.velocity.dy = (abs((botDistanceFromSaveY/ballDistanceFromGoalY) * ball!.physicsBody!.velocity.dx)) * velocityScalar
                        
                        
                        if (botDistanceFromSaveX >= -5) && (botDistanceFromSaveX <= 5)
                        {
                            botPlayer?.physicsBody?.velocity.dx = 0
                        }
                        if (botDistanceFromSaveY >= -5) && (botDistanceFromSaveY <= 5)
                        {
                            botPlayer?.physicsBody?.velocity.dy = 0
                        }
                        if (botDistanceFromSaveX >= -5) && (botDistanceFromSaveX <= 5) && (botDistanceFromSaveY >= -5) && (botDistanceFromSaveY <= 5)
                        {
                            madeItToExpectedBallPosAtPlayerHeight = true
                        }
                    }
                }
                
            }
            
            else if ballIsOnTarget() == true && (botPlayer!.position.y <= ball!.position.y && (botPlayer!.position.y < playerGoalDefenseLowerYBound || botPlayer!.position.y > playerGoalDefenseHigherYBound))
            {
                // returned to mirror Y zone
                if botPlayer!.position.y >= playerGoalDefenseLowerYBound && botPlayer!.position.y <= playerGoalDefenseHigherYBound && madeItToExpectedBallPosAtPlayerHeight == false
                {
                    botPlayer!.physicsBody?.velocity.dy = 0
                }
                //below mirroring y-zone for passive defending
                else if botPlayer!.position.y < playerGoalDefenseLowerYBound && madeItToExpectedBallPosAtPlayerHeight == false
                {
                    botPlayer!.physicsBody?.velocity.dy = recoverySpeed
                }
                //above mirroring y-zone for passive defending
                else if botPlayer!.position.y > playerGoalDefenseHigherYBound && madeItToExpectedBallPosAtPlayerHeight == false
                {
                    botPlayer!.physicsBody?.velocity.dy = -recoverySpeed
                }
            }
        }
        
        else if ballIsOnTarget() == false && ballCanReachTarget() == false && (ball?.position.y)! > frame.height * 0.50 && botAttackSwitch == true && ball!.physicsBody!.velocity.dy > -1 * (frame.height * 0.2)
        {
            let timeToReachBall = 2.5
            
            let linearDampingX =  floor(Double(ball!.physicsBody!.velocity.dx / (1 + ((timeToReachBall/2) * ball!.physicsBody!.linearDamping))))
            
            let linearDampingY =  floor(Double(ball!.physicsBody!.velocity.dy / (1 + ((timeToReachBall/2) * ball!.physicsBody!.linearDamping))))
            
            let intersectionXPoint = ball!.position.x + linearDampingX
            let intersectionYPoint = ball!.position.y + linearDampingY
            
            let botPlayerXVelocity = (botPlayer!.position.x - intersectionXPoint) * timeToReachBall
            let botPlayerYVelocity = (botPlayer!.position.y - intersectionYPoint) * timeToReachBall
            if (intersectionXPoint > 0 && intersectionXPoint < frame.width) && intersectionYPoint > frame.height * 0.5
            {
                botPlayer?.physicsBody?.velocity = CGVector(dx: -botPlayerXVelocity, dy: -botPlayerYVelocity)
            }
        }
        else
        {
            botAttackSwitch = false
        }
    }
    
    func botMirror()
    {
        let playerPosBelowTopGoalEdge = topGoalEdgeBottom - botPlayer!.radius
        let playerGoalDefenseHigherYBound = playerPosBelowTopGoalEdge - frame.height * 0.01
        let playerGoalDefenseLowerYBound = playerPosBelowTopGoalEdge - frame.height * 0.02
        //        let recoveryYVelocity = frame.height * 0.2
        //        let recoveryXVelocity = frame.height * 0.2
        
        
        // If ball is on player's side, mirror the balls movement to prepare for defense and attack
        
        if (ball!.position.y) < frame.height * 0.5 && botMirrorSwitch == false
        {
            botMirrorSwitch = true
            botDefendSwitch = false
            botAttackSwitch = false
            botCoverPostSwitch = false
            botPlayer?.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        }
        else if (ball!.position.y) < frame.height * 0.5 && botMirrorSwitch == true
        {
            // returned to mirror Y zone
            if botPlayer!.position.y >= playerGoalDefenseLowerYBound && botPlayer!.position.y <= playerGoalDefenseHigherYBound
            {
                botPlayer!.physicsBody?.velocity.dy = 0
                
                //in playable mirror x zone .10 to .90
                if ((botPlayer!.position.x >= frame.width * 0.30 && botPlayer!.position.x <= frame.width * 0.70) || (ball!.position.x > frame.width * 0.30 && ball!.position.x < frame.width * 0.70))
                {
                    if botPlayer!.position.x < ball!.position.x && abs(botPlayer!.position.x - ball!.position.x) > 10
                    {
                        if botPlayer!.physicsBody!.velocity.dx < recoverySpeed
                        {
                            botPlayer!.physicsBody?.velocity.dx += recoverySpeed/5
                        }
                    }
                    else if botPlayer!.position.x > ball!.position.x && abs(botPlayer!.position.x - ball!.position.x) > 10
                    {
                        if botPlayer!.physicsBody!.velocity.dx > -recoverySpeed
                        {
                            botPlayer!.physicsBody?.velocity.dx -= recoverySpeed/5
                        }
                    }
                    else if abs(botPlayer!.position.x - ball!.position.x) <= 10
                    {
                        if botPlayer!.physicsBody!.velocity.dx < 0 && abs(botPlayer!.position.x - ball!.position.x) > 2
                        {
                            botPlayer!.physicsBody?.velocity.dx += 10
                        }
                        else if botPlayer!.physicsBody!.velocity.dx < 0 && abs(botPlayer!.position.x - ball!.position.x) <= 2
                        {
                            botPlayer!.physicsBody?.velocity.dx = round(botPlayer!.physicsBody!.velocity.dx)
                            botPlayer!.physicsBody?.velocity.dx += 1
                        }
                        if botPlayer!.physicsBody!.velocity.dx > 0 && abs(botPlayer!.position.x - ball!.position.x) > 2
                        {
                            botPlayer!.physicsBody?.velocity.dx -= 10
                        }
                        else if botPlayer!.physicsBody!.velocity.dx > 0 && abs(botPlayer!.position.x - ball!.position.x) >= 2
                        {
                            botPlayer!.physicsBody?.velocity.dx = round(botPlayer!.physicsBody!.velocity.dx)
                            botPlayer!.physicsBody?.velocity.dx -= 1
                        }
                    }
                }
                
                //in unplayable mirror x zone < frame.width * .20
                if (botPlayer!.position.x < frame.width * 0.30) && ball!.position.x >= frame.width * 0.30
                {
                    if botPlayer!.physicsBody!.velocity.dx <= recoverySpeed
                    {
                        botPlayer?.physicsBody?.velocity.dx += recoverySpeed/5
                    }
                    else if botPlayer!.physicsBody!.velocity.dx > recoverySpeed
                    {
                        botPlayer?.physicsBody?.velocity.dx = recoverySpeed
                        
                    }
                }
                else if (botPlayer!.position.x < frame.width * 0.30) && ball!.position.x < frame.width * 0.30
                {
                    let distanceOutOfBounds = abs(botPlayer!.position.x - (frame.width * 0.30))
                    botPlayer?.physicsBody?.velocity.dx = distanceOutOfBounds
                }
                else if (botPlayer!.position.x == frame.width * 0.30) && ball!.position.x <= frame.width * 0.30
                {
                    botPlayer!.physicsBody?.velocity.dx = 0
                }
                
                //in uplayable mirror x zone .70
                if (botPlayer!.position.x > frame.width * 0.70) && ball!.position.x <= frame.width * 0.70
                {
                    if botPlayer!.physicsBody!.velocity.dx >= -recoverySpeed
                    {
                        botPlayer?.physicsBody?.velocity.dx -= recoverySpeed/5
                    }
                    else if botPlayer!.physicsBody!.velocity.dx < -recoverySpeed
                    {
                        botPlayer?.physicsBody?.velocity.dx = -recoverySpeed
                        
                    }
                }
                else if (botPlayer!.position.x > frame.width * 0.70) && ball!.position.x > frame.width * 0.70
                {
                    let distanceOutOfBounds = abs(botPlayer!.position.x - (frame.width * 0.70))
                    botPlayer?.physicsBody?.velocity.dx = -distanceOutOfBounds
                }
                else if (botPlayer!.position.x == frame.width * 0.70) && ball!.position.x >= frame.width * 0.70
                {
                    botPlayer!.physicsBody?.velocity.dx = 0
                }
            }
            
            //below mirroring y-zone for passive defending
            else if botPlayer!.position.y < playerGoalDefenseLowerYBound
            {
                botPlayer!.physicsBody?.velocity.dy = recoverySpeed
                
                //in playable mirror x zone .10 to .90
                if ((botPlayer!.position.x >= frame.width * 0.30 && botPlayer!.position.x <= frame.width * 0.70) || (ball!.position.x > frame.width * 0.30 && ball!.position.x < frame.width * 0.70))
                {
                    if botPlayer!.position.x < ball!.position.x && abs(botPlayer!.position.x - ball!.position.x) > 10
                    {
                        if botPlayer!.physicsBody!.velocity.dx < recoverySpeed
                        {
                            botPlayer!.physicsBody?.velocity.dx += recoverySpeed/5
                        }
                    }
                    else if botPlayer!.position.x > ball!.position.x && abs(botPlayer!.position.x - ball!.position.x) > 10
                    {
                        if botPlayer!.physicsBody!.velocity.dx > -recoverySpeed
                        {
                            botPlayer!.physicsBody?.velocity.dx -= recoverySpeed/5
                        }
                    }
                    else if abs(botPlayer!.position.x - ball!.position.x) <= 10
                    {
                        if botPlayer!.physicsBody!.velocity.dx < 0 && abs(botPlayer!.position.x - ball!.position.x) > 2
                        {
                            botPlayer!.physicsBody?.velocity.dx += 10
                        }
                        else if botPlayer!.physicsBody!.velocity.dx < 0 && abs(botPlayer!.position.x - ball!.position.x) <= 2
                        {
                            botPlayer!.physicsBody?.velocity.dx = round(botPlayer!.physicsBody!.velocity.dx)
                            botPlayer!.physicsBody?.velocity.dx += 1
                        }
                        if botPlayer!.physicsBody!.velocity.dx > 0 && abs(botPlayer!.position.x - ball!.position.x) > 2
                        {
                            botPlayer!.physicsBody?.velocity.dx -= 10
                        }
                        else if botPlayer!.physicsBody!.velocity.dx > 0 && abs(botPlayer!.position.x - ball!.position.x) >= 2
                        {
                            botPlayer!.physicsBody?.velocity.dx = round(botPlayer!.physicsBody!.velocity.dx)
                            botPlayer!.physicsBody?.velocity.dx -= 1
                        }
                    }
                }
                
                //in unplayable mirror x zone < frame.width * .20
                if (botPlayer!.position.x < frame.width * 0.30) && ball!.position.x >= frame.width * 0.30
                {
                    if botPlayer!.physicsBody!.velocity.dx <= recoverySpeed
                    {
                        botPlayer?.physicsBody?.velocity.dx += recoverySpeed/5
                    }
                    else if botPlayer!.physicsBody!.velocity.dx > recoverySpeed
                    {
                        botPlayer?.physicsBody?.velocity.dx = recoverySpeed
                        
                    }
                }
                else if (botPlayer!.position.x < frame.width * 0.30) && ball!.position.x < frame.width * 0.30
                {
                    let distanceOutOfBounds = abs(botPlayer!.position.x - (frame.width * 0.30))
                    botPlayer?.physicsBody?.velocity.dx = distanceOutOfBounds
                }
                else if (botPlayer!.position.x == frame.width * 0.30) && ball!.position.x <= frame.width * 0.30
                {
                    botPlayer!.physicsBody?.velocity.dx = 0
                }
                
                //in uplayable mirror x zone .70
                if (botPlayer!.position.x > frame.width * 0.70) && ball!.position.x <= frame.width * 0.70
                {
                    if botPlayer!.physicsBody!.velocity.dx >= -recoverySpeed
                    {
                        botPlayer?.physicsBody?.velocity.dx -= recoverySpeed/5
                    }
                    else if botPlayer!.physicsBody!.velocity.dx < -recoverySpeed
                    {
                        botPlayer?.physicsBody?.velocity.dx = -recoverySpeed
                        
                    }
                }
                else if (botPlayer!.position.x > frame.width * 0.70) && ball!.position.x > frame.width * 0.70
                {
                    let distanceOutOfBounds = abs(botPlayer!.position.x - (frame.width * 0.70))
                    botPlayer?.physicsBody?.velocity.dx = -distanceOutOfBounds
                }
                else if (botPlayer!.position.x == frame.width * 0.70) && ball!.position.x >= frame.width * 0.70
                {
                    botPlayer!.physicsBody?.velocity.dx = 0
                }
            }
            
            //above mirroring y-zone for passive defending
            else if botPlayer!.position.y > playerGoalDefenseHigherYBound
            {
                botPlayer!.physicsBody?.velocity.dy = -recoverySpeed
                
                //in playable mirror x zone .25 to .80
                if ((botPlayer!.position.x >= frame.width * 0.30 && botPlayer!.position.x <= frame.width * 0.70) || (ball!.position.x > frame.width * 0.30 && ball!.position.x < frame.width * 0.70))
                {
                    if botPlayer!.position.x < ball!.position.x && abs(botPlayer!.position.x - ball!.position.x) > 10
                    {
                        if botPlayer!.physicsBody!.velocity.dx < recoverySpeed
                        {
                            botPlayer!.physicsBody?.velocity.dx += recoverySpeed/5
                        }
                    }
                    else if botPlayer!.position.x > ball!.position.x && abs(botPlayer!.position.x - ball!.position.x) > 10
                    {
                        if botPlayer!.physicsBody!.velocity.dx > -recoverySpeed
                        {
                            botPlayer!.physicsBody?.velocity.dx -= recoverySpeed/5
                        }
                    }
                    else if abs(botPlayer!.position.x - ball!.position.x) <= 10
                    {
                        if botPlayer!.physicsBody!.velocity.dx < 0 && abs(botPlayer!.position.x - ball!.position.x) > 2
                        {
                            botPlayer!.physicsBody?.velocity.dx += 10
                        }
                        else if botPlayer!.physicsBody!.velocity.dx < 0 && abs(botPlayer!.position.x - ball!.position.x) <= 2
                        {
                            botPlayer!.physicsBody?.velocity.dx = round(botPlayer!.physicsBody!.velocity.dx)
                            botPlayer!.physicsBody?.velocity.dx += 1
                        }
                        if botPlayer!.physicsBody!.velocity.dx > 0 && abs(botPlayer!.position.x - ball!.position.x) > 2
                        {
                            botPlayer!.physicsBody?.velocity.dx -= 10
                        }
                        else if botPlayer!.physicsBody!.velocity.dx > 0 && abs(botPlayer!.position.x - ball!.position.x) >= 2
                        {
                            botPlayer!.physicsBody?.velocity.dx = round(botPlayer!.physicsBody!.velocity.dx)
                            botPlayer!.physicsBody?.velocity.dx -= 1
                        }
                    }
                }
                
                //in unplayable mirror x zone < frame.width * .20
                if (botPlayer!.position.x < frame.width * 0.30) && ball!.position.x >= frame.width * 0.30
                {
                    if botPlayer!.physicsBody!.velocity.dx <= recoverySpeed
                    {
                        botPlayer?.physicsBody?.velocity.dx += recoverySpeed/5
                    }
                    else if botPlayer!.physicsBody!.velocity.dx > recoverySpeed
                    {
                        botPlayer?.physicsBody?.velocity.dx = recoverySpeed
                        
                    }
                }
                else if (botPlayer!.position.x < frame.width * 0.30) && ball!.position.x < frame.width * 0.30
                {
                    let distanceOutOfBounds = abs(botPlayer!.position.x - (frame.width * 0.30))
                    botPlayer?.physicsBody?.velocity.dx = distanceOutOfBounds
                }
                else if (botPlayer!.position.x == frame.width * 0.30) && ball!.position.x <= frame.width * 0.30
                {
                    botPlayer!.physicsBody?.velocity.dx = 0
                }
                
                //in uplayable mirror x zone .70
                if (botPlayer!.position.x > frame.width * 0.70) && ball!.position.x <= frame.width * 0.70
                {
                    if botPlayer!.physicsBody!.velocity.dx >= -recoverySpeed
                    {
                        botPlayer?.physicsBody?.velocity.dx -= recoverySpeed/5
                    }
                    else if botPlayer!.physicsBody!.velocity.dx < -recoverySpeed
                    {
                        botPlayer?.physicsBody?.velocity.dx = -recoverySpeed
                        
                    }
                }
                else if (botPlayer!.position.x > frame.width * 0.70) && ball!.position.x > frame.width * 0.70
                {
                    let distanceOutOfBounds = abs(botPlayer!.position.x - (frame.width * 0.70))
                    botPlayer?.physicsBody?.velocity.dx = -distanceOutOfBounds
                }
                else if (botPlayer!.position.x == frame.width * 0.70) && ball!.position.x >= frame.width * 0.70
                {
                    botPlayer!.physicsBody?.velocity.dx = 0
                }
            }
        }
        else
        {
            botMirrorSwitch = false
        }
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
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        let touch = touches.first
        
        if let location = touch?.location(in: self)
        {
            let nodesArray = self.nodes(at: location)
            
            if nodesArray.contains(pauseButton) && touchedPauseButton == true && GameIsPaused == false
            {
                touchedPauseButton = false
                pauseButton.colorBlendFactor = 0.40
                if UserDefaults.standard.string(forKey: "Music") == "On"
                {
                    run(buttonSound)
                    SKTAudio.sharedInstance().playBackgroundMusic("MenuSong2.mp3")
                }
                else if UserDefaults.standard.string(forKey: "Sound") == "Off" {}
                else{run(buttonSound)}
                updatePauseBackground()
                pauseButtonSprite.isHidden = true
                playButtonSprite.isHidden = false
                pausePhysics()
                showPauseMenuButton()
                // Configure the view.
                let skView = self.view!
                skView.isMultipleTouchEnabled = false
                GameIsPaused = true
                
                
            }
            else if nodesArray.contains(pauseButton) && touchedPauseButton == true && GameIsPaused == true
            {
                touchedPauseButton = false
                pauseButton.colorBlendFactor = 0.40
                if UserDefaults.standard.string(forKey: "Sound") == "On" {run(buttonSound)}
                else if UserDefaults.standard.string(forKey: "Sound") == "Off" {}
                else{run(buttonSound)}
                resetPauseBackground()
                pauseButtonSprite.isHidden = false
                playButtonSprite.isHidden = true
                resumePhysics()
                hidePauseMenuButtons()
                SKTAudio.sharedInstance().pauseBackgroundMusic()
                // Configure the view.
                let skView = self.view!
                skView.isMultipleTouchEnabled = false
                GameIsPaused = false
            }
            else if nodesArray.contains(backToMenuButton) && touchedBackToMenuButton == true
            {
                if UserDefaults.standard.string(forKey: "Sound") == "On"
                {
                    run(buttonSound)
                }
                else if UserDefaults.standard.string(forKey: "Sound") == "Off" {}
                else{run(buttonSound)}
                backToMenuButton.colorBlendFactor = 0
                touchedBackToMenuButton = false
                let scene = MenuScene(size: (view?.bounds.size)!)
                
                // Configure the view.
                let skView = self.view!
                
                /* Sprite Kit applies additional optimizations to improve rendering performance */
                skView.ignoresSiblingOrder = true
                
                /* Set the scale mode to scale to fit the window */
                scene.scaleMode = .resizeFill
                let transition = SKTransition.doorsCloseHorizontal(withDuration: 0.75)
                skView.presentScene(scene, transition: transition)
            }
            else if nodesArray.contains(soundButton) && touchedSoundOff == true && UserDefaults.standard.string(forKey: "Sound") == "On"
            {
                soundButtonSprite.isHidden = true
                soundButtonOffSprite.isHidden = false
                let save = UserDefaults.standard
                save.set("Off", forKey: "Sound")
                SKTAudio.sharedInstance().pauseBackgroundMusic()
                save.synchronize()
                touchedSoundOff = false
                soundButton.colorBlendFactor = 0
                
                if UserDefaults.standard.string(forKey: "Sound") == "On" {run(buttonSound)}
                else if UserDefaults.standard.string(forKey: "Sound") == "Off" {}
                else{run(buttonSound)}
            }
            else if nodesArray.contains(soundButton) && touchedSoundOff == true && UserDefaults.standard.string(forKey: "Sound") == "Off"
            {
                soundButtonSprite.isHidden = false
                soundButtonOffSprite.isHidden = true
                let save = UserDefaults.standard
                save.set("On", forKey: "Sound")
                save.synchronize()
                touchedSoundOff = false
                soundButton.colorBlendFactor = 0
                if UserDefaults.standard.string(forKey: "Music") == "On"
                {
                    run(buttonSound)
                    SKTAudio.sharedInstance().playBackgroundMusic("MenuSong2.mp3")
                }
                else if UserDefaults.standard.string(forKey: "Sound") == "Off" {}
                else{run(buttonSound)}
            }
            else
            {
                if touchedPauseButton == true
                {
                    touchedPauseButton = false
                    pauseButton.colorBlendFactor = 0.40
                }
                if touchedBackToMenuButton == true
                {
                    touchedBackToMenuButton = false
                    backToMenuButton.colorBlendFactor = 0
                }
                if touchedSoundOff == true
                {
                    touchedSoundOff = false
                    soundButton.colorBlendFactor = 0
                }
            }
        }
    }
}

