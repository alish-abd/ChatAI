//
//  ViewController.swift
//  ChatAI
//
//  Created by Alisher Abdulin on 25.01.2023.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    
    
    private let field: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Type something ..."
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .systemGray6
//        textField.borderStyle = .lineHo to
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 20
        textField.layer.borderColor = UIColor.gray.cgColor
//        textField.layer.borderRa
        
        textField.returnKeyType = .done
        return textField
    }()
    
    private var models = [String]()
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell" )
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        let paddingView = UIView(frame: CGRectMake(0, 0, 15, self.field.frame.height))
        field.leftView = paddingView
        field.leftViewMode = UITextField.ViewMode.always
        view.addSubview(field)
        view.addSubview(tableView)
        
        field.delegate = self
        
        NSLayoutConstraint.activate([
            field.heightAnchor.constraint(equalToConstant: 50),
            field.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 10),
            field.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -10),
            field.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor ),
            
            tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor  .constraint(equalTo: field.topAnchor)
            
        ])
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = models[indexPath.row]
        cell.textLabel?.numberOfLines = 0
        return cell
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let text = textField.text, !text.isEmpty {
            models.append(text)
            APICaller.shared.getResponse(input: text) { [weak self] result in
                switch result {
                case .success(let output):
                    self?.models.append(output)
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                        self?.field.text = nil
                    }
                case .failure:
                    print("Failed")
                }
            }
        }
        return true
    }


}

