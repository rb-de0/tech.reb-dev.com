import Foundation
import FluentProvider

extension Timestampable {
    
    var formattedCreatedAt: String? {

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        return createdAt.map { formatter.string(from: $0) }
    }
    
    var formattedUpdatedAt: String? {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        return updatedAt.map { formatter.string(from: $0) }
    }
    
}
