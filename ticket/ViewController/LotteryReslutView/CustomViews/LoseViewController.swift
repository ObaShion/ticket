//
//  LoseViewController.swift
//  practice_list
//
//  Created by 大場史温 on 2025/02/05.
//

import UIKit

class LoseViewController: UIViewController {
    
    var events: [EventModel] = []
    
    @IBOutlet var titleText: [UILabel]!
    @IBOutlet var detailText: [UITextView]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        Task {
            await fetchData()
        }
        
        for (index, event) in events.shuffled().prefix(3).enumerated() {
            guard index < titleText.count, index < detailText.count else { break }
            titleText[index].text = event.name
            detailText[index].text = event.detail
            print(event)
        }
    }
    
    // supabaseからeventsテーブルデータを取得
    private func fetchData() async {
        do {
            events = try await supabase
                .from("events")
                .select()
                .eq("is_lottery_processed", value: false)// 未抽選のイベントを取得
                .execute()
                .value
        } catch {
            dump(error)
        }
    }
    
}
