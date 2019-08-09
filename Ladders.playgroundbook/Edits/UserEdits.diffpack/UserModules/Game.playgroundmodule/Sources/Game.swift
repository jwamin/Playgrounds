public class Game {
    
    public private(set) var state:GameState
    var players = [Player]()
    var currentTurn:Int = 0
    var dice:Dice
    public var numberOfPlayers:Int {
        return players.count
    }
    
    public func currentPositionForPlayer(number:Int)->Int{
        return players[number].currentPosition
    }
    
    public init(numberOfPlayers:Int = 2,dice:Dice = Dice()){
        state = .notStarted
        for x in 0..<numberOfPlayers{
            let newPlayer = Player(type: .com)
            players.append(newPlayer)
        }
        self.dice = dice
    }
    
    public func nextTurn(){
        if(state != .finished){
        currentTurn += 1
        if currentTurn>=numberOfPlayers{
            currentTurn = 0
        }
        }
    }
    
    func resetGame(){
        
        for var player in players{
            player.reset()
        }
        
        state = .notStarted
    }
    
    public func performTurn(config:BoardConfiguration,_ callback:()->()){
        
        if (state == .notStarted){
            state = .playing
        }
        
        if(state == .finished){
            resetGame()
            callback()
            return
        }
        
        let currentPlayer = players[currentTurn]
        let roll = dice.roll()
        print("player \(currentTurn+1)'s turn")
        let newPosition = currentPlayer.currentPosition + roll
        
        if let eventSquare = config.isEventSquare(number: newPosition){
            
            currentPlayer.currentPosition = eventSquare.to
        } else {
            currentPlayer.currentPosition = newPosition
        }
        
        if currentPlayer.currentPosition>100{
            let toWin = (currentPlayer.currentPosition - 100)
            currentPlayer.currentPosition = 100 - toWin
            print("oh no! now on \(currentPlayer.currentPosition), you need to roll a \(toWin) to win")
        }
        
        print("player \(currentTurn+1) now on \(currentPlayer.currentPosition)")
        
        if currentPlayer.currentPosition == 100{
            state = .finished
            print("player \(currentTurn+1) is the winner")
        }
        
        self.nextTurn()
        callback()
    }
    
}

public enum GameState{
    case notStarted
    case playing
    case finished
}
