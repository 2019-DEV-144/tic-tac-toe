import Foundation

enum PlayResponse {
    /// The play went through and the game continues
    case `continue`
    /// The play ended the game in a draw
    case draw
    /// The play ended the game in victory for the turn player
    case victory
    /// The play was not valid so control does not switch
    case invalid
}
