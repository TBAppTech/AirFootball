enum BodyType:UInt32
{
    //powers of 2
    case player = 1
    case sideWalls = 2
    case topBottomWalls = 128
    case ball = 512
    case ball2 = 514
    case goals = 4
    case playerForceField = 8
    case leftMagnet = 16
    case centerMagnet = 32
    case rightMagnet = 64
    case topGoalZone = 1024
    case bottomGoalZone = 256
}
