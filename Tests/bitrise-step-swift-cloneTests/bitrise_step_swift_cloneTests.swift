import TSCTestSupport
import XCTest

@testable import bitrise_step_swift_clone

let expectedRepoURL = "http://bitrise.io"
let expectedCloneDestination = "_tmp"
let expectedCheckoutBranch = "test_branch"
let expectedCloneDepth = "1"

final class BuildGitCommandTests: XCTestCase {
    func testFullyPopulatedConfig() throws {
        // Given
        let config = Config(
            repositoryURL: expectedRepoURL,
            cloneDestination: expectedCloneDestination,
            checkoutBranch: expectedCheckoutBranch,
            cloneDepth: expectedCloneDepth
        )
        let expectedArgs = [
            expectedRepoURL,
            "--verbose",
            "--branch", expectedCheckoutBranch,
            "--depth", expectedCloneDepth,
        ]

        // When
        let cloneStep = SwiftCloneStep(config: config)

        // Then
        XCTAssertEqual(cloneStep.gitCloneArgs, expectedArgs)
    }

    func testMissingCloneDepth() throws {
        // Given
        let config = Config(
            repositoryURL: expectedRepoURL,
            cloneDestination: expectedCloneDestination,
            checkoutBranch: expectedCheckoutBranch,
            cloneDepth: nil
        )
        let expectedArgs = [
            expectedRepoURL,
            "--verbose",
            "--branch", expectedCheckoutBranch,
        ]

        // When
        let gitCommand = SwiftCloneStep(config: config)

        // Then
        XCTAssertEqual(gitCommand.gitCloneArgs, expectedArgs)
    }

    func testMissingCheckoutBranch() throws {
        // Given
        let config = Config(
            repositoryURL: expectedRepoURL,
            cloneDestination: expectedCloneDestination,
            checkoutBranch: nil,
            cloneDepth: expectedCloneDepth
        )
        let expectedArgs = [
            expectedRepoURL,
            "--verbose",
            "--depth", expectedCloneDepth,
        ]

        // When
        let gitCommand = SwiftCloneStep(config: config)

        // Then
        XCTAssertEqual(gitCommand.gitCloneArgs, expectedArgs)
    }

    func testMissingCheckoutBranchAndCloneDepth() throws {
        // Given
        let config = Config(
            repositoryURL: expectedRepoURL,
            cloneDestination: expectedCloneDestination,
            checkoutBranch: nil,
            cloneDepth: nil
        )
        let expectedArgs = [expectedRepoURL, "--verbose"]

        // When
        let gitCommand = SwiftCloneStep(config: config)

        // Then
        XCTAssertEqual(gitCommand.gitCloneArgs, expectedArgs)
    }
}

final class CreateClonePathTests: XCTestCase {
    func testCreateClonePathSuccess() throws {
        // Given
        let config = Config(
            repositoryURL: expectedRepoURL,
            cloneDestination: expectedCloneDestination
        )
        let step = SwiftCloneStep(config: config)

        // When
        let path = try step.createClonePath()

        // Then
        XCTAssertNotNil(path)
    }
}

final class ParseConfigTests: XCTestCase {
    override class func setUp() {
        Config.clearLocalEnv()
    }

    override func tearDownWithError() throws {
        Config.clearLocalEnv()
    }

    func testParseConfigSuccess() throws {
        // Given
        Config.writeToLocalEnv(
            repositoryURL: expectedRepoURL,
            cloneDestination: expectedCloneDestination,
            checkoutBranch: expectedCheckoutBranch,
            cloneDepth: expectedCloneDepth
        )

        // When
        let config = try XCTUnwrap(Config())

        // Then
        XCTAssertEqual(config.repositoryURL, expectedRepoURL)
        XCTAssertEqual(config.cloneDestination, expectedCloneDestination)
        XCTAssertEqual(config.checkoutBranch, expectedCheckoutBranch)
        XCTAssertEqual(config.cloneDepth, expectedCloneDepth)
    }

    func testParseConfigMissingRepoURL() throws {
        // Given
        Config.writeToLocalEnv(
            cloneDestination: expectedCloneDestination,
            checkoutBranch: expectedCheckoutBranch,
            cloneDepth: expectedCloneDepth
        )

        // Then
        XCTAssertThrows(ConfigParsingError.repositoryURLNotProvided, {
            // When
            _ = try Config()
        })
    }

    func testParseConfigMissingCheckoutDestination() throws {
        // Given
        Config.writeToLocalEnv(
            repositoryURL: expectedRepoURL,
            checkoutBranch: expectedCheckoutBranch,
            cloneDepth: expectedCloneDepth
        )

        // Then
        XCTAssertThrows(ConfigParsingError.cloneDestinationNotProvided, {
            // When
            _ = try Config()
        })
    }
}

private extension Config {
    static func writeToLocalEnv(
        repositoryURL: String? = nil,
        cloneDestination: String? = nil,
        checkoutBranch: String? = nil,
        cloneDepth: String? = nil
    ) {
        if let repositoryURL = repositoryURL {
            setenv("repository_url", repositoryURL, 1)
        }
        if let cloneDestination = cloneDestination{
            setenv("clone_destination", cloneDestination, 1)
        }
        if let checkoutBranch = checkoutBranch {
            setenv("checkout_branch", checkoutBranch, 1)
        }
        if let cloneDepth = cloneDepth {
            setenv("clone_depth", cloneDepth, 1)
        }
    }

    static func clearLocalEnv() {
        unsetenv("repository_url")
        unsetenv("clone_destination")
        unsetenv("checkout_branch")
        unsetenv("clone_depth")
    }
}
