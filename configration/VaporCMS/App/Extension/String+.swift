import Foundation

extension String{
    func take(n: Int) -> String{
        if n >= self.characters.count{
            return self
        }
        
        return NSString(string: self).substring(to: n)
    }
}