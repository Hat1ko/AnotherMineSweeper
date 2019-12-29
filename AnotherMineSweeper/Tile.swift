//
//  Tile.swift
//  AnotherMineSweeper
//
//  Created by Pasha Suprun on 29.12.2019.
//  Copyright © 2019 Pasha Suprun. All rights reserved.
//

import Foundation

enum TileType: CustomStringConvertible {
    case unrevealed, empty, numbered(Int), flagged, bomb
    
    var description: String {
        switch self{
        case .unrevealed:
            return ""
        case .empty: return ""
        case .numbered(let value): return "\(value)"    //num of bombs around
        case .flagged: return "🚩"  //flag emoji
        case .bomb: return "💥"     //explosion emoji
        }
    }
    
    var hashValue: Int {
        switch self {
        case .unrevealed: return Int.min    //differs much from any possible number
        case .empty: return 0
        case .numbered(let value): return value
        case .flagged: return -1
        case .bomb: return Int.max          //differs much from any possible number
        }
    }
}

func ==(l: TileType, r: TileType) -> Bool {
    return l.hashValue == r.hashValue;
}

func !=(l: TileType, r: TileType) -> Bool {
    return l.hashValue != r.hashValue
}

struct Tile {
    let tileType: TileType
    
    init(_ tileType: TileType){
        self.tileType = tileType
    }
}
