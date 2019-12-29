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
}
