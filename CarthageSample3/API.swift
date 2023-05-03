//
//  API.swift
//  CarthageSample3
//
//  Created by koala panda on 2023/04/22.
//

import Foundation
import Alamofire

enum APIError: Error {
    case postAccessToken
    case getItems
}

final class API {
    static let shared = API()
    private init() {}

    private let host = "https://qiita.com/api/v2"
    private let clientID = "459805dbc32e8d12d9e9f544db0bd5a36074650d"
    private let clientSecret = "57673417cc5f73efbfd72e82b25239eb8c898a5d"
    let qiitState = "bb17785d811bb1913ef54b0a7657de780defaa2d"

    static let jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()

    // ハードコーティングを防ぐためだと思う
    enum URLParameterName: String {
        case clientID = "client_id"
        case clientSecret = "client_secret"
        case scope = "scope"
        case state = "state"
        case code = "code"
    }
    // GET /api/v2/oauth/authorizeにアクセス
    var oAuthURL: URL {
        let endPoint = "/oauth/authorize"
        return URL(string: host + endPoint + "?" +
                    "\(URLParameterName.clientID.rawValue)=\(clientID)" + "&" +
                    "\(URLParameterName.scope.rawValue)=read_qiita" + "&" +
                    "\(URLParameterName.state.rawValue)=\(qiitState)")!
    }

    func postAccessToken(code: String, completion: ((Result<QiitaAccessTokenModel, Error>) -> Void)? = nil) {
        let endPoint = "/access_tokens"
        // ここがQiitaのドキュメントとちがうURLクエリストリングで送ってる
        // HTTPボディで送らないといけない
        guard let url = URL(string: host + endPoint + "?" +
                                "\(URLParameterName.clientID.rawValue)=\(clientID)" + "&" +
                                "\(URLParameterName.clientSecret.rawValue)=\(clientSecret)" + "&" +
                                "\(URLParameterName.code)=\(code)") else {
            completion?(.failure(APIError.postAccessToken))
            return
        }

        AF.request(url, method: .post).responseData { (response) in
            do {
                guard
                    let _data = response.data else {
                    completion?(.failure(APIError.postAccessToken))
                    return
                }
                let accessToken = try API.jsonDecoder.decode(QiitaAccessTokenModel.self, from: _data)
                completion?(.success(accessToken))
            } catch let error {
                completion?(.failure(error))
            }
        }
    }

    func getItems(completion: ((Result<[QiitaItemModel], Error>) -> Void)? = nil) {
        let endPoint = "/authenticated_user/items"
        guard let url = URL(string: host + endPoint),
              !UserDefaults.standard.qiitaAccessToken.isEmpty else {
            completion?(.failure(APIError.getItems))
            return
        }
        //　認可が必要な通信にはこれをいれてAPI叩いてね
        // トークンを送信
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(UserDefaults.standard.qiitaAccessToken)"
        ]
        let parameters = [
            "page": 1,
            "per_page": 20
        ]

        AF.request(url, method: .get, parameters: parameters, headers: headers).responseData { (response) in
            do {
                guard
                    let _data = response.data else {
                    completion?(.failure(APIError.getItems))
                    return
                }
                let items = try API.jsonDecoder.decode([QiitaItemModel].self, from: _data)
                completion?(.success(items))
            } catch let error {
                completion?(.failure(error))
            }
        }
    }
}
