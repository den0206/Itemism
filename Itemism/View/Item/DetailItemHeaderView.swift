//
//  DetailItemHeaderView.swift
//  Itemism
//
//  Created by 酒井ゆうき on 2020/07/18.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit
import SKPhotoBrowser

private let DetailIdentifier = "DetailImage"

protocol DetailItemHeaderViewDelegate : class {
    func presentPhotoBrowser(_ view : DetailItemHeaderView, browser : SKPhotoBrowser)
}

class DetailItemHeaderView : UICollectionReusableView {
    
    
    weak var delegate : DetailItemHeaderViewDelegate?
    
    var imageUrls = [String]()
    
    //MARK: - Parts
    private let imageLabel : UILabel = {
        let label = UILabel()
        label.text = "Images"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .darkGray
        
        return label
    }()
    
    private lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        return cv
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear

        
        addSubview(collectionView)
        collectionView.fillSuperview()
        
        let bottomLine = UIView()
        bottomLine.backgroundColor = .lightGray
        
        addSubview(bottomLine)
        bottomLine.anchor(top : collectionView.bottomAnchor, left : leftAnchor,right: rightAnchor,width: frame.width,height: 0.75)
        
        configureCV()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureCV() {
        collectionView.delegate = self
        collectionView.dataSource = self
       
        collectionView.register(DetailItemCell.self, forCellWithReuseIdentifier: DetailIdentifier)
        
    }
}

extension DetailItemHeaderView : UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageUrls.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailIdentifier, for: indexPath) as! DetailItemCell
        
        cell.imageUrlString = imageUrls[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        var images = [SKPhoto]()
        
        imageUrls.forEach { (url) in
            let image = SKPhoto.photoWithImageURL(url)
            images.append(image)
        }
        
        let browser = SKPhotoBrowser(photos: images)
        browser.initPageIndex = 0
        
        delegate?.presentPhotoBrowser(self, browser: browser)
        
        
    }
    
    
    
}

extension DetailItemHeaderView : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.height - 10, height: frame.height - 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    }
    
    
}

