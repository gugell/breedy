//
//  CombineExtensions.swift
//  Breedy
//
//  Created by Ilia Gutu on 10.01.2022.
//

import Combine
import CombineExt
import Moya

extension Publisher {
    // swiftlint:disable:next line_length
    func sinkOnMainQueue(receiveCompletion: @escaping (Subscribers.Completion<Failure>) -> Void, receiveValue: @escaping (Output) -> Void) -> AnyCancellable {
        receive(on: DispatchQueue.main)
            .sink(receiveCompletion: receiveCompletion, receiveValue: receiveValue)
    }
}

extension Publisher where Self.Failure == Never {
    func sinkOnMainQueue(receiveValue: @escaping (Output) -> Void = { _ in }) -> AnyCancellable {
        receive(on: DispatchQueue.main)
            .sink(receiveValue: receiveValue)
    }

    // swiftlint:disable:next line_length
    func assign<Root: AnyObject, S: Scheduler>(to keyPath: ReferenceWritableKeyPath<Root, Self.Output>, on object: Root, ownership: ObjectOwnership, scheduler: S) -> AnyCancellable {
        receive(on: scheduler)
            .assign(to: keyPath, on: object, ownership: ownership)
    }
}

extension Publisher where Self.Failure == Never {
    // swiftlint:disable:next line_length
    func flatMapLatest<P: Publisher>(_ transform: @escaping (Output) -> P) -> Publishers.SwitchToLatest<P, Publishers.Map<Publishers.SetFailureType<Self, P.Failure>, P>> {
        setFailureType(to: P.Failure.self)
            .map(transform)
            .switchToLatest()
    }
}

extension Publisher {
    // swiftlint:disable:next line_length
    func flatMapLatest<P: Publisher>(_ transform: @escaping (Output) -> P) -> Publishers.SwitchToLatest<P, Publishers.Map<Self, P>> where Self.Failure == P.Failure {
        map(transform)
            .switchToLatest()
    }
}

extension Publisher {
    func shareReplay() -> Publishers.Autoconnect<Publishers.Multicast<Self, ReplaySubject<Self.Output, Self.Failure>>> {
        share(replay: 1)
    }
}

extension Publisher {
    func mapTo<Result>(_ value: Result) -> Publishers.Map<Self, Result> {
        map { _ in value }
    }

    func asVoid() -> Publishers.Map<Self, Void> {
        return map { _ in () }
    }
}

extension AnyPublisher where Output == Response, Failure == MoyaError {
    func mapObject<T: Codable>(_ type: T.Type, path: String? = nil) -> AnyPublisher<T, MoyaError> {
        return unwrapThrowable {
            try $0.mapObject(type, path: path)
        }
    }

    func mapArray<T: Codable>(_ type: T.Type, path: String? = nil) -> AnyPublisher<[T], MoyaError> {
        return unwrapThrowable {
            try $0.mapArray(type, path: path)
        }
    }
}

extension AnyPublisher where Failure == MoyaError {

    // Workaround for a lot of things, actually. We don't have Publishers.Once, flatMap
    // that can throw and a lot more. So this monster was created because of that. Sorry.
    private func unwrapThrowable<T>(throwable: @escaping (Output) throws -> T) -> AnyPublisher<T, MoyaError> {
        self.tryMap { element in
            try throwable(element)
        }
        .mapError { error -> MoyaError in
            if let moyaError = error as? MoyaError {
                return moyaError
            } else {
                return .underlying(error, nil)
            }
        }
        .eraseToAnyPublisher()
    }
}

public extension Response {
    func mapObject<T: Codable>(_ type: T.Type, path: String? = nil) throws -> T {
        do {
            return try JSONDecoder().decode(T.self, from: try getJsonData(path))
        } catch {
            debugPrint(error.localizedDescription)
            debugPrint((error as? DecodingError).debugDescription)
            throw MoyaError.jsonMapping(self)
        }
    }

    func mapArray<T: Codable>(_ type: T.Type, path: String? = nil) throws -> [T] {

        do {
            return try JSONDecoder().decode([T].self, from: try getJsonData(path))
        } catch {
            debugPrint(error)
            throw MoyaError.jsonMapping(self)
        }
    }

    private func getJsonData(_ path: String? = nil) throws -> Data {

        do {

            var jsonObject = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
            if let path = path {
                guard let specificObject = jsonObject.value(forKeyPath: path) else {
                    throw MoyaError.jsonMapping(self)
                }
                jsonObject = specificObject as AnyObject
            }

            return try JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)
        } catch {
            throw MoyaError.jsonMapping(self)
        }
    }
}
