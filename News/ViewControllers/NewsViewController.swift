//
//  NewsViewController.swift
//  News
//
//  Created by Савелий on 13.07.2023.
//

import UIKit

class NewsViewController: UIViewController {
    private let newsFeed = UITableView()
    private var stack = UIStackView()
    private var news: [News] = [] {
        didSet {
            DispatchQueue.main.async {
                self.stack.isHidden = true
                self.newsFeed.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setupTable()
        setUpStack()
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
        
        newsFeed.separatorStyle = .none
        
        newsFeed.dataSource = self
        newsFeed.delegate = self
    }
    
    func setUpStack() {
        let activityInd = UIActivityIndicatorView()
        activityInd.style = .medium
        activityInd.startAnimating()
        activityInd.translatesAutoresizingMaskIntoConstraints = false
        activityInd.color = .white
        stack.addArrangedSubview(activityInd)
        stack.axis = .vertical
        
        let label = UILabel()
        label.text = "Загрузка"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = Config.deviderColor
        stack.addArrangedSubview(label)
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)
        label.textColor = .white
        stack.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stack.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
    }
    
    func getData() {
        let key = "e30df1ce6b3e404fb343f8fb1e607c09"
        let request = URLRequest(url: URL(string: "https://newsapi.org/v2/top-headlines?country=ru&category=business&apiKey=\(key)")!)
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

            for i in 0..<min(json.count, 15) {
                let currentNews = json[i]
                makeChatRequest(currentNews["title"] as! String) { text in
                    guard let text = text else {return}
                    self.news.append(News(title: currentNews["title"] as? String,
                                     description: text,
                                          date: self.dateEnchancer(currentNews["publishedAt"] as! String),
                                     link: currentNews["url"] as? String))
                }
            }
        } catch { }
    }
    
    func dateEnchancer(_ string: String) -> String {
        let result = string.replacingOccurrences(of: "Z", with: "")
        return result.replacingOccurrences(of: "T", with: " ")
    }
}

extension NewsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        news.count
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UIApplication.shared.open(URL(string: news[indexPath.row].link ?? "")!)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        
        let curNews = news[indexPath.row]
        cell.backgroundColor = Config.deviderColor
        cell.layer.cornerRadius = 16
        cell.textLabel?.text = "\(curNews.title ?? "")\n"
        cell.textLabel?.font = cell.textLabel?.font.withSize(15)
        cell.textLabel?.numberOfLines = 0
        cell.detailTextLabel?.numberOfLines = 0
        cell.detailTextLabel?.text = "\(curNews.description ?? "")\n \nДата публикации: \(curNews.date ?? "неизвестна")"
        cell.detailTextLabel?.font = cell.detailTextLabel?.font.withSize(10)

        return cell
    }
}
