import UIKit

class CompletedTodoViewController: UIViewController, TodoEndPointViewController {
    let middleWare = AppDelegate.middleware
    let boardType: TodoBoard = .completed
    
    @IBOutlet weak var tableView: TodoTableView!
    
    private var tableViewManagement: TodoTableViewManagement? {
        didSet {
            tableView.management = tableViewManagement
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewManagement = TodoTableViewManagement(tableView, in: boardType)
        
        NotificationCenter.default.addObserver(
            forName: boardType.notificationName,
            object: middleWare,
            queue: .main)
        { [weak self] noti in
            
            guard
                let info = noti.userInfo,
                let result = info["result"] as? Result<[CardData], DataTaskError>
            else {
                return
            }
            
            switch result {
            case .success(let data):
                guard let self = self else { return }
                self.tableViewManagement?.setDataSource(data: data)
            case .failure(let error):
                Log.error(error)
            }
        }
    }
}
