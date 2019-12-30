//
//  GameScene.swift
//  AnotherMineSweeper
//
//  Created by Pasha Suprun on 29.12.2019.
//  Copyright © 2019 Pasha Suprun. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var tileSize: CGFloat
    var game: Game = Game(difficulty: GameDifficulty.last)
    var selectedPosition: GridPosition?
    var colorTheme: ColorTheme
    
    let gameLayer = SKNode()
    let tilesLayer = SKNode()
    
    var label: SKLabelNode?
    
    var columns: Int {
        return game.difficulty.size.columns
    }
    
    var rows: Int {
        return game.difficulty.size.rows
    }
    
    required init?(coder aDecoder: NSCoder) {
        tileSize = 30
        colorTheme = UIColor.colorTheme(colors: Direction.all.count)
        super.init(coder: aDecoder)
    }
    
    override init(size: CGSize){
        let columns = game.difficulty.size.columns
        let rows = game.difficulty.size.rows
        
        self.tileSize = min(size.width / CGFloat(columns), size.height / CGFloat(rows))
        colorTheme = UIColor.colorTheme(colors: Direction.all.count)
        super.init(size: size)
    }
    
    func addLayers() {
        addChild(gameLayer)
        let layerPosition = CGPoint(x: -tileSize * CGFloat(columns)/2, y: -tileSize * CGFloat(rows)/2)
        tilesLayer.position = layerPosition
        gameLayer.addChild(tilesLayer)
    }
    
    override var size: CGSize {
        didSet {
            tileSize = min(size.width / CGFloat(columns), size.height / CGFloat(rows))
        }
    }
    
    @objc func onLongPress(sender: UILongPressGestureRecognizer) {
        
        guard let selectedPosition = selectedPosition,
            !game.isOver
            else {
                return }
        guard let tileType = game.board[selectedPosition]?.tileType,
            tileType == .flagged || tileType == .unrevealed
            else { return }
        
        if sender.state == .began {
            label?.text = "🤔"
            game.toggleFlag(at: selectedPosition)
            renderTiles()
        }
        
        if sender.state == .ended {
            label?.text = "🙂"
        }
    }
    
    func pointFrom(position: GridPosition) -> CGPoint {
        return CGPoint(
            x: CGFloat(position.column)*tileSize + tileSize/2,
            y: CGFloat(position.row)*tileSize + tileSize/2)
    }
    
    override func didMove(to view: SKView) {
        addLayers()
        label = childNode(withName: "label") as? SKLabelNode
        label?.position = CGPoint(x: 0, y: -tilesLayer.position.y + label!.frame.size.height / 2)
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(GameScene.onLongPress(sender:)))
        view.addGestureRecognizer(longPress)
        
        newGame()
    }
    
    func renderTiles() {
        let oldBoard = tilesLayer.children
        var newBoard = [SKNode]()
        
        for row in 0..<rows {
            for column in 0..<columns {
                guard let tileType = game.board[column, row]?.tileType
                    else { continue }
                let node = SKSpriteNode.tile(tileType, ofSize: tileSize, colorTheme: colorTheme)
                node.position = pointFrom(position: (column: column, row: row))
                node.name = "\(column), \(row), \(tileType.hashValue)" //😒
                newBoard.append(node)
                if !oldBoard.contains{ $0.name == node.name }, tileType != .flagged {
                    node.alpha = 0
                    let action = SKAction.fadeIn(withDuration: 0.5)
                    node.run(action)
                }
            }
        }
        
        tilesLayer.removeAllChildren()
        newBoard.forEach{ tilesLayer.addChild($0) }
    }
    
    func newGame() {
        tilesLayer.removeAllChildren()
        selectedPosition = nil
        colorTheme = UIColor.colorTheme(colors: Direction.all.count)
        
        var newDifficulty = game.difficulty.rawValue
        if game.isOver && game.isWon {
            newDifficulty += 1
            GameDifficulty.last = .level(newDifficulty)
        }
        
        label?.text = "🙂"
        game = Game(difficulty: GameDifficulty.last)
        tileSize = min(size.width / CGFloat(game.difficulty.size.columns), size.height / CGFloat(game.difficulty.size.rows))
        
        renderTiles()
    }
    
    func gridPosition(from point: CGPoint) -> GridPosition? {
        
        if point.x >= 0 && point.x < CGFloat(columns)*tileSize &&
            point.y >= 0 && point.y < CGFloat(rows)*tileSize {
            return (Int(point.x / tileSize), Int(point.y / tileSize))
        } else {
            return nil
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        let touch = touches.first!
        let location = touch.location(in: tilesLayer)
        
        let newGamePressed = (nodes(at: touch.location(in: self)).filter {
            $0.name == "label"
        }).count > 0
        if newGamePressed {
            newGame()
            return
        }
        
        if game.isOver {
            return
        }
        
        if let position = gridPosition(from: location) {
            selectedPosition = position
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let selectedPosition = selectedPosition
            else { return }
        
        if !game.isOver {
            game.play(at: selectedPosition)
            run(SKAction.sequence([
                SKAction.run {
                    self.label?.text = "😮"
                }
            ]))
            
            renderTiles()
        }
        
        if game.isOver {
            run(SKAction.sequence([
                SKAction.wait(forDuration: 0.5, withRange: 1),
                SKAction.run {
                    self.label?.text = self.game.isWon ? "😎" : "☹️"
                }
            ]))
            
            
            if !game.isWon {
                let node = SKSpriteNode.highlightedTile(ofSize: tileSize)
                node.position = pointFrom(position: selectedPosition)
                tilesLayer.addChild(node)
            }
        } else {
            run(SKAction.sequence([
                SKAction.wait(forDuration: 0.5, withRange: 1),
                SKAction.run {
                    self.label?.text = "🙂"
                }
            ]))
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        
    }
}
