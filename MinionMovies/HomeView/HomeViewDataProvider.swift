//
//  DataProviderHomeView.swift
//  MinionMovies
//
//  Created by Vitor Costa on 29/04/20.
//  Copyright © 2020 Vitor Costa. All rights reserved.
//

import Foundation

protocol HomeViewDataProviderProtocol {
    func add(items: [MovieDB])
    func retriveAllObjects() -> [MovieDB]
}

class HomeViewDataProvider: HomeViewDataProviderProtocol {
    private var config: ConfigurationType
    
    init(config: ConfigurationType) {
        self.config = config
    }
    
    func add(items: [MovieDB]) {
        let dbManager = DBManager(config: config)
        items.forEach { item in
            dbManager.add(object: item)
        }
    }
    
    func retriveAllObjects() -> [MovieDB] {
        let dbManager = DBManager(config: config)
        return dbManager.retrieveAllObjects(type: MovieDB.self) as? [MovieDB] ?? []
    }
}
