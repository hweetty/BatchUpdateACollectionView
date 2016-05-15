//
//  MyCellView.swift
//  BatchUpdateACollectionView
//
//  Created by Jerry Yu on 2016-05-08.
//  Copyright © 2016 Jerry Yu. All rights reserved.
//

import UIKit

class MyCellView: UICollectionViewCell {

	lazy var label: UILabel = {
		let label = UILabel(frame: self.bounds)
		label.font = UIFont.systemFontOfSize(35)
		label.shadowColor = .grayColor()
		label.shadowOffset = CGSizeMake(2, 2)
		label.textAlignment = .Center
		label.textColor = .whiteColor()
		self.addSubview(label)
		return label
	}()

	var index: Int! {
		didSet {
			label.text = "\(index)"

			let idx = index % Colours.count
			self.backgroundColor = Colours[idx]

			self.layer.cornerRadius = self.bounds.height / 2
		}
	}

}

private let Colours: [UIColor] = [
	UIColor.greenColor(),
	UIColor.blueColor(),
	UIColor.yellowColor(),
	UIColor.redColor(),
	UIColor.purpleColor(),
	UIColor.brownColor(),
	UIColor.magentaColor(),
	UIColor.cyanColor(),
	UIColor.orangeColor(),
]
