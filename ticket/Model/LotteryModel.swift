//
//  LotteryModel.swift
//  ticket
//
//  Created by 渡邉羽唯 on 2025/02/16.
//

import Foundation

// テーブルに書き込み用のモデル
struct LotteryModel: Encodable {
    let people_number: Int
    let event_id: Int
    let device_id: String
    let fcm_token: String
}

// 描画のためのモデル
struct decodeLotteryModel: Decodable, Identifiable {
    let id: Int
    let people_number: Int
    let device_id: String
    let events: EventModel
    let is_win: Bool
}
