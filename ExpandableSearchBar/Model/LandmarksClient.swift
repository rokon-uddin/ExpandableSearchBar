//
//  LandmarksClient.swift
//  ExpandableSearchBar
//
//  Created by Mohammed Rokon Uddin on 10/1/24.
//

import Foundation

struct LandmarksClient {
  private func readJSONFile<T: Decodable>(_ type: T.Type, with url: URL) throws -> T {
    let jsonData = try Data(contentsOf: url)
    let validatedData = try validateAndCorrectJSON(jsonData)

    return try JSONDecoder().decode(T.self, from: validatedData)
  }

  private func isValidJSONData(_ data: Data) -> Bool {
    let jsonObject = try? JSONSerialization.jsonObject(with: data)
    guard let jsonObject else { return false }
    return JSONSerialization.isValidJSONObject(jsonObject)
  }

  private func validateAndCorrectJSON(_ data: Data) throws -> Data {
    let jsonString = String(data: data, encoding: .utf8)
    guard let jsonString else { throw JSONError.invalidCharacterFound }

    let isJSONBrackets: (Character) -> Bool = { char in
      char.isNewline || char.isWhitespace || char == "[" || char == "]"
        || char == "{" || char == "}"

    }

    for index in jsonString.indices where !isJSONBrackets(jsonString[index]) {
      var correctedJsonString = jsonString
      correctedJsonString.insert(",", at: index)

      let correctedData = correctedJsonString.data(using: .utf8)
      guard let correctedData else { throw JSONError.invalidCharacterFound }

      if isValidJSONData(correctedData) {
        return correctedData
      }
    }
    return data
  }

  func fetchLandmarks() throws -> Landmarks {
    let jsonURL = Bundle.main.url(forResource: "landmarkData", withExtension: "json")
    guard let jsonURL else { throw JSONError.urlNotFound }
    let response = try? readJSONFile(Landmarks.self, with: jsonURL)
    guard let response else { throw JSONError.invalidCharacterFound }
    return response
  }
}
