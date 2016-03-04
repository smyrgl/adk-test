//
//  ADKCollectionViewController.swift
//  adk_test
//
//  Created by John Tumminaro on 3/4/16.
//  Copyright © 2016 John Tumminaro. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class ADKCollectionViewController: ASViewController, PinnedFlowLayoutProvider, ASCollectionDataSource, ASCollectionDelegate {
    
    var offsetYToPinHeader: CGFloat { return headerNode.calculatedSize.height - topLayoutGuide.length - (navigationController?.navigationBar.bounds.height ?? 0) }
    var headerSize: CGSize { return headerNode.calculatedSize }
    let collectionNode: ASCollectionNode
    
    lazy var headerNode: ASCellNode = {
        let cellNode = ASCellNode()
        cellNode.preferredFrameSize = CGSizeMake(self.view.bounds.width, 200)
        cellNode.backgroundColor = UIColor.redColor()
        return cellNode
    }()
    
    init () {
        let layout = PinnedFlowLayout()
        let node = ASCollectionNode(collectionViewLayout: layout)
        self.collectionNode = node
        super.init(node: node)
        layout.provider = self
        node.view.layoutInspector = layout
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionNode.backgroundColor = UIColor.whiteColor()
        collectionNode.view.registerSupplementaryNodeOfKind(UICollectionElementKindSectionHeader)
        collectionNode.view.asyncDataSource = self
        collectionNode.view.asyncDelegate = self
        // Uncomment reloadData and it will not crash.
        //collectionNode.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - ASCollectionDataSource
    
    func collectionView(collectionView: ASCollectionView, constrainedSizeForNodeAtIndexPath indexPath: NSIndexPath) -> ASSizeRange {
        return ASSizeRangeMake(CGSizeMake(view.bounds.width, 1), CGSizeMake(view.bounds.width, 10000))
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
    }
    
    func collectionView(collectionView: ASCollectionView, nodeForItemAtIndexPath indexPath: NSIndexPath) -> ASCellNode {
        let cell = ASTextCellNode()
        cell.text = "Test Item \(indexPath.row)"
        return cell
    }
    
    func collectionView(collectionView: ASCollectionView, nodeForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> ASCellNode {
        return headerNode
    }
    
    func collectionView(collectionView: ASCollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        headerNode.measureWithSizeRange(ASSizeRangeMake(CGSizeMake(collectionView.bounds.width, 150), CGSizeMake(collectionView.bounds.width, 500)))
        return headerNode.calculatedSize
    }

}
