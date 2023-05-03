//
//  QiitaAccessTokenModel.swift
//  CarthageSample3
//
//  Created by koala panda on 2023/04/25.
//

import Foundation
// Qiitaから渡されたアクセストークンを受け取るモデルなの??
struct QiitaAccessTokenModel: Codable {
  let clientId: String
  let scopes: [String]
  let token: String
}
