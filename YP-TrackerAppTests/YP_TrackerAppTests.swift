//
//  YP_TrackerAppTests.swift
//  YP-TrackerAppTests
//
//  Created by Богдан Полыгалов on 23.07.2023.
//

import XCTest
import SnapshotTesting
@testable import YP_TrackerApp

final class YP_TrackerAppTests: XCTestCase {
    
    override func setUpWithError() throws {
        
    }
    
    override func tearDownWithError() throws {
        
    }
    
    func testScreenshotDark() throws {
        let trackerView = TrackersViewController()
        assertSnapshot(matching: trackerView, as: .image(traits: .init(userInterfaceStyle: .dark)))
    }
    
    func testScreenshotLight() throws {
        let trackerView = TrackersViewController()
        assertSnapshot(matching: trackerView, as: .image(traits: .init(userInterfaceStyle: .light)))
    }
}
