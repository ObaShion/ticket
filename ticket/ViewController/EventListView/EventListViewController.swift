//
//  EventListViewController.swift
//  ticket
//
//  Created by 渡邉羽唯 on 2025/02/16.
//

import UIKit

class EventListViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    
    // eventsデータの配列
    private var events: [EventModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // tableviewデリゲート
        tableView.dataSource = self
        tableView.delegate = self
        
        // 検索バーデリゲート
        searchBar.delegate = self
        
        // リフレッシュ画面の設定
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(onRefresh(_:)), for: .valueChanged)
        
        // supabaseからeventsテーブルデータを取得
        Task {
            await fetchData()
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

            tableView.reloadData()
        } catch {
            dump(error)
        }
    }
    
    // リフレッシュ関数
    @objc private func onRefresh(_ sender: AnyObject) {
        Task {
            await fetchData()
        }
        tableView.reloadData()
        tableView.refreshControl?.endRefreshing()
    }
    
    // 画面遷移
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toLotteryView" {
            let row = tableView.indexPathForSelectedRow?.row
            let vc = segue.destination as! LotteryViewController
            // eventデータの受け継ぎ
            vc.event = events[row!]
        }
    }
    
}

// MARK: table view
extension EventListViewController: UITableViewDelegate, UITableViewDataSource {
    // テーブルリストの数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    // テーブルリストの描画内容
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "eventTableCell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = events[indexPath.row].name
        content.secondaryText = events[indexPath.row].detail
        cell.contentConfiguration = content
        return cell
    }
}

// MARK: search bar
extension EventListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text, !query.isEmpty else {
            Task {
                await fetchData()
            }
            return
        }
        
        // イベントデータからフィルターする
        events = events.filter { event in
            event.name.localizedCaseInsensitiveContains(query)
        }
        // tableviewの更新
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        Task {
            await fetchData()
        }
    }
}
