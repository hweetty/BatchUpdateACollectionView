//
//  ViewController.swift
//  BatchUpdateACollectionView
//
//  Created by Jerry Yu on 2016-05-08.
//  Copyright © 2016 Jerry Yu. All rights reserved.
//

import UIKit

private let Cell_Id = "Cell_Id"

class ViewController: UIViewController {

	let collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: UICollectionViewFlowLayout())

	var items = [0, 1, 2, 3, 4, 5, 6, 7]

	override func viewDidLoad() {
		super.viewDidLoad()
		self.title = "BatchUpdate a CollectionView"

		collectionView.backgroundColor = .whiteColor()
		collectionView.registerClass(MyCellView.self, forCellWithReuseIdentifier: Cell_Id)
		collectionView.delegate = self
		collectionView.dataSource = self
		self.view.addSubview(collectionView)

		let flowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
		flowLayout.sectionInset = UIEdgeInsetsMake(20, 30, 30, 44)

		collectionView.translatesAutoresizingMaskIntoConstraints = false
		collectionView.topAnchor.constraintEqualToAnchor(self.view.topAnchor).active = true
		collectionView.bottomAnchor.constraintEqualToAnchor(self.view.bottomAnchor).active = true
		collectionView.leftAnchor.constraintEqualToAnchor(self.view.leftAnchor).active = true
		collectionView.rightAnchor.constraintEqualToAnchor(self.view.rightAnchor).active = true

		collectionView.reloadData()

		let toolbar = UIToolbar()
		toolbar.items = [
			UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil),
			UIBarButtonItem(title: "Regenerate", style: .Plain, target: self, action: #selector(regenerate)),
			UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil),
			UIBarButtonItem(title: "Shuffle", style: .Plain, target: self, action: #selector(shufflePressed)),
			UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil),
			UIBarButtonItem(title: "Reset", style: .Plain, target: self, action: #selector(resetPressed)),
			UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil),
		]
		self.view.addSubview(toolbar)

		toolbar.translatesAutoresizingMaskIntoConstraints = false
		toolbar.bottomAnchor.constraintEqualToAnchor(self.view.bottomAnchor).active = true
		toolbar.leftAnchor.constraintEqualToAnchor(self.view.leftAnchor).active = true
		toolbar.rightAnchor.constraintEqualToAnchor(self.view.rightAnchor).active = true
	}

	func shufflePressed() {
		var newItems = items

		for _ in 0..<newItems.count {
			let randIndex = Int(arc4random()) % newItems.count
			let item = newItems[randIndex]

			newItems.removeAtIndex(randIndex)
			newItems.append(item)
		}

		setCollectionViewItems(newItems)
	}

	func resetPressed() {
		setCollectionViewItems([0, 1, 2, 3, 4, 5, 6, 7])
	}

	// Generate 8 random numbers from 0 - 14
	// Demonstrates the delete, move, and insert
	func regenerate() {
		var newItems = [Int]()

		while newItems.count < 8 {
			let randItem = Int(arc4random()) % 15
			if (newItems.indexOf(randItem) != nil) { continue }
			newItems.append(randItem)
		}

		setCollectionViewItems(newItems.sort())
	}
}

// MARK: Batch Update
extension ViewController {

	func setCollectionViewItems(newItems: [Int]) {
		print("New order should be: \(newItems)")

		// Delete old items
		collectionView.performBatchUpdates({

			// Perform this in reverse to maintain correct indices
			for (i, item) in self.items.enumerate().reverse() {
				guard newItems.indexOf(item) == nil else { continue }

				self.items.removeAtIndex(i)
				self.collectionView.deleteItemsAtIndexPaths([ NSIndexPath(forItem: i, inSection: 0) ])
			}

		}, completion: nil)

		// Move existing items to correct order
		collectionView.performBatchUpdates({

			var index = 0
			for item in newItems {
				guard let fromIndex = self.items.indexOf(item) else { continue }

				self.collectionView.moveItemAtIndexPath(NSIndexPath(forItem: fromIndex, inSection: 0), toIndexPath: NSIndexPath(forItem: index, inSection: 0))
				index += 1
			}

		}, completion: nil)

		// Insert new items
		collectionView.performBatchUpdates({

			let newIndexPaths = newItems.enumerate().filter({ (index, item) -> Bool in
				return !self.items.contains(item)
			}).map({ (index, item) -> NSIndexPath in
				return NSIndexPath(forItem: index, inSection: 0)
			})

			self.items = newItems
			self.collectionView.insertItemsAtIndexPaths(newIndexPaths)

		}, completion: nil)
	}

}

// MARK: UICollectionViewDataSource

extension ViewController: UICollectionViewDataSource {

	func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return items.count
	}

	func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier(Cell_Id, forIndexPath: indexPath) as! MyCellView

		cell.index = items[indexPath.row]

		return cell
	}
}

// MARK: UICollectionViewDelegate

extension ViewController: UICollectionViewDelegate {

	func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
		return CGSizeMake(105, 105)
	}

}
