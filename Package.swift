// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "QGVAPlayer",
    platforms: [.iOS(.v8)],
    products: [
        .library(name: "QGVAPlayer", targets: ["QGVAPlayer"])
    ],
    targets: [
        .target(
            name: "QGVAPlayer",
            path: "iOS/QGVAPlayer",
            // Use the existing embedded Metal shader source instead of a resource bundle.
            exclude: ["QGVAPlayer.xcodeproj", "QGVAPlayerTests", "QGVAPlayer/Info.plist", "QGVAPlayer/Shaders/QGHWDShaders.metal"],
            sources: ["QGVAPlayer/Classes"],
            publicHeadersPath: ".",
            cSettings: [
                .headerSearchPath("QGVAPlayer/Classes"),
                .headerSearchPath("QGVAPlayer/Classes/Controllers"),
                .headerSearchPath("QGVAPlayer/Classes/Controllers/Decoders"),
                .headerSearchPath("QGVAPlayer/Classes/Models"),
                .headerSearchPath("QGVAPlayer/Classes/MP4Parser"),
                .headerSearchPath("QGVAPlayer/Classes/Utils"),
                .headerSearchPath("QGVAPlayer/Classes/Utils/Categorys"),
                .headerSearchPath("QGVAPlayer/Classes/Utils/Logger"),
                .headerSearchPath("QGVAPlayer/Classes/Views/Metal"),
                .headerSearchPath("QGVAPlayer/Classes/Views/Metal/Vapx"),
                .headerSearchPath("QGVAPlayer/Classes/Views/OpenGL"),
                .headerSearchPath("QGVAPlayer/Shaders")
            ],
            linkerSettings: [
                .linkedFramework("UIKit"),
                .linkedFramework("AVFoundation"),
                .linkedFramework("VideoToolbox"),
                .linkedFramework("CoreMedia"),
                .linkedFramework("CoreVideo"),
                .linkedFramework("QuartzCore"),
                .linkedFramework("OpenGLES"),
                .linkedFramework("GLKit"),
                .linkedFramework("Metal"),
                .linkedFramework("MetalKit")
            ]
        )
    ]
)
