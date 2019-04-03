//
//  ViewController.swift
//  Swift5ResultType
//
//  Created by Alexandru Corut on 4/3/19.
//  Copyright © 2019 Alexandru Corut. All rights reserved.
//

import UIKit



struct Course: Decodable {
    let id: Int
    let name: String
    let imageUrl: String
    let number_of_lessons: Int
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchCourseJSONSwift4 { (courses, err) in
            if let err = err {
                print("Failed to fetch courses:", err)
            }

            courses?.forEach({ (course) in
                print(course.name)
            })
        }
        
     
        fetchCourseJSONSwif5 { (result) in
            switch result {
            
            case .success(let courses):
                courses.forEach({ (course) in
                    print(course.name)
                })
            
            case .failure(let err):
                print("Failed to fetch courses:", err)
            }
        }
    }

    
    fileprivate func fetchCourseJSONSwift4(completion: @escaping ([Course]?, Error?) -> ()) {
        let urlString = "https://api.letsbuildthatapp.com/jsondecodable/courses"
        guard let url = URL(string: urlString) else { return }


        URLSession.shared.dataTask(with: url) { (data, response, err) in

            if let err = err {
                completion(nil, err)
                return
            }

            //successful
            do {
                let courses = try JSONDecoder().decode([Course].self, from: data!)
                completion(courses, nil)
            } catch let jsonError {
                completion(nil, jsonError)
            }

        }.resume()
    }
    
    //Swift5
    fileprivate func fetchCourseJSONSwif5(completion: @escaping (Result<[Course], Error>) -> ()) {
        let urlString = "https://api.letsbuildthatapp.com/jsondecodable/courses"
        guard let url = URL(string: urlString) else { return }
        
        
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            
            if let err = err {
                completion(.failure(err))
                return
            }
            
            //successful
            do {
                let courses = try JSONDecoder().decode([Course].self, from: data!)
                completion(.success(courses))
            } catch let jsonError {
                completion(.failure(jsonError))
            }
            
            }.resume()
    }

}

