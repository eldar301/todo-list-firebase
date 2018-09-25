//
//  ListViewController.swift
//  todo-list-firebase
//
//  Created by Eldar Goloviznin on 21/09/2018.
//  Copyright © 2018 Eldar Goloviznin. All rights reserved.
//

import UIKit

class ListViewController: UICollectionViewController {
    
    fileprivate let reuseIdentifier = "Cell"
    
    fileprivate let interitemSpacing: CGFloat = 8.0
    
    fileprivate var hotTasks: [Task] = []
    fileprivate var normalTasks: [Task] = []
    fileprivate var completedTasks: [Task] = []
    
    var presenter: ListPresenter!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.view = self
        presenter.startListening()

        let insets = UIEdgeInsets(top: 8.0, left: 8.0, bottom: 8.0, right: 8.0)
        self.collectionView.contentInset = insets
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return hotTasks.count
        } else if section == 1 {
            return normalTasks.count
        } else if section == 2 {
            return completedTasks.count
        } else {
            return 1
        }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        
        if indexPath.section < 3 {
            var task: Task
            if indexPath.section == 0 {
                task = hotTasks[indexPath.row]
                cell.backgroundColor = .red
            } else if indexPath.section == 1 {
                task = normalTasks[indexPath.row]
                cell.backgroundColor = .yellow
            } else {
                task = completedTasks[indexPath.row]
                cell.backgroundColor = .green
            }
            
            let titleLabel = cell.viewWithTag(1) as! UILabel
            titleLabel.text = task.title
        } else {
            cell.backgroundColor = .yellow
            let addLabel = cell.viewWithTag(1) as! UILabel
            addLabel.text = "+"
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            presenter.showTask(task: hotTasks[indexPath.row])
        } else if indexPath.section == 1 {
            presenter.showTask(task: normalTasks[indexPath.row])
        } else if indexPath.section == 2 {
            presenter.showTask(task: completedTasks[indexPath.row])
        } else {
            presenter.createTask()
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "reuseheader", for: indexPath)
    }

}

extension ListViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let insets = collectionView.contentInset
        let width = (self.collectionView.bounds.width - insets.left - insets.right - interitemSpacing) / 2.0
        let height: CGFloat = 120
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return interitemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return interitemSpacing
    }
    
}

extension ListViewController: ListView {
    func update(withHotTasks hotTasks: [Task], withNormalTasks normalTasks: [Task], withCompletedTasks completedTasks: [Task]) {
        self.hotTasks = hotTasks
        self.normalTasks = normalTasks
        self.completedTasks = completedTasks
        self.collectionView.reloadData()
    }
    
}
