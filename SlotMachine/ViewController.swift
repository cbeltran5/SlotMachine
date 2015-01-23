//
//  ViewController.swift
//  SlotMachine
//
//  Created by Carlos Beltran on 12/13/14.
//  Copyright (c) 2014 Carlos. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var firstContainer: UIView!
    var secondContainer: UIView!
    var thirdContainer:UIView!
    var fourthContainer:UIView!
    
    var titleLabel: UILabel!
    
    let kMarginforView: CGFloat = 10.0
    let kMarginforSlot: CGFloat = 2.0
    let kSixth: CGFloat = 1.0/6.0
    let kThird: CGFloat = 1.0/3.0
    let kHalf: CGFloat = 1.0/2.0
    let kEigth: CGFloat = 1.0/8.0
    
    let kNumberofSlots = 3
    let kNumberofContainers = 3
    
    // Information Labels
    var creditsLabel: UILabel!
    var betLabel: UILabel!
    var winnerPaidLabel: UILabel!
    var creditsTitleLabel: UILabel!
    var betTitleLabel: UILabel!
    var winnerPaidTitleLabel: UILabel!
    
    // Buttons in fourth container
    var resetButton: UIButton!
    var betOneButton: UIButton!
    var betMaxButton: UIButton!
    var spinButton: UIButton!
    
    var slots:[[Slot]] = []
    
    // Stats
    var currentBet = 0
    var credits = 0
    var winnings = 0
    
    //IBActions
    func resetButtonPressed(button: UIButton){
        hardReset()
    }
    
    func betOneButtonPressed(button: UIButton) {
        if credits <= 0 {
            showAlertMessage(header: "Not enough credits!", message: "Reset Game")
        }
        else {
            if currentBet < 5 {
                currentBet++
                credits--
                updateMainView()
            }
            else {
                showAlertMessage(message: "You can only bet 5 credits at a time")
            }
        }
    }
    
    func betMaxButtonPressed(button: UIButton) {
        if credits <= 5 {
            showAlertMessage(header: "Not enough credits", message: "Bet less")
        }
        else {
            if currentBet < 5 {
                credits -= 5 - currentBet
                currentBet += 5 - currentBet
                updateMainView()
            }
            else {
                showAlertMessage(message: "Already at max bet")
            }
        }
    }
    
    func spinButtonPressed(button: UIButton) {
        removeOldImages()
        slots = Factory.createSlots()
        setupSecondContainer(secondContainer)
        winnings = currentBet * SlotBrain.computeWinnings(slots)
        currentBet = 0
        credits += winnings
        updateMainView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setUpContainerViews()
        setupFirstContainer(firstContainer)
        setupThirdContainer(thirdContainer)
        hardReset()
        setupFourthContainer(fourthContainer)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setUpContainerViews() {
        self.firstContainer = UIView(frame: CGRect(x: self.view.bounds.origin.x + kMarginforView, y: self.view.bounds.origin.y, width: self.view.bounds.width - (kMarginforView * 2), height: self.view.bounds.height * kSixth))
        self.firstContainer.backgroundColor = UIColor.redColor()
        self.view.addSubview(self.firstContainer)
        
        self.secondContainer = UIView(frame: CGRect(x: self.view.bounds.origin.x + kMarginforView, y: firstContainer.frame.height, width: self.view.bounds.width - (kMarginforView * 2 ), height: self.view.bounds.height * (3 * kSixth)))
        self.secondContainer.backgroundColor = UIColor.blackColor()
        self.view.addSubview(self.secondContainer)
        
        self.thirdContainer = UIView(frame: CGRect(x: self.view.bounds.origin.x + kMarginforView, y: secondContainer.frame.height + firstContainer.frame.height, width: self.view.frame.width - (kMarginforView * 2), height: self.view.frame.height * kSixth))
        self.thirdContainer.backgroundColor = UIColor.grayColor()
        self.view.addSubview(thirdContainer)
        
        self.fourthContainer = UIView(frame: CGRect(x: self.view.bounds.origin.x + kMarginforView, y: firstContainer.frame.height + secondContainer.frame.height + thirdContainer.frame.height, width: self.view.bounds.width - (2 * kMarginforView), height: self.view.frame.height * kSixth))
        self.fourthContainer.backgroundColor = UIColor.blackColor()
        self.view.addSubview(fourthContainer)
    }
    
    func setupFirstContainer(containerView: UIView) {
        self.titleLabel = UILabel()
        titleLabel.text = "Super Slots"
        self.titleLabel.textColor = UIColor.yellowColor()
        self.titleLabel.font = UIFont(name: "MarkerFelt-Wide", size: 30)
        self.titleLabel.sizeToFit()
        self.titleLabel.center = containerView.center
        containerView.addSubview(self.titleLabel)
    }

    func setupSecondContainer(containerView:UIView) {
        for var i = 0; i < kNumberofContainers; i++ {
            for var j = 0; j < kNumberofSlots; j++ {
                
                var slot:Slot
                var slotImage = UIImageView()
                if (slots.count != 0) {
                    let slotContainer = slots[i]
                    slot = slotContainer[j]
                    slotImage.image = slot.image
                }
                
                else {
                    slotImage.image = UIImage(named: "Ace")
                }
                
                slotImage.backgroundColor = UIColor.yellowColor()
                slotImage.frame = CGRect(x: containerView.bounds.origin.x + (containerView.bounds.size.width * CGFloat(i) * kThird) , y: containerView.bounds.origin.y + (containerView.bounds.size.height * CGFloat(j) * kThird), width: containerView.bounds.width * kThird - kMarginforSlot, height: containerView.bounds.height * kThird - kMarginforSlot)
                containerView.addSubview(slotImage)
            }
        }
    }
    
    func setupThirdContainer(containerView: UIView) {
        creditsLabel = UILabel()
        creditsLabel.text = "000000"
        creditsLabel.textColor = UIColor.redColor()
        creditsLabel.font = UIFont(name: "Menlo-Bold", size: 16)
        creditsLabel.sizeToFit()
        creditsLabel.center = CGPoint(x: containerView.frame.width * kSixth, y: containerView.frame.height * kThird)
        creditsLabel.textAlignment = NSTextAlignment.Center
        creditsLabel.backgroundColor = UIColor.darkGrayColor()
        containerView.addSubview(creditsLabel)
        
        betLabel = UILabel()
        betLabel.text = "0000"
        betLabel.textColor = UIColor.redColor()
        betLabel.font = UIFont(name: "Menlo-Bold", size: 16)
        betLabel.sizeToFit()
        betLabel.center = CGPoint(x: containerView.frame.width * kSixth * 3, y: containerView.frame.height * kThird)
        
        betLabel.textAlignment = NSTextAlignment.Center
        betLabel.backgroundColor = UIColor.darkGrayColor()
        containerView.addSubview(betLabel)
        
        winnerPaidLabel = UILabel()
        winnerPaidLabel.text = "000000"
        winnerPaidLabel.font = UIFont(name: "Menlo-Bold", size: 16)
        winnerPaidLabel.textColor = UIColor.redColor()
        winnerPaidLabel.sizeToFit()
        winnerPaidLabel.center = CGPoint(x: containerView.frame.width * 5 * kSixth, y: containerView.frame.height * kThird)
        winnerPaidLabel.textAlignment = NSTextAlignment.Center
        winnerPaidLabel.backgroundColor = UIColor.darkGrayColor()
        containerView.addSubview(winnerPaidLabel)
        
        creditsTitleLabel = UILabel()
        creditsTitleLabel.text = "Credits"
        creditsTitleLabel.textColor = UIColor.blackColor()
        creditsTitleLabel.font = UIFont(name: "AmericanTypewriter", size: 14)
        creditsTitleLabel.sizeToFit()
        creditsTitleLabel.center = CGPoint(x: containerView.frame.width * kSixth, y: containerView.frame.height * kThird * 2 )
        
        containerView.addSubview(creditsTitleLabel)
        
        betTitleLabel = UILabel()
        betTitleLabel.text = "Bet"
        betTitleLabel.textColor = UIColor.blackColor()
        betTitleLabel.font = UIFont(name: "AmericanTypewriter", size: 14)
        betTitleLabel.sizeToFit()
        betTitleLabel.center = CGPoint(x: containerView.frame.width * kSixth * 3, y: containerView.frame.height * kThird * 2)
        containerView.addSubview(betTitleLabel)
        
        winnerPaidTitleLabel = UILabel()
        winnerPaidTitleLabel.text = "Winner Paid"
        winnerPaidTitleLabel.textColor = UIColor.blackColor()
        winnerPaidTitleLabel.font = UIFont(name: "AmericanTypewriter", size: 14)
        winnerPaidTitleLabel.sizeToFit()
        winnerPaidTitleLabel.center = CGPoint(x: containerView.frame.width * kSixth * 5, y: containerView.frame.height * kThird * 2)
        containerView.addSubview(winnerPaidTitleLabel)
    }
    
    func setupFourthContainer(containerView: UIView) {
        resetButton = UIButton()
        resetButton.setTitle("Reset", forState: UIControlState.Normal)
        resetButton.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        resetButton.titleLabel?.font = UIFont(name: "Superclarendon-Bold", size: 12)
        resetButton.backgroundColor = UIColor.lightGrayColor()
        resetButton.sizeToFit()
        resetButton.center = CGPoint(x: containerView.frame.width * kEigth, y: containerView.frame.height * kHalf)
        resetButton.addTarget(self, action: "resetButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        containerView.addSubview(resetButton)
        
        betOneButton = UIButton()
        betOneButton.setTitle("Bet One", forState: UIControlState.Normal)
        betOneButton.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        betOneButton.titleLabel?.font = UIFont(name: "Superclarendon-Bold", size: 12)
        betOneButton.backgroundColor = UIColor.greenColor()
        betOneButton.sizeToFit()
        betOneButton.center = CGPoint(x: containerView.frame.width * kEigth * 3, y: containerView.frame.height * kHalf)
        betOneButton.addTarget(self, action: "betOneButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        containerView.addSubview(betOneButton)
        
        betMaxButton = UIButton()
        betMaxButton.setTitle("Bet Max", forState: UIControlState.Normal)
        betMaxButton.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        betMaxButton.titleLabel?.font = UIFont(name: "Superclarendon-Bold", size: 12)
        betMaxButton.backgroundColor = UIColor.lightGrayColor()
        betMaxButton.sizeToFit()
        betMaxButton.center = CGPoint(x: containerView.frame.width * kEigth * 5, y: containerView.frame.height * kHalf)
        betMaxButton.addTarget(self, action: "betMaxButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        containerView.addSubview(betMaxButton)
        
        spinButton = UIButton()
        spinButton.setTitle("Spin", forState: UIControlState.Normal)
        spinButton.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        spinButton.titleLabel?.font = UIFont(name: "Superclarendon-Bold", size: 12)
        spinButton.backgroundColor = UIColor.lightGrayColor()
        spinButton.sizeToFit()
        spinButton.center = CGPoint(x: containerView.frame.width * kEigth * 7, y: containerView.frame.height * kHalf)
        spinButton.addTarget(self, action: "spinButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        containerView.addSubview(spinButton)
    }
    
    // Removes all the subviews from secondContainer
    // The ? means the object might or might not exist (nil)
    func removeOldImages() {
        if secondContainer != nil {
            let container: UIView? = secondContainer
            let subViews:Array? = container!.subviews
            for view in  subViews! {
                view.removeFromSuperview()
            }
        }
    }
    
    func hardReset() {
        removeOldImages()
        slots.removeAll(keepCapacity: true)
        self.setupSecondContainer(self.secondContainer)
        credits = 50
        winnings = 0
        currentBet = 0
        updateMainView()
    }
    
    func updateMainView() {
        creditsLabel.text = "\(credits)"
        betLabel.text = "\(currentBet)"
        winnerPaidLabel.text = "\(winnings)"
    }
    
    func showAlertMessage(header:String = "Warning", message: String) {
        var alert = UIAlertController(title: header, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
}

