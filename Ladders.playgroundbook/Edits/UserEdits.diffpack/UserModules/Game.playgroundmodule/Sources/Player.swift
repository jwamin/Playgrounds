enum PlayerType{
    case human
    case com
}

class Player {
    
    let type:PlayerType
    static let startingPosition = 1
    var currentPosition:Int = Player.startingPosition
    
    init(type:PlayerType){
        self.type = type
    }
    
    public func reset(){
        currentPosition = Player.startingPosition
    }
    
}
