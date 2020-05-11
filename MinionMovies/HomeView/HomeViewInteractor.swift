//
//  HomeViewInteractor.swift
//  MinionMovies
//
//  Created by Vitor Costa on 29/04/20.
//  Copyright © 2020 Vitor Costa. All rights reserved.
//

import Foundation

protocol InteractorProtocol {
    var presenter: PresenterProtocol? { get }
    var worker: WorkerProtocol? { get }
    
    func theScreenIsLoading()
    func searching(string: String)
    func doingResearch(boolean: Bool)
}

class HomeViewInteractor: InteractorProtocol {
    var presenter: PresenterProtocol?
    var worker: WorkerProtocol?
    internal var dbManager: DBManagerProtocol = DBManager(config: .basic)
    
    init(presenter: PresenterProtocol?, worker: WorkerProtocol?) {
        self.presenter = presenter
        self.worker = worker
    }
    
    func theScreenIsLoading() {
        worker?.makeGetRequest(urlString: "http://localhost:8080/response.json", completionHandler: { [weak self] result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let receivedItems):
                self?.presenter?.receiveItems(items: receivedItems)
                
                for item in receivedItems {
                    self?.dbManager.add(object: item)
                }
            }
        })
    }
    
    func searching(string: String) {
        presenter?.searchResult(string: string)
    }
    
    func  doingResearch(boolean: Bool) {
        if boolean {
            
        }
    }
}
