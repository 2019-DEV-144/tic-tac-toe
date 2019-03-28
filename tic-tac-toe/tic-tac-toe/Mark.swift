import Foundation

enum Mark {
    case X
    case O
    
    func getOppositeMark() -> Mark {
        switch self {
        case .X:
            return .O
        case .O:
            return .X
        }
    }
}
