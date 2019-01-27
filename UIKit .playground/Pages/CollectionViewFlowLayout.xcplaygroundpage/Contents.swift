import UIKit
import PlaygroundSupport
import os

class Cell : UICollectionViewCell{
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        print("hello world")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        self.backgroundColor = UIColor.red
    }
    
}

class SuppView : UICollectionReusableView{
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        print(frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        print("reuse!")
    }
    
}

class ViewController : UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    var collection:UICollectionView!
    var layout:UICollectionViewFlowLayout!
    
    var detailView:DetailView?
    
    override func loadView(){
        print("loading view")
        layout = UICollectionViewFlowLayout()
        
        view = UICollectionView(frame: UIScreen.main.bounds, collectionViewLayout:layout)
        
    }
    
    override func viewDidLoad() {
        print("view loaded")
        collection = (view as! UICollectionView)
        collection.register(Cell.self, forCellWithReuseIdentifier: "cell")
        
        collection.register(SuppView.self, forSupplementaryViewOfKind:UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        
        collection.register(SuppView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "footer")
        
        collection.delegate = self
        collection.dataSource = self
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 3, height: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: 5, height: 20)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Int(floor(Double(arc4random_uniform(20)+1)))
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collection.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! Cell
        cell.backgroundColor = UIColor.red
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        var supp:SuppView!
        print(kind)
        switch kind {
        case UICollectionView.elementKindSectionFooter:
            supp = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "footer", for: indexPath) as! SuppView
            supp.backgroundColor = UIColor.green
        case
        UICollectionView.elementKindSectionHeader:
            supp = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as! SuppView
            supp.backgroundColor = UIColor.yellow
        default:
            break;
        }
        
        return supp
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath)
        if(detailView == nil){
            detailView = DetailView(nibName: nil, bundle: nil)
        }
        print(detailView)
        guard let detailview = detailView else {
            print("err no")
            return
        }
        
        detailview.text = "Section:\(indexPath.section) \n Row:\(indexPath.row                                                  )"
        
        
        
        //OSLog(subsystem: "hello", category: OSLog.Category.pointsOfInterest)
        self.navigationController?.pushViewController(detailview, animated: true)
        
    }
    
}

class DetailView : UIViewController {
    var constraints:[NSLayoutConstraint] = []
    var label:UILabel!
    var text:String = ""
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor.white
        label = UILabel(frame: self.view.frame)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.backgroundColor = UIColor.red
        self.view.addSubview(label)
        
        self.navigationItem.title = "Detail  "
        
        constraints = []
        let views:[String:UIView] = ["label":label]
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "|-[label]-|", options: [], metrics: nil, views: views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-[label]-|", options: [], metrics: nil, views: views)
        NSLayoutConstraint.activate(constraints)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        for constraint in constraints{
            print(constraint.isActive)
        }
        label.text = text
        label.text
        label.isHidden
        
    }
    
}


let navigationController = UINavigationController()
let viewC = ViewController()
navigationController.pushViewController(viewC, animated: true)
viewC.navigationItem.title = "Master"
PlaygroundPage.current.liveView = navigationController



