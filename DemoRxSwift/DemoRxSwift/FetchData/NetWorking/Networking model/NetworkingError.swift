//
//  NetworkingError.swift
//  DemoRxSwift
//
//  Created by MAC on 8/3/22.
//

import Foundation
enum NetworkingError: Error {
  case invalidURL(String)
  case invalidParameter(String, Any)
  case invalidJSON(String)
  case invalidDecoderConfiguration
}
