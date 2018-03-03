//
//  GameScene.swift
//  Pong
//
//  Created by david padawer on 3/3/18.
//  Copyright © 2018 DPad Studios. All rights reserved.
//

import SpriteKit



class GameScene: SKScene {

    var playerScores : [SKLabelNode] = []
    var playerPaddles : [SKShapeNode] = []
    var playerVelocities : [CGFloat] = [0, 0]
    var gameOverLabel = SKLabelNode(fontNamed: "CourierNewPS-BoldMT")
    var button = ButtonNode(text: "Play Again")
    var restart : (() -> Void)!

    var ball : SKShapeNode!

    var score = [0, 0] {
        didSet {
            self.updateScoreLabels()
        }
    }

    func updateScoreLabels() {
        self.playerScores[0].text = String(score[0])
        self.playerScores[1].text = String(score[1])
    }

    override func update(_ currentTime: TimeInterval) {
        let newPlayerOneY = min(max(0, playerPaddles[0].position.y + playerVelocities[0]), 500)
        let newPlayerTwoY = min(max(0, playerPaddles[1].position.y + playerVelocities[1]), 500)
        playerPaddles[0].position = CGPoint(x: playerPaddles[0].position.x, y: newPlayerOneY)
        playerPaddles[1].position = CGPoint(x: playerPaddles[1].position.x, y: newPlayerTwoY)

        if (self.ball.position.x <= self.playerPaddles[0].position.x + 10) {
            self.addScore(player: 1)
        }
        if (self.ball.position.x >= self.playerPaddles[1].position.x) {
            self.addScore(player: 0)
        }
    }

    override func didMove(to view: SKView) {
        self.backgroundColor = .purple
        self.isUserInteractionEnabled = false

        let playerOneScore = SKLabelNode(fontNamed: "CourierNewPS-BoldMT")
        playerOneScore.position = CGPoint(x: 200, y: 550)
        playerOneScore.fontColor = .white
        playerOneScore.fontSize = 50
        playerOneScore.text = "0"
        playerScores.append(playerOneScore)

        let playerTwoScore = SKLabelNode(fontNamed: "CourierNewPS-BoldMT")
        playerTwoScore.position = CGPoint(x: 600, y: 550)
        playerTwoScore.fontColor = .white
        playerTwoScore.fontSize = 50
        playerTwoScore.text = "0"
        playerScores.append(playerTwoScore)


        let playerOnePaddle = SKShapeNode(path: CGPath(rect: CGRect(x: 0, y: 0, width: 10, height: 100) , transform: nil))
        playerOnePaddle.position = CGPoint(x: 10, y: 250)
        playerOnePaddle.fillColor = .green
        playerOnePaddle.strokeColor = .green
        playerPaddles.append(playerOnePaddle)

        let playerOnePhysicsBody = SKPhysicsBody(edgeLoopFrom: playerOnePaddle.path!)
        playerOnePhysicsBody.affectedByGravity = false
        playerOnePhysicsBody.isDynamic = false
        playerOnePhysicsBody.friction = 0
        playerOnePhysicsBody.mass = 1
        playerOnePhysicsBody.restitution = 1
        playerOnePaddle.physicsBody = playerOnePhysicsBody

        let playerTwoPaddle = SKShapeNode(path: CGPath(rect: CGRect(x: 0, y: 0, width: 10, height: 100) , transform: nil))
        playerTwoPaddle.position = CGPoint(x: 780, y: 250)
        playerTwoPaddle.fillColor = .green
        playerTwoPaddle.strokeColor = .green
        playerPaddles.append(playerTwoPaddle)

        let playerTwoPhysicsBody = SKPhysicsBody(edgeLoopFrom: playerTwoPaddle.path!)
        playerTwoPhysicsBody.affectedByGravity = false
        playerTwoPhysicsBody.isDynamic = false
        playerTwoPhysicsBody.friction = 0
        playerTwoPhysicsBody.mass = 1
        playerTwoPhysicsBody.restitution = 1
        playerTwoPaddle.physicsBody = playerTwoPhysicsBody

        self.ball = SKShapeNode(circleOfRadius: 10)
        self.ball.fillColor = .green
        self.ball.strokeColor = .green
        self.ball.position = CGPoint(x: 400, y: 300)

        let border = SKPhysicsBody(edgeLoopFrom: self.frame)
        border.friction = 0
        border.restitution = 1
        self.physicsBody = border

        self.gameOverLabel.horizontalAlignmentMode = .center
        self.gameOverLabel.verticalAlignmentMode = .center
        self.gameOverLabel.position = CGPoint(x: 400, y: 300)
        self.button.position = CGPoint(x: 300, y: 100)

        self.addChild(playerOneScore)
        self.addChild(playerTwoScore)
        self.addChild(playerOnePaddle)
        self.addChild(playerTwoPaddle)
        self.addChild(self.ball)
        self.startGame()

    }

