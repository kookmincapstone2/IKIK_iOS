//
//  NetworkingService.swift
//  IK IK
//
//  Created by 서민주 on 2020/09/28.
//  Copyright © 2020 minjuseo. All rights reserved.
//

import Foundation

enum MyResult<T, E: Error>{
    case success(T?)
    case failure(E)
}

class NetworkingService {
    
    let baseUrl = "http://3.34.158.76:8000/api"
    
    func handleResponse(for request: URLRequest,
                        completion: @escaping (Result<User?, Error>) -> Void) {
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            DispatchQueue.main.async {
                
                guard let unwrappedResponse = response as? HTTPURLResponse else {
                    completion(.failure(NetworkingError.badResponse))
                    return
                }
                
                print(unwrappedResponse.statusCode)
                switch unwrappedResponse.statusCode {
                    
                case 200..<300 :
                    print("success")
                    
                    if let unwrappedData = data {
                        do {
                            let json = try JSONSerialization.jsonObject(with: unwrappedData, options: .allowFragments)
                            print(json)
                            
                            if String(data: unwrappedData, encoding: .utf8) == "{\n}" {
                                completion(.success(nil))
                            }
                            
                            if let user = try? JSONDecoder().decode(User.self, from: unwrappedData) {
                                completion(.success(user))
                                
                            } else {
                                completion(.success(nil))
                                //                            } else {
                                //                                let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: unwrappedData)
                                //                                completion(.failure(errorResponse))
                            }
                        } catch {
                            completion(.failure(error))
                        }
                    }
                    
                case 400:
                    completion(.failure(AuthorizationError.formatNotMatch))
                    
                case 401:
                    completion(.failure(AuthorizationError.existingEmail))
                    
                case 404:
                    completion(.failure(AuthorizationError.unknownAccount))
                    
                default:
//                    completion(.failure(AuthorizationError.unknownAccount))
                    print("failure")
                }
            }
        }.resume()
    }
    
    func request(endpoint: String,
                 parameters: [String: Any],
                 completion: @escaping (Result<User?, Error>) -> Void) {
        
        guard let url = URL(string: baseUrl + endpoint) else {
            completion(.failure(NetworkingError.badUrl))
            return
        }
        
        let request = makePostRequest(url: url, method: "POST", parameters: parameters)
        handleResponse(for: request, completion: completion)
    }
    
    func getMyRooms(endpoint: String, userId: Int, completion: @escaping (Result<[Room], Error>) -> Void) {
        
        guard let url = URL(string: baseUrl + endpoint) else {
            completion(.failure(NetworkingError.badUrl))
            return
        }
        
        var roomList = [Room]()
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        let queryItems = [URLQueryItem(name: "user_id", value: String(userId))]
        
        components?.queryItems = queryItems
        
        URLSession.shared.dataTask(with: (components?.url!)!) { (data, response, error) in
            
            DispatchQueue.main.async(execute: {
                
                guard let data = data else { completion(.failure(NetworkingError.badResponse))
                    return
                }
                
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: Any]
                    
                    for (_, value) in json {
                        print(value.self)
                        let json2 = try JSONSerialization.data(withJSONObject: value)
                        let decoder = JSONDecoder()
                        
                        roomList.append(try decoder.decode(Room.self, from: json2))
                    }
                    completion(.success(roomList))
                    
                } catch {
                    print(error)
                }
            })
        }.resume()
    }
    
    func handleRoom(method: String, endpoint: String, parameters: [String: Any], completion: @escaping (Result<Room?, Error>) -> Void) {
        
        guard let url = URL(string: baseUrl + endpoint) else {
            completion(.failure(NetworkingError.badUrl))
            return
        }
        
        let request = makePostRequest(url: url, method: method, parameters: parameters)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            DispatchQueue.main.async {
                
                guard let unwrappedResponse = response as? HTTPURLResponse else {
                    completion(.failure(NetworkingError.badResponse))
                    return
                }
                
                print(unwrappedResponse.statusCode)
                switch unwrappedResponse.statusCode {
                    
                case 200..<300 :
                    print("success")
                    
                    if let unwrappedData = data {
                        
                        do {
                            let json = try JSONSerialization.jsonObject(with: unwrappedData, options: .allowFragments)
                            print(json)
                            
                            if let room = try? JSONDecoder().decode(Room.self, from: unwrappedData) {
                                completion(.success(room))
                                
                            } else {
                                completion(.success(nil))
                            }
                            
                        } catch {
                            completion(.failure(error))
                        }
                    }
//                case 400:
//                    // 요청 형식 맞지않음
//                    break
//
//                case 404:
//                    // 해당 유저 존재하지 않음 or 존재하지 않는 초대 코드
//                    break
//
//                case 409:
//                    // 이미 가입된 방 or 최대 가입 인원수 초과
//                    break
                    
                default:
                    print("failure")
                }
                
                if let unwrappedError = error {
                    completion(.failure(unwrappedError))
                    return
                }
            }
        }.resume()
    }
    
    func makePostRequest(url: URL, method: String, parameters: [String: Any]) -> URLRequest {
        
        var request = URLRequest(url: url)
        var components = URLComponents()
        var queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: String(describing: value))
            queryItems.append(queryItem)
        }
        
        components.queryItems = queryItems
        
        let queryItemData = components.query?.data(using: .utf8)
        
        request.httpBody = queryItemData
        request.httpMethod = method
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        return request
    }
    
}

enum NetworkingError: Error {
    case badUrl
    case badResponse
    case badEncoding
}

enum AuthorizationError: Error {
    case formatNotMatch
    case unknownAccount
    case existingEmail
    case existingPhone
}
