//
//  ViewController.swift
//  tabbar-practice
//
//  Created by Jinsei Shima on 2021/11/11.
//

import UIKit

class ViewController1: UIViewController {

  @IBOutlet weak var safeAreaLabel: UILabel!

  override func viewDidLoad() {
    super.viewDidLoad()

    safeAreaLabel.numberOfLines = 0

    view.backgroundColor = .systemGray4
  }

  override func viewSafeAreaInsetsDidChange() {
    super.viewSafeAreaInsetsDidChange()

    print("### safe area1:", view.safeAreaInsets)

    safeAreaLabel.text = "safeAreaInsets:\n \(view.safeAreaInsets)"
  }

  @IBAction func didTapShowButton(_ sender: Any) {
    NotificationCenter.default.post(name: TabBarNotification.showCustomTabBar, object: nil)
  }

  @IBAction func didTapHideButton(_ sender: Any) {
    NotificationCenter.default.post(name: TabBarNotification.hideCustomTabBar, object: nil)
  }

}

class ViewController2: UIViewController {

  let scrollView = UIScrollView()

  override func viewDidLoad() {
    super.viewDidLoad()

    view.addSubview(scrollView)

    scrollView.backgroundColor = .systemGray4
    scrollView.alwaysBounceVertical = true
    scrollView.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate([
      scrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
      scrollView.rightAnchor.constraint(equalTo: view.rightAnchor),
      scrollView.topAnchor.constraint(equalTo: view.topAnchor),
      scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
    ])

    let box = UIView(frame: .init(x: 100, y: 50, width: 200, height: 800))

    box.backgroundColor = .systemGray6
    scrollView.addSubview(box)

    scrollView.contentSize = .init(width: view.bounds.width, height: box.frame.maxY)
  }

  override func viewSafeAreaInsetsDidChange() {
    super.viewSafeAreaInsetsDidChange()

    print("### safe area2:", additionalSafeAreaInsets, view.safeAreaInsets)
  }
}
