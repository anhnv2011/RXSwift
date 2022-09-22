//
//  Music.swift
//  DemoRxSwift
//
//  Created by MAC on 8/3/22.
//

import Foundation

struct Music: Codable {
    var artistName: String?
    var id: String?
    var releaseDate: String?
    var name: String?
    var copyright: String?
    var artworkUrl100: String?
}

struct MusicResults: Codable {
  var results: [Music]
}

struct FeedResult: Codable {
  var feed: MusicResults
}

//struct FeedResult: Codable {
//
//    let feed: Feed
//
//    private enum CodingKeys: String, CodingKey {
//        case feed = "feed"
//    }
//
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        feed = try values.decode(Feed.self, forKey: .feed)
//    }
//
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(feed, forKey: .feed)
//    }
//
//}
//struct Feed: Codable {
//
//    let title: String
//    let id: String
//    let author: Author
//    let links: [Links]
//    let copyright: String
//    let country: String
//    let icon: String
//    let updated: String
//    let results: [Music]
//
//    private enum CodingKeys: String, CodingKey {
//        case title = "title"
//        case id = "id"
//        case author = "author"
//        case links = "links"
//        case copyright = "copyright"
//        case country = "country"
//        case icon = "icon"
//        case updated = "updated"
//        case results = "results"
//    }
//
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        title = try values.decode(String.self, forKey: .title)
//        id = try values.decode(String.self, forKey: .id)
//        author = try values.decode(Author.self, forKey: .author)
//        links = try values.decode([Links].self, forKey: .links)
//        copyright = try values.decode(String.self, forKey: .copyright)
//        country = try values.decode(String.self, forKey: .country)
//        icon = try values.decode(String.self, forKey: .icon)
//        updated = try values.decode(String.self, forKey: .updated)
//        results = try values.decode([Music].self, forKey: .results)
//    }
//
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(title, forKey: .title)
//        try container.encode(id, forKey: .id)
//        try container.encode(author, forKey: .author)
//        try container.encode(links, forKey: .links)
//        try container.encode(copyright, forKey: .copyright)
//        try container.encode(country, forKey: .country)
//        try container.encode(icon, forKey: .icon)
//        try container.encode(updated, forKey: .updated)
//        try container.encode(results, forKey: .results)
//    }
//
//}
//struct Author: Codable {
//
//    let name: String
//    let url: String
//
//    private enum CodingKeys: String, CodingKey {
//        case name = "name"
//        case url = "url"
//    }
//
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        name = try values.decode(String.self, forKey: .name)
//        url = try values.decode(String.self, forKey: .url)
//    }
//
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(name, forKey: .name)
//        try container.encode(url, forKey: .url)
//    }
//
//}
//struct Links: Codable {
//
//    let selfField: String
//
//    private enum CodingKeys: String, CodingKey {
//        case selfField = "self"
//    }
//
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        selfField = try values.decode(String.self, forKey: .selfField)
//    }
//
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(selfField, forKey: .selfField)
//    }
//
//}
//struct Music: Codable {
//
//    let artistName: String
//    let id: String
//    let name: String
//    let releaseDate: String
//    let kind: String
//    let artistId: String
//    let artistUrl: String
//    let contentAdvisoryRating: String
//    let artworkUrl100: String
//    let genres: [Genres]
//    let url: String
//
//    private enum CodingKeys: String, CodingKey {
//        case artistName = "artistName"
//        case id = "id"
//        case name = "name"
//        case releaseDate = "releaseDate"
//        case kind = "kind"
//        case artistId = "artistId"
//        case artistUrl = "artistUrl"
//        case contentAdvisoryRating = "contentAdvisoryRating"
//        case artworkUrl100 = "artworkUrl100"
//        case genres = "genres"
//        case url = "url"
//    }
//
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        artistName = try values.decode(String.self, forKey: .artistName)
//        id = try values.decode(String.self, forKey: .id)
//        name = try values.decode(String.self, forKey: .name)
//        releaseDate = try values.decode(String.self, forKey: .releaseDate)
//        kind = try values.decode(String.self, forKey: .kind)
//        artistId = try values.decode(String.self, forKey: .artistId)
//        artistUrl = try values.decode(String.self, forKey: .artistUrl)
//        contentAdvisoryRating = try values.decode(String.self, forKey: .contentAdvisoryRating)
//        artworkUrl100 = try values.decode(String.self, forKey: .artworkUrl100)
//        genres = try values.decode([Genres].self, forKey: .genres)
//        url = try values.decode(String.self, forKey: .url)
//    }
//
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(artistName, forKey: .artistName)
//        try container.encode(id, forKey: .id)
//        try container.encode(name, forKey: .name)
//        try container.encode(releaseDate, forKey: .releaseDate)
//        try container.encode(kind, forKey: .kind)
//        try container.encode(artistId, forKey: .artistId)
//        try container.encode(artistUrl, forKey: .artistUrl)
//        try container.encode(contentAdvisoryRating, forKey: .contentAdvisoryRating)
//        try container.encode(artworkUrl100, forKey: .artworkUrl100)
//        try container.encode(genres, forKey: .genres)
//        try container.encode(url, forKey: .url)
//    }
//
//}
//struct Genres: Codable {
//
//    let genreId: String
//    let name: String
//    let url: String
//
//    private enum CodingKeys: String, CodingKey {
//        case genreId = "genreId"
//        case name = "name"
//        case url = "url"
//    }
//
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        genreId = try values.decode(String.self, forKey: .genreId)
//        name = try values.decode(String.self, forKey: .name)
//        url = try values.decode(String.self, forKey: .url)
//    }
//
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(genreId, forKey: .genreId)
//        try container.encode(name, forKey: .name)
//        try container.encode(url, forKey: .url)
//    }
//
//}
