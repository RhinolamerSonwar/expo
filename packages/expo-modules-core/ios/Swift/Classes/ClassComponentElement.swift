// Copyright 2022-present 650 Industries. All rights reserved.

/**
 A type-erased protocol that must be implemented by the components passed as ``ClassComponent`` elements.
 */
public protocol ClassComponentElement: AnyDefinition {}

public protocol OwnedClassComponentElement: ClassComponentElement {
  associatedtype OwnerType
}

// MARK: - Conformance
// Allow some other components to be used as the class component elements.

extension SyncFunctionComponent: OwnedClassComponentElement {
  public typealias OwnerType = FirstArgType
}

extension AsyncFunctionComponent: OwnedClassComponentElement {
  public typealias OwnerType = FirstArgType
}

extension PropertyComponent: OwnedClassComponentElement {
  public typealias OwnerType = Void
}

extension ConstantsDefinition: OwnedClassComponentElement {
  public typealias OwnerType = Void
}
