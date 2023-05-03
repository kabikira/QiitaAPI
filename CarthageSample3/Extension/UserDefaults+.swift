//
//  UserDefaults+.swift
//  CarthageSample3
//
//  Created by koala panda on 2023/04/25.
//

import Foundation

extension UserDefaults {
  private var qiitaAccessTokenKey: String { "qiitaAccessTokenKey" }
  var qiitaAccessToken: String {
    get {
      self.string(forKey: qiitaAccessTokenKey) ?? ""
    }
    set {
      self.setValue(newValue, forKey: qiitaAccessTokenKey)
    }
  }
}
