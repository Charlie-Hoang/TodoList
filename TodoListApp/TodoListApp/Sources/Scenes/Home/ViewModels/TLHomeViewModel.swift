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
    var labelSelectedIndex: PublishSubject<Int>{get}
    var sortSelectedIndex: PublishSubject<Int>{get}
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
    var labelSelectedIndex = PublishSubject<Int>()
    var sortSelectedIndex = PublishSubject<Int>()
    
    var tasks = [Task]()
    var labels = [Label]()
    weak var coordinator: TLHomeCoordinator?
    private let disposeBag = DisposeBag()
    private let dbService = TLDBService()
    
    init() {
        binding()
        let labels: Results<Label> = dbService.fetchLabels()
        self.labels = Array(labels)
        var labelToDisplay = ["All Label"]
        labelToDisplay.append(contentsOf: labels.map{($0.title ?? "")})
        listLabels.accept(labelToDisplay)
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
                let res: Results<Task> = self.dbService.fetchTasks()
                self.tasks = Array(res)
                _ = self.tasks.map{$0.processScheduleNotification()}
                self.output.listTasks.accept(self.tasks.map{TLTaskCellViewModel(task: $0)})
                
            }
        }).disposed(by: disposeBag)
        input.deleteTaskIndex.subscribe(onNext:{index in
            let taskDelete = self.tasks[index]
            self.dbService.deleteTask(task: taskDelete)
            self.input.fetchTasks.onNext(true)
        }).disposed(by: disposeBag)
        input.labelSelectedIndex.subscribe(onNext: {[unowned self] index in
            if index == 0{
                self.output.listTasks.accept(self.tasks.map{TLTaskCellViewModel(task: $0)})
            }else{
                self.output.listTasks.accept(self.tasks.filter{$0.label == self.labels[index-1]}.map{TLTaskCellViewModel(task: $0)})
            }
        }).disposed(by: disposeBag)
        input.sortSelectedIndex.subscribe(onNext: {[unowned self] index in
            self.output.listTasks.accept(index.toSortType()?.sort(tasks: self.tasks).map{TLTaskCellViewModel(task: $0)} ?? [])
//            if index == 0{
//                self.output.listTasks.accept(self.tasks.map{TLTaskCellViewModel(task: $0)})
//            }else{
//                self.output.listTasks.accept(self.tasks.filter{$0.label == self.labels[index-1]}.map{TLTaskCellViewModel(task: $0)})
//            }
        }).disposed(by: disposeBag)
    }
}
