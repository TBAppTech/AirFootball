import UIKit
import Firebase


class RatingViewController: PortraitViewController {
    var ref: DatabaseReference!
    
    @IBOutlet weak var ratingTable: UITableView!
    @IBOutlet weak var ratingLabel: UILabel!
    private let cellIdentifier = "ratingCell"
    var users = [User]()
    
    
    
    let playerRating: [Int]! = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UIDevice.current.userInterfaceIdiom == .phone{
            ratingLabel.font = UIFont(name: "Palatino Bold", size: 26)
            ratingTable.rowHeight = 50
            ratingTable.separatorInset = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
        }else {
            ratingLabel.font = UIFont(name: "Palatino Bold", size: 56)
            ratingTable.rowHeight = 100
            ratingTable.separatorInset = UIEdgeInsets(top: 30, left: 16, bottom: 30, right: 16)
        }
        ratingTable.rowHeight = 50
        ratingTable.separatorInset = UIEdgeInsets(top: 50, left: 0, bottom: 10, right: 0)
        ratingLabel.textColor = .white
        ref = Database.database().reference(withPath: "users")
        
        ratingTable.delegate = self
        ratingTable.dataSource = self
        registerCell()
//        //Получение данных из баззы данных
//       let fb = FirebaseManager()
        
       
        

    }
    
  
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //создаем наблюдателя за нашей баззой данных
        ref.observe(.value) { [weak self] snapshot, agr  in
           self?.users = [User]()
                for child in snapshot.children.allObjects as! [DataSnapshot] {
                    let user = User(snapshot: child)
                    self?.users.append(user!)
                }
            self?.users.sort(by: { user1, user2 in
                return user1.gold > user2.gold
            })
            self?.ratingTable.reloadData()
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

    }
    
    private func registerCell() {
        ratingTable.register(UINib(nibName: "RatingCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
        
    }

    @IBAction func backButtonClicked(_ sender: UIButton) {
        
        dismiss(animated: true)
    }
    

}

extension RatingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! RatingCell
        let user = users[indexPath.row]
        cell.teamImage.image = UIImage(named: "team\(user.team)")
        cell.playerLabel.text = user.playerName


        cell.goldLabel.text = String(describing: user.gold)
        cell.selectionStyle = .none

        cell.backgroundColor = .clear
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            
            return 70
        }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
   
}
