//
//  ViewController.swift
//  HeaderAnimation
//
//  Created by Dylan Park on 2021-05-20.
//

import UIKit

class ViewController: UIViewController {

	@IBOutlet private var navBarHeightConstraint: NSLayoutConstraint!
	private var navBarStatus = false
	private var imageStackView: UIStackView!
	@IBOutlet private var navBarView: UIView!
	@IBOutlet var addButton: UIButton!
	@IBOutlet var tableView: UITableView!
	private var selectedItems = [String]()
	private let items = ["Oreos", "Pizza Pockets", "Pop Tarts", "Popsicle", "Ramen"]
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// create 5 imageviews
		let imageView1 = UIImageView(image: UIImage(named: "oreos"))
		let imageView2 = UIImageView(image: UIImage(named: "pizza_pockets"))
		let imageView3 = UIImageView(image: UIImage(named: "pop_tarts"))
		let imageView4 = UIImageView(image: UIImage(named: "popsicle"))
		let imageView5 = UIImageView(image: UIImage(named: "ramen"))
		let imageViews = [imageView1, imageView2, imageView3, imageView4, imageView5]
		
		// create a stackView and configure it
		imageStackView = UIStackView(frame: CGRect(x: 0, y: 88, width: view.frame.width, height: 100))
		imageStackView.axis = .horizontal
		imageStackView.distribution = .fillEqually
		
		// add 5 imageviews to the stackView
		for i in 0..<imageViews.count {
			imageViews[i].isUserInteractionEnabled = true
			
			// gesture recognizer for the StackView
			let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(addItem(_:)))
			imageViews[i].addGestureRecognizer(tapGestureRecognizer)
			imageViews[i].tag = i
			imageStackView.addArrangedSubview(imageViews[i])
		}
		imageStackView.isHidden = true
		imageStackView.translatesAutoresizingMaskIntoConstraints = false
		navBarView.addSubview(imageStackView)
		
		// set constraints for StackView
		imageStackView.bottomAnchor.constraint(equalTo: navBarView.bottomAnchor).isActive = true
		imageStackView.leftAnchor.constraint(equalTo: navBarView.leftAnchor).isActive = true
		imageStackView.widthAnchor.constraint(equalTo: navBarView.widthAnchor).isActive = true
		imageStackView.heightAnchor.constraint(equalToConstant: 100).isActive = true

		// tableView
		tableView.dataSource = self
		tableView.delegate = self
	}
	
	@objc private func addItem(_ sender: UITapGestureRecognizer) {
		if navBarStatus {
			if let i = sender.view?.tag {
				selectedItems.append(items[i])
				let indexPath = IndexPath(row: selectedItems.count - 1, section: 0)
				tableView.insertRows(at: [indexPath], with: .automatic)
			}
		}
	}

	@IBAction func addButtonTapped(_ sender: UIButton) {
		if !navBarStatus {
			UIView.animate(withDuration: 1.5, delay: 0.0, usingSpringWithDamping: 0.1, initialSpringVelocity: 2, options: .curveEaseInOut, animations: {
				self.imageStackView.isHidden = false
				self.navBarHeightConstraint.constant = 200
				self.addButton.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
				self.view.layoutIfNeeded()
			}, completion: nil)
			
		} else {
			UIView.animate(withDuration: 1.5, delay: 0.0, usingSpringWithDamping: 0.2, initialSpringVelocity: 2, options: .curveEaseInOut, animations: {
				self.imageStackView.isHidden = true
				self.navBarHeightConstraint.constant = 88
				self.addButton.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
				self.view.layoutIfNeeded()
			}, completion: nil)
			
		}
		navBarStatus = !navBarStatus
	}
	
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {

	func numberOfSections(in tableView: UITableView) -> Int {
    
		return 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
		return selectedItems.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
		cell.textLabel?.text = selectedItems[indexPath.row]
		
		return cell
	}
}

