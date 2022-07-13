import Foundation

do {
    let exitCode = try SwiftCloneStepRunner.run()
    print("Git clone was successful!")
    exit(exitCode)
} catch {
    print(error.localizedDescription)
    exit(EXIT_FAILURE)
}
