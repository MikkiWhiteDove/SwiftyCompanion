//
//  Token.swift
//  swiftyCompanion
//
//  Created by Миша on 16.09.2021.
//

import Foundation
import UIKit

enum ApiErr: Error {
    case noData
    case unowned
}

class Token: NSObject {
    
    var token = String()
    let url = "https://api.intra.42.fr/oauth/token"
    let parameters = [
        "client_id": "f8a2c154ad4a2a8b1be90f4750379aecd7ca2ec6ada0d0ec754cc590431a9766",
        "client_secret": "7782bf83cf1eaaed55762ac4a075e93af36a6fb2351b7e22375ee9c1c01fcec2"]
    func getToken() {
        guard let url = URL(string: self.url) else {return}
        let checkVetifyToken = UserDefaults.standard.object(forKey: "token")
        if checkVetifyToken == nil {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
                
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {return}
            request.httpBody = httpBody
                
            let session = URLSession.shared
            session.dataTask(with: request) { (data, response, error) in
                guard let data = data else {return}
                do {
                    let jsonObj = try JSONSerialization.jsonObject(with: data, options: [])
                        
                    guard
                        let json = jsonObj as? [String: Any],
                        let token = json["access_token"] as? String
                        else {
                            return
                    }
                        UserDefaults.standard.set(token, forKey: "token")
                    } catch {
                    }
                }.resume()
        } else {
            self.token = checkVetifyToken as! String
            checkToken()
        }
    }
    
        func checkToken() {
            UserDefaults.standard.removeObject(forKey: "tokenLive")
            guard let token = UserDefaults.standard.string(forKey: "token") else {
                getToken()
                return
            }
            guard let url = URL(string: "https://api.intra.42.fr/oauth/token/info?access_token=\(self.token)") else { return }
            let request = URLRequest(url: url)
            let session = URLSession.shared
            let dataTask = session.dataTask(with: request, completionHandler: { data, response, error in
            guard let data = data else {
                return
            }
            do{
                let jsonObj = try? JSONSerialization.jsonObject(with: data, options: [])
                            
                guard
                    let json = jsonObj as? [String: Any],
                    let tokenLifeSeconds = json["expires_in_seconds"] as? Int
                    else {
                        UserDefaults.standard.removeObject(forKey: "token")
                        self.getToken()
                        return
                    }
                    UserDefaults.standard.set(tokenLifeSeconds, forKey: "tokenLive")
            }catch {
            }
            })
            dataTask.resume()
        }
    
    
    func checkUserName (userName: String, completion: @escaping (Result <User, Error>) -> Void) {
        guard let token = UserDefaults.standard.string(forKey: "token") else {
            return
        }
        guard let url = URL(string: "https://api.intra.42.fr/v2/users/\(userName)?access_token=\(token)") else {return}
        let urlRequest = URLRequest(url: url)
        let session = URLSession.shared
        let dataTask = session.dataTask(with: urlRequest, completionHandler: { data, response, error in
            if let response = response {
            }
            if (response as? HTTPURLResponse)?.statusCode != 200 {
                completion(.failure(ApiErr.unowned))
                return
            }
            guard let data = data else {
                return
            }
            let decoder = JSONDecoder()
            do {
                let response = try decoder.decode(User.self, from: data)
                completion(.success(response.self))
            } catch {
                completion(.failure(ApiErr.noData))
            }
        })
        dataTask.resume()
    }
    
}
