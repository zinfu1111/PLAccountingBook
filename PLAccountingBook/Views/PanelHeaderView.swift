//
//  PanelHeaderView.swift
//  PLAccountingBook
//
//  Created by User on 2022/1/16.
//

import UIKit

protocol PanelHeaderViewDelegate {
    func selected(index: Int)
}

class PanelHeaderView: UIView,UICollectionViewDataSource, UICollectionViewDelegate {
    
    

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var targetView: UIView!
    @IBOutlet weak var targetViewX: NSLayoutConstraint!
    @IBOutlet weak var selectedViewW: NSLayoutConstraint!
    
    let data:[String]
    var delegate: PanelHeaderViewDelegate?
    private var currentIndex = 0
    
    init(frame: CGRect,data:[String]) {
        self.data = data
        super.init(frame: frame)
        loadXib(nibName: "\(PanelHeaderView.self)", for: type(of: self))
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        self.data = []
        super.init(coder: aDecoder)
        loadXib(nibName: "\(PanelHeaderView.self)", for: type(of: self))
        self.isHidden = true
        print(self,"data failed.")
    }
    
    func setupUI() {
        let width = self.bounds.width/CGFloat(data.count)
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width, height: collectionView.bounds.height)
        self.collectionView.collectionViewLayout = layout
        self.collectionView.register(UINib(nibName: "\(PanelHeaderCell.self)", bundle: nil), forCellWithReuseIdentifier: "\(PanelHeaderCell.self)")
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.selectedViewW.constant = width
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(PanelHeaderCell.self)", for: indexPath) as! PanelHeaderCell
        cell.titleLabel.textColor = currentIndex == indexPath.row ? .systemTeal : .lightGray
        cell.titleLabel.text = data[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.row != currentIndex else {
            return
        }
        currentIndex = indexPath.row
        collectionView.reloadData()
        updateTargetView()
        delegate?.selected(index: currentIndex)
    }
    
    private func updateTargetView(){
        
        if currentIndex != 0 {
            UIView.animate(withDuration: 1) {
                self.targetViewX.constant = self.selectedViewW.constant * CGFloat(self.currentIndex)
                self.layoutIfNeeded()
            }
        }else{
            UIView.animate(withDuration: 1) {
                self.targetViewX.constant = 0
                self.layoutIfNeeded()
            }
        }
    }
    
}
