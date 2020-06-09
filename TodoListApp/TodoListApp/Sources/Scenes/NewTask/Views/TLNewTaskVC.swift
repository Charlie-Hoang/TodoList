//
//  TLNewTaskVC.swift
//  TodoListApp
//
//  Created by Charlie on 6/6/20.
//  Copyright © 2020 C. All rights reserved.
//

import UIKit
import RxSwift

class TLNewTaskVC: TLBaseVC {
    
    var viewModel: TLNewTaskViewModel!
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var fireDateTextField: UITextField!
    @IBOutlet weak var repeatTypeTextField: UITextField!
    @IBOutlet weak var labelsScollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "New Task"
        showSaveButton()
        binding()
        fetchData()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        resignTextFields()
    }
    @objc override func save() {
        viewModel.input.save()
    }
    @IBAction func selectFireDate(sender: UITextField) {
        let datePickerView = UIDatePicker()
        datePickerView.datePickerMode = .dateAndTime
        sender.inputView = datePickerView
        viewModel.output.fireDateString.asObservable().subscribe(onNext:{date in
            self.fireDateTextField.text = date
            datePickerView.setDate(date.tlDate(), animated: true)
        }).disposed(by: disposeBag)
        datePickerView.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)
    }
    @IBAction func selectRepeatType(sender: UITextField) {
        let repeatTypePickerView = UIPickerView()
        
        
        sender.inputView = repeatTypePickerView
        viewModel.output.repeatTypeList.asObservable().bind(to: repeatTypePickerView.rx.itemTitles) { _, item in
            return "\(item.toString())"
        }.disposed(by: disposeBag)
        repeatTypePickerView.rx.itemSelected.asObservable().subscribe(onNext: {item in
            self.viewModel.input.repeatTypeSelectedIndex.accept(item.row)
        }).disposed(by: disposeBag)
        repeatTypePickerView.selectRow(self.viewModel.input.repeatTypeSelectedIndex.value, inComponent: 0, animated: true)
//        viewModel.output.repeatTypeList.asObservable().subscribe(onNext:{date in
//            self.fireDateTextField.text = date
//            datePickerView.setDate(date.tlDate(), animated: true)
//        }).disposed(by: disposeBag)
//        datePickerView.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)
    }
    @objc func handleDatePicker(sender: UIDatePicker){
        self.fireDateTextField.text = sender.date.tlString()
        
    }
}

extension TLNewTaskVC{
    private func binding(){
        self.titleTextField.rx.text.orEmpty.bind(to: viewModel.output.title).disposed(by: disposeBag)
        viewModel.output.title.asObservable().bind(to: self.titleTextField.rx.text).disposed(by: disposeBag)
        self.fireDateTextField.rx.text.orEmpty.bind(to: viewModel.output.fireDateString).disposed(by: disposeBag)
        viewModel.output.fireDateString.asObservable().bind(to: self.fireDateTextField.rx.text).disposed(by: disposeBag)
        viewModel.output.listLabels.asObservable().subscribe{event in
            if let element = event.element{
                self.setupLabels(element)
            }
        }.disposed(by: disposeBag)
        viewModel.output.labelIndexSelected.asObservable().subscribe{event in
            if let element = event.element{
                self.setupSelectedLabels(index: element)
            }
        }.disposed(by: disposeBag)
        viewModel.output.repeatTypeSelected.asObservable().subscribe{event in
            if let element = event.element{
                self.repeatTypeTextField.text = element.toString()
            }
        }.disposed(by: disposeBag)
//            .bind(to: repeatTypeTextField.rx.text).disposed(by: disposeBag)
    }
    private func setupSelectedLabels(index: Int){
        var count = 0
        while true {
            let _btn = self.view.viewWithTag(count+100) as? UIButton
            count += 1
            if let _btn = _btn {
                _btn.setTitleColor(.black, for: .normal)
            }else{
                break
            }
        }
        let _selectedBtn = self.view.viewWithTag(index+100) as? UIButton
        _selectedBtn?.setTitleColor(.red, for: .normal)
    }
    private func setupLabels(_ labels: [String]?) {
        guard let labels = labels else { return }
        var xOffset: CGFloat = 16
        let buttonPadding: CGFloat = 16
        for item in labels {
            let _btnFont = UIFont.boldSystemFont(ofSize: 17)
            let _title = item.removingPercentEncoding
            let _titleSize: CGSize = _title?.size(withAttributes: [NSAttributedString.Key.font: _btnFont]) ?? CGSize(width: 0, height: 0)
            let _btn = UIButton(frame: CGRect(x: xOffset, y: 0.0, width: _titleSize.width , height: labelsScollView.bounds.height))
            _btn.setTitle(_title , for: .normal)
            _btn.setTitleColor(.black, for: .normal)
            _btn.titleLabel?.font = _btnFont
            _btn.tag = 100 + (labels.firstIndex(of: item) ?? 0)
            _btn.rx.tap.subscribe({[unowned self] value in
                self.viewModel.input.labelButtonSelectedIndex.onNext(_btn.tag - 100)
            }).disposed(by: disposeBag)
            
//            _btn.rx.tap.bind {[unowned self] in
//                self.viewModel.action.topCategoryItemClicked(model: item)
//            }.disposed(by: disposeBag)
//            _btn.addTarget(self, action: #selector(self.selectTopCategory), for: .touchUpInside)
            labelsScollView.addSubview(_btn)
            xOffset = xOffset + _btn.bounds.width + buttonPadding
        }
        labelsScollView.contentSize = CGSize(width: xOffset, height: 50)
    }
    private func fetchData(){
        viewModel.input.fetchLabels.onNext(true)
    }
    private func resignTextFields(){
        titleTextField.resignFirstResponder()
        fireDateTextField.resignFirstResponder()
    }
    
}
