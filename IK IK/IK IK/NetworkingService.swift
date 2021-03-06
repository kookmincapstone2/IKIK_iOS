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
    
    // MARK: - Autorization
    func request(endpoint: String,
                 method: String,
                 parameters: [String: Any],
                 completion: @escaping (Result<Any?, Error>) -> Void) {
        
        guard let url = URL(string: baseUrl + endpoint) else {
            completion(.failure(NetworkingError.badUrl))
            return
        }
        
        let request: URLRequest
        
        switch method {
            
        case "GET", "DELETE":
            request = makeQueryRequest(url: url, method: method, parameters: parameters)
            
        default:    // case "POST", "PUT":
            request = makeRequest(url: url, method: method, parameters: parameters)
        }
        
        handleResponse(for: request, completion: completion)
    }
    
    func request(endpoint: String,
                 parameters: [String: Any],
                 completion: @escaping (Result<[Any]?, Error>) -> Void) {
        
        guard let url = URL(string: baseUrl + endpoint) else {
            completion(.failure(NetworkingError.badUrl))
            return
        }
        
        let request = makeQueryRequest(url: url, method: "GET", parameters: parameters)
        
        handleResponse(for: request, completion: completion)
    }
    
    // MARK: - function returns Request
    func makeQueryRequest(url: URL, method: String, parameters: [String: Any]) -> URLRequest {
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        var queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: String(describing: value))
            queryItems.append(queryItem)
        }
        
        components?.queryItems = queryItems
        
        var request = URLRequest(url: (components?.url!)!)
        request.httpMethod = method
        
        return request
    }
    
    func makeRequest(url: URL, method: String, parameters: [String: Any]) -> URLRequest {
        
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
    
    func handleResponse(for request: URLRequest,
                        completion: @escaping (Result<Any?, Error>) -> Void) {
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            DispatchQueue.main.async {
                
                guard let unwrappedResponse = response as? HTTPURLResponse else {
                    completion(.failure(NetworkingError.badResponse))
                    return
                }
                
                print(unwrappedResponse.statusCode)
                switch unwrappedResponse.statusCode {
                    
                case 200..<300 :
                    
                    if let unwrappedData = data {
                        do {
                            let json = try JSONSerialization.jsonObject(with: unwrappedData, options: .allowFragments)
                            print(json)
                            
                            // TODO: email 중복검사, phone 중복검사, 400 예외처리
                            // 회원가입, room-DELETE, member-DELETE, check-POST,PUT
                            if String(data: unwrappedData, encoding: .utf8) == "{}\n" {
                                completion(.success(nil))
                            }
                            
                            // 로그인
                            if let user = try? JSONDecoder().decode(User.self, from: unwrappedData) {
                                completion(.success(user))
                            }
                            
                            // room-POST,GET,PUT, member-POST
                            if let room = try? JSONDecoder().decode(Room.self, from: unwrappedData) {
                                completion(.success(room))
                            }
                            
                        } catch {
                            print(error.localizedDescription)
                            completion(.failure(error))
                        }
                    }
                    
                case 400: // 요청 형식 맞지않음
                    completion(.failure(AuthorizationError.formatNotMatch))
                    
                case 401:
                    completion(.failure(AuthorizationError.existingEmail))
                    
                case 404: // 해당 유저 존재하지 않음 or 존재하지 않는 초대 코드
                    completion(.failure(AuthorizationError.unknownAccount))
                    
                case 409: // 이미 가입된 방 or 최대 가입 인원수 초과
                    break
                    
                default:
                    // completion(.failure(AuthorizationError.unknownAccount))
                    print("failure")
                }
                
                if let unwrappedError = error {
                    completion(.failure(unwrappedError))
                    return
                }
            }
        }.resume()
    }
    
    func handleResponse(for request: URLRequest,
                        completion: @escaping (Result<[Any]?, Error>) -> Void) {
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            DispatchQueue.main.async {
                
                guard let unwrappedResponse = response as? HTTPURLResponse else {
                    completion(.failure(NetworkingError.badResponse))
                    return
                }
                
                print(unwrappedResponse.statusCode)
                switch unwrappedResponse.statusCode {
                    
                case 200..<300 :
                    
                    if let unwrappedData = data {
                        do {
                            let json = try JSONSerialization.jsonObject(with: unwrappedData, options: .allowFragments) as! [String: Any]
                            print(json)
                            
                            // member-GET(roomList)
                            if json.keys.contains("0") {
                                var roomList = [Room]()
                                
                                for (_, room) in json {
                                    let roomData = try JSONSerialization.data(withJSONObject: room)
                                    roomList.append(try JSONDecoder().decode(Room.self, from: roomData))
                                }
                                
                                completion(.success(roomList))
                                
                            } else if let checked = json["checked"], let unchecked = json["unchecked"] {
                                    var studentList = [[],[]]
                                    
                                    for (_, student) in checked as! [String: Any] {
                                        let studentData = try JSONSerialization.data(withJSONObject: student)
                                        studentList[0].append(try JSONDecoder().decode(User.self, from: studentData).name)
                                    }
                                    
                                    for (_, student) in unchecked as! [String: Any] {
                                        let studentData = try JSONSerialization.data(withJSONObject: student)
                                        let user = try JSONDecoder().decode(User.self, from: studentData)
                                        if user.rank == "student" { studentList[1].append(user.name) }
                                    }
                                    
                                    completion(.success(studentList))
                                
                            } else if let studentData = json["User"] {
                                var studentList = [User]()
                                
                                for (_, userObject) in studentData as! [String: [String:Any]]  {
                                    let studentData = try JSONSerialization.data(withJSONObject: userObject)
                                    let student = try JSONDecoder().decode(User.self, from: studentData)
                                    if student.rank == "student" {
                                        studentList.append(student)
                                    }
                                }
                                
                                completion(.success(studentList))
                                
                            } else if let attendanceData = json["Date"] {
                                var attendanceDict = [[String: Bool]]()
                                
                                for (date, attendanceInfo) in attendanceData as! [String: [String: Any]]  {
                                    let checkInfo = try JSONSerialization.data(withJSONObject: attendanceInfo)
//                                    attendanceDict[0].append(try JSONDecoder().decode(User.self, from: userData))
                                    
                                    if attendanceDict == [] {
                                        attendanceDict.append([date: try JSONDecoder().decode(Check.self, from: checkInfo).attendance_check_is_checked])
                                    } else {
                                        attendanceDict[0].updateValue(try JSONDecoder().decode(Check.self, from: checkInfo).attendance_check_is_checked, forKey: date)
                                    }
                                }
                                
                                completion(.success(attendanceDict))
                            }
                            
                            // completion(.success(nil))
                            // } else {
                            //     let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: unwrappedData)
                            //     completion(.failure(errorResponse))
                            // }
                            
                        } catch {
                            print(error.localizedDescription)
                            completion(.failure(error))
                        }
                    }
                    
                case 400: // 요청 형식 맞지않음
                    completion(.failure(AuthorizationError.formatNotMatch))
                    
                case 401:
                    completion(.failure(AuthorizationError.existingEmail))
                    
                case 404: // 해당 유저 존재하지 않음 or 존재하지 않는 초대 코드
                    completion(.failure(AuthorizationError.unknownAccount))
                    
                case 409: // 이미 가입된 방 or 최대 가입 인원수 초과
                    break
                    
                default:
                    // completion(.failure(AuthorizationError.unknownAccount))
                    print("failure")
                }
                
                if let unwrappedError = error {
                    completion(.failure(unwrappedError))
                    return
                }
            }
        }.resume()
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
