//
//  TLHomeVC.swift
//  TodoListApp
//
//  Created by Charlie on 6/6/20.
//  Copyright © 2020 C. All rights reserved.
//

import UIKit

class TLHomeVC: TLBaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func addBtnClicked(_ sender: Any) {
        TLNotificationService().schedule(body: "example", time: Date(timeIntervalSinceNow: 3), trigger: .everySecond)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
