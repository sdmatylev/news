//
//  ViewController.swift
//  News
//
//  Created by Савелий on 13.07.2023.
//

import UIKit

class MenuViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black

        let startButton = UIButton(type: .system)
        startButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(startButton)
        
        startButton.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                             constant: 100).isActive = true
        startButton.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                              constant: -100).isActive = true
        startButton.topAnchor.constraint(equalTo: view.topAnchor,
                                         constant: 400).isActive = true
        startButton.bottomAnchor.constraint(equalTo: view.bottomAnchor,
                                            constant: -400).isActive = true
        
        startButton.setTitle("Показать новости", for: .normal)
        startButton.setTitleColor(Config.buttonTextColor, for: .normal)
        startButton.layer.cornerRadius = Config.buttonCornerRadius
        startButton.backgroundColor = Config.buttonBackgroudColor
        startButton.addTarget(self, action: #selector(nextScene),
                              for: UIControl.Event.touchUpInside)
    }
    
    @objc
    func nextScene() {
        let nextScene = NewsViewController()
        navigationController?.pushViewController(nextScene, animated: true)
    }
}
