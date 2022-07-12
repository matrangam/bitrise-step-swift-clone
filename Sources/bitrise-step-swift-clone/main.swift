import Foundation

public struct bitrise_step_swift_clone {
    public static func main() {
        do {
            let exitCode = try bitrise_step_swift_clone().run()
            exit(exitCode)
        } catch {
            print(error.localizedDescription)
            exit(EXIT_FAILURE)
        }
    }

    private func run() throws -> Int32 {
        let config = try Config()
        let cloneStep = SwiftCloneStep(config: config)
        let clonePath = try cloneStep.createClonePath()
        try cloneStep.cloneRepo(into: clonePath)

        print("Repo successfully cloned")
        exit(EXIT_SUCCESS)
    }
}
