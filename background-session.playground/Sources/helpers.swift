//
//  Helpers.swift
//  BitcoinInvestmentMonitor
//
//  Created by Joss Manger on 12/23/17.
//  Copyright © 2017 Joss Manger. All rights reserved.
//

import Foundation

//
//  BTCPriceModel.swift
//  BitcoinInvestmentMonitor
//
//  Created by Joss Manger on 12/7/17.
//  Copyright © 2017 Joss Manger. All rights reserved.
//

public protocol BTCPriceDelegate {
    func updatedPrice()
    func displayError()
    func silentFail()
}

public class BTCPriceModel: NSObject,URLSessionDataDelegate {
    
    var btcRate:Float!
    var cryptoRates:Dictionary<String,Float> = [:]
    var delegate:BTCPriceDelegate?
    
    let config = URLSessionConfiguration.background(withIdentifier: "background")
    var session:URLSession!
    
    var  dispatch_group: DispatchGroup? = DispatchGroup()
    
    static let polling:Array<CryptoTicker> = [.btc,.ltc,.eth]
    
    public override init() {
        super.init()
        //seed initial value of zero
        //let queue = OperationQueue()
        session = URLSession(configuration: URLSessionConfiguration.background(withIdentifier: "background"), delegate: self, delegateQueue: nil)
        
        btcRate = 0.0
        for cryp in BTCPriceModel.polling{
            cryptoRates[cryp.stringValue()] = 0.0
        }
    }
    
   public func killAll(){
        print("got kill All, removing observer, shanking dispatch group")
        
        dispatch_group = nil
        self.delegate?.silentFail()
        
        
    }
    
    var responses:Dictionary<String,Data> = [:]
    
    public func getUpdateBitcoinPrice(){
        
        
        session.invalidateAndCancel()
        for ticker in BTCPriceModel.polling{
            
            request(ticker:ticker)
            
        }
        
        dispatch_group?.notify(queue: .main, execute: {
            print("tasks done",self.cryptoRates)
            
            self.delegate?.updatedPrice()
        })
        
        
        
        
    }
    
    
   public func request(ticker:CryptoTicker){
        if (dispatch_group === nil){
            print("rebuilding dispatch group")
            dispatch_group = DispatchGroup()
        }
        dispatch_group?.enter()
        let cburl = "https://api.coinbase.com/v2/prices/"+ticker.stringValue()+"-USD/spot"
        //"https://api.coindesk.com/v1/bpi/currentprice.json"
        if let url = URL(string:cburl){
            var errorPointer:Error?
            let task = session.dataTask(with: url)
            responses[String(task.taskIdentifier)] = Data()
            task.resume()
        }
    }
    
    public func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        //        session.getAllTasks(completionHandler: { (tasks) in
        //
        //            for task in tasks{
        //                //                do{
        //                //                    let dict = try JSONSerialization.jsonObject(with: task.response.re, options: .init(rawValue: 0)) as! Dictionary<String,Any>
        //                //                    print(dict)
        //                //
        //                //                    if let data = dict["data"] as? Dictionary<String,Any>{
        //                //
        //                //                        //print(usd)
        //                //                        if let rate = data["amount"] as? NSString{
        //                //                            if(ticker == .btc){
        //                //                                self.btcRate = rate.floatValue
        //                //                            }
        //                //                            self.cryptoRates[ticker.stringValue()] = rate.floatValue
        //                //                            self.dispatch_group?.leave()
        //                //                        } else {
        //                //                            print("fail at rate")
        //                //                        }
        //                //                    }
        //                //
        //                //                } catch {
        //                //                    fatalError()
        //                //                }
        //
        //            }
        //
        //        })
    }
    
     public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        print(dataTask.taskIdentifier)
        responses[String(dataTask.taskIdentifier)]?.append(data)
    }
    
     public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        
        
        
        print(responses)
        for responsedata in responses{
            
            do{
                let dict = try JSONSerialization.jsonObject(with: responsedata.value, options: .init(rawValue: 0)) as! Dictionary<String,Any>
                print(dict)
                
                //  if let data = dict["data"] as? Dictionary<String,Any>{
                
                //print(usd)
                //           if let rate = data["amount"] as? NSString{
                //        if(ticker == .btc){
                //          self.btcRate = rate.floatValue
                //             }
                //        self.cryptoRates[ticker.stringValue()] = rate.floatValue
                //         self.dispatch_group?.leave()
                //            } else {
                //                 print("fail at rate")
                //             }
                //             }
                
            } catch {
                fatalError()
            }
        }
    }
    
    
    
}












public enum CryptoTicker:Int {
    
    case btc = 0
    case ltc = 1
    case eth = 2
    
    public func stringValue() -> String {
        switch(self){
        case .btc:
            return "BTC"
        case .ltc:
            return "LTC"
        case .eth:
            return "ETH"
        }
    }
    
   public static func ticker(ticker:String?) -> CryptoTicker {
        if let validString = ticker {
            switch(validString){
            case "LTC":
                return .ltc
            case "ETH":
                return .eth
            default:
                return .btc
            }
        } else {
            return .btc
        }
    }
    
}

