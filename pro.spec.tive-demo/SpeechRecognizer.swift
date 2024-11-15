import Speech
import AVFoundation

class SpeechRecognizer: ObservableObject {
private let recognizer = SFSpeechRecognizer()
private var recognitionTask: SFSpeechRecognitionTask?
private let audioEngine = AVAudioEngine()

@Published var recognizedText = ""
@Published var userPrompt = ""
private var lastProcessedIndex = 0
private var triggerEndIndex = 0
private var isRecording = false
private var silenceTimer: Timer? // Added timer property

func startListening() {
    SFSpeechRecognizer.requestAuthorization { authStatus in
        if authStatus == .authorized {
            self.configureAudioSession()
            self.startRecognition()
        } else {
            print("Speech recognition authorization denied.")
        }
    }
}

private func configureAudioSession() {
    let audioSession = AVAudioSession.sharedInstance()
    do {
        try audioSession.setCategory(.record, mode: .default, options: .duckOthers)
        try audioSession.setPreferredSampleRate(44100)
        try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
    } catch {
        print("Failed to set up audio session: \(error)")
    }
}

private func startRecognition() {
    // Stop any ongoing recognition task
    recognitionTask?.cancel()
    recognitionTask = nil
    
    let request = SFSpeechAudioBufferRecognitionRequest()
    let inputNode = self.audioEngine.inputNode
    
    guard let recognizer = recognizer, recognizer.isAvailable else {
        print("Speech recognizer is not available.")
        return
    }
    
    recognitionTask = recognizer.recognitionTask(with: request) { result, error in
        if let result = result {
            let spokenText = result.bestTranscription.formattedString
            
            self.recognizedText = String(spokenText.dropFirst(self.lastProcessedIndex))
            print(self.recognizedText)
            
            // Reset the silence timer whenever speech is detected
            self.resetSilenceTimer()
            
            if self.recognizedText.lowercased().contains("initialize") {
                self.lastProcessedIndex = spokenText.count
                self.isRecording = true
            }
        }
        if error != nil || result?.isFinal == true {
            self.stopRecognition()
        }
    }
    
    let recordingFormat = inputNode.inputFormat(forBus: 0)
    inputNode.removeTap(onBus: 0) // Ensure no previous taps are active
    inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
        request.append(buffer)
    }
    
    audioEngine.prepare()
    do {
        try audioEngine.start()
        // Start the silence timer when recognition starts
        self.resetSilenceTimer()
    } catch {
        print("Failed to start audio engine: \(error)")
    }
}

private func stopRecognition() {
    audioEngine.stop()
    audioEngine.inputNode.removeTap(onBus: 0)
    recognitionTask?.cancel()
    recognitionTask = nil
    silenceTimer?.invalidate() // Invalidate the silence timer
    silenceTimer = nil
}

private func resetSilenceTimer() {
    // Invalidate any existing timer
    silenceTimer?.invalidate()
    // Schedule a new timer
    silenceTimer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { _ in
        // Silence detected for 5 seconds, stop recognition
        if self.isRecording {
            self.handleCodeQuery()
            self.lastProcessedIndex += self.recognizedText.count
            self.isRecording = false
        }
    }
}

private func handleCodeQuery() {
    self.userPrompt = self.recognizedText
    print("DING", self.self.userPrompt)
    NotificationCenter.default.post(name: .codeQueryDetected, object: nil)
}
}
