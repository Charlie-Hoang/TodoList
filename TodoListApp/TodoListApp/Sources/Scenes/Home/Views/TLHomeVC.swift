//
//  TLHomeVC.swift
//  TodoListApp
//
//  Created by Charlie on 6/6/20.
//  Copyright © 2020 C. All rights reserved.
//

import UIKit

class TLHomeVC: TLBaseVC, TLVC {
    
    var viewModel: TLHomeViewModel!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var newTaskButton: UIButton!
    @IBOutlet weak var labelsPickerViewContainer: UIView!
    @IBOutlet weak var labelsPickerView: UIPickerView!
    @IBOutlet weak var sortPickerViewContainer: UIView!
    @IBOutlet weak var sortPickerView: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Todo List"
        showLabelButton()
        showSortButton()
        initTableView()
        binding()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
    }
    @objc override func category() {
        sortPickerViewContainer.isHidden = true
        labelsPickerViewContainer.isHidden = false
        labelsPickerViewContainer.makeLTAnimation(animationType: .pushFromTop)
    }
    @objc override func sort() {
        labelsPickerViewContainer.isHidden = true
        sortPickerViewContainer.isHidden = false
        sortPickerViewContainer.makeLTAnimation(animationType: .pushFromTop)
    }
    
    @IBAction func doneLabelsPickerView(_ sender: Any) {
        labelsPickerViewContainer.isHidden = true
        self.labelsPickerViewContainer.makeLTAnimation(animationType: .pushFromBottom)
    }
    @IBAction func doneSortPickerView(_ sender: Any) {
        sortPickerViewContainer.isHidden = true
        sortPickerViewContainer.makeLTAnimation(animationType: .pushFromBottom)
    }
}
extension TLHomeVC{
    private func initTableView(){
        tableView.register(UINib(nibName: TLHomeCell.identifier, bundle: nil), forCellReuseIdentifier: TLHomeCell.identifier)
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.allowsMultipleSelectionDuringEditing = false
    }
    private func binding(){
        //list task
        viewModel.output.listTasks.asObservable().bind(to:tableView.rx.items) { (tableView, row, element) in
            let cell = tableView.dequeueReusableCell(withIdentifier: TLHomeCell.identifier) as! TLHomeCell
            cell.configCell(presenter: element)
            return cell
        }.disposed(by: disposeBag)
        
        //select task
        tableView.rx.itemSelected.subscribe(onNext: { [unowned self] indexPath in
            self.viewModel.input.taskIndexSelected.onNext(indexPath.row)
        }).disposed(by: disposeBag)
        
        //delete task
        tableView.rx.itemDeleted.subscribe(onNext: {[unowned self] element in
                self.viewModel.input.deleteTaskIndex.onNext(element.row)
        }).disposed(by: disposeBag)
        
        //btn new task
        newTaskButton.rx.tap.subscribe({[unowned self] value in
            self.viewModel.input.newTaskButtonSelected.onNext(true)
        }).disposed(by: disposeBag)
        //labels
        viewModel.output.listLabels.asObservable().bind(to: labelsPickerView.rx.itemTitles) { _, item in
            self.navigationItem.leftBarButtonItem = self.createBarButton(title: item, image: nil, selector: #selector(self.category))
            return "\(item)"
        }.disposed(by: disposeBag)
        labelsPickerView.rx.itemSelected.asObservable().subscribe(onNext: {item in
            self.viewModel.input.labelSelectedIndex.onNext(item.row)
        }).disposed(by: disposeBag)
        //sort
        viewModel.output.listSorts.asObservable().bind(to: sortPickerView.rx.itemTitles) { _, item in
//            self.navigationItem.rightBarButtonItem = self.createBarButton(title: item.toString(), image: nil, selector: #selector(self.sort))
            return "\(item.toString())"
        }.disposed(by: disposeBag)
        sortPickerView.rx.itemSelected.asObservable().subscribe(onNext: {item in
            self.viewModel.input.sortSelectedIndex.onNext(item.row)
        }).disposed(by: disposeBag)
    }
    private func fetchData(){
        viewModel.input.fetchTasks.onNext(true)
    }
}
