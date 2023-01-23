//
//  test.swift
//  Ohcle_
//
//  Created by Do Yi Lee on 2022/12/14.
//

import Foundation

public class Debouncer {

  // MARK: Lifecycle

  public init(delay: TimeInterval, queue: DispatchQueue = .main) {
    self.delay = delay
    self.queue = queue
  }

  // MARK: Public

  public func run(action: @escaping () -> Void) {
    workItem?.cancel()
    let workItem = DispatchWorkItem(block: action)
    queue.asyncAfter(deadline: .now() + delay, execute: workItem)
    self.workItem = workItem
  }

  public func cancel() {
    workItem?.cancel()
  }

  // MARK: Private

  private let delay: TimeInterval
  private var workItem: DispatchWorkItem?
  private let queue: DispatchQueue

}
