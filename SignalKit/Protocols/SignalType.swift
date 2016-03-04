//
//  SignalType.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 3/4/16.
//  Copyright © 2016 Yanko Dimitrov. All rights reserved.
//

import Foundation

public protocol SignalType: Observable, Disposable {
    
    var disposableSource: Disposable? {get set}
}

// MARK: - Disposable

extension SignalType {
    
    public func dispose() {
        
        disposableSource?.dispose()
    }
}

// MARK: - Next

extension SignalType {
    
    /// Add a new observer to a Signal
    
    public func next(observer: ObservationValue -> Void) -> Self {
        
        addObserver(observer)
        
        return self
    }
}

// MARK: - Map

extension SignalType {
    
    /// Transform a Signal of type ObservationValue to a Signal of type U
    
    public func map<U>(transform: ObservationValue -> U) -> Signal<U> {
        
        let signal = Signal<U>()
        
        addObserver { [weak signal] in
            
            signal?.sendNext(transform($0))
        }
        
        signal.disposableSource = self
        
        return signal
    }
}

// MARK: - Filter

extension SignalType {
    
    /// Filter the Signal value using a predicate
    
    public func filter(predicate: ObservationValue -> Bool) -> Signal<ObservationValue> {
        
        let signal = Signal<ObservationValue>()
        
        addObserver { [weak signal] in
            
            if predicate($0) {
                
                signal?.sendNext($0)
            }
        }
        
        signal.disposableSource = self
        
        return signal
    }
}

// MARK: - Skip

extension SignalType {
    
    /// Skip a number of sent values
    
    public func skip(var count: Int) -> Signal<ObservationValue> {
        
        let signal = Signal<ObservationValue>()
        
        addObserver { [weak signal] in
        
            guard count <= 0 else { count -= 1; return }
            
            signal?.sendNext($0)
        }
        
        signal.disposableSource = self
        
        return signal
    }
}

// MARK: - ObserveOn

extension SignalType {
    
    /// Observe the Signal on a given queue
    
    public func observeOn(queue: SchedulerQueue) -> Signal<ObservationValue> {
        
        let signal = Signal<ObservationValue>()
        let scheduler = Scheduler(queue: queue)
        
        addObserver { [weak signal] value in
            
            scheduler.async {
                
                signal?.sendNext(value)
            }
        }
        
        signal.disposableSource = self
        
        return signal
    }
}
