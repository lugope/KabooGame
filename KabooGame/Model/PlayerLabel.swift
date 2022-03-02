//
//  PlayerLabel.swift
//  KabooGame
//
//  Created by Lucas Pereira on 24/02/22.
//

import Foundation
import SpriteKit

class PlayerLabel: SKNode {
    let image: String
    var score: Int = 0 {
        didSet {
            if score > 0 {
                scoreLabel.attributedText = NSAttributedString(string: "0", attributes: [.font: UIFont.systemFont(ofSize: fontSize), .foregroundColor: UIColor.red])
            }
        }
    }
    var isCurrentTurn: Bool = false {
        didSet {
            if isCurrentTurn {
                nameLabel.fontColor = UIColor.white
                rect.fillColor = UIColor.systemBlue
                
            } else {
                nameLabel.fontColor = UIColor.black
                rect.fillColor = UIColor.white
            }
        }
    }
    
    let padding: CGFloat = 7
    let sideInset: CGFloat = 7
    let topBotInset: CGFloat = 5
    let fontSize: CGFloat = 14
    
    let nameLabel = SKLabelNode()
    let scoreLabel = SKLabelNode()
    let imageNode = SKShapeNode(circleOfRadius: 8)
    let rect: SKShapeNode
    
    init(userName: String, image: String, score : Int = 0) {

        self.image = image
        self.score = score
        
        imageNode.fillColor = UIColor.darkGray
        imageNode.strokeColor = UIColor.clear
        
        nameLabel.fontColor = UIColor.black
        nameLabel.attributedText = NSAttributedString(string: userName, attributes: [.font: UIFont.systemFont(ofSize: fontSize)])
        
        scoreLabel.attributedText = NSAttributedString(string: "0", attributes: [.font: UIFont.systemFont(ofSize: fontSize), .foregroundColor: UIColor.red])
        
        let rectWidth = imageNode.frame.width + nameLabel.frame.width + scoreLabel.frame.width*2 + padding*2 + sideInset*2
        let rectHeigh = imageNode.frame.height + topBotInset*2
        rect = SKShapeNode(rectOf: CGSize(width: rectWidth, height: rectHeigh), cornerRadius: 9)
        rect.fillColor = UIColor.white
        rect.strokeColor = UIColor.systemGray
        
        super.init()
        
        positionNodes()
        addNodes()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    func positionNodes() {
        imageNode.position = CGPoint(
            x: rect.frame.minX + sideInset + imageNode.frame.width/2,
            y: frame.midY
        )
        nameLabel.position = CGPoint(
            x: imageNode.position.x + imageNode.frame.width/2 + nameLabel.frame.width/2 + padding,
            y: imageNode.position.y - 6
        )
        scoreLabel.position = CGPoint(
            x: rect.frame.maxX - scoreLabel.frame.width - sideInset,
            y: imageNode.position.y - 6
        )
    }
    
    func addNodes() {
        addChild(rect)
        addChild(nameLabel)
        addChild(scoreLabel)
        addChild(imageNode)
    }
}
