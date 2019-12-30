//
//  Game.swift
//  AnotherMineSweeper
//
//  Created by Pasha Suprun on 29.12.2019.
//  Copyright © 2019 Pasha Suprun. All rights reserved.
//

import SpriteKit

class Game {
    let difficulty: GameDifficulty
    var isOver: Bool
    var mines: Grid<Bool>
    var board: Grid<Tile>
    
    var isWon: Bool {
        let unrevealed = board.count {
            tile in
            guard let tile = tile
                else {
                    return false
            }
            return tile.tileType == .unrevealed || tile.tileType == .flagged
        }
        
        return unrevealed == mines.count()
    }
    
    init(difficulty: GameDifficulty) {
        self.difficulty = difficulty
        self.isOver = false
        self.mines = Grid<Bool>(difficulty.size.columns, difficulty.size.rows)
        self.board = Grid<Tile>(difficulty.size.columns, difficulty.size.rows)
        addTiles()
    }
    
    func addTiles() -> Void {
        for row in 0..<difficulty.size.rows {
            for column in 0..<difficulty.size.columns {
                board[column, row] = Tile(.unrevealed)
            }
        }
    }
    
    func revealAllTiles() -> Void {
        for row in 0..<difficulty.size.rows {
            for column in 0..<difficulty.size.columns {
                if mines[column, row] != nil {
                    board[column, row] = Tile(.bomb)
                } else
                    if let tileType = board[column, row]?.tileType, tileType == .unrevealed {
                        board[column, row] = Tile(.empty)
                }
            }
        }
    }
    
    func addMines(around position: GridPosition) -> Void {
        while mines.count() < difficulty.mines {
            let row: Int = Int(arc4random_uniform(UInt32(difficulty.size.rows)))
            let column: Int = Int(arc4random_uniform(UInt32(difficulty.size.columns)))
            if mines[column, row] == nil && !(row == position.row && column == position.column){
                mines[column, row] = true
            }
        }
    }
    
    func play(at position: GridPosition) -> Void {
        if mines.count() == 0 {
            addMines(around: position)
        }
        
        let isFlagged = board[position]?.tileType ?? .unrevealed == .flagged
        
        if mines[position] != nil && !isFlagged{
            isOver = true
            revealAllTiles()
            return
        }
        
        revealTiles(from: position)
        
        if isWon {
            isOver = true
        }
    }
    
    func toggleFlag(at position: GridPosition) -> Void {
        
        if let tileType = board[position]?.tileType, tileType == .flagged {
            board[position] = Tile(.unrevealed)
        } else {
            board[position] = Tile(.flagged)
        }
    }
    
    //change method name
    //number of bombs around
    func bombs(around position: GridPosition) -> Int {
        //reduce(initialResult, Direction(two cords))
        return Direction.all.reduce(0 ,{ (result, current) -> Int in
            let neighbourPos: GridPosition = GridPosition(position.column + current.offset.column, position.row + current.offset.row)

            guard 0..<difficulty.size.columns ~= neighbourPos.column,  //equ neighbour.column <= difficulty.size.columns
                0..<difficulty.size.rows ~= neighbourPos.row           //equ neighbour.row <= difficulty.size.rows
                else {
                    return result
            }
            return mines[neighbourPos] == nil ? result : result + 1
        })
        
//        var bombsCount: Int = 0
//
//        Direction.all.forEach{
//            direction in
//
//            bombsCount += { num -> Int in
//
//                let offset = direction.offset
//                let pos: GridPosition = GridPosition(position.column + offset.column, position.row + offset.row)
//
//                if let _ = mines[pos] {
//                    return 1
//                }
//                else {
//                    return 0
//                }
//            }
//
//
////            let offset = direction.offset
////            let pos: GridPosition = GridPosition(position.column + offset.column, position.row + offset.row)
////
////            if let _ = mines[pos] {
////                bombsCount += 1
////            }
//        }
//        return bombsCount
        
//        return Direction.all.reduce(0, )
    }
    
    func revealTiles(from position: GridPosition) -> Void {
        guard let tileType = board[position]?.tileType,
            tileType == .unrevealed,
            mines[position] == nil
            else{
                return
        }
        
        let sourroundingBombs: Int = bombs(around: position)
        
        if sourroundingBombs == 0 {
            board[position] = Tile(.empty)
            Direction.all.forEach {
                direction in
                let neighbour = GridPosition(position.column + direction.offset.column, position.row + direction.offset.row)
                
                guard 0..<difficulty.size.columns ~= neighbour.column,
                    0..<difficulty.size.rows ~= neighbour.row
                    else {
                        return
                }
                revealTiles(from: neighbour)
            }
        }
        else{
            board[position] = Tile(.numbered(sourroundingBombs))
        }
    }
}
