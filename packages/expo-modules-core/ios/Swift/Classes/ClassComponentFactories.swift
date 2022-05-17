// Copyright 2022-present 650 Industries. All rights reserved.

/**
 Class constructor without arguments.
 */
public func Constructor<R>(
  _ body: @escaping () throws -> R
) -> SyncFunctionComponent<(), Void, R> {
  return Function("constructor", body)
}

/**
 Class constructor with one argument.
 */
public func Constructor<R, A0: AnyArgument>(
  _ body: @escaping (A0) throws -> R
) -> SyncFunctionComponent<(A0), A0, R> {
  return Function("constructor", body)
}

/**
 Class constructor with two arguments.
 */
public func Constructor<R, A0: AnyArgument, A1: AnyArgument>(
  _ body: @escaping (A0, A1) throws -> R
) -> SyncFunctionComponent<(A0, A1), A0, R> {
  return Function("constructor", body)
}

/**
 Class constructor with three arguments.
 */
public func Constructor<R, A0: AnyArgument, A1: AnyArgument, A2: AnyArgument>(
  _ body: @escaping (A0, A1, A2) throws -> R
) -> SyncFunctionComponent<(A0, A1, A2), A0, R> {
  return Function("constructor", body)
}

/**
 Class constructor with four arguments.
 */
public func Constructor<R, A0: AnyArgument, A1: AnyArgument, A2: AnyArgument, A3: AnyArgument>(
  _ body: @escaping (A0, A1, A2, A3) throws -> R
) -> SyncFunctionComponent<(A0, A1, A2, A3), A0, R> {
  return Function("constructor", body)
}

/**
 Class constructor with five arguments.
 */
public func Constructor<R, A0: AnyArgument, A1: AnyArgument, A2: AnyArgument, A3: AnyArgument, A4: AnyArgument>(
  _ body: @escaping (A0, A1, A2, A3, A4) throws -> R
) -> SyncFunctionComponent<(A0, A1, A2, A3, A4), A0, R> {
  return Function("constructor", body)
}

/**
 Class constructor with six arguments.
 */
public func Constructor<R, A0: AnyArgument, A1: AnyArgument, A2: AnyArgument, A3: AnyArgument, A4: AnyArgument, A5: AnyArgument>(
  _ body: @escaping (A0, A1, A2, A3, A4, A5) throws -> R
) -> SyncFunctionComponent<(A0, A1, A2, A3, A4, A5), A0, R> {
  return Function("constructor", body)
}

/**
 Creates the component describing a JavaScript class.
 */
public func Class<SharedObjectType: SharedObject>(
  _ name: String,
  _ sharedObjectType: SharedObjectType.Type? = nil,
  @ClassComponentElementsBuilder<SharedObjectType> _ elements: () -> [ClassComponentElement]
) -> ClassComponent {
  return ClassComponent(name: name, sharedObjectType: sharedObjectType, elements: elements())
}
