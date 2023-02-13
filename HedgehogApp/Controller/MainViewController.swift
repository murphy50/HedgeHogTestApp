//
//  MainViewController.swift
//  HedgehogTestApp
//
//  Created by murphy on 07.02.2023.
//

import UIKit

class MainViewController: UIViewController {
    
// MARK: - IBoutlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet var searchBar: UISearchBar!
    
    @IBOutlet weak var gradientView: UIView!
    
// MARK: - Private properties
    private var images: Images = []
    private let itemsPerRow: CGFloat = 2
    private let sectionInserts = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
    
    
// MARK: - ViewDidload
    override func viewDidLoad() {
        super.viewDidLoad()
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor(named: "Bubblegum")!.cgColor, UIColor(named: "Ice")!.cgColor]
        gradientLayer.frame = gradientView.bounds
        gradientView.layer.addSublayer(gradientLayer)
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.collectionViewLayout = UICollectionViewFlowLayout()
        self.searchBar.delegate = self
        self.collectionView.keyboardDismissMode = .onDrag
        navigationItem.titleView = searchBar
    }
   
    
// MARK: - IBActions
    @IBAction func tapToHideKeyboard(_ sender: UITapGestureRecognizer) {
        searchBar.resignFirstResponder()
    }
}

// MARK: - UICollectionViewDelegate
extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.item
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "ImageViewController") as? ImageViewController else { return }
        vc.images = images
        vc.selectedIndex = index
        navigationController?.present(vc, animated: true)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let image = images[indexPath.item]
        let paddingSpace = sectionInserts.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        let heightPerItem = CGFloat(image.height) * widthPerItem / CGFloat(image.width)
        return CGSize(width: widthPerItem, height: heightPerItem)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInserts
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInserts.left
    }
    
}

// MARK: - UICollectionViewDataSource
extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCollectionViewCell.identifier, for: indexPath) as? CustomCollectionViewCell else { return UICollectionViewCell() }
        guard let image = images[indexPath.item].original ?? images[indexPath.item].thumbnail else { return cell }
        cell.setup(with: image)
        return cell
    }
}

// MARK: - UISearchBarDelegate
extension MainViewController: UISearchBarDelegate {
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, text.count > 0 else {
            return
        }
        NetworkDataFetcher.shared.fetchImages(searchTerm: text) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success):
                self.images = success
                self.collectionView.reloadData()
            case .failure(let failure):
                print(failure)
            }
        }
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
}
