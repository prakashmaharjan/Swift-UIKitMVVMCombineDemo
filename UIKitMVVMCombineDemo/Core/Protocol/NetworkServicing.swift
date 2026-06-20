//
//  NetworkServicing.swift
//  UIKitMVVMCombineDemo
//
//  Created by Prakash Maharjan on 20/06/2026.
//

import Foundation
import Combine

protocol NetworkServicing {
    func request<T: Decodable>(_ request: URLRequest) -> AnyPublisher<T, NetworkError>
}
