import Vision


let model = try VNCoreMLModel(for: ImageClassifier().model)

let urls = try FileManager.default.contentsOfDirectory(at: URL(string: "/Users/ikorin/Downloads/test/test_bmp")!, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)

let group = DispatchGroup()

for url in urls {
    DispatchQueue.global(qos: .userInitiated).async {
        group.enter()
        func resultsHandler(request: VNRequest, error: Error?) {
            guard let results = request.results as? [VNClassificationObservation]
                else { fatalError("") }
            print(url.deletingPathExtension().lastPathComponent + "," + results[0].identifier)
            group.leave()
        }
        let request = VNCoreMLRequest(model: model, completionHandler: resultsHandler)
        let handler = VNImageRequestHandler(url: url)
        try! handler.perform([request])
    }
}

group.wait()

