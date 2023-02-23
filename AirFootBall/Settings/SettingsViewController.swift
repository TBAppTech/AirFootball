import UIKit
import Firebase

class SettingsViewController: PortraitViewController {
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var avatarButton: UIButton!
    @IBOutlet weak var soundsLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var settingsLabel: UILabel!
    @IBOutlet weak var musicLabel: UILabel!
    @IBOutlet weak var musicSwitch: UISwitch!
    @IBOutlet weak var soundsSwiftch: UISwitch!
    @IBOutlet weak var numberOfGoalsLabel: UILabel!
    @IBOutlet weak var goalStepper: UIStepper!
    private var avatar: UIImage?
    private var firebaseManager = FirebaseManager()
    var imagePicker = UIImagePickerController()
    let textFont = "Palatino Bold"
    
    //var user: Users!
    var ref: DatabaseReference!
    var playerName = "Player"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if UIDevice.current.userInterfaceIdiom == .phone{
            settingsLabel.font = UIFont(name: textFont, size: 26)
            soundsLabel.font = UIFont(name: textFont, size: 17)
            musicLabel.font = UIFont(name: textFont, size: 17)
            userNameLabel.font = UIFont(name: textFont, size: 17)
            saveButton.titleLabel?.font = UIFont(name: textFont, size: 26)
        }else {
            settingsLabel.font = UIFont(name: textFont, size: 56)
            soundsLabel.font = UIFont(name: textFont, size: 27)
            musicLabel.font = UIFont(name: textFont, size: 27)
            userNameLabel.font = UIFont(name: textFont, size: 27)
            saveButton.titleLabel?.font = UIFont(name: textFont, size: 46)
        }
        
        settingsLabel.textColor = .white
        let selectedTeam = UserDefaults.standard.integer(forKey: "team")
        
        avatar = UIImage(named: "team\(selectedTeam)")
        avatarButton.setImage(avatar, for: .normal)
        saveButton.setTitleColor(.black, for: .normal)
        userNameTextField.backgroundColor = .white
        userNameTextField.delegate = self
        addDoneButtonTo(userNameTextField)
        userNameTextField.placeholder = playerName
        if let goals = UserDefaults.standard.value(forKey: "Rounds") as? Double {
            goalStepper.value = goals
        }else {
            goalStepper.value = 3.0
        }
        
        if UserDefaults.standard.string(forKey: "Sound") != "Off"{
            soundsSwiftch.isOn = true
        }else {
            soundsSwiftch.isOn = false
        }
        
        if UserDefaults.standard.string(forKey: "Music") != "Off"{
            musicSwitch.isOn = true
        }else {
            musicSwitch.isOn = false
        }
        
        
        numberOfGoalsLabel.text = "Goals: \(Int(goalStepper.value))"
       // numberOfGoalsLabel.textColor = .white
        goalStepper.layer.cornerRadius = 15
        guard let currentUser = Auth.auth().currentUser else {return}
        //user = Users(user: currentUser)
        ref = Database.database().reference(withPath: "users").child(currentUser.uid)
        
        //наблюдатель когда клавиатура появиться
        NotificationCenter.default.addObserver(self, selector: #selector(kbDidShow), name: UIResponder.keyboardDidShowNotification, object: nil)
        //наблюдатель когда клавиатура пропадет
        NotificationCenter.default.addObserver(self, selector: #selector(kbDidHide), name: UIResponder.keyboardDidHideNotification, object: nil)
        
        addTapGestureToHideKeyboard()
    }
    
 
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //создаем наблюдателя за нашей баззой данных
        ref.child("playerName").observe(.value) { [weak self] snapshot  in
            if let userName = snapshot.value as? String {
                self?.userNameTextField.text = userName

            }
            
        }
        ref.child("team").observe(.value) { [weak self] snapshot,_   in
            if let team = snapshot.value as? Int {
                let teamName = "team\(team)"
                
                self?.avatar = UIImage(named: teamName)
                self?.avatarButton.setImage(self?.avatar, for: .normal)
            }
            
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.ref.removeAllObservers()
    }
    func addTapGestureToHideKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapGesture))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func tapGesture() {
        userNameTextField.resignFirstResponder()
    }
    
    @objc func kbDidShow(notification: Notification){
        //получаем размер клафиатуры
        guard let userInfo = notification.userInfo else {return}
        guard let scrollView = self.view as? UIScrollView else { return }
        let kbFrameSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        scrollView.contentSize = CGSize(width: self.view.bounds.size.width,
                                        height: self.view.bounds.size.height + 100)
        scrollView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0,
                                                        bottom: kbFrameSize.height, right: 0)
        scrollView.setContentOffset(CGPoint(x: 0, y: 100), animated: true)
        
    }
    
    @objc func kbDidHide(notification: Notification){
        guard let scrollView = self.view as? UIScrollView else { return }
            scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                scrollView.contentSize = CGSize(width: self.view.bounds.size.width,
                                                height: self.view.bounds.size.height)
            }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    

    @IBAction func goalStepper(_ sender: UIStepper) {
        numberOfGoalsLabel.text = "Goals: \(Int(sender.value))"
        UserDefaults.standard.set(Int(sender.value), forKey: "Rounds")
        
    }
    
    @IBAction func saveSettingsClicked(_ sender: UIButton) {
        savePlayerName(name: playerName)
        dismiss(animated: true)
    }
    
    @IBAction func backButtonClicked(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction func musicSwitchClicked(_ sender: UISwitch) {
        if musicSwitch.isOn {
            UserDefaults.standard.set("On", forKey: "Music")
            SKTAudio.sharedInstance().playBackgroundMusic("MenuSong2.mp3")
        }else{
            UserDefaults.standard.set("Off", forKey: "Music")
            SKTAudio.sharedInstance().pauseBackgroundMusic()

        }
        
    }
    
    @IBAction func soundsSwitchClicked(_ sender: UISwitch) {
        if soundsSwiftch.isOn {
            UserDefaults.standard.set("On", forKey: "Sound")
        }else{
            UserDefaults.standard.set("Off", forKey: "Sound")
            

        }
    }
    func savePlayerName(name: String){
        let ref = ref.child("playerName")
        ref.removeValue()
        ref.setValue(name)
    }
        
}


extension SettingsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard textField.text != nil && textField.text != " " else {
            let alert  = UIAlertController(title: "Wrong format!", message: "Please enter correct name.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            
            return }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        playerName = text
        let newLength = text.count + string.count - range.length
        return newLength <= 10
    }
    
    func addDoneButtonTo(_ textField: UITextField) {
        
        let keyboardToolbar = UIToolbar()
        textField.inputAccessoryView = keyboardToolbar
        keyboardToolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title:"Done",
                                         style: .done,
                                         target: self,
                                         action: #selector(didTapDone))
        
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                            target: nil,
                                            action: nil)
        
        
        
        keyboardToolbar.items = [flexBarButton, doneButton]
    }
    
    @objc private func didTapDone() {
        view.endEditing(true)
    }
}
