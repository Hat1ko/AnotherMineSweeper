//
//  GameDifficulty.swift
//  AnotherMineSweeper
//
//  Created by Pasha Suprun on 29.12.2019.
//  Copyright © 2019 Pasha Suprun. All rights reserved.
//

import Foundation

//TODO: refactor
enum GameDifficulty: CustomStringConvertible {
    case level(Int)
    
    var description: String {
        return NSLocalizedString("level \(self.rawValue)", comment: "")
    }
    
    var rawValue: Int{
        switch self{
        case .level(let value): return value
        }
    }
    
    var size: (columns: Int, rows: Int) {
        switch rawValue{
        case 1...2:
            return (6, 6)
        case 3...8:
            return (8, 8)
        case 9...20:
            return (10, 10)
        default:
            return (12, 12)
        }
    }
    
    var mines: Int{
        switch rawValue {
        case 1:
            return 4
        case 2:
            return 6
        case 3...5:
            return 10
        case 5...8:
            return 12
        case 9...14:
            return 12
        case 15...17:
            return 14
        case 18...19:
            return 16
        case 20...24:
            return 18
        default:
            return max(rawValue/2, 24)
        }
    }
    
    static var last: GameDifficulty{
        get{
            let level = UserDefaults.standard.integer(forKey: "level")
            return 1...80 ~= level ? .level(level) : .level(1)
        }
        set{
            UserDefaults.standard.set(newValue.rawValue, forKey: "level")
        }
    }
}
