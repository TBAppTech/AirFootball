import Foundation
import Firebase

struct User {
    let uid: String
    let playerName: String
    let gold: Int
    let team: Int
    
    // Инициализатор для создания объекта User из Firebase DataSnapshot
    init?(snapshot: DataSnapshot) {
        guard let dict = snapshot.value as? [String: Any],
              let playerName = dict["playerName"] as? String,
              let team = dict["team"] as? Int,
              let gold = dict["gold"] as? Int
        else { return nil }
        
        self.uid = snapshot.key
        self.playerName = playerName
        self.gold = gold
        self.team = team
    }
}
