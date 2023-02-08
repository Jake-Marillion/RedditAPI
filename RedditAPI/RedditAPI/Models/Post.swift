//
//  Post.swift
//  RedditAPI
//
//  Created by Jacob Marillion on 2/5/23.
//

//MARK: - Explanation
//https://www.reddit.com/r/funny.json
//Pasted above link into online json viewer.  Created structs below to access the data I wanted.

import Foundation

struct TopLevelObject: Decodable {
    let data: SecondLevelObject
}

struct SecondLevelObject: Decodable {
    let children: [ThirdLevelObject]
}

struct ThirdLevelObject: Decodable {
    let data: Post
}

struct Post: Decodable {
    let title: String
    let ups: Int
    let thumbnail: String
}
