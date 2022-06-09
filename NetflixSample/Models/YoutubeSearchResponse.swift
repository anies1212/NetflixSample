//
//  YoutubeSearchResponse.swift
//  NetflixSample
//
//  Created by anies1212 on 2022/06/09.
//

import Foundation

struct YoutubeSearchResponse: Codable {
    let items: [VideoElement]
}
struct VideoElement: Codable {
    let id: IdVideoElement
}
struct IdVideoElement:Codable {
    let kind: String
    let videoId: String
}
