import UIKit
import Game

let colors:[UIColor] = [
.yellow,
.cyan,
.magenta,
.black
]

public class GameBoardController : UIViewController{
    
    var gameView: GameBoard!
    let config:BoardConfiguration
    let game:Game
    var counters = [UIView]()
    let counterRect = CGRect(x:0,y:0,width:40,height:40)
    public init(config:BoardConfiguration = .basic){
        self.config = config
        print(config.alternating)
        game = Game()
        
        super.init(nibName: nil, bundle: nil)
        
        
    }
    
    private func setupCounters(){
        if counters.count == 0{ 
        for index in 0..<game.numberOfPlayers{
            //using frames for counters
            let counter = UIView(frame:counterRect)
            counter.backgroundColor = colors[index]
            counter.translatesAutoresizingMaskIntoConstraints = false
            if (counter.backgroundColor == .black){
                counter.layer.borderWidth = 1.0
                counter.layer.borderColor = UIColor.white.cgColor
            }
            counter.layer.cornerRadius = counterRect.width / 2
            counter.layer.zPosition = 1
            counters.append(counter)
            gameView.addSubview(counter)
        }
        }
    }
    
    func updateCounters(_ animated:Bool = false){
        let block = {
        for (index,counter) in self.counters.enumerated(){ 
        counter.center = self.gameView.getCenterOfSquareInView(index:self.game.currentPositionForPlayer(number: index)) ?? .zero
        }
        }
        
        if animated {
            UIView.animate(withDuration: 1.0) { 
                block()
            }
        } else {
            block()
        }
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        
        gameView = GameBoard(config: config)
        view.addSubview(gameView)
        
        setupCounters()
        //displayErrorsIfAny()
        
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        game.performTurn(config: config){
            updateCounters(true)
        }
    }
    
    func displayErrorsIfAny(_ action:Any?){
        print("called")
        if config.errorsDisplayed == false && config.initErrors.count > 0 { 
            print("errornotdisplayed")
            //if let errors = config.initErrors{ 
            print("inside called")
            displayNextError(nil)
            //}
            //config.setErrorsDisplayed()
        }
        config.setErrorsDisplayed()
    }
    
    func displayNextError(_ action: Any?){
        print("called")
        if let error = config.popFirstError(){
            print(error.localizedDescription)
            displayError(errorString:error.localizedDescription)
        }
        //config.setErrorsDisplayed()
        
    }
    
    private func displayError(errorString:String){
        
        var errorScreen:UIAlertController = {
            let vc = UIAlertController(title: "error", message: "there was an error", preferredStyle: .alert)
            print("hello?")
            vc.addAction(UIAlertAction(title: "ok", style: .default, handler: { action in
                print("hello")
                self.displayNextError(nil)
            }))
            return vc
        }()
        
        
        errorScreen.message = errorString
        self.present(errorScreen,animated:true)
    
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        gameView.setupPaths()
        updateCounters()
        //self.displayErrorsIfAny(nil)
        
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        print("appeared")
        self.displayErrorsIfAny(nil)
    }
    
    public override func viewSafeAreaInsetsDidChange() {
        gameView.setupPaths()
        
    }
    
    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        gameView.setupPaths()
        
    }
    
    public override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        gameView.setupPaths()
    }
    
}

public class GameBoard : UIView{
    
    var myConstraints:[NSLayoutConstraint]?
    var rowConstraints:[NSLayoutConstraint]?
    
    let boardConfiguration:BoardConfiguration
    
    var squares = [NumberView]()
    var imageViews = [UIImageView]()
    
    var pathsAreSetup:Bool = false {
        didSet{
            print("now \(pathsAreSetup)")
        }
    }
    
    public init(config:BoardConfiguration){
        boardConfiguration = config
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = UIColor.red
        
        var rowConstraints = [NSLayoutConstraint]()
        
        var previous:UIView?
        print(boardConfiguration.alternating,boardConfiguration.ascending)
        for i in 1...10 {
            
            let rowAdjust:Int = {
                if i == 1{
                    return 1
                } else {
                    return  ((i-1) * 10)+1
                }
            }()
            
            let row = self.addRow(start: rowAdjust, of: 9, for: i)
            
                //add squares to board squares array
            for square in row.subviews as! [NumberView]{
                squares.append(square)
            }
            
            constrainRowInBoard(rowIndex: i, row: row,previous: previous, pointerLayoutConstraints: &rowConstraints)
            previous = row
        }
        self.rowConstraints = rowConstraints
        
        //setupPaths()
        
        
    }
    
//      public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//          
//          //test touch
//          
//          let touchPoint = touches.first!.location(in: self)
//          
//          for square in squares{
//              //let convertedFrame = self.convert(touchPoint, to: square)
//              if let hit = self.hitTest(touchPoint, with: event) as? NumberView{
//                  print(hit.convert(hit.center, to: self),self.frame.size)
//                  break
//              }
//          }
//          
//      }
    
