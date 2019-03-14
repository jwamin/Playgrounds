import Foundation
import PlaygroundSupport

// since dispatch is used, we need indefinite execution
PlaygroundPage.current.needsIndefiniteExecution = true

// CODABLE DATA STRUCTURES, NESTED
// Codable is syntactic sugar for

struct Pokedex : Codable {
    let descriptions:[Description]
    let id:Int
    let is_main_series:Bool
    let name:String
    let names:[Name]
    let pokemon_entries:[PokemonEntry]
    let region:NameURL?
    let version_groups:[NameURL]
    
    enum CodingKeys:String,CodingKey{
        case descriptions
        case id
        case is_main_series
        case name
        case names
        case pokemon_entries
        case region
        case version_groups
    }
    
}

struct PokemonEntry : Codable {
    let entry_number:Int
    let pokemon_species:NameURL
}

struct Name : Codable {
    let language:NameURL
    let name:String
}

struct Description : Codable {
    let description:String
    let language:NameURL
}

struct Pokemon : Codable {
    let abilities:[Ability]
    let forms:[NameURL]
    let species:NameURL
    let weight:Int
    let order:Int
    let name:String
    let height:Int
    let id:Int
    let is_default:Bool
    let location_area_encounters: URL
    let sprites:Sprites
}

struct Stat:Codable {
    let baseStat:Int
    let effort:Int
    let stat:NameURL
}

// this structure is used a lot throughout pokeAPI and appeara nested in a number of other codable structures
struct NameURL:Codable {
    let name:String
    let url:URL
}

struct GameIndex {
    let game_index:Int
    let version:NameURL
}

struct Ability:Codable {
    let ability:NameURL
    let is_hidden:Bool
    let slot:Int
}

struct Type {
    let slot:Int
    let type:NameURL
}


struct Sprites : Codable {
    let back_default:URL?
    let back_female:URL?
    let back_shiny:URL?
    let back_shiny_female:URL?
    let frontDefault:URL?
    let front_female:URL?
    let front_shiny:URL?
    let front_shiny_female:URL?
    
    enum CodingKeys:String,CodingKey{
        case frontDefault = "front_default"
        case back_default
        case back_female
        case back_shiny
        case front_female
        case front_shiny_female
        case back_shiny_female
        case front_shiny
    }
    
}

//decode json data to instance of value type object - struct
func processData(_ str:Data){
    do{
        let decoder = JSONDecoder()
        let dict = try decoder.decode(Pokedex.self, from: str)
        
        DispatchQueue.main.async {
            pokedex = dict
        }
        
    } catch {
        print(str)
        fatalError(error.localizedDescription)
    }
}


// and recode to data!
func encode(){
    
    guard let pokedex = pokedex else{
        return
    }
    
    let encoder = JSONEncoder()
    do{
        let encoded = try encoder.encode(pokedex)
        print(encoded)
    } catch {
        print(error.localizedDescription)
    }
    
}

var pokedex:Pokedex!{
    didSet{
        print(pokedex)
        print(pokedex.names[0].name)
        print(pokedex.pokemon_entries.count)
        pokedex.pokemon_entries.first!.entry_number
        pokedex.pokemon_entries.first!.pokemon_species.name
        encode()
        PlaygroundPage.current.finishExecution()
    }
}


func main(){
    
    
    guard let url = URL(string:"https://pokeapi.co/api/v2/pokedex/2") else {
        fatalError()
    }
    
    
    DispatchQueue.global(qos: .background).async {
        
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            
            if(error != nil){
                fatalError(error.debugDescription)
            }
            
            guard let data = data else {
                print("no data")
                return
            }
            
            guard let dataString = String(data: data, encoding: .utf8) else {
                fatalError()
            }
            
            print(dataString)
            processData(data)
            
            
            
            
            
        }).resume()
        
    }
    
}

main()

