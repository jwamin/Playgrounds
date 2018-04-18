//: A UIKit based Playground for presenting user interface

import UIKit
import PlaygroundSupport

struct CalDimensions {
    let height:Int = 350
    let width:Int = 350
    let month:Int = 4
}


let bookedDates:[DateComponents] = [
    DateComponents(calendar: nil, timeZone: nil, era: nil, year: 2018, month: 1, day: 23, hour: nil, minute: nil, second: nil, nanosecond: nil, weekday: nil, weekdayOrdinal: nil, quarter: nil, weekOfMonth: nil, weekOfYear: nil, yearForWeekOfYear: nil),
    DateComponents(calendar: nil, timeZone: nil, era: nil, year: 2018, month: 4, day: 2, hour: nil, minute: nil, second: nil, nanosecond: nil, weekday: nil, weekdayOrdinal: nil, quarter: nil, weekOfMonth: nil, weekOfYear: nil, yearForWeekOfYear: nil),
    DateComponents(calendar: nil, timeZone: nil, era: nil, year: 2018, month: 4, day: 3, hour: nil, minute: nil, second: nil, nanosecond: nil, weekday: nil, weekdayOrdinal: nil, quarter: nil, weekOfMonth: nil, weekOfYear: nil, yearForWeekOfYear: nil),
    DateComponents(calendar: nil, timeZone: nil, era: nil, year: 2018, month: 5, day: 23, hour: nil, minute: nil, second: nil, nanosecond: nil, weekday: nil, weekdayOrdinal: nil, quarter: nil, weekOfMonth: nil, weekOfYear: nil, yearForWeekOfYear: nil),
        DateComponents(calendar: nil, timeZone: nil, era: nil, year: 2018, month: 5, day: 11, hour: nil, minute: nil, second: nil, nanosecond: nil, weekday: nil, weekdayOrdinal: nil, quarter: nil, weekOfMonth: nil, weekOfYear: nil, yearForWeekOfYear: nil),
    DateComponents(calendar: nil, timeZone: nil, era: nil, year: 2018, month: 6, day: 19, hour: nil, minute: nil, second: nil, nanosecond: nil, weekday: nil, weekdayOrdinal: nil, quarter: nil, weekOfMonth: nil, weekOfYear: nil, yearForWeekOfYear: nil)
];


class CalendarViewController : UIViewController {
    
    var calDimensions = CalDimensions()
    var calendarView:UIView!
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white
        
        //        let label = UILabel()
        //        label.frame = CGRect(x: 150, y: 200, width: 200, height: 200)
        //        label.text = "Hello World!"
        //        label.textColor = .black
        //
        //        view.addSubview(label)
        self.view = view
    }
    
    override func viewDidLoad() {
      
        loadCalendarLayout(month:calDimensions.month)
        loadSlider(month:calDimensions.month)
    }
    
    func loadSlider(month:Int){
        let sliderFrame = CGRect(x: 0, y: calDimensions.height, width: calDimensions.height, height: 30)
        let slider = UISlider(frame: sliderFrame)
        slider.maximumValue = 12
        slider.minimumValue = 1
        slider.value = Float(month)
        slider.isContinuous = false
        view.addSubview(slider)
        slider.addTarget(self, action: #selector(sliderChanged), for: .valueChanged)
        
    }
    
    @objc func sliderChanged(_ sender:Any){
        let slider = sender as! UISlider;
        let month = slider.value.rounded()
        slider.value = month
        print(month)
        calendarView.removeFromSuperview()
        loadCalendarLayout(month: Int(month))
    }
    
    func loadCalendarLayout(month:Int){
        
        
        let rect = CGRect(x: 0, y: 0, width: calDimensions.width, height: calDimensions.height)
        
        let calView = UIView(frame: rect)
        calView.backgroundColor = UIColor.black;
        view.center.x
        view.center.y
        //calView.frame.origin = CGPoint(x: , y: )
        calendarView = calView
        view.addSubview(calendarView)
        
        let dateComponents:DateComponents? = DateComponents(year: 2018, month: month)
        var calendar = Calendar.current
        calendar.firstWeekday = 2
        let currentDate = (dateComponents != nil) ? calendar.date(from: dateComponents!)! : Date()
        let range = calendar.range(of: .day, in: .month, for: currentDate)!
        
        let mainComponents = calendar.dateComponents([.weekday,.day,.month,.year], from: currentDate)
        let numDays = range.count
        
        let dates:[Date] = { () -> [Date] in
            var dates:[Date] = []
            for comp in bookedDates{
                if let date = calendar.date(from: comp){
                    dates.append(date)
                }
            }
            return dates
        }()
        
        for day in 1...numDays{
            let components = DateComponents(year:mainComponents.year!,month:mainComponents.month!,day: day)
            let date = calendar.date(from: components)
            let dayInfo = calendar.dateComponents([.weekday,.weekOfMonth], from: date!)
            var position = dayInfo.weekday!-calendar.firstWeekday
            var booked = false
            for bookedDate in dates{
                if date == bookedDate {
                    booked = true
                }
            }
            
            position = (position == -1) ? 6 : position;
            let day = DayView(parentDimension: calDimensions.height, positionLeft: position, positionTop: dayInfo.weekOfMonth!-1,day:day,booked:booked)
            
            let gesture = UITapGestureRecognizer(target: self, action: #selector(gotTap))
            day.addGestureRecognizer(gesture)
            calView.addSubview(day)
            
        }
        
    }
    
    @objc func gotTap(gesture:UITapGestureRecognizer){
        let view = gesture.view as! DayView
        print(view.day)
        view.backgroundColor = UIColor.red
        UIView.animate(withDuration: 1.0) {
            view.backgroundColor = UIColor.white
        }
    }
    
}

class DayView : UIView{
    let day:Int!
    init(parentDimension: Int,positionLeft:Int,positionTop:Int,day:Int,booked:Bool) {
        let dimensionX = parentDimension / 7;
        let dimensionY = parentDimension / 6;
        let x = positionLeft * dimensionX;
        let y = positionTop * dimensionY;
        let point:CGPoint = CGPoint(x: x, y: y)
        self.day = day
        let size:CGSize = CGSize(width: dimensionX, height: dimensionY)
        let rect = CGRect(origin: point, size: size)
        super.init(frame: rect)
        if(booked){
          self.backgroundColor = UIColor.cyan
        } else {
            self.backgroundColor = UIColor.white
        }
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: dimensionX, height: dimensionY))
        label.textAlignment = .center
        label.font = UIFont(name: "Helvetica", size: 9.0)
        label.text = "\(self.day!)"
        self.addSubview(label)
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.green.cgColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


// Present the view controller in the Live View window
PlaygroundPage.current.liveView = CalendarViewController()
