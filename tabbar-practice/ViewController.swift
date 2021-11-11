//
//  ViewController.swift
//  tabbar-practice
//
//  Created by Jinsei Shima on 2021/11/11.
//

import UIKit

class CustomTabBarController: UITabBarController {

  static let customBarHeight: CGFloat = 40

  private var isBarViewShowing = false

  private let customBar: UIView = .init()

  override func viewDidLoad() {
    super.viewDidLoad()

    customBar.backgroundColor = .lightGray

    showBar()

    tabBar.backgroundColor = .white
  }

  public func showBar() {

    object_setClass(tabBar, CustomTabBar.self)

    tabBar.addSubview(customBar)

    customBar.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate([
      customBar.heightAnchor.constraint(equalToConstant: Self.customBarHeight),
      customBar.leftAnchor.constraint(equalTo: tabBar.leftAnchor),
      customBar.rightAnchor.constraint(equalTo: tabBar.rightAnchor),
      customBar.topAnchor.constraint(equalTo: tabBar.topAnchor),
    ])

    for item in (self.tabBar.items)! {
      item.imageInsets = UIEdgeInsets(
        top: Self.customBarHeight/2,
        left: 0,
        bottom: -Self.customBarHeight/2,
        right: 0
      )
    }

    isBarViewShowing = true
  }

  public func hideBar() {

    customBar.removeFromSuperview()

    object_setClass(tabBar, UITabBar.self)

    for item in (self.tabBar.items)! {
      item.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    isBarViewShowing = false
  }

  class CustomTabBar: UITabBar {
    override func sizeThatFits(_ size: CGSize) -> CGSize {
      super.sizeThatFits(size)
      var sizeThatFits = super.sizeThatFits(size)
      sizeThatFits.height = sizeThatFits.height + CustomTabBarController.customBarHeight
      return sizeThatFits
    }
  }
}


class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
  }

}
