
import UIKit
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true
//PlaygroundPage.current.wantsFullScreenLiveView = true

let MAX = 151

struct Pokemon{
    var name:String
    var number:Int
    var img:UIImage
}

class ViewController : UIViewController{
    
    var imageview:UIImageView!
    
    var tasks:DispatchGroup!
    
    var pokedex:[Int:Pokemon] = [:]
    
    override func viewDidLoad() {
        
        //initialise image view
        imageview = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: 300, height: 300)))
        imageview.translatesAutoresizingMaskIntoConstraints = false
        imageview.backgroundColor = UIColor.white
        imageview.contentMode = UIView.ContentMode.center
        imageview.animationDuration = 20
        imageview.animationRepeatCount = Int.max
        imageview.stopAnimating()
        
        
        
        let progress = UIActivityIndicatorView(style: .gray)
        progress.center = CGPoint(x: imageview.center.x, y: imageview.center.y)
        imageview.addSubview(progress)
        progress.startAnimating()
        
        vc.view.addSubview(imageview)
        addConstraints()
        
        //create dispatch group
        tasks = DispatchGroup()

        //add background URLSessions, with index, to dispatch group
        for index in 1...MAX{
            let task = createTask(index: index)
            task.resume()
        }
        
        tasks.notify(queue: .main, execute: { 
            print("complete")
            self.initialiseAndStartAnimation()
        })
        
    }
    
    func createTask(index:Int)->URLSessionDataTask{
        
        tasks.enter()
        
        guard let url = URL(string:"http://pokeapi.co/api/v2/pokemon/\(index)/") else {
            fatalError()
        }
        
        return URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            
            if(error != nil){
                fatalError(error.debugDescription)
            }
            
            guard let data = data else {
                return
            }
            DispatchQueue.global(qos: .utility).async {
                
                
                do{
                    let dict = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String:Any]
                
                    
                    guard let name = dict["name"] as? String, let number = dict["id"] as? Int else {
                        fatalError()
                    }
                    
                    self.pokedex[index] = Pokemon(name: name, number: number, img: UIImage())
                    
                    let spritesDict = dict["sprites"] as! [String:Any]
                    let imgUrl = URL(string:spritesDict["front_default"]! as! String)!

                    let imageTask = URLSession.shared.dataTask(with: imgUrl, completionHandler: {
                        (data,response,error) in

                        let image = UIImage(data: data!, scale: 1.0)
                        self.pokedex[index]!.img = image!
                        
                        //notify DispatchGroup that we are done with this particular last
                        self.tasks.leave()
                        
                        
                    })
                    imageTask.resume()
                    
                } catch {
                    print(error)
                }
            }
            
        })
    }
    
    func initialiseAndStartAnimation(){

        let sortedpokedex = self.pokedex.sorted{$0.key<$1.key}
        var images:[UIImage] = []
        for (index,pokemon) in sortedpokedex{
            print("\(pokemon.number): \(pokemon.name)")
            images.append(pokemon.img)
        }
   
        self.setImages(images: images)
        
    }
    
    func setImages(images:[UIImage]){
        let progress = imageview.subviews[0] as! UIActivityIndicatorView
        progress.stopAnimating()
        progress.removeFromSuperview()
        imageview.image = images.first
        imageview.animationImages = images
        imageview.startAnimating()
    }
    
    
    func addConstraints(){
        if(imageview.constraints.count == 0){
            var views = ["imageview":imageview]; //"H:|-0-[label]-0-|"
            var constraints = [NSLayoutConstraint]()
            constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:[imageview(==300)]", options: [], metrics: nil, views: views)
            constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:[imageview(==300)]", options: [], metrics: nil, views: views)
            NSLayoutConstraint.activate(constraints)
            NSLayoutConstraint(item: imageview, attribute: .centerX, relatedBy: .equal, toItem: vc.view, attribute: .centerX, multiplier: 1.0, constant: 0.0).isActive = true
            NSLayoutConstraint(item: imageview, attribute: .centerY, relatedBy: .equal, toItem: vc.view, attribute: .centerY, multiplier: 1.0, constant: 0.0).isActive = true
            
        }
    }
    
}

let vc = ViewController()
vc.view.backgroundColor = UIColor.gray
PlaygroundPage.current.liveView = vc
