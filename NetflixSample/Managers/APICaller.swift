//
//  APICaller.swift
//  NetflixSample
//
//  Created by anies1212 on 2022/06/08.
//

import Foundation

struct Constants {
    static let apiKey = "5203469e2a48c64b29913d7a2ac0183c"
    static let baseURL = "https://api.themoviedb.org"
    static let imageBaseURL = "https://image.tmdb.org/t/p/w500"
    static let youtubeAPIKey = "AIzaSyBAUp6_8Vk-HNXtS1YwQNBojXb6h-AW_K8"
    static let youtubeSearchBaseAPIKey = "https://youtube.googleapis.com/youtube/v3/search?"
}

enum APIError {
    case failedToGetData
}

class APICaller {
    static let shared = APICaller()
    
    
    func getTrendingMovies(completion: @escaping (Result<[Title], Error>)->Void){
        guard let url = URL(string: Constants.baseURL + "/3/trending/movie/day?api_key=" + Constants.apiKey) else {return}
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                print(APIError.failedToGetData)
                return
            }
            do {
                let results = try JSONDecoder().decode(TitleResponse.self, from: data)
                completion(.success(results.results))
            } catch {
                print("Failed to fetch movie data:\(error.localizedDescription)")
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    func getTrendingTVs(completion: @escaping (Result<[Title], Error>)->Void){
        guard let url = URL(string: Constants.baseURL + "/3/trending/tv/day?api_key=" + Constants.apiKey) else {return}
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                print(APIError.failedToGetData)
                return
            }
            do {
                let results = try JSONDecoder().decode(TitleResponse.self, from: data)
                completion(.success(results.results))
            } catch {
                print("Failed to fetch movie data:\(error.localizedDescription)")
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    func getUpcomingMovies(completion: @escaping (Result<[Title],Error>)->Void){
        guard let url = URL(string: Constants.baseURL + "/3/movie/upcoming?api_key=" + Constants.apiKey) else {return}
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                print(APIError.failedToGetData)
                return
            }
            do {
                let results = try JSONDecoder().decode(TitleResponse.self, from: data)
                completion(.success(results.results))
            } catch  {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    func getPopularMovies(completion: @escaping (Result<[Title],Error>)->Void){
        guard let url = URL(string: Constants.baseURL + "/3/movie/popular?api_key=" + Constants.apiKey) else {return}
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                print(APIError.failedToGetData)
                return
            }
            do {
                let results = try JSONDecoder().decode(TitleResponse.self, from: data)
                completion(.success(results.results))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    func getTopRatedMovies(completion: @escaping (Result<[Title], Error>)->Void){
        guard let url = URL(string: Constants.baseURL + "/3/movie/top_rated?api_key=" + Constants.apiKey) else {return}
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                print(APIError.failedToGetData)
                return
            }
            do {
                let results = try JSONDecoder().decode(TitleResponse.self, from: data)
                completion(.success(results.results))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    func getDiscoveredMovies(completion: @escaping (Result<[Title], Error>)-> Void){
        guard let url = URL(string: Constants.baseURL + "/3/discover/movie?api_key=" + Constants.apiKey + "&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&with_watch_monetization_types=flatrate") else {
            print(APIError.failedToGetData)
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                print(APIError.failedToGetData)
                return
            }
            do {
                let results = try JSONDecoder().decode(TitleResponse.self, from: data)
                completion(.success(results.results))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    func searchMovies(query: String, completion: @escaping (Result<[Title],Error>)->Void){
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {return}
        guard let url = URL(string: Constants.baseURL + "/3/search/movie?api_key=" + Constants.apiKey + "&language=en-US&query=" + query + "&page=1&include_adult=false") else {
            print(APIError.failedToGetData)
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                print(APIError.failedToGetData)
                return
            }
            do {
                let results = try JSONDecoder().decode(TitleResponse.self, from: data)
                completion(.success(results.results))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    func getYoutubeMovie(with query: String, completion: @escaping (Result<VideoElement,Error>)->Void){
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {return}
        guard let url = URL(string: "\(Constants.youtubeSearchBaseAPIKey)q=\(query)&key=\(Constants.youtubeAPIKey)") else {
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                print(APIError.failedToGetData)
                return
            }
            do {
                let results = try JSONDecoder().decode(YoutubeSearchResponse.self, from: data)
                completion(.success(results.items[0]))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
