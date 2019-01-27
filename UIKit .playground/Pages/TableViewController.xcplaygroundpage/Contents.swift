import UIKit
import PlaygroundSupport

class TableViewController : UITableViewController {
    
    var tableItems = [
        [
            "item",
            "another item",
            "yet another item"
        ],
        [
            "ooh an item in another section...",
            "and another",
            "and another",
            "and another"
        ],
        [
            "brup",
            "hello?"
        ]
    ]
    
    let detailView = DetailView()
    
    override func viewDidLoad() {
        
        self.title = "Master"
        detailView.title = "Detail"
        
        self.clearsSelectionOnViewWillAppear = true
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "hf")
        navigationController?.setToolbarHidden(false, animated: true)
        
        var spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        var addbutton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(add))
        var editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(beginEdit))
        self.setToolbarItems([editButton,spacer,addbutton], animated: true)
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return tableItems.count
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if(tableItems[section].count>0){ 
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "hf") as! UITableViewHeaderFooterView
        header.textLabel?.text = "Section \(section)"
        return header
        } else {
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableItems[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = tableItems[indexPath.section][indexPath.row]+" IndexPath: \(indexPath)"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        detailView.updateLabel(str: (tableView.cellForRow(at: indexPath)?.textLabel?.text)!)
        self.navigationController?.pushViewController(detailView, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let item = tableItems[sourceIndexPath.section][sourceIndexPath.row]
        tableItems[sourceIndexPath.section].remove(at: sourceIndexPath.row)
        tableItems[destinationIndexPath.section].insert(item, at: destinationIndexPath.row)
        tableView.reloadData()
        tableItems
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            tableItems[indexPath.section].remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .right)
            case .insert:
                return
        default:
            return
        }

    }
    
    override func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
        updateSectionsInDataSource()
        tableView.reloadData()

    }
    
    func updateSectionsInDataSource(){
        print("updated")
        var removeSections:[Int] = []
        for (index,array) in tableItems.enumerated(){
            if(array.count==0){
                removeSections.append(index)
            }
        }
        if(removeSections.count>0){
                tableView.beginUpdates()
                for section in removeSections{
                    tableItems.remove(at: section)
                }
                let removeSet = IndexSet(removeSections)
                tableView.deleteSections(removeSet, with: .top)
                tableView.endUpdates()
            
        }
    }
    
    
    @objc func beginEdit(){
        tableView.setEditing(!tableView.isEditing, animated: true)
        tableView.isEditing
        let button = (tableView.isEditing) ? UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(beginEdit)) : UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(beginEdit))
        self.setToolbarItems([button,self.toolbarItems![1],self.toolbarItems![2]], animated: true)
        if(!tableView.isEditing){
            updateSectionsInDataSource()
        }
    }
    
    @objc func add(){
        tableItems.count
        tableItems[tableItems.count-1].append(Date().debugDescription)
        tableItems
        let newIndexPath = IndexPath(item: tableItems[tableItems.count-1].count-1, section: tableItems.count-1)
        tableView.insertRows(at: [newIndexPath], with: .right)
        
    }
    
}

class DetailView : UIViewController{
    
    let label = UILabel()
    
    override func viewDidLoad() {
        self.view.addSubview(label)
        self.view.backgroundColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.black
        label.numberOfLines = 0
        label.textAlignment = .center
        setupConstraints()
    }
    
    private func setupConstraints(){
        if(self.view.constraints.count == 0){
            var constraints = [NSLayoutConstraint]()
            var views = ["label":label]
            constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[label]-0-|", options: [], metrics: nil, views: views)
            constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[label]-0-|", options: [], metrics: nil, views: views)
            NSLayoutConstraint.activate(constraints)
        }
    }
    
    func updateLabel(str:String){
        label.text = str
    }
    
}

let nav = UINavigationController(nibName: nil, bundle: nil)
nav.viewControllers = [TableViewController()]


PlaygroundPage.current.liveView = nav
