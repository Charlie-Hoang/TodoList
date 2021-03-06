//
//  TLNewTaskVC.swift
//  TodoListApp
//
//  Created by Charlie on 6/6/20.
//  Copyright © 2020 C. All rights reserved.
//

import UIKit
import RxSwift

let TAG_BTN_LABEL_START = 100
let TAG_BTN_IMG_START = 200

class TLNewTaskVC: BaseVC {
    
    var viewModel: TLNewTaskViewModel!
    
    @IBOutlet weak var disableEditView: UIView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var fireDateTextField: UITextField!
    @IBOutlet weak var repeatTypeTextField: UITextField!
    @IBOutlet weak var labelsScollView: UIScrollView!
    @IBOutlet weak var imgsScollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Task"
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
    }
    
    @IBAction func addLabelBtnClicked(_ sender: Any) {
        editLabels()
    }
    
    @objc func handleDatePicker(sender: UIDatePicker){
        self.fireDateTextField.text = sender.date.tlString()
    }
    
}
//private
extension TLNewTaskVC{
    private func binding(){
        viewModel.taskNotFinished.asObservable().bind(to: self.disableEditView.rx.isHidden).disposed(by: disposeBag)
        self.titleTextField.rx.text.orEmpty.bind(to: viewModel.output.title).disposed(by: disposeBag)
        viewModel.output.title.asObservable().bind(to: self.titleTextField.rx.text).disposed(by: disposeBag)
        self.fireDateTextField.rx.text.orEmpty.bind(to: viewModel.output.fireDateString).disposed(by: disposeBag)
        viewModel.output.fireDateString.asObservable().bind(to: self.fireDateTextField.rx.text).disposed(by: disposeBag)
        viewModel.output.listLabels.asObservable().subscribe{event in
            if let element = event.element{
                self.setupLabels(element)
            }
        }.disposed(by: disposeBag)
        viewModel.output.listImgs.asObservable().subscribe{event in
            if let element = event.element{
                self.setupImgs(element)
            }
        }.disposed(by: disposeBag)
        viewModel.output.labelIndexSelected.asObservable().subscribe{event in
            if let element = event.element, element >= 0{
                self.setupSelectedLabel(index: element)
            }
        }.disposed(by: disposeBag)
        viewModel.output.imgIndexSelected.asObservable().subscribe{event in
            if let element = event.element, element >= 0{
                self.setupSelectedImg(index: element)
            }
        }.disposed(by: disposeBag)
        viewModel.output.repeatTypeSelected.asObservable().subscribe{event in
            if let element = event.element{
                self.repeatTypeTextField.text = element.toString()
            }
        }.disposed(by: disposeBag)
    }
    private func setupSelectedLabel(index: Int){
        var count = 0
        while true {
            let _btn = self.view.viewWithTag(count+TAG_BTN_LABEL_START) as? UIButton
            count += 1
            if let _btn = _btn {
                _btn.setTitleColor(.black, for: .normal)
            }else{
                break
            }
        }
        let _selectedBtn = self.view.viewWithTag(index+TAG_BTN_LABEL_START) as? UIButton
        _selectedBtn?.setTitleColor(.red, for: .normal)
    }
    private func setupSelectedImg(index: Int){
        var count = 0
        while true {
            let _btn = self.view.viewWithTag(count+TAG_BTN_IMG_START) as? UIButton
            count += 1
            if let _btn = _btn {
                _btn.backgroundColor = .clear
            }else{
                break
            }
        }
        let _selectedBtn = self.view.viewWithTag(index+TAG_BTN_IMG_START) as? UIButton
        _selectedBtn?.backgroundColor = .orange
    }
    private func setupLabels(_ labels: [String]?) {
        labelsScollView.removeSubviews()
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
            _btn.tag = TAG_BTN_LABEL_START + (labels.firstIndex(of: item) ?? 0)
            _btn.rx.tap.subscribe({[unowned self] value in
                self.viewModel.input.selectLabel(index: _btn.tag - TAG_BTN_LABEL_START)
            }).disposed(by: disposeBag)
            
            labelsScollView.addSubview(_btn)
            xOffset = xOffset + _btn.bounds.width + buttonPadding
        }
        labelsScollView.contentSize = CGSize(width: xOffset, height: 50)
    }
    private func setupImgs(_ imgs: [String]?) {
        imgsScollView.removeSubviews()
        guard let imgs = imgs else { return }
        var xOffset: CGFloat = 16
        let buttonPadding: CGFloat = 16
        for img in imgs {
            let _btn = UIButton(frame: CGRect(x: xOffset, y: 0.0, width: 50 , height: 50))
            _btn.setBackgroundImage(UIImage(named: img), for: .normal)
            _btn.tag = TAG_BTN_IMG_START + (imgs.firstIndex(of: img) ?? 0)
            _btn.rx.tap.subscribe({[unowned self] value in
                self.viewModel.selectImg(index: _btn.tag - TAG_BTN_IMG_START)
            }).disposed(by: disposeBag)
            
            imgsScollView.addSubview(_btn)
            xOffset = xOffset + _btn.bounds.width + buttonPadding
        }
        imgsScollView.contentSize = CGSize(width: xOffset, height: 50)
    }
    private func fetchData(){
        viewModel.input.fetchLabels.onNext(true)
    }
    private func resignTextFields(){
        titleTextField.resignFirstResponder()
        fireDateTextField.resignFirstResponder()
    }
    
}
//Edit Labels
extension TLNewTaskVC{
    private func editLabels(){
        let alert = UIAlertController(title: "Edit Labels", message: nil, preferredStyle: .alert)
        
        for (index, label) in viewModel.output.listLabels.value.enumerated() {
            let labelAction = UIAlertAction(title: label, style: .default) { [unowned self] _ in
                self.editLabel(index: index)
            }
            alert.addAction(labelAction)
        }
        let addAction = UIAlertAction(title: "Add new Label", style: .default) { [unowned self] _ in
            self.addNewLabel()
        }
        alert.addAction(addAction)
        let noAction = UIAlertAction(title: "Cancel", style: .default)
        alert.addAction(noAction)
        present(alert, animated: true, completion: nil)
    }
    private func editLabel(index: Int){
        let alert = UIAlertController(title: "Delete Label", message: viewModel.output.listLabels.value[index], preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Delete", style: .default) { [unowned self] _ in
            self.viewModel.input.deleteLabel(index: index)
            self.editLabels()
        }
        alert.addAction(yesAction)
        let noAction = UIAlertAction(title: "Cancel", style: .default) { [unowned self] _ in
            self.editLabels()
        }
        alert.addAction(noAction)
        present(alert, animated: true, completion: nil)
    }
    private func addNewLabel(){
        let alertController = UIAlertController(title: "Add new Label", message: nil, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Add", style: .default) { (_) in
            if let txtField = alertController.textFields?.first, let text = txtField.text {
                self.viewModel.input.addNewLabel(title: text)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        alertController.addTextField { (textField) in
            textField.placeholder = "Tag"
        }
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
