//
//  Supabase.swift
//  ticket
//
//  Created by 大場史温 on 2025/02/17.
//

import Foundation
import Supabase


private let env = try! EnvManager()
let supabase = SupabaseClient(
    supabaseURL: URL(string: env.value("SUPABASE_URL")!)!,
    supabaseKey: env.value("SUPABASE_ANON_KEY")!
)
