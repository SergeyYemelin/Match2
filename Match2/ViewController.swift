//
//  ViewController.swift
//  Match2
//
//  Created by Сергей Емелин on 24.11.2024.
//

import UIKit

class ViewController: UIViewController {
    
  
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var countGameLabel: UILabel!
    @IBOutlet weak var bestTimeLabel: UILabel!
    
    var time = 0
    var timer = Timer()
    
    var images = ["1", "2", "3", "4", "5", "6", "7", "8", "1", "2", "3", "4", "5", "6", "7", "8"]
    
    var state = [Int](repeating: 0, count: 16)
    
    var isActive = false
    
    var isTimerRunning = false
    
    var countMoves = 0
    
    var isShuffleArray = false
    
    var testCount = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        timerLabel.text = timeString(time: time)
        countGameLabel.text = "\(countMoves)"
        bestTimeLabel.text = timeString(time: UserDefaults.standard.integer(forKey: "savedTime"))
        // Do any additional setup after loading the view.
    }

    @IBAction func restart(_ sender: Any) {
                                          
        time = 0
        state = [Int](repeating: 0, count: 16)
        isActive = false
        isTimerRunning = false
        countMoves = 0
        isShuffleArray = false
        testCount = 0
        for i in 0...15 {
                state[i] = 0
                let button = view.viewWithTag(i + 1) as! UIButton
                button.setBackgroundImage(nil, for: .normal)
                button.backgroundColor = UIColor.systemCyan
            }
        timerLabel.text = timeString(time: time)
        countGameLabel.text = "\(countMoves)"
        timer.invalidate()
        
    }
    
    @IBAction func game(_ sender: UIButton) {
        
        shuffleArray()
        
        let winState = arrayToIndexArraay(in: images)
        print(sender.tag)
        
        startTimer()
        
        if state[sender.tag - 1] != 0 || isActive {
            return
        }
        
        sender.setBackgroundImage(UIImage(named: images[sender.tag - 1]), for: .normal)
        sender.backgroundColor = UIColor.white
        
        state[sender.tag - 1] = 1
        
        var count = 0
        
        for item in state{
            if item == 1 {
                count += 1
            }
        }
        if count == 2 {
            isActive = true
            
            for winArray in winState {
                if state[winArray[0]] == state[winArray[1]] && state[winArray[1]] == 1 {
                    state[winArray[0]] = 2
                    state[winArray[1]] = 2
                    isActive = false
                    testCount += 1
                    print("testCount = \(testCount)")
                    if testCount == 8 {
                        timer.invalidate()
                        let alert = UIAlertController(title: "Поздравляем, вы закончили игру за \(timeString(time: time)) и \(countMoves) ходов!", message: nil, preferredStyle: .alert)
                        
                        alert.addAction(UIAlertAction(title: "Start again", style: .default, handler: startAgain))
                        present(alert, animated: true, completion: nil)
                    }
                }
                
            }
            if isActive == true {
                Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(clear), userInfo: nil, repeats: false)
                
            }
        }
        countMovesFunc()
    }
    
   
    @objc func clear() {
        for i in 0...15 {
            if state[i] == 1 {
                state[i] = 0
                let button = view.viewWithTag(i + 1) as! UIButton
                button.setBackgroundImage(nil, for: .normal)
                button.backgroundColor = UIColor.systemCyan
            }
        }
        isActive = false
        
    }
    
    func startTimer() {
        if isTimerRunning {
            return
        }
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countTimer), userInfo: nil, repeats: true)
        isTimerRunning = true
    }
    
    @objc func countTimer() {
        time += 1
        timerLabel.text = timeString(time: time)
    }
    
    func timeString(time: Int) -> String {
            let hour = Int(time) / 3600
            let minute = Int(time) / 60 % 60
            let second = Int(time) % 60

            // return formated string
            return String(format: "%02i:%02i:%02i", hour, minute, second)
        }
    
    func countMovesFunc() {
        if !isActive  {
            countMoves += 1
            countGameLabel.text = "\(countMoves)"
        } else {
            return
        }
    }
    
    func shuffleArray() {
        if !isShuffleArray  {
            images.shuffle()
            isShuffleArray = true
        } else {
            return
        }
    }
    
    func arrayToIndexArraay(in array: [String]) -> [[Int]] {
        var winState: [[Int]] = []
        var state: [String: [Int]] = [:]
        
        for (index, element) in array.enumerated() {
            if state[element] != nil {
                state[element]!.append(index)
            } else {
                state[element] = [index]
            }
        }
        
        for indices in state.values {
            if indices.count > 1 {
                winState.append(indices)
            }
        }
        
        return winState
    }
    
    func startAgain(action: UIAlertAction) {
        
        if let savedTime = UserDefaults.standard.object(forKey: "savedTime") as? Int {
            if time < savedTime {
                UserDefaults.standard.set(time, forKey: "savedTime")
            } else {
                
            }
        } else {
            UserDefaults.standard.set(time, forKey: "savedTime")
        }
                                          
        time = 0
        state = [Int](repeating: 0, count: 16)
        isActive = false
        isTimerRunning = false
        countMoves = 0
        isShuffleArray = false
        testCount = 0
        for i in 0...15 {
                state[i] = 0
                let button = view.viewWithTag(i + 1) as! UIButton
                button.setBackgroundImage(nil, for: .normal)
                button.backgroundColor = UIColor.systemCyan
            }
        timerLabel.text = timeString(time: time)
        countGameLabel.text = "\(countMoves)"
        bestTimeLabel.text = timeString(time: UserDefaults.standard.integer(forKey: "savedTime"))
    }
}
    


