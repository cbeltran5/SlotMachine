//
//  SlotBrain.swift
//  SlotMachine
//
//  Created by Carlos Beltran on 12/18/14.
//  Copyright (c) 2014 Carlos. All rights reserved.
//

import Foundation

class SlotBrain {
    class func unpackSlotsIntoRows(slots:[[Slot]]) -> [[Slot]] {
        var row1:[Slot] = []
        var row2:[Slot] = []
        var row3:[Slot] = []
        
        for slotArray in slots {
            for var i = 0; i < slotArray.count; i++ {
                let slot = slotArray[i]
                if i == 0 {
                    row1.append(slot)
                }
                else if i == 1{
                    row2.append(slot)
                }
                else if i == 2 {
                    row3.append(slot)
                }
                else {
                    println("Error")
                }
            }
        }
        var slotsInRows:[[Slot]] = [row1, row2, row3]
        return slotsInRows
    }
    
    class func computeWinnings(slots:[[Slot]]) -> Int {
        var slotsInRows = unpackSlotsIntoRows(slots)
        var winnings = 0
        var flushWinCount = 0
        var threeOfAKindWinCount = 0
        var straightWinCount = 0
        
        for slotRow in slotsInRows {
            if (checkFlush(slotRow) == true) {
                println("Flush")
                winnings++
                flushWinCount++
            }
            if (checkThreeInARow(slotRow) == true) {
                println("Three in a row")
                winnings++
                straightWinCount++
            }
            if (checkThreeOfAKind(slotRow) == true) {
                println("Three of a kind")
                winnings++
                threeOfAKindWinCount++
            }
        }
        
        if (flushWinCount == 3) {
            println("Royal Flush")
            winnings += 15
        }
        
        if (straightWinCount == 3) {
            println("Epic straight")
            winnings += 1000
        }
        
        if (threeOfAKindWinCount == 3) {
            println("Threes all around!")
            winnings += 50
        }
        
        return winnings
    }
    
    class func checkFlush(slotRow: [Slot]) -> Bool {
        let slot1 = slotRow[0]
        let slot2 = slotRow[1]
        let slot3 = slotRow[2]
        
        if (slot1.isRed == true && slot2.isRed == true && slot3.isRed == true) {
            return true
        }
        else if (slot1.isRed == false && slot2.isRed == false && slot3.isRed == false) {
            return true
        }
        else {
            return false
        }
    }
    
    class func checkThreeInARow(slotRow: [Slot]) -> Bool {
        let slot1 = slotRow[0]
        let slot2 = slotRow[1]
        let slot3 = slotRow[2]
        
        if slot1.value == slot2.value - 1 && slot1.value == slot3.value - 2 {
            return true
        }
        else if slot1.value == slot2.value + 1 && slot1.value == slot3.value + 1 {
            return true
        }
        else {
            return false
        }
    }
    
    class func checkThreeOfAKind(slotRow: [Slot]) -> Bool {
        let slot1 = slotRow[0]
        let slot2 = slotRow[1]
        let slot3 = slotRow[2]
        
        if (slot1.value == slot2.value && slot1.value == slot3.value) {
            return true
        }
        else {
            return false
        }
    }
}

