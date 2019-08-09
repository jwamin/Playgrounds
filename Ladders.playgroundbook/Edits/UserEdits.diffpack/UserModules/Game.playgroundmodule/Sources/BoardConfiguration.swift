import Foundation 

public enum SnakeOrLadder : String{
    case snake = "Snake"
    case ladder = "Ladder"
}

public class EventSquare{
    public init(from:Int,to:Int){
        self.from = from
        self.to = to
    }
    
    public let from:Int
    public let to:Int
    public var type:SnakeOrLadder{
        return (from>to) ? .snake : .ladder
    }
    public var frequency:Int?
}

public class BoardConfiguration{
    
    public static var basic = BoardConfiguration(ascending: false, alternating: true)
    
    public static var ascending = BoardConfiguration(ascending: true, alternating: false)
    
    public static var ascendingAlternating = BoardConfiguration(ascending: true, alternating: true)
    
    //EventSquares
    private var snakesNLadders = [EventSquare]()
    
    public private(set) var initErrors = [SnakesLadderError]() {
        didSet{
            print(initErrors.count)
        }
    }
    
    public private(set) var errorsDisplayed = false
    
    public func setErrorsDisplayed(){
        errorsDisplayed = true
    }
    
    public func popFirstError()->SnakesLadderError?{
        //print(initErrors?.count)
        if initErrors.count > 0 {
        return initErrors.removeFirst()
        } else{
            return nil
        }
    }
    
    public func addInitError(error:SnakesLadderError){
        if initErrors == nil{
            initErrors = []
        }
        initErrors.append(error)
    }
    
    //Rendering
    //board increments from top left to bottom right
    public let ascending:Bool
    
    //11 is directly below 10, or 
    public let alternating:Bool
    
    public init(ascending:Bool,alternating:Bool){
        self.ascending = ascending
        self.alternating = alternating
    }
    
    public func printEventSquares()->String{
        var string = ""
        for square in snakesNLadders{
            string += "From: \(square.from) To: \(square.to), it's a \(square.type.rawValue)\n"
        }
        return string
    }
    
    public func getEventSquares()->[EventSquare]{
        return snakesNLadders
    }
    
    public func isEventSquare(number:Int)->EventSquare?{
        for square in snakesNLadders{
            if square.from == number{
                return square
                break
            }
        }
        return nil
    }
    
    public func addEventSquare(newSquare:EventSquare) throws{
        
        if newSquare.from == 100{
            throw SnakesLadderError.cannotStartOn100
        }
        
        if newSquare.from == 1{
            throw SnakesLadderError.cannotStartOnOne
        }
        
        for existingSquare in snakesNLadders{
            if existingSquare.from == newSquare.from {
                throw SnakesLadderError.AlreadyAnEventSquare
            }
            if existingSquare.to == newSquare.from {
                throw SnakesLadderError.isAtTheBottomOfAnotherEventSquare
            }
            if newSquare.to == existingSquare.from {
                throw SnakesLadderError.LeadsToAnotherEventSquare
            }
        }
        
        snakesNLadders.append(newSquare)
        
    }
    
}

public enum SnakesLadderError : Error{
    case AlreadyAnEventSquare
    case LeadsToAnotherEventSquare
    case isAtTheBottomOfAnotherEventSquare
    case cannotStartOn100
    case cannotStartOnOne
}
