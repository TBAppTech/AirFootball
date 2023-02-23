import UIKit
import Firebase
import FirebaseDatabase

class FirebaseManager {
    private var ref: DatabaseReference!
    
    
    func saveCoins(_ gold: Int){
        guard let currentUser = Auth.auth().currentUser else {return}
       // let user = Users(user: currentUser)
        ref = Database.database().reference(withPath: "users").child(currentUser.uid)
        ref.updateChildValues(["gold": gold])
        
    }
    func saveLockedSkins(array: [Int]) {
        let ref = Database.database().reference()
        let arrayRef = ref.child("lockedSkins")
        arrayRef.setValue(array)
    }
    
    
}

