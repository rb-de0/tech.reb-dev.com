import Foundation

class DateUtil{
    
    class func currentDate() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ja_JP")
        formatter.dateFormat = "yyyy年M月dd日 HH時mm分"
        return formatter.string(from: Date())
    }
}
