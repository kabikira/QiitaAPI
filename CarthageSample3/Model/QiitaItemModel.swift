//
//  QiitaItemModel.swift
//  CarthageSample3
//
//  Created by koala panda on 2023/04/25.
//

import Foundation

struct QiitaItemModel: Codable {
    var urlStr: String
    var title: String

    enum CodingKeys: String, CodingKey {
        case urlStr = "url"
        case title = "title"
    }
    var url: URL? { URL.init(string: urlStr)}
}

