//
//  PresentationViewController.swift
//  ticket
//
//  Created by 大場史温 on 2025/02/18.
//

import UIKit

class LotteryReslutViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    private var lotterys: [decodeLotteryModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
        
        Task {
            await fetchData()
        }
    }
    
    // supabaseからeventsテーブルデータを取得
    private func fetchData() async {
        do {
            lotterys = try await supabase
                .from("lottery")
                .select(
                """
                    id,
                    people_number,
                    device_id,
                    events(id, name, detail, event_start_date),
                    is_win
                """
                )
                .eq("device_id", value: DeviceIDManager().deviceId)
                .execute()
                .value
            tableView.reloadData()
        } catch {
            dump(error)
        }
    }
}

extension LotteryReslutViewController: UITableViewDelegate, UITableViewDataSource {
    // テーブルリストの数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lotterys.count
    }
    
    // テーブルリストの描画内容
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "lotteryReslutTableCell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = lotterys[indexPath.row].events.name
        content.secondaryText = lotterys[indexPath.row].events.detail
        cell.contentConfiguration = content
        return cell
    }
    
    // cellが押された時に実行
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let event = lotterys[indexPath.row].events
        let lottery = lotterys[indexPath.row]
        
        // 画面遷移
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let identifier = lottery.is_win ? "WinViewController" : "LoseViewController"
        let resultVC = storyboard.instantiateViewController(withIdentifier: identifier)
        navigationController?.pushViewController(resultVC, animated: true)
    }
}
