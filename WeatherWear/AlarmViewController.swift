//
//  AlarmViewController.swift
//  WeatherWear
//
//  Created by Zander Chown on 11/13/23.
//

import UIKit

class AlarmViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    private var models = [AlarmListItem]()
    
    private var timeSelect = Date()

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let tableView:UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "alarmcell")
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .darkGray
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        self.view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
        tableView.backgroundColor = .lightGray
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAdd))
        
        getAllItems()
    }
    
//    add functionality to choose a date
    @objc private func didTapAdd() {
        var timePicker = UIDatePicker()
        timePicker.preferredDatePickerStyle = UIDatePickerStyle.wheels
        timePicker.setValue(UIColor.white, forKeyPath: "textColor")
        
        timePicker.datePickerMode = .time
        timePicker.addTarget(self, action: #selector(timePickerChange(sender:)), for: UIControl.Event.valueChanged)
        timePicker.frame = view.bounds
        timePicker.backgroundColor = .darkGray
        self.view.addSubview(timePicker)
//        timePicker.center = tableView.convert(tableView.center, from:tableView.superview)
    }
    
    @objc private func timePickerChange(sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat =  "hh:mm a"
//        timeSelect = formatter.string(from: sender.date)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "alarmcell", for: indexPath)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        
//       if for whatever reason the alarm has a nil date the default is the current date
        cell.textLabel?.text = dateFormatter.string(from: model.dateTime ?? Date())
        return cell
    }
   
    func getAllItems() {
        do {
            models = try context.fetch(AlarmListItem.fetchRequest())
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        catch {
//           ToDo
        }
    }
    
    func createItem() -> AlarmListItem {
        let newItem = AlarmListItem(context: context)
//      default values to current time and disabled
        newItem.dateTime = Date()
        newItem.enabled = false
        
        do {
            try context.save()
            getAllItems()
        }
        catch {
//          ToDo
        }
        
        return newItem
    }
    
    func createItem(dt: Date) -> AlarmListItem {
        let newItem = AlarmListItem(context: context)
        newItem.dateTime = dt
        newItem.enabled = false
        
        do {
            try context.save()
            getAllItems()
        }
        catch {
//           ToDo
        }
        return newItem
    }
    
    func deleteItem(item: AlarmListItem) {
        context.delete(item)
        
        do {
            try context.save()
        }
        catch {
//           ToDo
        }
    }
    
//   ToDo
    func updateItem(item: AlarmListItem) {
    }
}

