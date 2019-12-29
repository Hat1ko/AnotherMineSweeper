//
//  Grid.swift
//  AnotherMineSweeper
//
//  Created by Pasha Suprun on 29.12.2019.
//  Copyright © 2019 Pasha Suprun. All rights reserved.
//

import Foundation

typealias GridPosition = (column: Int, row: Int)

struct Grid<T> {
    let columns: Int
    let rows: Int
    
    fileprivate var array: Array<T?>
    
    init(_ columns: Int, _ rows: Int) {
        self.columns = columns
        self.rows = rows
        array = Array<T?>(repeating: nil, count: rows * columns)
    }
    
    subscript(column: Int, row: Int) -> T?{
        get{
            return array[row * columns + column]
        }
        set{
            array[row * columns + column] = newValue
        }
    }
    
    subscript(position: GridPosition) -> T? {
        get {
            return self[position.column, position.row]
        }
        set{
            self[position.column, position.row] = newValue
        }
    }
    
    func count() -> Int {
        return array.filter{ $0 != nil }.count
    }
    
    func count(where by:((T?) -> Bool)) -> Int{
        return array.filter(by).count
    }
}
