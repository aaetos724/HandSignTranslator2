
Hand Sign Translator This is an iOS application built with SwiftUI that serves as a real-time translator between text and American Sign Language (ASL) finger signs. It demonstrates the integration of Apple's advanced frameworks for media capture, computer vision, and machine learning inference.

✨ Key Features
Real-Time Sign Detection: Utilizes the AVFoundation and Vision frameworks to capture video from the front camera and detect the position of a single hand in real time.

Core ML Classification: The captured hand pose data (21 key points) is processed and fed into a custom Core ML model (HandPoseClassifier_2) to classify the hand gesture into a specific letter or number sign.

Text-to-Sign Translation: Features a dedicated view where users can input text, and the application translates it into a sequential, animated display of corresponding sign language images.

Modern SwiftUI Architecture: Built with a clear separation of concerns, utilizing ObservableObject models (CameraManager, SignLanguageTranslator) for reactive state management.

🛠️ Technologies Used
SwiftUI: Declarative UI framework.

AVFoundation: Camera session management.

Vision Framework: Used specifically for the VNDetectHumanHandPoseRequest to extract 21 hand joints.

Core ML: Executes the trained custom model (HandPoseClassifier_2) for sign classification.

Combine: Used for asynchronous updates and managing the sequential animation timing.
