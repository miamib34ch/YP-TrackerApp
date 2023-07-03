//
//  ScheduleController.swift
//  YP-TrackerApp
//
//  Created by Богдан Полыгалов on 20.05.2023.
//

import UIKit

class ScheduleController: UIViewController, CreateTrackerDelegate {
    var createTrackerController: CreateTrackerProtocol?
    
    let label = UILabel()
    let button = UIButton()
    var table = UITableView()
    var switchViews: [UISwitch?] = []
    var daysOfWeek = ["Понедельник", "Вторник", "Среда", "Четверг", "Пятница", "Суббота", "Воскресенье"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //меняем цвет фона фона uiswitch, поскольку каждый раз при открытии вью он отрисовывается с параметрами по-умолчанию
        //метод выбран, потому что вью уже отрисовано и можно менять цвет
        for switchView in switchViews {
            switchView?.layer.sublayers?[0].sublayers?[0].backgroundColor = UIColor(named: "#E6E8EB")?.cgColor
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        var createTrackerController = createTrackerController ?? CreateTrackerController()
        createTrackerController.tableSubnames[1] = createSubname()
        createTrackerController.setTableSubnames()
    }
    
    func configureView() {
        view.backgroundColor = UIColor(named: "MainBackgroundColor")
        configureLabel()
        configureButton()
        configureTable()
    }
    
    func configureLabel() {
        
        label.text = "Расписание"
        label.textColor = UIColor(named: "MainForegroundColor")
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: 27),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.heightAnchor.constraint(equalToConstant: 16)
        ])
    }
    
    func configureButton() {
        
        button.backgroundColor = UIColor(named: "MainForegroundColor")
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.setTitle("Готово", for: .normal)
        button.setTitleColor(UIColor(named: "MainBackgroundColor"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.addTarget(self, action: #selector(buttonTap), for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            button.heightAnchor.constraint(equalToConstant: 60),
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    @objc func buttonTap() {
        var createTrackerController = createTrackerController ?? CreateTrackerController()
        createTrackerController.tableSubnames[1] = createSubname()
        createTrackerController.setTableSubnames()
        dismiss(animated: true)
    }
    
    func createSubname() -> String {
        guard let createTrackerController = createTrackerController else { return "" }
        let indices = createTrackerController.selectedShedule.indices
        var days: [String] = []
        for index in indices {
            if createTrackerController.selectedShedule[index] == true {
                switch index {
                case 0:
                    days.append("Пн")
                case 1:
                    days.append("Вт")
                case 2:
                    days.append("Ср")
                case 3:
                    days.append("Чт")
                case 4:
                    days.append("Пт")
                case 5:
                    days.append("Сб")
                case 6:
                    days.append("Вс")
                default:
                    break
                }
            }
        }
        if days.count == 7 {
            return "Каждый день"
        }
        else {
            var subname = ""
            for day in days {
                subname += day
                if day != days[days.count - 1] {
                    subname += ", "
                }
            }
            return subname
        }
    }
    
    func configureTable() {
        if !(view.contains(label) && view.contains(button)) {
            return
        }
        
        table.separatorStyle = .none
        table.backgroundColor = .clear
        
        table.dataSource = self
        table.delegate = self
        
        table.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(table)
        
        NSLayoutConstraint.activate([
            table.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            table.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            table.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            table.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 30),
            table.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -47),
            table.heightAnchor.constraint(equalToConstant: 525)
        ])
    }
    
}

extension ScheduleController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return daysOfWeek.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        cell.backgroundColor = UIColor(named: "ElementsBackgroundColor")
        cell.selectionStyle = .none
        
        let switchView = UISwitch(frame: CGRect(x: 0, y: 0, width: table.frame.width - cell.contentView.frame.width, height: 15))
        switchViews.append(switchView)
        
        switchView.layer.sublayers?[0].sublayers?[0].backgroundColor = UIColor(named: "#E6E8EB")?.cgColor
        
        
        
        switchView.onTintColor = UIColor(named: "#3772E7")
        switchView.isOn = createTrackerController?.selectedShedule[indexPath.row] ?? false
        switchView.addTarget(self, action: #selector(switchChanged(_:)), for: .valueChanged)
        cell.accessoryView = switchView
        
        
        cell.textLabel?.text = daysOfWeek[indexPath.row]
        
        if indexPath.row == 0 {
            cell.layer.cornerRadius = 16
            cell.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            cell.layer.masksToBounds = true
        }
        if indexPath.row == daysOfWeek.count - 1 {
            cell.layer.cornerRadius = 16
            cell.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            cell.layer.masksToBounds = true
        }
        if indexPath.row != 0 {
            
            let modelName = UIDevice.current.modelName
            if modelName == "iPhone SE" {
                cell.addSeperator(accessoryWidth: (cell.accessoryView?.frame.width ?? 0) - 30)
            }
            else {
                cell.addSeperator(accessoryWidth: (cell.accessoryView?.frame.width ?? 0) - 10)
            }
        }
        
        
        return cell
    }
}

extension ScheduleController: UITableViewDelegate {
    @objc func switchChanged(_ sender: UISwitch) {
        guard let cell = sender.superview as? UITableViewCell,
              let indexPath = table.indexPath(for: cell) else {
            return
        }
        
        createTrackerController?.selectedShedule[indexPath.row] = sender.isOn
        // Здесь вы можете выполнить необходимые действия при изменении состояния переключателя
    }
}
