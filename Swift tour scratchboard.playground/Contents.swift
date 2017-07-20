import Foundation

func greet(_ name:String, on day:String) -> String {
    return "hello \(name), it is \(day)"
}
// no explicit argument name given with _

func greet(name:String, on day:String) -> String {
    return "hello \(name), it is \(day)"
}

greet("jossy", on: "Monday")

greet(name:"Tayto",on:"Tuesday")

greet("tora", on: "Tuesday")


let numbers = [43,65,78,34,23,99,100]

numbers.map({
    (number:Int) -> Int in
    if number % 2 == 0 {
        return number
    }
    else {return 0}
})
numbers
numbers.map({number in (number % 2 == 0) ? number : 0})

numbers.sorted {$0<$1}

func takeClosure(myClosure:([Int]) -> [Int]) -> [Int]{
    return myClosure(numbers)
}

enum FamilyMembers {
    case jossy,tora,tayto,sarah,rachel
    func fullName() -> String{
        switch self {
        case .jossy:
            return "call me Jossy" 
        case .tora:
            return "Victoria Naomi Shea"
        case .sarah:
            return "Sarah Catherine Cannon"
        case .tayto:
            return "Messrs Sweet P. & Tayto, Attorneys at law"
        default:
            return String(self.hashValue)
        }
    }
}

let member:FamilyMembers = FamilyMembers.tayto
let member2:FamilyMembers = FamilyMembers.jossy
member.fullName()

func compare(_ familymembers:(FamilyMembers,FamilyMembers)) ->(highestRankingFamilyMember:FamilyMembers,lowestRankingFamilyMember:FamilyMembers){
    if familymembers.0.hashValue < familymembers.1.hashValue {
    return (familymembers.0,familymembers.1)
    } else{
    return (familymembers.1,familymembers.0)
    } 
    
    //return familymembers {$0<$1}
    
}

func compare(_ familymembers:[FamilyMembers]) ->(highestRankingFamilyMember:FamilyMembers,lowestRankingFamilyMember:FamilyMembers,sortedMembers:[FamilyMembers]){
    
    let ranked = familymembers.sorted {$0.hashValue<$1.hashValue}
    return(ranked.first!,ranked.last!,ranked)
}

compare((member, member2))

compare([member,member2])


let toraCalc = (300 + 250 + 400 + 100) * 4

Date()

1500/4


