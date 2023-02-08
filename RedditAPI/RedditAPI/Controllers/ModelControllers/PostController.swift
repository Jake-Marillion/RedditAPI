//
//  PostController.swift
//  RedditAPI
//
//  Created by Jacob Marillion on 2/5/23.
//
//MARK: - Reference
//https://www.reddit.com/r/funny.json

import UIKit

class PostController {
    
    static let baseURL = URL(string: "https://www.reddit.com")
    static let rComonent = "r"
    static let jsonExtension = "json"
    
    static func fetchPostWith(searchTerm: String, completion: @escaping (Result<[Post], PostError>) -> Void) {
        
        guard let baseURL = baseURL else { return completion(.failure(.invalidURL)) }
        let rURL = baseURL.appendingPathComponent(rComonent)
        let searchURL = rURL.appendingPathComponent(searchTerm)
        let finalURL = searchURL.appendingPathExtension(jsonExtension)
        print(finalURL)
        
        URLSession.shared.dataTask(with: finalURL) { data, response, error in
            if let error = error {
                return completion(.failure(.thrownError(error)))
            }
            
            if let response = response as? HTTPURLResponse {
                if response.statusCode != 200 {
                    print("POST STATUS CODE: \(response)")
                }
            }
            
            guard let data = data else { return completion(.failure(.noData)) }
            
            do {
                let topLevelObject = try JSONDecoder().decode(TopLevelObject.self, from: data)
//                let secondLevelObject = topLevelObject.data.c
//                let thirdLevelObject = secondLevelObject.children
                //or
                let dataDict = topLevelObject.data.children
                
                var arrayOfPosts: [Post] = []
                
                for dict in dataDict {
                    let post = dict.data
                    arrayOfPosts.append(post)
                }
                return completion(.success(arrayOfPosts))
                
            } catch {
                return completion(.failure(.unableToDecode))
            }
            
        }.resume()
    }
    
    static func fetchThumbnailFor(post: Post, completion: @escaping (Result<UIImage, PostError>) -> Void) {
        
        guard let thumbnailURL = URL(string: post.thumbnail) else { return completion(.failure(.invalidURL)) }
        
        URLSession.shared.dataTask(with: thumbnailURL) { data, response, error in
            if let error = error {
                return completion(.failure(.thrownError(error)))
            }
            
            if let response = response as? HTTPURLResponse {
                if response.statusCode != 200 {
                    print("THUMBNAIL STATUS CODE: \(response.statusCode)")
                }
            }
            
            guard let data = data else { return completion(.failure(.noData)) }
            
            guard let thumbnail = UIImage(data: data) else { return completion(.failure(.unableToDecode)) }
            
            return completion(.success(thumbnail))
            
        }.resume()
    }
    
} //MARK: - End of class
