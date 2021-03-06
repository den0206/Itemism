//
//  MessageHeaderView.swift
//  Itemism
//
//  Created by 酒井ゆうき on 2020/07/12.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit

private let recentIdentifier = "RecentCell"

protocol RecentHeaderViewDelegate : class {
    func handleMatch(match : Match)
}

class RecentHeaderView : UICollectionReusableView {
    
    //MARK: - property
    
    var matches = [Match]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    weak var delegate : RecentHeaderViewDelegate?
    
    
    //MARK: - parts
    private let newMatchLabel : UILabel = {
        let label = UILabel()
        label.text = "New Matches"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .darkGray
        
        return label
    }()
    
    private lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .systemGroupedBackground
        return cv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .systemGroupedBackground
        
        addSubview(newMatchLabel)
        newMatchLabel.anchor(top : topAnchor,left: leftAnchor,paddingTop: 8,paddingLeft: 12)
        
        addSubview(collectionView)
        collectionView.anchor(top : newMatchLabel.bottomAnchor,left: leftAnchor,bottom: bottomAnchor,right: rightAnchor,paddingTop: 4,paddingLeft: 12,paddingBottom: 24,paddingRight: 12)
        
        let bottomLine = UIView()
        bottomLine.backgroundColor = .lightGray
        
        addSubview(bottomLine)
        bottomLine.anchor(top : collectionView.bottomAnchor, left : leftAnchor,right: rightAnchor,width: frame.width,height: 0.75)
        
        configureCV()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - UI
    
    private func configureCV() {
        collectionView.delegate = self
        collectionView.dataSource = self
       
        collectionView.register(RecentMatchCell.self, forCellWithReuseIdentifier: recentIdentifier)
        
    }
    
}

//MARK: - collectionview Delegate

extension RecentHeaderView : UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        
        return matches.count > 0 ? matches.count : 1
    
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: recentIdentifier, for: indexPath) as! RecentMatchCell

        
        guard (matches.count > 0) else {
            cell.profileImageView.image =  #imageLiteral(resourceName: "noMatch")

            return cell
            
        }
        
        cell.match = matches[indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard (matches.count > 0) else {return }
        
        let match = matches[indexPath.item]
        
        delegate?.handleMatch(match: match)
        
    }
    
    
    
}

extension RecentHeaderView : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 120)
    }
}
