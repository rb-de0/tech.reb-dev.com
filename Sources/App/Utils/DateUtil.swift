import Foundation

class DateUtil{
    
    class func currentDate() -> String {
        
        let now: Date
        if let interval = TimeZone(abbreviation: "JST")?.secondsFromGMT(){
            now = Date(timeIntervalSinceNow: TimeInterval(interval))
        } else {
            now = Date()
        }
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ja_JP")
        formatter.dateFormat = "yyyy年M月dd日 HH時mm分"
        return formatter.string(from: now)
    }
}
