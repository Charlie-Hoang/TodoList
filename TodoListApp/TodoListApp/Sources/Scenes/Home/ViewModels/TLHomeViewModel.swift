//
//  TLHomeViewModel.swift
//  TodoListApp
//
//  Created by Charlie on 8/6/20.
//  Copyright © 2020 C. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RealmSwift

protocol TLHomeViewModelInputProtocol {
    var fetchTasks: PublishSubject<Bool>{get}
    var newTaskButtonSelected: PublishSubject<Bool>{get}
    
    var taskIndexSelected: PublishSubject<Int>{get}
    var deleteTaskIndex: PublishSubject<Int>{get}
    var labelSelectedIndex: BehaviorRelay<Int>{get}
    var sortSelectedIndex: BehaviorRelay<Int>{get}
}
protocol TLHomeViewModelOutputProtocol {
    var listTasks: BehaviorRelay<[TLTaskCellViewModel]>{get}
    var listLabels: BehaviorRelay<[String]>{get}
    var listSorts: BehaviorRelay<[SortType]>{get}
}
protocol TLHomeViewModelProtocol {
    var input: TLHomeViewModelInputProtocol{get}
    var output: TLHomeViewModelOutputProtocol{get}
}

class TLHomeViewModel: TLHomeViewModelProtocol, TLHomeViewModelInputProtocol, TLHomeViewModelOutputProtocol{
    
    var input: TLHomeViewModelInputProtocol{return self}
    var output: TLHomeViewModelOutputProtocol{return self}
    
    var listTasks = BehaviorRelay<[TLTaskCellViewModel]>(value: [])
    var listLabels = BehaviorRelay<[String]>(value: [])
    var listSorts = BehaviorRelay<[SortType]>(value: [.createDate, .fireDate, .title])
    var newTaskButtonSelected = PublishSubject<Bool>()
    let taskIndexSelected = PublishSubject<Int>()
    var fetchTasks = PublishSubject<Bool>()
    var deleteTaskIndex = PublishSubject<Int>()
    var labelSelectedIndex = BehaviorRelay<Int>(value: 0)
    var sortSelectedIndex = BehaviorRelay<Int>(value: 0)
    
    var tasks = [Task]()
    var displayTasks = [Task]()
    var labels = [Label]()
    var labelToDisplay: [String] = []
    weak var coordinator: TLHomeCoordinator?
    private let disposeBag = DisposeBag()
    private let dbService = TLDBService()
    
    init() {
        binding()
    }
    func binding(){
        input.newTaskButtonSelected.subscribe(onNext: {[unowned self] value in
            if value{
                self.coordinator?.newTask()
            }
        }).disposed(by: disposeBag)
        input.taskIndexSelected.subscribe(onNext: {[unowned self] index in
            let task = self.tasks[index]
            self.coordinator?.editTask(task: task)
        }).disposed(by: disposeBag)
        input.fetchTasks.subscribe(onNext:{[unowned self] value in
            if value{
                //fetch Labels
                let labels: Results<Label> = self.dbService.fetchLabels()
                self.labels = Array(labels)
                self.labelToDisplay = ["All Label"]
                self.labelToDisplay.append(contentsOf: labels.map{($0.title ?? "")})
                self.listLabels.accept(self.labelToDisplay)
                //fetch Tasks
                let res: Results<Task> = self.dbService.fetchTasks()
                self.tasks = Array(res)
                self.displayTasks = self.tasks
                self.applyLabel()
                _ = self.tasks.map{$0.processScheduleNotification()}
                self.output.listTasks.accept(self.displayTasks.map{TLTaskCellViewModel(task: $0)})
                
            }
        }).disposed(by: disposeBag)
        input.deleteTaskIndex.subscribe(onNext:{index in
            let taskDelete = self.tasks[index]
            self.dbService.deleteTask(task: taskDelete)
            self.input.fetchTasks.onNext(true)
        }).disposed(by: disposeBag)
        input.labelSelectedIndex.subscribe(onNext: {[unowned self] index in
            if index == 0{
                self.displayTasks = self.tasks
                self.applyLabel()
                self.output.listTasks.accept(self.displayTasks.map{TLTaskCellViewModel(task: $0)})
            }else{
                self.displayTasks = self.tasks.filter{$0.label == self.labels[index-1]}
                self.applyLabel()
                self.output.listTasks.accept(self.displayTasks.map{TLTaskCellViewModel(task: $0)})
            }
        }).disposed(by: disposeBag)
        input.sortSelectedIndex.subscribe(onNext: {[unowned self] index in
//            self.displayTasks = index.toSortType()?.sort(tasks: self.displayTasks) ?? []
            self.applyLabel()
            self.output.listTasks.accept(self.displayTasks.map{TLTaskCellViewModel(task: $0)})
        }).disposed(by: disposeBag)
    }
    func applySort(){
        let sortType = sortSelectedIndex.value.toSortType() ?? .createDate
        self.displayTasks = sortType.sort(tasks: self.displayTasks)
    }
    func applyLabel(){
        if labelSelectedIndex.value == 0 {
            self.displayTasks = tasks
        }else{
            self.displayTasks = self.tasks.filter{$0.label == self.labels[labelSelectedIndex.value - 1]}
        }
        applySort()
    }
}
