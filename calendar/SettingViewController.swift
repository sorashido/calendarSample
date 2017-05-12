import QuickTableViewController
import GoogleSignIn
import GoogleAPIClientForREST

//var gEvents:[GTLRCalendar_Event] = []
class SettingViewController: QuickTableViewController, GIDSignInDelegate, GIDSignInUIDelegate{
    
    private let service = GTLRCalendarService()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableContents = [
            Section(title: "Sync Calendar", rows: [
                TapActionRow(title: "Sync Calendar", action: { [weak self] in self?.calendarSync($0) }),
                ]),

            Section(title: "Switch", rows: [
                SwitchRow(title: "Setting 1", switchValue: true, action: { _ in }),
                SwitchRow(title: "Setting 2", switchValue: false, action: { _ in }),
                ]),
            
            Section(title: "Calendar", rows: [
                TapActionRow(title: "Add google calendar", action: { [weak self] in self?.signIn($0) }),
                NavigationRow(title: "Default", subtitle: .none),
                ]),
            
            Section(title: "Exit", rows:[
                TapActionRow(title: "Exit", action: { [weak self] in self?.exit($0) }),
                ]),
        ]
        
        /* google sign in for calendar*/
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().scopes = [kGTLRAuthScopeCalendarReadonly]
        GIDSignIn.sharedInstance().signInSilently()
    }
    
    private func signIn(_ sender: Row) {
        GIDSignIn.sharedInstance().signIn()
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        if let error = error {
            showAlert(title: "Authentication Error", message: error.localizedDescription)
            self.service.authorizer = nil
        } else {
            self.service.authorizer = user.authentication.fetcherAuthorizer()
            fetchEvents()
        }
    }

    private func calendarSync(_ sender: Row){
        fetchEvents()
    }
    
    // Construct a query and get a list of upcoming events from the user calendar
    private func fetchEvents() {
        let query = GTLRCalendarQuery_EventsList.query(withCalendarId: "primary")
        query.maxResults = 10
        query.timeMin = GTLRDateTime(date: Date())
        query.singleEvents = true
        query.orderBy = kGTLRCalendarOrderByStartTime
        service.executeQuery(
            query,
            delegate: self,
            didFinish: #selector(displayResultWithTicket(ticket:finishedWithObject:error:)))
    }
    
    // Display the start dates and event summaries in the UITextView
    @objc private func displayResultWithTicket(
        ticket: GTLRServiceTicket,
        finishedWithObject response : GTLRCalendar_Events,
        error : NSError?) {
        
        if let error = error {
            showAlert(title: "Error", message: error.localizedDescription)
            return
        }
        
//      gEvents = response.items!
        if let events = response.items, !events.isEmpty {
            for event in events {
                let start = event.start!.dateTime ?? event.start!.date!
                let startString = DateFormatter.localizedString(
                    from: start.date,
                    dateStyle: .short,
                    timeStyle: .short)
//                outputText += "\(startString) - \(event.summary!)\n"
            }
        } else {
//            outputText = "No upcoming events found."
        }
    }
    
    // Helper for showing an alert
    private func showAlert(title : String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: UIAlertControllerStyle.alert
        )
        let ok = UIAlertAction(
            title: "OK",
            style: UIAlertActionStyle.default,
            handler: nil
        )
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
    private func exit(_ sender: Row) {
        self.dismiss(animated: true, completion: nil)
    }
}
