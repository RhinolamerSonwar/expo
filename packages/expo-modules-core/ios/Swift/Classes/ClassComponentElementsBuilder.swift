// Copyright 2022-present 650 Industries. All rights reserved.

#if swift(>=5.4)
/**
 A result builder that captures the ``ClassComponent`` elements such as functions, constants and properties.
 */
@resultBuilder
public struct ClassComponentElementsBuilder<OwnerType> {
  public static func buildBlock(_ elements: ClassComponentElement...) -> [ClassComponentElement] {
    return elements
  }

  public static func buildExpression<ElementType: OwnedClassComponentElement>(
    _ expression: ElementType
  ) -> ClassComponentElement where ElementType.OwnerType == OwnerType {
    return expression
  }

  public static func buildExpression<ElementType: OwnedClassComponentElement>(
    _ expression: ElementType
  ) -> ClassComponentElement where ElementType.OwnerType == Void {
    return expression
  }
}
#endif
