import Foundation
import GitKit
import TSCBasic

struct SwiftCloneStep {
    let config: Config

    var gitCloneArgs: [String] {
        var args = [config.repositoryURL, "--verbose"]
        if let checkoutBranch = config.checkoutBranch, !checkoutBranch.isEmpty {
            args.append(contentsOf: ["--branch", checkoutBranch])
        }
        if let cloneDepth = config.cloneDepth, !cloneDepth.isEmpty {
            args.append(contentsOf: ["--depth", cloneDepth])
        }
        return args
    }

    func createClonePath() throws -> AbsolutePath {
        let currentPath = AbsolutePath(FileManager.default.currentDirectoryPath)
        let clonePath = currentPath.appending(component: config.cloneDestination)
        print("Cloning into path: \(clonePath)")
        try FileManager.default.createDirectory(atPath: clonePath.pathString, withIntermediateDirectories: true)
        return clonePath
    }

    func cloneRepo(into destination: AbsolutePath) throws {
        let git = Git(path: destination.pathString)
        let combinedArgs = gitCloneArgs.joined(separator: " ")
        print("Running git clone \(combinedArgs)")
        let output = try git.run(.cmd(.clone, combinedArgs))
        print(output)
    }
}

enum SwiftCloneStepRunner {
    static func run() throws -> Int32 {
        let config = try Config()
        let cloneStep = SwiftCloneStep(config: config)
        let clonePath = try cloneStep.createClonePath()
        try cloneStep.cloneRepo(into: clonePath)

        print("Repo successfully cloned")
        exit(EXIT_SUCCESS)
    }
}
