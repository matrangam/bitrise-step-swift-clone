import Foundation
import GitKit
import TSCBasic

struct SwiftCloneStep {
    let config: Config

    var gitCloneArgs: [String] {
        var args = [config.repositoryURL, "--verbose"]
        if let checkoutBranch = config.checkoutBranch {
            args.append(contentsOf: ["--branch", checkoutBranch])
        }
        if let cloneDepth = config.cloneDepth {
            args.append(contentsOf: ["--depth", cloneDepth])
        }
        return args
    }

    func createClonePath() throws -> AbsolutePath {
        let currentPath = AbsolutePath(FileManager.default.currentDirectoryPath)
        let clonePath = currentPath.appending(component: config.cloneDestination)
        try FileManager.default.createDirectory(atPath: clonePath.pathString, withIntermediateDirectories: true)
        return clonePath
    }

    func cloneRepo(into destination: AbsolutePath) throws {
        let git = Git(path: destination.pathString)
        let combinedArgs = gitCloneArgs.joined(separator: " ")
        let output = try git.run(.cmd(.clone, combinedArgs))
        print(output)
    }
}
