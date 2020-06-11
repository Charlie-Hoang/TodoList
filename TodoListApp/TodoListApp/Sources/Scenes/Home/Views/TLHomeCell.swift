//
//  TLHomeCell.swift
//  TodoListApp
//
//  Created by Charlie on 7/6/20.
//  Copyright © 2020 C. All rights reserved.
//

import UIKit

class TLHomeCell: UITableViewCell, CellConfigurable {
    typealias Presenter = TLTaskCellPresentable
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var fireDateLabel: UILabel!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var repeatImageView: UIImageView!
    @IBOutlet weak var imgAttchmentImageView: UIImageView!
    var viewModel: TLTaskCellViewModel?
    
    func configCell(presenter: Presenter){
        viewModel = presenter as? TLTaskCellViewModel
        titleLabel.text = presenter.title
        fireDateLabel.text = presenter.fireDate
        label.text = (presenter.label != nil) ? "#\(presenter.label ?? "")" : ""
        checkButton.setBackgroundImage(getCheckImage(), for: .normal)
        repeatImageView.isHidden = !presenter.isRepeat
        fireDateLabel.textColor = presenter.isPendingNotification ? .blue : .lightGray
        if let imgAttachment = presenter.imgAttachment{
            imgAttchmentImageView.image = UIImage(named: imgAttachment)
        }
    }
    
    @IBAction func checkBtnClicked(_ sender: Any) {
        viewModel?.check()
        configCell(presenter: viewModel!)
        checkButton.setBackgroundImage(getCheckImage(), for: .normal)
    }
    private func getCheckImage() -> UIImage?{
        if let finished =  viewModel?.model.finished.value{
            return UIImage(named: finished ? "ic_checked.png" : "ic_unchecked.png")
        }
        return nil
    }
}
