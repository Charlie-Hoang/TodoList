//
//  TLNewTaskViewModel.swift
//  TodoListApp
//
//  Created by Charlie on 8/6/20.
//  Copyright © 2020 C. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RealmSwift

protocol TLNewTaskViewModelInputProtocol {
    var fetchLabels: PublishSubject<Bool>{get}
    func save()
    var repeatTypeSelectedIndex: BehaviorRelay<Int>{get}
//    var memberSlected: PublishSubject<Int>{get}
    var labelButtonSelectedIndex: PublishSubject<Int>{get}
}
protocol TLNewTaskViewModelOutputProtocol {
    var listLabels: BehaviorRelay<[String]>{get}
    var title: BehaviorRelay<String>{get}
//    var amount: Variable<String>{get}
//    var listMembers: Variable<[MemberInPartyViewModel]>{get}
//    var paidBy: Variable<String>{get}
    var fireDateString: BehaviorRelay<String>{get}
//    var currencySymbol: Variable<String>{get}
    var labelIndexSelected: BehaviorRelay<Int>{get}
    var repeatTypeList: BehaviorRelay<[RepeatType]>{get}
    var repeatTypeSelected: BehaviorRelay<RepeatType>{get}
}
protocol TLNewTaskViewModelProtocol {
    var input: TLNewTaskViewModelInputProtocol{get}
    var output: TLNewTaskViewModelOutputProtocol{get}
}
class TLNewTaskViewModel: TLNewTaskViewModelProtocol, TLNewTaskViewModelInputProtocol, TLNewTaskViewModelOutputProtocol{
    
    var input: TLNewTaskViewModelInputProtocol{return self}
    var output: TLNewTaskViewModelOutputProtocol{return self}
    //Subjects
    
    var fetchLabels = PublishSubject<Bool>()
    var listLabels = BehaviorRelay<[String]>(value: [])
//    var newMember = PublishSubject<String>()
    
    var title = BehaviorRelay<String>(value: "")
    var fireDateString = BehaviorRelay<String>(value: "")
    var labelIndexSelected = BehaviorRelay<Int>(value: 0)
    var labelButtonSelectedIndex = PublishSubject<Int>()
    var repeatTypeList = BehaviorRelay<[RepeatType]>(value: [.once, .hourly, .daily, .weekly, .monthly, .yearly])
    var repeatTypeSelected = BehaviorRelay<RepeatType>(value: .once)
    var repeatTypeSelectedIndex = BehaviorRelay<Int>(value: 0)
//    var description = Variable<String>("")
//    var listMembers = Variable<[String]>([])
//    var listCurrencies = Variable<[(String, String)]>([])
//    var currencySelectedIndex = Variable<Int>(0)
//    var currencyString = Variable<String>("")
//    
//    var router: SWRouter
//    var members = [Member]()
    var task: Task!
    var labels = [Label]()
    var selectedLabel: Label?
    var isNewTask = false
    
    weak var coordinator: TLNewTaskCoordinator?
    private let disposeBag = DisposeBag()
    private let notificationService = TLNotificationService()
    
    //functions
    init() {
        task = Task(title: nil, fireDate: Date().add1Day())
        isNewTask = true
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.initFromTask()
        }
        binding()
    }
    init(task: Task) {
        self.task = task
        //wait for View binding first
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.initFromTask()
        }
        binding()
    }
    private func initFromTask(){
        output.title.accept(task.title ?? "")
        output.fireDateString.accept(task.fireDate?.tlString() ?? "")
        selectedLabel = task.label
        repeatTypeSelected.accept(task.repeatType.value?.toRepeatType() ?? RepeatType.once)
        repeatTypeSelectedIndex.accept(task.repeatType.value ?? 0)
    }
    func binding(){
        input.fetchLabels.subscribe(onNext:{[unowned self] value in
            if value{
                let res: Results<Label> = TLDBService().fetchLabels()
                self.labels = Array(res)
                self.output.listLabels.accept(res.map{"#\($0.title ?? "")"})
                self.output.labelIndexSelected.accept(res.enumerated().filter{$0.element.id == self.task.label?.id}.first?.offset ?? 0)
                guard let _ = self.selectedLabel else {
                    self.selectedLabel = self.labels.first
                    return
                }
            }
        }).disposed(by: disposeBag)
        input.labelButtonSelectedIndex.subscribe(onNext:{[unowned self] index in
            self.selectedLabel = self.labels[index]
            self.output.labelIndexSelected.accept(index)
        }).disposed(by: disposeBag)
//        input.newMember.subscribe(onNext: {[unowned self] name in
//            self.listMembers.value.append(name)
//            self.members.append(Member(name: name))
//        }).disposed(by: disposeBag)
//        input.currencySelectedIndex.asObservable().subscribe(onNext:{[unowned self] index in
//            self.output.currencyString.value = self.listCurrencies.value[index].0
//        }).disposed(by: disposeBag)
        input.repeatTypeSelectedIndex.asObservable().subscribe(onNext: {[unowned self] index in
            self.repeatTypeSelected.accept(self.repeatTypeList.value[index])
        }).disposed(by: disposeBag)
    }
    func save() {
        if isNewTask{
            task.title = title.value
            let d = Date()
            task.fireDate = fireDateString.value.tlDate()
            if self.selectedLabel == nil {
                self.selectedLabel = self.labels.first
            }
            task.label = self.selectedLabel
            task.repeatType.value = self.repeatTypeSelected.value.rawValue
            print("idtf1: \(task.id)")
            TLDBService().createTask(task: task)
            coordinator?.save()
        }else{
            TLDBService().update(task: task) {
                task.title = title.value
                task.fireDate = fireDateString.value.tlDate()
                task.label = self.selectedLabel
                task.repeatType.value = self.repeatTypeSelected.value.rawValue
                
                coordinator?.save()
            }
        }
    }
}
