//
//  SearchVC.swift
//  iTunesSearchApp
//
//  Created by Mert Ozkaya on 8.09.2023.
//

import UIKit

class SearchVC: UIViewController {
    
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.placeholder = "Search..."
        searchBar.returnKeyType = .done
        searchBar.searchBarStyle = .minimal
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.keyboardDismissMode = .onDrag
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 30
        tableView.rowHeight = UITableView.automaticDimension
        tableView.contentInset = .init(top: 0, left: 0, bottom: 0, right: 0)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(PageTableViewCell.self, forCellReuseIdentifier: "PageTableViewCell")
        tableView.register(OnlyTextTableCell.self, forCellReuseIdentifier: "OnlyTextTableCell")
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private var viewModel: SearchViewModel?
    private var searchTimer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
        self.navigationItem.title = "Search in Apple Stores"
        self.view.backgroundColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel?.start()
    }
    
    func prepareUI() {
        view.addSubview(searchBar)
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: 44),
            
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        tableView.reloadData()
    }
    
    func binVM(viewModel: SearchViewModel) {
        self.viewModel = viewModel
        
        self.viewModel?.stateClosure = { [weak self] (state) in
            guard let self else { return }
            switch state {
            case .updateUI:
                self.tableView.reloadData()
            }
        }
    }
}

extension SearchVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel?.sections.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let section = viewModel?.sections[section] as? SearchViewModel.ContentSection {
            return section.sectionPageContent.count
        } else if viewModel?.sections[section] is SearchViewModel.NoDataSection {
            return 1
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let section = viewModel?.sections[indexPath.section] as? SearchViewModel.ContentSection {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PageTableViewCell", for: indexPath) as! PageTableViewCell
            let provider = section.sectionPageContent[indexPath.row].provider
            provider.frame = .init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: OnlyImageViewCollectionCell.cellHeight*10 + 9*10 + 30 + 20)
            provider.layoutIfNeeded()
            cell.setupUI(collectionViewProvider: provider)
            return cell
        } else if let section = viewModel?.sections[indexPath.section] as? SearchViewModel.NoDataSection {
            let cell = OnlyTextTableCell(style: .default, reuseIdentifier: "OnlyTextTableCell")
            cell.messageLabel.text = section.text
            return cell
        } else {
            return .init()
        }
    }
}

extension SearchVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let section = viewModel?.sections[section] as? SearchViewModel.ContentSection {
            let view = UIView()
            view.backgroundColor = .lightGray
            let label = UILabel(frame: .init(x: 10, y: 0, width: tableView.frame.width, height: 30))
            label.text = section.pageHeaderTitle
            label.font = .systemFont(ofSize: 15, weight: .medium)
            label.textColor = .black
            label.backgroundColor = .clear
            view.addSubview(label)
            
            return view
        }
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return viewModel?.sections[section] is SearchViewModel.ContentSection ? 30 : 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel?.sections[indexPath.section] is SearchViewModel.ContentSection ? (OnlyImageViewCollectionCell.cellHeight*10 + 9*10 + 30 + 20) : 30
    }
}

extension SearchVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("textDidChange >> text: \(searchText)")
        searchTimer?.invalidate()
        searchTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { [weak self] timer in
            self?.viewModel?.search(with: searchText.trimmingCharacters(in: .whitespacesAndNewlines))
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("searchBarSearchButtonClicked")
        searchBar.resignFirstResponder()
    }
}