    func constrainRowInBoard(rowIndex:Int,row:UIView,previous:UIView?, pointerLayoutConstraints:inout [NSLayoutConstraint]){
        
        let i = rowIndex
        row.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(row)
        
        pointerLayoutConstraints += [row.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.1),row.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1.0)
            ]
        
        if boardConfiguration.ascending{
        
        pointerLayoutConstraints += [
                           row.leadingAnchor.constraint(equalTo: self.leadingAnchor)]
        
        if previous != nil{
            //constrain row top, to bottom of previous
            pointerLayoutConstraints += [
                row.topAnchor.constraint(equalTo: previous!.bottomAnchor)
            ]
        } 
        if(i == 1){
            pointerLayoutConstraints += [row.topAnchor.constraint(equalTo: self.topAnchor)]
        }
        
        } else {
            pointerLayoutConstraints += [row.leadingAnchor.constraint(equalTo: self.leadingAnchor)]
            
            if previous != nil{
                //constrain row top, to bottom of previous
                pointerLayoutConstraints += [
                    row.bottomAnchor.constraint(equalTo: previous!.topAnchor)
                ]
            } 
            if(i == 1){
                pointerLayoutConstraints += [row.bottomAnchor.constraint(equalTo: self.bottomAnchor)]
            }
        }
        
    }


    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addRow(start:Int,of length:Int = 10,for rowNo:Int)->UIView{
        let container = UIView()
        var previousTile:UIView?
        
        //print("from \(start+rowAdjust) to \(start+length+rowAdjust)")
        let evenRow = rowNo % 2 == 0
        let arr = Array(start...(start+length))
        
        print(boardConfiguration.alternating)
        
        let orderedArray = (boardConfiguration.alternating) ? (evenRow) ? arr : arr.reversed() : arr
        orderedArray
        
        for num in orderedArray{ 
            let tile = NumberView(number:num)
            tile.translatesAutoresizingMaskIntoConstraints = false
            container.addSubview(tile)
            
            // Alternate the tile color
            let test = (evenRow&&boardConfiguration.alternating) ? ((num+rowNo) % 2 != 0) : ((num+rowNo) % 2 == 0) 
            tile.backgroundColor = test ? UIColor.black : UIColor.white
            
            tile.label.textColor = test ? UIColor.white : UIColor.black
            
            for eventSq in boardConfiguration.getEventSquares(){
                if num == eventSq.from || num == eventSq.to{
                    if(eventSq.type == .snake){
                        tile.backgroundColor = .red
                        tile.label.textColor = .white
                    } else {
                        tile.backgroundColor = .blue
                        tile.label.textColor = .white
                    }
                }
            }
            
            
                //alternate
            
            
            // Set height, top and bottom constraints of a tile.
            tile.heightAnchor.constraint(equalTo: tile.widthAnchor).isActive = true
            tile.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
            tile.bottomAnchor.constraint(equalTo: container.bottomAnchor).isActive = true
            
            // Join the leading anchor of current tile with trailing anchor of previous tile.
            // Also add equal width constraint between previous and current tile.
            if previousTile != nil {
                tile.leadingAnchor.constraint(equalTo: previousTile!.trailingAnchor).isActive = true
                tile.widthAnchor.constraint(equalTo: previousTile!.widthAnchor).isActive = true
            }
            
            // If first tile, add leading with container
            if num == orderedArray.first! {
                tile.leadingAnchor.constraint(equalTo: container.leadingAnchor).isActive = true
            }
                // If last tile, add trailing with container
            else if num == orderedArray[orderedArray.endIndex-1] {
                tile.trailingAnchor.constraint(equalTo: container.trailingAnchor).isActive = true
            }
            
            previousTile = tile
        }
        return container
    }
    
    public func setupPaths(){
        
        for imageview in imageViews{
            imageview.removeFromSuperview()
            
        }
        imageViews.removeAll()
        
        let squares = boardConfiguration.getEventSquares()
        var points = [(CGPoint,CGPoint,SnakeOrLadder,Int)]()
        for (index,event) in squares.enumerated(){
                
                if let from = numberSquareForIndex(event.from), let to = numberSquareForIndex(event.to){
                    
                    //print(from.number,to.number,self.frame.size)
                    let centerOfElement = CGPoint(x: from.bounds.midX, y: from.bounds.midY)
                    
                    //we need to do these superview coordinate calculations because the .center attribute of the tile is in relation to the tile's superview, the 'row' not the actual gameboard square
                    
                    let centerFrom = from.convert(centerOfElement, to: self)
                    
                    let centerTo = to.convert(centerOfElement, to: self)
                    
                    print(centerTo,to.center)
                    print(centerFrom,from.center)
                    points.append((centerFrom,centerTo,event.type,index))
                    
                    //points.append((from.center,to.center))
                    
            }
            
        }
        UIGraphicsBeginImageContext(self.frame.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setLineWidth(10)
        
        
        for (point1,point2,type,index) in points{
            context?.beginPath()
            
            if (type == .ladder){ context?.setStrokeColor(UIColor.green.cgColor)
                
                context?.move(to: point1)
            context?.addLine(to: point2)
                //context?.setAlpha(0.7)
            
            } else {
                
                context?.setStrokeColor(UIColor.red.cgColor)
                
                let p1 = point1
                let p2 = point2
                let dx = p2.x - p1.x
                let dy = p2.y - p1.y
                let d = sqrt(dx * dx + dy * dy)
                let a = atan2(dy, dx)
                let cosa = cos(a) // Calculate only once...
                let sina = sin(a) // Ditto
                
                // Initialise our path
                let path = CGMutablePath()
                path.move(to: p1)
                
                let randomFrequency:CGFloat
                if(boardConfiguration.getEventSquares()[index].frequency == nil){
                    boardConfiguration.getEventSquares()[index].frequency = Int.random(in: 2...10)
                }
                
                randomFrequency = CGFloat(boardConfiguration.getEventSquares()[index].frequency!)
                
                // Plot a parametric function with 100 points
                let nPoints = 100
                for t in 0 ... nPoints {
                    // Calculate the un-transformed x,y
                    let tx = CGFloat(t) / CGFloat(nPoints) // 0 ... 1
                    
                    print(randomFrequency)
                    let ty = 0.1 * sin(tx * randomFrequency * CGFloat.pi ) // 0 ... 2π, arbitrary amplitude
                    // Apply the transform
                    let x = p1.x + d * (tx * cosa - ty * sina)
                    let y = p1.y + d * (tx * sina + ty * cosa)
                    // Add the transformed point to the path
                    path.addLine(to: CGPoint(x: x, y: y))
                }
                context?.addPath(path)
            }
            context?.strokePath()
            
        }
        
        context?.stroke(self.bounds)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        if let image = image{
            image
            let imageView = UIImageView(image: image)
            //imageView.frame.origin = .zero
            imageView
            self.addSubview(imageView)
            imageViews.append(imageView)
        }
        
    }
    
    func numberSquareForIndex(_ index:Int)->NumberView?{
        
        return squares.first(where: { (square) -> Bool in
            square.number == index
        })
        
    }
    
    func getCenterOfSquareInView(index:Int)->CGPoint?{
        if let square = numberSquareForIndex(index){
            let centerOfElement = CGPoint(x: square.bounds.midX, y: square.bounds.midY)
            print(square.center)
            return square.convert(centerOfElement, to: self)
            
        }
        return nil
        
        
    }
    
    public override func updateConstraints() {
        
        if(myConstraints == nil){
            
            //let views = ["self":self]
            
            let constraints = [
                //width and height
                self.widthAnchor.constraint(lessThanOrEqualTo: self.superview!.widthAnchor, multiplier: 1.0),
            self.heightAnchor.constraint(lessThanOrEqualTo: self.superview!.heightAnchor, multiplier: 1.0),
            
            self.widthAnchor.constraint(equalTo: self.heightAnchor),
            
            //vertical and horizontal position
            self.safeAreaLayoutGuide.centerXAnchor.constraint(equalTo: self.superview!.centerXAnchor),
            self.safeAreaLayoutGuide.centerYAnchor.constraint(equalTo: self.superview!.centerYAnchor),
                
            ]
            
            var lowerPriorityConstraints = [NSLayoutConstraint]()
            
            let vertical = self.heightAnchor.constraint(equalTo: self.superview!.heightAnchor, multiplier: 1.0)
            vertical.priority = UILayoutPriority(750)
            
            let horizontal = self.widthAnchor.constraint(equalTo: self.superview!.widthAnchor, multiplier: 1.0)
            horizontal.priority = vertical.priority
            
            lowerPriorityConstraints.append(vertical)
            lowerPriorityConstraints.append(horizontal)
            
            
            
            //let rowConstraints = [NSLayoutConstraint]()
            NSLayoutConstraint.activate(constraints+lowerPriorityConstraints+(rowConstraints ?? []))
            
            self.myConstraints = constraints
            
        }
        
        super.updateConstraints()
    }
    
}


class NumberView : UIView{
    
    let label = UILabel()
    let number:Int
    var myConstraints:[NSLayoutConstraint]?
    
    init(number:Int) {
        self.number = number
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "\(number)"
        
        self.addSubview(label)
        self.backgroundColor = UIColor.white
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.black.cgColor
    }
    
    override func updateConstraints() {
        if(myConstraints == nil){
            
            var constraints = [
                self.safeAreaLayoutGuide.widthAnchor.constraint(equalTo: self.superview!.widthAnchor, multiplier: 0.1),
                               self.safeAreaLayoutGuide.heightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.widthAnchor, multiplier: 1),
                               label.safeAreaLayoutGuide.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
                               label.safeAreaLayoutGuide.centerYAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerYAnchor)
            ]
            
            
            NSLayoutConstraint.activate(constraints)
            
            self.myConstraints = constraints
            
        }
        super.updateConstraints()
    }
    
    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
