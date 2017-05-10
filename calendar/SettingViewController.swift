import QuickTableViewController
import GoogleSignIn

class SettingViewController: QuickTableViewController, GIDSignInUIDelegate{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableContents = [
            Section(title: "Switch", rows: [
                SwitchRow(title: "Setting 1", switchValue: true, action: { _ in }),
                SwitchRow(title: "Setting 2", switchValue: false, action: { _ in }),
                ]),
            
            Section(title: "Calendar", rows: [
                TapActionRow(title: "Add google calendar", action: { [weak self] in self?.showAlert($0) }),
                NavigationRow(title: "Default", subtitle: .none),
                ]),
            
            Section(title: "Exit", rows:[
                TapActionRow(title: "Exit", action: { [weak self] in self?.exit($0) }),
                ]),
        ]
        
        /* google sign in*/
        GIDSignIn.sharedInstance().uiDelegate = self
    }
    
    private func showAlert(_ sender: Row) {
        GIDSignIn.sharedInstance().signIn()
        
    }
    
    private func exit(_ sender: Row) {
        // ...
        self.dismiss(animated: true, completion: nil)
    }
}
