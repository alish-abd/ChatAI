//
//  APICaller.swift
//  ChatAI
//
//  Created by Alisher Abdulin on 25.01.2023.
//
import OpenAISwift
import Foundation

final class APICaller {
    static let shared = APICaller()
    
    @frozen enum Contants {
        static let key = "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"
    }
    private var client: OpenAISwift?
    private init() {}
    
    public func setup() {
        self.client = OpenAISwift(authToken: Contants.key)
    }
    
    public func getResponse(input: String,
                            completion: @escaping (Result<String, Error>) -> Void) {
        client?.sendCompletion(with: input, model: .codex(.davinci), completionHandler: { result in
            switch result {
            case .success(let model):
                print(String(describing: model.choices))
                let output = model.choices.first?.text ?? ""
                completion(.success(output))
            case.failure(let error):
                completion(.failure(error))
            }
        })
    }
}