    func startGame() {

        //serve to random player at random (bounded) angle
        let player = arc4random_uniform(2)
        let dy = Int(arc4random_uniform(401)) - 200
        var dx = -300
        if (player == 1) {
            dx *= -1
        }

        let ballPhysicsBody = SKPhysicsBody(circleOfRadius: 10)
        ballPhysicsBody.affectedByGravity = false
        ballPhysicsBody.isDynamic = true
        ballPhysicsBody.friction = 0
        ballPhysicsBody.mass = 1
        ballPhysicsBody.linearDamping = 0
        ballPhysicsBody.angularDamping = 0
        ballPhysicsBody.usesPreciseCollisionDetection = true
        self.ball.physicsBody = ballPhysicsBody
        self.ball.physicsBody!.applyImpulse(CGVector(dx: dx, dy: dy))
    }



    override func keyDown(with event: NSEvent) {
        var playerOneVelocityMagnitude : CGFloat = 0
        var playerTwoVelocityMagnitude : CGFloat = 0
        if let characters = event.characters {
            if (characters == "w") {
                playerOneVelocityMagnitude += 10
            }
            if (characters == "s") {
                playerOneVelocityMagnitude -= 10
            }
            if (characters == "o") {
                playerTwoVelocityMagnitude += 10
            }
            if (characters == "l") {
                playerTwoVelocityMagnitude -= 10
            }

        }
        self.playerVelocities[0] = min(max(self.playerVelocities[0] + playerOneVelocityMagnitude, -10), 10)
        self.playerVelocities[1] = min(max(self.playerVelocities[1] + playerTwoVelocityMagnitude, -10), 10)
    }

    override func keyUp(with event: NSEvent) {
        var playerOneVelocityMagnitude : CGFloat = 0
        var playerTwoVelocityMagnitude : CGFloat = 0
        if let characters = event.characters {
            if (characters == "w") {
                playerOneVelocityMagnitude -= 10
            }
            if (characters == "s") {
                playerOneVelocityMagnitude += 10
            }
            if (characters == "o") {
                playerTwoVelocityMagnitude -= 10
            }
            if (characters == "l") {
                playerTwoVelocityMagnitude += 10
            }
        }
        self.playerVelocities[0] = min(max(self.playerVelocities[0] + playerOneVelocityMagnitude, -10), 10)
        self.playerVelocities[1] = min(max(self.playerVelocities[1] + playerTwoVelocityMagnitude, -10), 10)
    }

    func addScore(player: Int) {
        self.score[player] += 1
        nextPointOrGameOver()
    }

    func nextPointOrGameOver() {
        if (self.score[0] == 10) {
            self.isPaused = true
            self.endGame(winner: 1)
            return
        }
        if (self.score[1] == 10) {
            self.isPaused = true
            self.endGame(winner: 2)
            return
        }
        self.startGame()
        self.ball.position = CGPoint(x: 400, y: 300)
    }

    func endGame(winner: Int) {
        self.gameOverLabel.text = "Player " + String(winner) + " wins!"
        self.button.onClick = self.restart
        self.addChild(self.gameOverLabel)
        self.addChild(self.button)
    }

}
