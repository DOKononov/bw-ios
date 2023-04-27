//
//  TestVC.swift
//  BeWired
//
//  Created by Dmitry Kononov on 25.04.23.
//

import UIKit

final class TestVC: UIViewController {
    
    private let audioRecorder = AudioRecorder(audioStorage: AudioStorage())
    private let audioPlayer = AudioPlayer(audioStorage: AudioStorage())

    private let recButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "record.circle"), for: .normal)
        button.backgroundColor = .systemBackground
        button.tintColor = .systemRed
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var recInProgress = false
    
    private let playButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "play"), for: .normal)
        button.backgroundColor = .systemBackground
        button.tintColor = .systemBlue
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var playInProgress = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
        view.backgroundColor = .cyan
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupLayout()
    }

    
    private func initialize() {
        addSubviews()
        addTargets()
    }
    
    private func addSubviews() {
        view.addSubview(recButton)
        view.addSubview(playButton)
    }
    
    private func setupLayout() {
        
        NSLayoutConstraint.activate([
            recButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            recButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -50),
            recButton.heightAnchor.constraint(equalToConstant: 80),
            recButton.widthAnchor.constraint(equalToConstant: 80),
            
            playButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            playButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 50),
            playButton.heightAnchor.constraint(equalToConstant: 80),
            playButton.widthAnchor.constraint(equalToConstant: 80)
        
        ])
        
    }
    
    private func addTargets() {
        recButton.addTarget(self, action: #selector(recDidTapped), for: .touchUpInside)
        playButton.addTarget(self, action: #selector(playDidTapped), for: .touchUpInside)
    }
    
    @objc private func recDidTapped() {
        recInProgress ? audioRecorder.stopRecording() : audioRecorder.startRecording()
        recInProgress = !recInProgress
    }
    
    @objc private func playDidTapped() {
        playInProgress ? audioPlayer.stopAudio() : audioPlayer.playAudio()
        playInProgress = !playInProgress
    }
    
}

