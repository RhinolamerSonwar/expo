// Copyright 2022-present 650 Industries. All rights reserved.

import ExpoModulesTestCore

@testable import ExpoModulesCore

class ExpoModulesSpec: ExpoSpec {
  override func spec() {
    let appContext = AppContext.create()
    let runtime = appContext.runtime
    let testModuleName = "TestModule"
    let testFunctionName = "testFunction"
    let constantsDict: [String: Any] = [
      "expo": "is cool",
      "sdk": 45,
    ]

    beforeSuite {
      appContext.moduleRegistry.register(holder: mockModuleHolder(appContext) {
        Name(testModuleName)

        Constants(constantsDict)

        Function(testFunctionName) { Double.pi }
      })
    }

    describe("shared object") {
      class MySharedObject: SharedObject {
        let value: Int

        init(_ value: Int) {
          self.value = value
          super.init()
        }
      }

      it("passes") {
        let randomInt = Int.random(in: 0..<100)

        appContext.moduleRegistry.register(holder: mockModuleHolder(appContext) {
          Name("SharedObjectTest")

          Function("createSharedObject") {
            return MySharedObject(randomInt)
          }

          Function("getValueFromSharedObject") { (sharedObject: MySharedObject) in
            return sharedObject.value
          }
        })

        try? runtime?.eval("""
for (let i = 0; i < 500000; i++) {
  let result = ExpoModules.SharedObjectTest.createSharedObject();
  result = null;
}
""")

//        expect(result?.isNumber()) == true
//        expect(try? result?.asInt()) == randomInt

        waitUntil(timeout: DispatchTimeInterval.seconds(60)) { done in
          DispatchQueue.main.asyncAfter(deadline: DispatchTime.now().advanced(by: .seconds(50))) {
            done()
            print(SharedObjectRegistry.pairs)
          }
        }
      }
    }

    describe("host object") {
      it("is defined") {
        expect(try! runtime?.eval("'ExpoModules' in this").asBool()) === true
      }

      it("has native module defined") {
        expect(try! runtime?.eval("'\(testModuleName)' in ExpoModules").asBool()) === true
      }

      it("can access native module") {
        let nativeModule = try! runtime?.eval("ExpoModules.\(testModuleName)")
        expect(nativeModule?.isUndefined()) == false
        expect(nativeModule?.isObject()) == true
        expect(nativeModule?.getRaw()).notTo(beNil())
      }

      it("has keys for registered modules") {
        let registeredModuleNames = appContext.moduleRegistry.getModuleNames()
        let keys = try! runtime?.eval("Object.keys(ExpoModules)").asArray().compactMap {
          return try! $0?.asString()
        }
        expect(keys).to(contain(registeredModuleNames))
      }
    }

    describe("module") {
      it("exposes constants") {
        let dict = try! runtime!.eval("ExpoModules.TestModule").asDict()

        dict.forEach { (key: String, value: Any) in
          expect(value) === dict[key]!
        }
      }

      it("has function") {
        expect(try! runtime?.eval("typeof ExpoModules.TestModule.\(testFunctionName)").asString()) == "function"
        expect(try! runtime?.eval("ExpoModules.TestModule.\(testFunctionName)").isFunction()) == true
      }

      it("calls function") {
        expect(try! runtime?.eval("ExpoModules.TestModule.\(testFunctionName)()").asDouble()) == Double.pi
      }
    }
  }
}
