//
//  ViewController.swift
//  TaskGroupSample
//
//  Created by Vince P. Nguyen on 2024-10-12.
//

import UIKit

class ViewController: UIViewController {
    
    var data:[QuoteImage] = []
    
    private lazy var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "RANDOM IMAGES & QUOTES"
        lbl.textAlignment = .left
        lbl.textColor = .systemBlue
        lbl.font = .boldSystemFont(ofSize: 26)
        lbl.numberOfLines = 0
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private lazy var reloadBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(systemName: "arrow.clockwise"), for: [])
        btn.addTarget(self, action: #selector(reloadTapped), for: .touchUpInside)
        return btn
    }()
    
    private lazy var tableView: UITableView = {
        let tblView = UITableView()
        tblView.showsVerticalScrollIndicator = false
        tblView.delegate = self
        tblView.dataSource = self
        tblView.translatesAutoresizingMaskIntoConstraints = false
        tblView.register(CustomCell.self, forCellReuseIdentifier: "CustomCell")
        return tblView
    }()
    
    private lazy var topHorizontalStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(quoteImageDidGet(notification:)), name: .didFetchQuoteImage, object: nil)
        customizeUI()
        layout()
        loadData()
    }
    
    private func customizeUI() {
        
        view.addSubview(topHorizontalStackView)
        view.addSubview(tableView)
        
        topHorizontalStackView.addArrangedSubview(titleLabel)
        topHorizontalStackView.addArrangedSubview(reloadBtn)
        titleLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        reloadBtn.setContentCompressionResistancePriority(.required, for: .horizontal)
    }
    
    private func layout() {
        
        //layout topHorizontalStackView
        NSLayoutConstraint.activate([
            topHorizontalStackView.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 2),
            topHorizontalStackView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 2),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: topHorizontalStackView.trailingAnchor, multiplier: 2)
        ])
        
        //layout tableView
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalToSystemSpacingBelow: topHorizontalStackView.bottomAnchor, multiplier: 2),
            tableView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 2),
            view.safeAreaLayoutGuide.bottomAnchor.constraint(equalToSystemSpacingBelow: tableView.bottomAnchor, multiplier: 2),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: tableView.trailingAnchor, multiplier: 2)
        ])
    }
    
    private func loadData() {
        
        Task(priority: .userInitiated) {
            print("Task is running")
            do {
                try await Network().getQuoteImages(amount: 5)
            } catch {
                print("Error loading data: \(error)")
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! CustomCell
        let item = data[indexPath.row]
        
        cell.quoteLbl.text = item.quote.q
        cell.imgView.image = UIImage(data: item.imgData)
        
        return cell
    }
    
}

extension ViewController {
    @objc private func reloadTapped() {
        loadData()
    }
}

extension ViewController {
    @objc private func quoteImageDidGet(notification: Notification) {
        Task {
            await handleQuoteImage(notification: notification)
        }
    }

    private func handleQuoteImage(notification: Notification) async {
        if let quoteImage = notification.object as? QuoteImage {
            
            data.append(quoteImage)
            
            await MainActor.run {
                self.tableView.reloadData()
                self.scrollToLastItem()
            }
        }
    }
    
    private func scrollToLastItem() {
        let lastRowIndex = data.count - 1
        if lastRowIndex >= 0 {
            let lastIndexPath = IndexPath(row: lastRowIndex, section: 0)
            tableView.scrollToRow(at: lastIndexPath, at: .bottom, animated: true)
        }
    }
}
