import SpriteKit
import MultipeerConnectivity
import Firebase


var adsAreDisabled = false
var textureAtlas = [SKTextureAtlas]()
var GameIsPaused : Bool?
let deviceType = UIDevice.current.model
let screenRect = UIScreen.main.bounds
let screenWidth = screenRect.size.width
let screenHeight = screenRect.size.height
let screenPixels = screenWidth * screenHeight
var multipeerGameReady = false

var hasTopNotch: Bool
{
    if #available(iOS 11.0, tvOS 11.0, *)
    {
        return UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0 > 20
    }
    return false
}


class GameViewController: PortraitViewController{
    
    private var firebaseManager = FirebaseManager()
    var ref: DatabaseReference!
    override func viewDidLoad(){
        super.viewDidLoad()
        guard let currentUser = Auth.auth().currentUser else {return}
        ref = Database.database().reference(withPath: "users").child(currentUser.uid)
       
        if UserDefaults.standard.string(forKey: "Music") != "Off"{
            SKTAudio.sharedInstance().playBackgroundMusicFadeIn("MenuSong2.mp3")
        }
        startScene()
        setupUserDefaults()
    }
    
    private func setupUserDefaults(){
        if  UserDefaults.standard.value(forKey: "gold") == nil{
            UserDefaults.standard.set(1000, forKey: "gold")
            
            let ref = ref.child("gold")
            ref.setValue(1000)
        }
        
        if  UserDefaults.standard.value(forKey: "team") == nil{
            UserDefaults.standard.set(1, forKey: "team")
            
            let ref = ref.child("team")
            ref.setValue(1)
        }
        
        if  UserDefaults.standard.value(forKey: "playerName") == nil{
            UserDefaults.standard.set(1, forKey: "playerName")
            
            let ref = ref.child("playerName")
            ref.setValue("Player")
        }
       
   
        
        if  UserDefaults.standard.value(forKey: "field") == nil{
            UserDefaults.standard.set(1, forKey: "field")
            
            let ref = ref.child("field")
            ref.setValue(1)
        }
        
        if  UserDefaults.standard.value(forKey: "purchasedFields") == nil{
            let field = [1]
            UserDefaults.standard.set(field, forKey: "purchasedFields")
            UserDefaults.standard.synchronize()
        }
        
        if  UserDefaults.standard.value(forKey: "purchasedTeams") == nil{
            let team = [1]
            UserDefaults.standard.set(team, forKey: "purchasedTeams")
            UserDefaults.standard.synchronize()
        }
        
    }

    func startScene(){
        let scene = MenuScene(size: view.bounds.size)
        let skView = self.view as! SKView
        
        skView.isMultipleTouchEnabled = false
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .resizeFill

        skView.presentScene(scene)
    }
    
 
    override var shouldAutorotate : Bool{
        return false
    }


    override func didReceiveMemoryWarning(){
        super.didReceiveMemoryWarning()
    }

    override var prefersStatusBarHidden : Bool{
        return true
    }
}

extension SKNode {
    class func unarchiveFromFile(_ file : NSString) -> SKNode?
    {
        if let path = Bundle.main.path(forResource: file as String, ofType: "sks")
        {
            let sceneData = try! Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            let archiver = NSKeyedUnarchiver(forReadingWith: sceneData)
            
            archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
            let scene = archiver.decodeObject(forKey: NSKeyedArchiveRootObjectKey) as! AirHockey2P
            archiver.finishDecoding()
            return scene
        }
        else
        {
            return nil
        }
    }
}
