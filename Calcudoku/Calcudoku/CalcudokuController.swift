//
//  ViewController.swift
//  calcudoku
//
//  Created by cofincup on 2023/11/12.
//

import UIKit

class CalcudokuController: UIViewController {
    var size = 4
    var difficulty: String = ""
    var volumeIndex: Int = 0
    var bookIndex: Int = 0
    
    @IBOutlet var inputStack: UIStackView!
    @IBOutlet var verticalStackView: UIStackView!
    var cellViews = [UIView]()
    var cellButtons = [UIButton]()
    var ruleLabels = [UILabel]()
    
    var cells = [[Cell]]()
    var rules = [Rule]()
    var rulesMap = [[[Rule]]]()
    
    var chosenCell : Cell? = nil {
        didSet {
            if chosenCell?.x == oldValue?.x && chosenCell?.y == oldValue?.y {
                return
            }
            
            if chosenCell != nil {
                cellButtons[getIndex(x: chosenCell!.x, y: chosenCell!.y)].backgroundColor = UIColor.yellow
            }
            if oldValue != nil {
                cellButtons[getIndex(x: oldValue!.x, y: oldValue!.y)].backgroundColor = UIColor.white
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.navigationItem.title =   "\(self.size)*\(self.size) \(self.difficulty) Vol. \(self.volumeIndex) Book \(self.bookIndex)"
        
        for y in 0..<size {
            let horizontalStackView = UIStackView()
            horizontalStackView.axis = .horizontal
            horizontalStackView.alignment = .fill
            horizontalStackView.distribution = .fillEqually
            horizontalStackView.spacing = 3
            for x in 0..<size {
                let cell = UIView()
                horizontalStackView.addArrangedSubview(cell)
                constructCell(cell: cell, tag: getIndex(x: x, y: y))
            }
            verticalStackView.addArrangedSubview(horizontalStackView)
            
            let inputButton = UIButton()
            constructInputButton(inputButton: inputButton, tag: y + 1)
            inputStack.addArrangedSubview(inputButton)
        }
        inputStack.heightAnchor.constraint(equalTo: cellButtons[0].heightAnchor).isActive = true
        
        
        // init arrays
        for y in 0..<size {
            cells.append([Cell]())
            rulesMap.append([[Rule]]())
            for x in 0..<size {
                cells[y].append(Cell(x: x, y: y))
                rulesMap[y].append([Rule]())
            }
        }
        
        // differ rules
        for y in 0..<size {
            let rule = Rule(type: .Differ)
            for x in 0..<size {
                rule.addCell(cell: cells[y][x])
            }
            rules.append(rule)
        }
        for x in 0..<size {
            let rule = Rule(type: .Differ)
            for y in 0..<size {
                rule.addCell(cell: cells[y][x])
            }
            rules.append(rule)
        }
        
        // other calculation rules
        loadOtherRules()
        
        // init rule map
        for rule in rules {
            for cell in rule.cells {
                rulesMap[cell.y][cell.x].append(rule)
            }
        }
        
        fulfillUI()
    }
    
    func constructInputButton(inputButton: UIButton, tag: Int) {
        inputButton.setTitle(String(tag), for: .normal)
        inputButton.backgroundColor = .link
        inputButton.tag = tag
        inputButton.addTarget(self, action: #selector(putValue), for: .touchUpInside)
    }
    
    func constructCell(cell: UIView, tag: Int) {
        cell.isUserInteractionEnabled = true
        
        cell.backgroundColor = .white
        let button = UIButton()
        let label = UILabel()
        cell.addSubview(button)
        cell.addSubview(label)
        
        button.tag = tag
        button.setTitleColor(.black, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalTo: cell.widthAnchor).isActive = true
        button.heightAnchor.constraint(equalTo: cell.heightAnchor).isActive = true
        button.leadingAnchor.constraint(equalTo: cell.leadingAnchor).isActive = true
        button.topAnchor.constraint(equalTo: cell.topAnchor).isActive = true
        button.addTarget(self, action: #selector(choose), for: .touchUpInside)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.leadingAnchor.constraint(equalTo: cell.leadingAnchor, constant: 3).isActive = true
        label.topAnchor.constraint(equalTo: cell.topAnchor, constant: 3).isActive = true
        
        cellViews.append(cell)
        cellButtons.append(button)
        ruleLabels.append(label)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        fulfillUI()
    }
    
    func fulfillUI() {
        // fill rule labels
        for rule in rules {
            if rule.ruleInfo != "" {
                let markCell = rule.cells.first!
                ruleLabels[getIndex(x: markCell.x, y: markCell.y)].text = rule.ruleInfo
            }
        }
        
        let length = (verticalStackView.frame.height - CGFloat(3 * (size - 1))) / CGFloat(size)
        let width = 3
        
        for rule in rules {
            switch rule.type {
            case .Differ:
                continue
            default:
                break
            }
            
            for cell1 in rule.cells {
                for cell2 in rule.cells {
                    if abs(cell1.x - cell2.x) + abs(cell1.y - cell2.y) ==  1 {
                        let border = CALayer()
                        border.frame = CGRect(x: cell1.x - cell2.x == 0 ? CGFloat(0)
                                              : (cell1.x - cell2.x < 0 ? length : CGFloat(-width))
                                              , y: cell1.y - cell2.y == 0 ? CGFloat(0)
                                              : (cell1.y - cell2.y < 0 ? length : CGFloat(-width)),
                                              width: cell1.y - cell2.y == 0 ? CGFloat(width) : length,
                                              height: cell1.x - cell2.x == 0 ? CGFloat(width) : length)
                        border.backgroundColor = UIColor.white.cgColor
                        cellButtons[getIndex(x: cell1.x, y: cell1.y)].layer.addSublayer(border)
                    }
                }
            }
        }
        
//        let border = CALayer();
//        border.frame = CGRect(x: -3, y: 0, width: CGFloat(width), height: length)
//        border.backgroundColor = UIColor.white.cgColor
//        cellButtons[6].layer.addSublayer(border)
    }
    
    func loadingFailAlert() {
        let alert = UIAlertController(title: "Fail to Load!", message: "Json not found!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Close", style: .default))
        self.present(alert, animated: true)
    }
    
    func loadOtherRules() {
        guard let jsonURL = Bundle.main.url(forResource: "./rule/size\(size)/vol\(volumeIndex)/\(difficultyToMark(difficulty: difficulty))/book\(bookIndex)", withExtension: "json") else {
            loadingFailAlert()
            return
        }
        let data = try! Data(contentsOf: jsonURL)
        guard let json = try! JSONSerialization.jsonObject(with: data) as? [[String: Any]] else {
            loadingFailAlert()
            return
        }
        
        for ruleJson in json {
            let target = ruleJson["target"] as! Int
            let calculation = ruleJson["calculation"] as! String
            let cellJsons = ruleJson["cells"] as! [[Int]]
            let rule = Rule(type: Rule.getType(calculationMark: calculation, target: target))
            for cellJson in cellJsons {
                rule.addCell(cell: cells[cellJson[0]][cellJson[1]])
            }
            rules.append(rule)
        }
    }
    
    func getIndex(x: Int, y: Int) -> Int {
        return x + y * size
    }
    
    func getX(index: Int) -> Int {
        return index % size
    }
    
    func getY(index: Int) -> Int {
        return index / size
    }
    
    @IBAction func choose(_ sender: UIButton) {
        let index = sender.tag
        chosenCell = cells[getY(index: index)][getX(index: index)]
    }
    
    @IBAction func putValue(_ sender: UIButton) {
        if chosenCell == nil {
            return
        }
        
        let newValue = sender.tag
        chosenCell!.value = newValue
        cellButtons[getIndex(x: chosenCell!.x, y: chosenCell!.y)].setTitle(chosenCell!.strValue, for: UIControl.State.normal)
        
        for rule in rulesMap[chosenCell!.y][chosenCell!.x] {
            let originStatus = rule.status
            rule.examine()
            if rule.status != originStatus{
                for cell in rule.cells {
                    cellButtons[getIndex(x: cell.x, y: cell.y)].setTitleColor(decideCellColor(cell: cell), for: .normal)
                }
            }
        }
        
        checkSuccess()
    }
    
    @IBAction func allClear() {
        for cellRow in cells {
            for cell in cellRow {
                cell.value = 0
            }
        }
        
        for cellButton in cellButtons {
            cellButton.setTitle("", for: UIControl.State.normal)
        }
    }
    
    func decideCellColor(cell: Cell) -> UIColor {
        var stillFail = false;
        for rule in rulesMap[cell.y][cell.x] {
            if rule.status == .Fail {
                stillFail = true
                break
            }
        }
        
        return stillFail ? UIColor.red : UIColor.black
    }
    
    func checkSuccess() {
        for rule in rules {
            if rule.status != .Pass {
                return
            }
        }
        
        let alert = UIAlertController(title: "Success!", message: "You have finished this Calcudoku!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Nice!", style: .default))
        self.present(alert, animated: true)
    }
}

func difficultyToMark(difficulty: String) -> String {
    switch(difficulty) {
        case "Beginner":
            return "KX"
        case "Easy":
            return "E"
        case "Med":
            return "M"
        case "Hard":
            return "H"
        case "Mixed":
            return "X"
        default:
            return ""
    }
}
