//
//  ViewController.swift
//  rpalkar02
//
//  Created by Rajesh Palkar on 2/19/18.
//  Copyright © 2018 Rajesh Palkar. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
 
    var bettingValue: Int = 50
    var computerVAlue: Int = 0
    var computerVAlue2: Int = 0
    var playerValue: Int = 0
    var playerValue2: Int = 0
    var gameRound: Int = 0
    var gameMoney: Int = 0
    var earn: Double = 0
    var diff: Int = 0
    
    @IBOutlet weak var computerDie: UIImageView!
    @IBOutlet weak var computerDie2: UIImageView!
    @IBOutlet weak var playerDie: UIImageView!
    @IBOutlet weak var playerDie2: UIImageView!
    
    
    
    @IBOutlet weak var myStepper: UIStepper!
    
    @IBOutlet weak var myBetting: UISlider!
    
    @IBOutlet weak var currentBettingLbl: UILabel!
    @IBOutlet weak var totalMoneyLbl: UILabel!
    @IBOutlet weak var roundLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func updateLabels(){
        roundLbl.text = String(gameRound)
        totalMoneyLbl.text = String(gameMoney)
        currentBettingLbl.text = String(bettingValue)
        
    }
    
    
    @IBAction func startOver(_ sender: UIButton) {
        viewDidLoad()
        
        bettingValue = 50
        computerVAlue = 0
        computerVAlue2 = 0
        playerValue = 0
        gameRound = 0
        gameMoney = 0
        earn = 0
        diff = 0
        myStepper.value = 0
        
        playerDie.image = UIImage(named:"blankDice")
        playerDie2.image = UIImage(named:"blankDice")
        computerDie.image = UIImage(named:"blankDice")
        computerDie2.image = UIImage(named:"blankDice")
        
        updateLabels()
    }
    
    @IBAction func startGame(_ sender: UIButton) {
        startComputer()
    }
    
    
    func startComputer()
    {
        playerDie.image = UIImage(named:"blankDice")
        playerDie2.image = UIImage(named:"blankDice")
        
        computerVAlue = 1 + Int(arc4random_uniform(6))
        computerVAlue2 = 1 + Int(arc4random_uniform(6))
        
        switch computerVAlue {
        case 1:
            computerDie.image = UIImage(named:"diceOne")
        case 2:
            computerDie.image = UIImage(named:"diceTwo")
        case 3:
            computerDie.image = UIImage(named:"diceThree")
        case 4:
            computerDie.image = UIImage(named:"diceFour")
        case 5:
            computerDie.image = UIImage(named:"diceFive")
        case 6:
            computerDie.image = UIImage(named:"diceSix")
        default:
            computerDie.image = UIImage(named:"blankDice")
        }
        
        switch computerVAlue2 {
        case 1:
            computerDie2.image = UIImage(named:"diceOne")
        case 2:
            computerDie2.image = UIImage(named:"diceTwo")
        case 3:
            computerDie2.image = UIImage(named:"diceThree")
        case 4:
            computerDie2.image = UIImage(named:"diceFour")
        case 5:
            computerDie2.image = UIImage(named:"diceFive")
        case 6:
            computerDie2.image = UIImage(named:"diceSix")
        default:
            computerDie2.image = UIImage(named:"blankDice")
        }
        
       
        
        
    }

    
    @IBAction func userRoll(_ sender: UIButton) {
        startUser()
        result()
    }
    
    func startUser()
    {
        playerValue = 1 + Int(arc4random_uniform(6))
        playerValue2 = 1 + Int(arc4random_uniform(6))
      
        switch playerValue {
        case 1:
            playerDie.image = UIImage(named:"diceOne")
        case 2:
            playerDie.image = UIImage(named:"diceTwo")
        case 3:
            playerDie.image = UIImage(named:"diceThree")
        case 4:
            playerDie.image = UIImage(named:"diceFour")
        case 5:
            playerDie.image = UIImage(named:"diceFive")
        case 6:
            playerDie.image = UIImage(named:"diceSix")
        default:
            playerDie.image = UIImage(named:"blankDice")
        }
        
        switch playerValue2 {
        case 1:
            playerDie2.image = UIImage(named:"diceOne")
        case 2:
            playerDie2.image = UIImage(named:"diceTwo")
        case 3:
            playerDie2.image = UIImage(named:"diceThree")
        case 4:
            playerDie2.image = UIImage(named:"diceFour")
        case 5:
            playerDie2.image = UIImage(named:"diceFive")
        case 6:
            playerDie2.image = UIImage(named:"diceSix")
        default:
            playerDie2.image = UIImage(named:"blankDice")
        }
        
        
    }
    
    func result()
    {
        
        if(computerVAlue==0 && computerVAlue2==0)
        {
            let alert = UIAlertController(title: "Computer didnt play yet!",
                message:"Try Again!",
                preferredStyle: .alert)
            
            playerDie.image = UIImage(named:"blankDice")
            playerDie2.image = UIImage(named:"blankDice")
            
            let action = UIAlertAction(title:"OKay!",
                                       style: .default,
                                    handler: {action in self.startComputer()})
            
            alert.addAction(action)
            present(alert, animated: true,completion: nil)
            return
        }
        else
            {
                if((playerValue+playerValue2) >= (computerVAlue+computerVAlue2))
                {
                   earn = Double(2 * bettingValue)
                   diff = (playerValue + playerValue2) - (computerVAlue + computerVAlue2)
                    //player wins
     
                    let message = "Your betting is: \(bettingValue)" +
                        "\nComputer Total: \(computerVAlue+computerVAlue2)" + "\nYour Total: \(playerValue+playerValue2)" +
                    "\nThe difference is: \(diff)" + "\nYou gained \(earn) dollars"
                    
                     gameMoney = gameMoney + 2 * bettingValue
                    
                    let alert = UIAlertController(title: "You WON!!!",
                                                  message: message,
                                                  preferredStyle: .alert)
                    
                    let action = UIAlertAction(title:"OKay!",
                                               style: .default,
                                              // handler: nil)
                    handler: {action in self.startComputer()})
                    
                    alert.addAction(action)
                    present(alert, animated: true,completion: nil)
                    
                    
                }
                else{
                    earn = Double(bettingValue * 2)
                    diff = (computerVAlue + computerVAlue2) - (playerValue + playerValue2)
                    //comp wins
                    
                    let message = "Your betting is: \(bettingValue)" +
                        "\nComputer Total: \(computerVAlue+computerVAlue2)" + "\nYour Total: \(playerValue+playerValue2)" +
                        "\nThe difference is: \(diff)" + "\nYou lost \(earn) dollars"
                    
                   gameMoney = gameMoney - bettingValue
                    
                    let alert = UIAlertController(title: "You lost :/",
                                                  message: message,
                                                  preferredStyle: .alert)
                    
                    let action = UIAlertAction(title:"OKay!",
                                               style: .default,
                                              // handler: nil)
                                            handler: {action in self.startComputer()})
                    
                    alert.addAction(action)
                    present(alert, animated: true,completion: nil)
                    
                }
        
                gameRound = gameRound + 1
                updateLabels()
            }
    }
   
    @IBAction func changeGambleMoney(_ sender: Any) {
        
        if(gameRound != 0)
        {
            print("Game money is changed ONLY before the game starts!")
            
            let alert = UIAlertController(title: "Error!!!",
                                          message: "Game money is changed ONLY before the game starts!",
                                          preferredStyle: .alert)
            
            let action = UIAlertAction(title:"OKay!",
                                       style: .default,
                                        handler: nil)
            
            alert.addAction(action)
            present(alert, animated: true,completion: nil)
            
        }else{
        gameMoney = Int(myStepper.value * 100)
        totalMoneyLbl.text = String(gameMoney)
        }
    }
    
    @IBAction func sliderMove(_ sender: Any) {
        bettingValue = lroundf(myBetting.value)
        
        currentBettingLbl.text = String(bettingValue)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
}

