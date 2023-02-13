//
//  ImageViewController.swift
//  HedgehogTestApp
//
//  Created by murphy on 12.02.2023.
//

import UIKit

class ImageViewController: UIViewController, UIScrollViewDelegate {
    
// MARK: - IBOutlet
    @IBOutlet weak var counterLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    
// MARK: - Private properties
    private var _selectedIndex: Int = 0
    
// MARK: - Public properties
    var images: Images = []
    var selectedIndex: Int {
        get {
            return _selectedIndex
        }
        set(newValue) {
            if newValue < 0 {
                _selectedIndex = images.count-1
            } else if newValue > images.count-1 {
                _selectedIndex = 0
            } else {
                _selectedIndex = newValue
            }
            if self.isBeingPresented {
                loadImage(selectedIndex: selectedIndex)
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        loadImage(selectedIndex: selectedIndex)
    }
    
// MARK: - IBActions
    @IBAction func closeViewController(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    @IBAction func openWebSource(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        guard let vc = storyboard.instantiateViewController(withIdentifier: "WebViewController") as? WebViewController else { return }
        vc.link = images[selectedIndex].source
        self.present(vc, animated: true)
    }
    @IBAction func leftSwipe(_ sender: Any) {
        selectedIndex += 1
        loadImage(selectedIndex: selectedIndex)
    }
    @IBAction func rightSwap(_ sender: Any) {
        selectedIndex -= 1
        loadImage(selectedIndex: selectedIndex)
    }
    
    func loadImage(selectedIndex: Int) {
        let image: UIImage
        if let orginal = images[selectedIndex].original {
            image = orginal
        } else if let thumbnail = images[selectedIndex].thumbnail {
            image = thumbnail
            NetworkDataFetcher.shared.download(from: images[selectedIndex].originalSource) {[weak self] result in
                switch result {
                case .success(let original):
                    DispatchQueue.main.async {
                        self?.images[selectedIndex].original = original
                        self?.loadImage(selectedIndex: selectedIndex)
                    }
                case .failure(let failure):
                    print(failure)
                }
            }
        } else {
            return
        }
        imageView.image = image
        counterLabel.text = "\(selectedIndex + 1) / \(images.count)"
        self.imageView.layoutIfNeeded()
    }
}
