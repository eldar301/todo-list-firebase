//
//  ListViewController.swift
//  todo-list-firebase
//
//  Created by Eldar Goloviznin on 21/09/2018.
//  Copyright © 2018 Eldar Goloviznin. All rights reserved.
//

import UIKit

fileprivate struct Constants {
    struct Strings {
        static let hotTasks = NSLocalizedString("Hot tasks", comment: #file)
        static let normalTasks = NSLocalizedString("Normal tasks", comment: #file)
    }
    struct CollectionView {
        static let reuseIdentifier = "Cell"
        static let reuseHeaderIdentifier = "reuseheader"
        static let contentInsets = UIEdgeInsets(top: 8.0, left: 8.0, bottom: 8.0, right: 8.0)
        static let interitemSpacing: CGFloat = 8.0
    }
    struct Cell {
        static let height: CGFloat = 120.0
        struct HotTask {
            static let backgroundColor = UIColor.red
        }
        struct NormalTask {
            static let backgroundColor = UIColor(red: 0.0, green: 0.5, blue: 0.0, alpha: 1.0)
        }
        struct CreateNew {
            static let backgroundColor = UIColor.blue
        }
    }
    struct SectionHeader {
        static let taskColor = UIColor(red: 0.25, green: 0.5, blue: 0.75, alpha: 1.0)
        static let taskHeight: CGFloat = 60.0
        static let createNewHeight = Constants.CollectionView.interitemSpacing
    }
}

class ListViewController: UICollectionViewController {
    
    private var hotTasks: [Task] = []
    private var normalTasks: [Task] = []
    
    var presenter: ListPresenter!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.view = self
        presenter.startListening()

        self.collectionView.contentInset = Constants.CollectionView.contentInsets
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return hotTasks.count
        } else if section == 1 {
            return normalTasks.count
        } else {
            return 1
        }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.CollectionView.reuseIdentifier, for: indexPath)
        
        if indexPath.section < 2 {
            var task: Task
            if indexPath.section == 0 {
                task = hotTasks[indexPath.row]
                cell.backgroundColor = Constants.Cell.HotTask.backgroundColor
            } else {
                task = normalTasks[indexPath.row]
                cell.backgroundColor = Constants.Cell.NormalTask.backgroundColor
            }
            
            let titleLabel = cell.viewWithTag(1) as! UILabel
            titleLabel.text = task.title
        } else {
            let addLabel = cell.viewWithTag(1) as! UILabel
            addLabel.text = "+"
            cell.backgroundColor = Constants.Cell.CreateNew.backgroundColor
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            presenter.showTask(task: hotTasks[indexPath.row])
        } else if indexPath.section == 1 {
            presenter.showTask(task: normalTasks[indexPath.row])
        } else {
            presenter.createTask()
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: Constants.CollectionView.reuseHeaderIdentifier, for: indexPath)
        
        let label = header.subviews.first(where: { $0 is UILabel }) as! UILabel
        
        header.backgroundColor = Constants.SectionHeader.taskColor
        if indexPath.section == 0 {
            label.text = Constants.Strings.hotTasks
        } else if indexPath.section == 1 {
            label.text = Constants.Strings.normalTasks
        } else {
            header.backgroundColor = self.collectionView.backgroundColor
            label.text = nil
        }
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let size = CGSize(width: self.view.bounds.width, height: Constants.SectionHeader.taskHeight)
        if section == 0 {
            return hotTasks.isEmpty ? .zero : size
        } else if section == 1 {
            return normalTasks.isEmpty ? .zero : size
        } else {
            return CGSize(width: self.view.bounds.width, height: Constants.SectionHeader.createNewHeight)
        }
    }

}

extension ListViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let insets = collectionView.contentInset
        let width = (self.collectionView.bounds.width - insets.left - insets.right - Constants.CollectionView.interitemSpacing) / 2.0
        let height = Constants.Cell.height
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.CollectionView.interitemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.CollectionView.interitemSpacing
    }
    
}

extension ListViewController: ListView {
    func update(withHotTasks hotTasks: [Task], withNormalTasks normalTasks: [Task]) {
        self.hotTasks = hotTasks
        self.normalTasks = normalTasks
        self.collectionView.reloadData()
    }
    
}
