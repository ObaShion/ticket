//
//  LotteryViewController.swift
//  ticket
//
//  Created by 渡邉羽唯 on 2025/02/16.
//

import UIKit

class LotteryViewController: UIViewController {
    @IBOutlet var name: UILabel!
    @IBOutlet var detail: UITextView!
    @IBOutlet var textField: UITextField!
    
    // 前の画面からEventModelの情報を取得
    var event: EventModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        textField.keyboardType = .numberPad
        name.text = event.name
        detail.text = event.detail
    }
    
    // 人数選択ボタン
    @IBAction func peopleNumberButton(_ sender: UIButton) {
        textField.text = String(sender.tag)
    }
    
    // 抽選サブミットボタン
    @IBAction func submitButton() {
        
        guard let peopleNumber = Int(textField.text ?? "") else { return }
        
        // 抽選申請内容
        let lottery = LotteryModel(people_number: peopleNumber, event_id: event.id, device_id: DeviceIDManager().deviceId)
        
        // supabaseのlotteryテーブルにデータを挿入
        Task {
            do {
                try await supabase
                    .from("lottery")
                    .insert(lottery)
                    .execute()
            } catch {
                dump(error)
            }
        }
    }
    
}
