//
//  PinnedFlowLayout.swift
//  adk_test
//
//  Created by John Tumminaro on 3/4/16.
//  Copyright © 2016 John Tumminaro. All rights reserved.
//

import UIKit
import AsyncDisplayKit

protocol PinnedFlowLayoutProvider: class {
    var offsetYToPinHeader: CGFloat { get }
    var headerSize: CGSize { get }
}

class PinnedFlowLayout: UICollectionViewFlowLayout, ASCollectionViewLayoutInspecting {
    
    weak var provider: PinnedFlowLayoutProvider?
    
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return true
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let result = super.layoutAttributesForElementsInRect(rect)
        let contentOffset = self.collectionView?.contentOffset ?? CGPointZero
        guard let provider = provider where contentOffset.y >= provider.offsetYToPinHeader else { return result }
        var filteredResult = result?.filter({ (attr) -> Bool in
            return attr.representedElementKind != UICollectionElementKindSectionHeader
        })
        
        let newHeaderAttributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withIndexPath: NSIndexPath(forItem: 0, inSection: 0))
        let frame = CGRectMake(0, contentOffset.y - provider.offsetYToPinHeader, provider.headerSize.width, provider.headerSize.height)
        newHeaderAttributes.frame = frame
        newHeaderAttributes.zIndex = 1024
        filteredResult?.append(newHeaderAttributes)
        return filteredResult
    }
    
    // MARK: - ASCollectionViewLayoutInspecting
    
    func collectionView(collectionView: ASCollectionView!, constrainedSizeForNodeAtIndexPath indexPath: NSIndexPath!) -> ASSizeRange {
        return ASSizeRangeMake(CGSizeMake(collectionView.bounds.width, 1), CGSizeMake(collectionView.bounds.width, 10000))
    }
    
    func collectionView(collectionView: ASCollectionView!, constrainedSizeForSupplementaryNodeOfKind kind: String!, atIndexPath indexPath: NSIndexPath!) -> ASSizeRange {
        return ASSizeRangeMake(CGSizeMake(collectionView.bounds.width, 0), CGSizeMake(collectionView.bounds.width, 500))
    }
    
    func collectionView(collectionView: ASCollectionView!, numberOfSectionsForSupplementaryNodeOfKind kind: String!) -> UInt {
        if kind == UICollectionElementKindSectionHeader { return 1 }
        return 0
    }
    
    func collectionView(collectionView: ASCollectionView!, supplementaryNodesOfKind kind: String!, inSection section: UInt) -> UInt {
        if kind == UICollectionElementKindSectionHeader { return 1 }
        return 0
    }
    
    func didChangeCollectionViewDelegate(delegate: ASCollectionDelegate!) {
        
    }
}
