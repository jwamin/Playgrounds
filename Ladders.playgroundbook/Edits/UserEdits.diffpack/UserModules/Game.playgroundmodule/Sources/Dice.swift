public class Dice {
    
    private let dice:Int
    
    public init(number:Int = 1){
        dice = number
    }
    
    public func roll()->Int{
        var sum = 0
        
        for _ in 0..<dice{
            sum += Int.random(in: 1...6)
        }
        return sum
    }
    
    public func numberOfDice()->Int{
        return dice
    }
    
}
