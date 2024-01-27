//
//  ViewController.swift
//  Calcudoku-Collection
//
//  Created by cofincup on 2024/1/11.
//

import UIKit
import WebKit

class BookViewController: UIViewController {
    var calcudokuSize: Int = 0
    var difficulty: String = ""
    var volumeIndex: Int = 0
    var bookIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.navigationItem.title = "\(self.calcudokuSize)*\(self.calcudokuSize) \(self.difficulty) Vol. \(self.volumeIndex) Book \(self.bookIndex)"
        print("https://files.krazydad.com/inkies/sfiles/INKY\(self.volumeIndex == 1 ? "" : ("_v" + String(self.volumeIndex)))_\(self.calcudokuSize)\(self.difficultyToMark(difficulty: difficulty))_b\(String(format: "%03d", self.bookIndex))_4pp.pdf")
        self.navigationItem.backButtonTitle = "Back"
        
        if let url = URL(string: "https://files.krazydad.com/inkies/sfiles/INKY\(self.volumeIndex == 1 ? "" : ("_v" + String(self.volumeIndex)))_\(self.calcudokuSize)\(self.difficultyToMark(difficulty: difficulty))_b\(String(format: "%03d", self.bookIndex))_4pp.pdf") {
            webView.load(URLRequest(url: url))
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
    
    @IBOutlet var webView: WKWebView!
}

