//
//  DataModel.swift
//  Chordilly
//
//  Created by Tarushi Goyal on 01/07/21.
//

import Foundation

// https://itunes.apple.com/search?term=coldplay&entity=song

class DataModel {
    
    private var dataTask: URLSessionDataTask?
    
    func loadSongs(searchTerm: String, completion: @escaping(([Song]) -> Void)) {
        if let songs = self.loadJson(){
            let filterSong = songs.filter({ $0.chords.localizedCaseInsensitiveContains(searchTerm) ||  $0.artistName.localizedCaseInsensitiveContains(searchTerm) ||  $0.trackName.localizedCaseInsensitiveContains(searchTerm)})
            completion(filterSong)
        } else {
            completion([])
        }

    }
    
    private func buildUrl(forTerm searchTerm: String) -> URL? {
        guard !searchTerm.isEmpty else { return nil }
        
        let queryItems = [
            URLQueryItem(name: "term", value: searchTerm),
            URLQueryItem(name: "entity", value: "song"),
        ]
        var components = URLComponents(string: "https://itunes.apple.com/search")
        components?.queryItems = queryItems
        
        return components?.url
    }
    
    func loadJson() -> [Song]? {
        if let url = Bundle.main.url(forResource: "Data", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(SongResponse.self, from: data)
                return jsonData.songs
            } catch {
                print("error:\(error)")
            }
        }
        return nil
    }
    
}

struct SongResponse: Decodable {
  let songs: [Song]
  
  enum CodingKeys: String, CodingKey {
    case songs = "results"
  }
}

struct Song: Decodable {
    let id: Int
    let trackName: String
    let artistName: String
    let artworkUrl: String
    let chords : String
    
    enum CodingKeys: String, CodingKey {
        case id = "trackId"
        case trackName
        case artistName
        case artworkUrl = "artworkUrl60"
        case chords
    }
}

