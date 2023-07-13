//
//  NewsViewController.swift
//  News
//
//  Created by Савелий on 13.07.2023.
//

import UIKit

class NewsViewController: UIViewController {
    private let newsFeed = UITableView()
    private var news: [News] = [] {
        didSet {
            DispatchQueue.main.async {
                self.newsFeed.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTable()
        getData()
    }
    
    func setupTable() {
        newsFeed.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(newsFeed)
        newsFeed.topAnchor.constraint(equalTo: view.topAnchor,
                                      constant: 80).isActive = true
        newsFeed.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        newsFeed.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        newsFeed.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        newsFeed.dataSource = self
        newsFeed.delegate = self
    }
    
    func getData() {
        let key = "e30df1ce6b3e404fb343f8fb1e607c09"
        var request = URLRequest(url: URL(string: "https://newsapi.org/v2/top-headlines?country=ru&apiKey=\(key)")!)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                self.updateData(from: data)
            }
        }
        
        task.resume()
    }
    
    func updateData(from dates: Data) {
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: dates)
            guard
                let json1 = jsonObject as? [String: Any],
                let json = json1["articles"] as? [[String: Any]]
            else {
                return
            }
            
            for i in 0..<json.count {
                let currentNews = json[i]
                news.append(News(title: currentNews["title"] as? String,
                                 description: currentNews["description"] as? String,
                                 date: currentNews["publishedAt"] as? String))
            }
        } catch { }
    }
}

extension NewsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        news.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
                let curNews = news[indexPath.row]
                cell.backgroundColor = Config.deviderColor
                cell.layer.cornerRadius = 16
                cell.textLabel?.text = curNews.title
                cell.textLabel?.font = cell.textLabel?.font.withSize(15)
                cell.textLabel?.numberOfLines = 0
                cell.detailTextLabel?.numberOfLines = 0
                cell.detailTextLabel?.text = "\(curNews.description ?? "")\n Дата публикации: \(curNews.date ?? "неизвестна")"
                cell.detailTextLabel?.font = cell.detailTextLabel?.font.withSize(10)
                cell.textLabel?.numberOfLines = 0
        
                return cell
    }
}
