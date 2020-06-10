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
    func selectLabel(index: Int)
    func selectImg(index: Int)
    func addNewLabel(title: String?)
    func deleteLabel(index: Int)
}
protocol TLNewTaskViewModelOutputProtocol {
    var listLabels: BehaviorRelay<[String]>{get}
    var listImgs: BehaviorRelay<[String]>{get}
    var title: BehaviorRelay<String>{get}
    var fireDateString: BehaviorRelay<String>{get}
    var labelIndexSelected: BehaviorRelay<Int>{get}
    var imgIndexSelected: BehaviorRelay<Int>{get}
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
    var listImgs = BehaviorRelay<[String]>(value: [])
    
    var title = BehaviorRelay<String>(value: "")
    var fireDateString = BehaviorRelay<String>(value: "")
    var labelIndexSelected = BehaviorRelay<Int>(value: -1)
    var imgIndexSelected = BehaviorRelay<Int>(value: -1)
//    var labelButtonSelectedIndex = PublishSubject<Int>()
    var repeatTypeList = BehaviorRelay<[RepeatType]>(value: [.once, .hourly, .daily, .weekly, .monthly, .yearly])
    var repeatTypeSelected = BehaviorRelay<RepeatType>(value: .once)
    var repeatTypeSelectedIndex = BehaviorRelay<Int>(value: 0)

    var task: Task!
    var labels = [Label]()
    var selectedLabel: Label?
    var selectedImg: String?
    var isNewTask = false
    
    weak var coordinator: TLNewTaskCoordinator?
    private let disposeBag = DisposeBag()
    private let notificationService = TLNotificationService()
    
    //functions
    init() {
        task = Task(title: nil, fireDate: Date().add1Day())
        isNewTask = true
        //wait for View binding first
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
            self.initFromTask()
        }
        binding()
    }
    init(task: Task) {
        self.task = task
        //wait for View binding first
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
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
        var imgs: [String] = []
        for i in 1...16 {
            imgs.append("img_att\(i).png")
        }
        listImgs.accept(imgs)
        self.output.imgIndexSelected.accept(imgs.enumerated().filter{$0.element == task.imgAttachment}.first?.offset ?? -1)
        
//        self.output.imgIndexSelected.accept(res.enumerated().filter{$0.element.id == self.task.label?.id}.first?.offset ?? -1)
    }
    func binding(){
        input.fetchLabels.subscribe(onNext:{[unowned self] value in
            if value{
                let res: Results<Label> = TLDBService().fetchLabels()
                self.labels = Array(res)
                self.output.listLabels.accept(res.map{"#\($0.title ?? "")"})
                self.output.labelIndexSelected.accept(res.enumerated().filter{$0.element.id == self.task.label?.id}.first?.offset ?? -1)
                guard let _ = self.selectedLabel else {
                    self.selectedLabel = self.labels.first
                    return
                }
            }
        }).disposed(by: disposeBag)
        input.repeatTypeSelectedIndex.asObservable().subscribe(onNext: {[unowned self] index in
            self.repeatTypeSelected.accept(self.repeatTypeList.value[index])
        }).disposed(by: disposeBag)
    }
    func save() {
        if isNewTask{
            task.title = title.value
            task.fireDate = fireDateString.value.tlDate()
            if self.selectedLabel == nil {
                self.selectedLabel = self.labels.first
            }
            task.label = self.selectedLabel
            task.imgAttachment = self.selectedImg
            task.repeatType.value = self.repeatTypeSelected.value.rawValue
            TLDBService().createTask(task: task)
            coordinator?.save()
        }else{
            TLDBService().update(task: task) {
                task.title = title.value
                task.fireDate = fireDateString.value.tlDate()
                task.label = self.selectedLabel
                task.imgAttachment = self.selectedImg
                print("att img: \(self.selectedImg ?? "")")
                task.repeatType.value = self.repeatTypeSelected.value.rawValue
                
                coordinator?.save()
            }
        }
    }
    func selectLabel(index: Int){
        self.selectedLabel = self.labels[index]
        self.output.labelIndexSelected.accept(index)
    }
    func selectImg(index: Int){
        self.selectedImg = self.listImgs.value[index]
        self.output.imgIndexSelected.accept(index)
    }
    func addNewLabel(title: String?){
        guard let title = title, title != "" else {return}
        let newLabel = Label(title: title)
        TLDBService().createLabel(label: newLabel)
        self.input.fetchLabels.onNext(true)
    }
    func deleteLabel(index: Int){
        let labelDelete = self.labels[index]
        TLDBService().deleteLabel(label: labelDelete)
        self.input.fetchLabels.onNext(true)
    }
}
