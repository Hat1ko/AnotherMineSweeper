//
//  Direction.swift
//  AnotherMineSweeper
//
//  Created by Pasha Suprun on 29.12.2019.
//  Copyright © 2019 Pasha Suprun. All rights reserved.
//

import Foundation

typealias Offset = (column: Int, row: Int)

enum Direction{
    case top, topLeft, left, bottomLeft, bottom, bottomRight, right, topRight
    
    //check this thing
    var offset: Offset{
        switch self{
        case .top:
            return Offset(0, 1)
        case .topLeft:
            return Offset(-1, 1)
        case .left:
            return Offset(-1, 0)
        case .bottomLeft:
            return Offset(-1, -1)
        case .bottom:
            return Offset(0, -1)
        case .bottomRight:
            return Offset(1, -1)
        case .right:
            return Offset(1, 0)
        case .topRight:
            return Offset(1, 1)
        }
    }
    
    public static var all: Array<Direction> {
        return [.top, .topLeft, .left, .bottomLeft, .bottom, .bottomRight, .right, .topRight]
    }
}
