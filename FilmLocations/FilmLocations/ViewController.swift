//
//  ViewController.swift
//  FilmLocations
//
//  Created by Mondale on 4/13/20.
//  Copyright © 2020 Mondale. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var films:[FilmEntry] = []
    var table = UITableView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        getDataFromFile("locations")
        configureTableView()
    }

    
    func getDataFromFile(_ fileName: String){
        let path = Bundle.main.path(forResource: fileName, ofType: ".json")
        if let path = path {
            let url = URL(fileURLWithPath: path)
            let contents = try? Data(contentsOf: url)
            
            do {
                if let data = contents,
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [[String: Any]] {
                    for film in jsonResult{
                        let firstActor = film["actor_1"] as? String ?? ""
                        let locations = film["locations"] as? String  ?? ""
                        let releaseYear = film["release_year"] as? String  ?? ""
                        let title = film["title"] as? String  ?? ""
                        let movie = FilmEntry(firstActor: firstActor, locations: locations, releaseYear: releaseYear, title: title)
                        films.append(movie)
                    }
                }
            } catch {
                print("Error deserializing JSON: \(error)")
            }
        }
    }
    
    func configureTableView(){
        view.addSubview(table)
        table.rowHeight = 100
        table.translatesAutoresizingMaskIntoConstraints = false
        table.delegate = self
        table.dataSource = self
        table.register(FilmCell.self, forCellReuseIdentifier: "FilmCell")
        NSLayoutConstraint.activate([
            table.topAnchor.constraint(equalTo: view.topAnchor),
            table.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            table.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            table.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    
}

extension ViewController: UITableViewDelegate {
    
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return films.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FilmCell",for: indexPath) as! FilmCell
        let film = films[indexPath.row].locations
        cell.nameLabel.text = film
        return cell
    }
    
    
}
