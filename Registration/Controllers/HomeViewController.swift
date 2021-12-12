//
//  HomeViewController.swift
//  Registration
//
//  Created by Александр Басов on 11/9/21.
//

import UIKit
import Firebase

class HomeViewController: UIViewController {

    var user: User!
    var ref: DatabaseReference!
    var tasks = [Task]()
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       addObserver()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeAll()
    }
    
    
    @IBAction func addTap(_ sender: Any) {
        let alertController = UIAlertController(title: "New task", message: "Add new task", preferredStyle: .alert)
        alertController.addTextField()
        // action 1
        let save = UIAlertAction(title: "Save", style: .default) { [weak self] _ in
            guard let textField = alertController.textFields?.first,
                  let text = textField.text,
                  let uid = self?.user.uid else { return }
            let task = Task(title: text, userId: uid)
            let taskRef = self?.ref.child(task.title.lowercased())
            taskRef?.setValue(task.convertToDictionary())
        }
        // action 2
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(save)
        alertController.addAction(cancel)
        present(alertController, animated: true)
    }
    
    @IBAction func signOutTapp(_ sender: Any) {
        do {
            try Auth.auth().signOut()
        } catch {
            print(error.localizedDescription)
        }
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: Private
    private func toggleCompletion(_ cell: UITableViewCell, isCompleted: Bool) {
        cell.accessoryType = isCompleted ? .checkmark : .none
    }
}


// MARK: UITableViewDelegate, UITableViewDataSource

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tasks.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.backgroundColor = .clear
        cell.textLabel?.textColor = .black
        let currentTask = tasks[indexPath.row]
        cell.textLabel?.text = currentTask.title
        toggleCompletion(cell, isCompleted: currentTask.completed)
        return cell
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle != .delete { return }
        let task = tasks[indexPath.row]
        // удаление
        task.ref?.removeValue()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        let task = tasks[indexPath.row]
        let isCompleted = !task.completed

        // изменяем ячейку
        toggleCompletion(cell, isCompleted: isCompleted)
        // меняем isCompleted
        task.ref?.updateChildValues(["completed": isCompleted])
    }
}
//MARK: - configure
private extension HomeViewController {
    func configure() {
        guard let currentUser = Auth.auth().currentUser else { return }
        user = User(user: currentUser)
        ref = Database.database().reference(withPath: "users").child(String(user.uid)).child("tasks")
    }
}

//MARK: - removeAll
private extension HomeViewController {
    func removeAll() {
        // удаляем всех Observers
        ref.removeAllObservers()
    }
}

//MARK: - addObserver
private extension HomeViewController {
    func addObserver() {
        // наблюдатель за значениями
        ref.observe(.value) { [weak self] snapshot in
            var tasks = [Task]()
            for item in snapshot.children { // вытаскиваем все tasks
                guard let snapshot = item as? DataSnapshot, let task = Task(snapshot: snapshot) else { continue }
                tasks.append(task)
            }
            self?.tasks = tasks
            self?.tableView.reloadData()
        }
    }
}
