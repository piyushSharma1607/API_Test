//
//  ViewController.swift
//  Test
//
//  Created by Piyush Sharma on 26/04/24.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - Properties
    var apiData = [PostData]()
    var currentPage = 1
    let itemsPerPage = 20
    var isLoading = false
    let activityIndicator = UIActivityIndicatorView(style: .medium)
    var computedDetailsCache: [Int: String] = [:] // Cache for computed details

    // MARK: - Outlets
    @IBOutlet weak var dataTableView: UITableView!
    
    // MARK: - Life Cycle
     override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupActivityIndicator()
        fetchPosts()
    }
    
    func setupActivityIndicator() {
         activityIndicator.hidesWhenStopped = true
        dataTableView.addSubview(activityIndicator)
         activityIndicator.translatesAutoresizingMaskIntoConstraints = false
         NSLayoutConstraint.activate([
             activityIndicator.centerXAnchor.constraint(equalTo: dataTableView.centerXAnchor),
             activityIndicator.bottomAnchor.constraint(equalTo: dataTableView.bottomAnchor, constant: -20)
         ])
     }
    
    func fetchPosts() {
        guard !isLoading else { return }
        isLoading = true
        activityIndicator.startAnimating()
        
        let urlString = "https://jsonplaceholder.typicode.com/posts?_page=\(currentPage)&_limit=\(itemsPerPage)"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                       self.activityIndicator.stopAnimating()
                   }
            if let error = error {
                print("Error fetching data: \(error)")
                return
            }
            guard let data = data else { return }
            do {
                let newPosts = try JSONDecoder().decode([PostData].self, from: data)
                DispatchQueue.main.async {
                    self.apiData.append(contentsOf: newPosts)
                    self.dataTableView.reloadData()
                    self.isLoading = false
                }
            } catch {
                print("Error decoding data: \(error)")
            }
        }.resume()
    }
    
    
    fileprivate func setupTableView() {
        let nib = UINib(nibName: PostTableCell.identifier, bundle: .main)
        dataTableView.register(nib, forCellReuseIdentifier: PostTableCell.identifier)
    }


}//..
 
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return apiData.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: PostTableCell.identifier, for: indexPath) as? PostTableCell {
            cell.configureCell(model: apiData[indexPath.row])
            loadAdditionalDetails(for: apiData[indexPath.row], at: indexPath)
            return cell
        }
        return UITableViewCell()
    }
    

      func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
           let lastRowIndex = tableView.numberOfRows(inSection: 0) - 1
           if indexPath.row == lastRowIndex {
               currentPage += 1
               fetchPosts()
           }
       }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let controller = self.storyboard?.instantiateViewController(withIdentifier: DetailViewController.description()) as? DetailViewController {
            controller.apiData = apiData[indexPath.row]
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
        
    }
}//..

// MARK: - Computation Functions
extension ViewController {
    // MARK: - Additional Details Loading
     
    func loadAdditionalDetails(for post: PostData, at indexPath: IndexPath) {
        if let cachedDetails = computedDetailsCache[indexPath.row] {
            // Use cached details if available
            updateCell(with: cachedDetails, at: indexPath)
        } else {
            let startTime = DispatchTime.now()
            // Perform heavy computation asynchronously
            DispatchQueue.global(qos: .background).async {
                let computedDetails = self.computeDetails(for: post)
                let endTime = DispatchTime.now()
                let elapsedTime = Double(endTime.uptimeNanoseconds - startTime.uptimeNanoseconds) / 1_000_000_000 // Convert to seconds
                print("Time taken for computation for indexPath \(indexPath.row): \(elapsedTime) seconds")
                DispatchQueue.main.async {
                    // Cache computed details and update cell
                    self.computedDetailsCache[indexPath.row] = computedDetails
                    self.updateCell(with: computedDetails, at: indexPath)
                }
            }
        }
    }
    
    func updateCell(with details: String, at indexPath: IndexPath) {
          if let cell = dataTableView.cellForRow(at: indexPath) {
              // Update cell with computed details
              cell.detailTextLabel?.text = details
          }
      }
    
    func computeDetails(for post: PostData) -> String {
          // Simulate heavy computation
          // Replace this with your actual computation logic
          var result = ""
          for _ in 0..<100000 {
              result += post.body
          }
          return result
      }
    
}

