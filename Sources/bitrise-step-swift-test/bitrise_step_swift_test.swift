@main
public struct bitrise_step_swift_test {
    public private(set) var text = "Hello, World!"

    public static func main() {
        print(bitrise_step_swift_test().text)
    }
}
