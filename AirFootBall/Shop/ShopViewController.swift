import UIKit
import Firebase

class ShopViewController: PortraitViewController {
    
    
    @IBOutlet var footballFields: [UIButton]!
    @IBOutlet var teamButtons: [UIButton]!
    @IBOutlet weak var coinLabel: UILabel!
    var selectedTeam = 1
    var selectedField = 1
    
    var purchasedFields: [Int]!
    var purchasedTeams: [Int]!
    var gold: Int!
    
    private var firebaseManager = FirebaseManager()
    private var ref: DatabaseReference!
    override func viewDidLoad() {
        super.viewDidLoad()
        if let currentUser = Auth.auth().currentUser  {
            ref = Database.database().reference(withPath: "users").child(currentUser.uid)
        }
        
        selectedTeam = UserDefaults.standard.integer(forKey: "team")
        selectedField = UserDefaults.standard.integer(forKey: "field")
        purchasedFields = UserDefaults.standard.array(forKey: "purchasedFields") as? [Int]
        purchasedTeams = UserDefaults.standard.array(forKey: "purchasedTeams") as? [Int]
        gold = UserDefaults.standard.integer(forKey: "gold")
        coinLabel.text = "\(gold)"
        updateShop()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ref.child("gold").observe(.value) { [weak self] snapshot,_   in
            if let gold = snapshot.value as? Int {
                self?.gold = gold
                self?.updateShop()
            }
        }
    }
    
    func updateShop(){
        for (index, button) in footballFields.enumerated() {
            if purchasedFields!.contains(index + 1) {
                if index == selectedField - 1 {
                    button.setTitle("Selected", for: .normal)
                }else{
                    button.setTitle("Select", for: .normal)
                }
            }else {
                button.setTitle("500", for: .normal)
            }
           
        }
        for (index, button) in teamButtons.enumerated() {
            if purchasedTeams!.contains(index + 1) {
                if index == selectedTeam - 1 {
                    button.setTitle("Selected", for: .normal)
                }else{
                    button.setTitle("Select", for: .normal)
                }
            }else {
                button.setTitle("1000", for: .normal)
            }
           
        }
        
        coinLabel.text = "\(String(describing: gold!))"
        
    }

    @IBAction func backButtonClicked(_ sender: UIButton) {
        UserDefaults.standard.set(gold, forKey: "gold")
        firebaseManager.saveCoins(gold)
        saveselectedTeam(name: selectedTeam)
        dismiss(animated: true)
       
    }
    
    
    @IBAction func footballFieldsButtonClicked(_ sender: UIButton) {
        if sender.titleLabel?.text! == "500" && gold >= 500{
            var indexField = sender.tag + 1
            purchasedFields.append(indexField)
            ShoppingManager.shared.purchasedField(field: indexField)
            gold -= 500
        }else if sender.titleLabel?.text! == "Select" {
            sender.titleLabel?.text = "Selected"
            selectedField = sender.tag + 1
            UserDefaults.standard.set(selectedField, forKey: "field")
            
        }
        updateShop()
    }
    
    func saveselectedTeam(name: Int){
        let ref = ref.child("team")
        ref.removeValue()
        ref.setValue(name)
    }
    @IBAction func teamButtonsCliked(_ sender: UIButton) {
        if sender.titleLabel?.text! == "1000" && gold >= 1000{
            var indexField = sender.tag + 1
            purchasedTeams.append(indexField)
            ShoppingManager.shared.purchasedTeam(team: indexField)
            gold -= 1000
        }else if sender.titleLabel?.text! == "Select" {
            sender.titleLabel?.text = "Selected"
            selectedTeam = sender.tag + 1
            UserDefaults.standard.set(selectedTeam, forKey: "team")
        }
        updateShop()
    }
}
