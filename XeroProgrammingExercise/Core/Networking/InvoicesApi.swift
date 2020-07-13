//
//  InvoicesApi.swift
//  XeroProgrammingExercise
//
//  Created by Tony Mu on 13/07/20.
//  Copyright © 2020 Xero Ltd. All rights reserved.
//

import UIKit

enum InvoicesApi {
    
    case getInvoice(invoiceNumber: String)
    case getInvvoices
    case postInvoice

    static let basueUrl = "https://google.com"
    
    private var full: String {
        switch self {
        case .getInvoice(let invoiceNumber):
            return InvoicesApi.basueUrl + "/invoices/number=?\(invoiceNumber)"
        case .getInvvoices:
            return InvoicesApi.basueUrl + "/invoices/"
        case .postInvoice:
            return InvoicesApi.basueUrl + "/invoice"
        }
    }
    
    private var method: HttpMethod {
        switch self {
        case .getInvoice,
             .getInvvoices:
            return .get
        default:
            return .post
        }
    }
    
    private var contentType: String {
        return "application/json"
    }
    
    func request(withBody body: Data? = nil, with token: String) throws -> URLRequest {
        guard let url = URL(string: full) else { throw ApiError.invalidUrl(url: full) }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.addValue(contentType, forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpBody = body
        return request
    }
    
}


enum HttpMethod: String {
    case get = "GET"
    case head = "HEAD"
    case post = "POST"
}


enum ApiError: Error {
    case invalidUrl(url: String)
    case invalidResponse
    case invalidData
}

extension HTTPURLResponse {
    static let successResponseCodeRange = 200..<299
    
    var isValidResponse: Bool {
        return HTTPURLResponse.successResponseCodeRange ~= statusCode
    }
    
}

extension URLRequest {
    var session: URLSession {
        return  URLSession(configuration: URLSessionConfiguration.default)
    }
    
    func send<T: Decodable>(completion: @escaping (Result<T, Error>) -> Void) {
        session.dataTask(with: self) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.isValidResponse, let data = data else {
                completion(.failure(ApiError.invalidResponse))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let value = try decoder.decode(T.self, from: data)
                completion(.success(value))
            } catch {
                completion(.failure(ApiError.invalidData))
            }
            
        }.resume()
    }
}


class SampleApiCall {
    
    struct Parameters: Encodable {
        let number: String
    }
    
    struct PostResult: Decodable {
        let success: Bool
    }
    
    func postInvoice(completion: @escaping (Result<PostResult,Error>)->Void) {
        let parameter = Parameters(number: "test")
        let encoder = JSONEncoder()
        do {
            let body = try encoder.encode(parameter)
            let request = try InvoicesApi.postInvoice.request(withBody: body, with: "token")
            request.send(completion: completion)
        } catch {
            
        }
    }
}
