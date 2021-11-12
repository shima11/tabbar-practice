//
//  ViewController.swift
//  tabbar-practice
//
//  Created by Jinsei Shima on 2021/11/11.
//

import UIKit

class CustomTabBarController: UITabBarController {

  static let showCustomTabBar: Notification.Name = .init(rawValue: "CustomTabBar.show")
  static let hideCustomTabBar: Notification.Name = .init(rawValue: "CustomTabBar.hide")

  static let customBarHeight: CGFloat = 44

  private var isBarViewShowing = false

  private let customBar: UIView = .init()

  override func viewDidLoad() {
    super.viewDidLoad()

    customBar.backgroundColor = .lightGray

    tabBar.backgroundColor = .white

    NotificationCenter.default.addObserver(forName: Self.showCustomTabBar, object: nil, queue: .main) { [weak self] notification in
      self?.showBar()
    }

    NotificationCenter.default.addObserver(forName: Self.hideCustomTabBar, object: nil, queue: .main) { [weak self] notification in
      self?.hideBar()
    }

  }

  public func showBar() {

    object_setClass(tabBar, CustomTabBar.self)

    // TODO: Animation

    tabBar.addSubview(customBar)

    customBar.translatesAutoresizingMaskIntoConstraints = false

    customBar.removeConstraints(customBar.constraints)

    NSLayoutConstraint.activate([
      customBar.heightAnchor.constraint(equalToConstant: Self.customBarHeight),
      customBar.leftAnchor.constraint(equalTo: tabBar.leftAnchor),
      customBar.rightAnchor.constraint(equalTo: tabBar.rightAnchor),
      customBar.topAnchor.constraint(equalTo: tabBar.topAnchor),
    ])

//    additionalSafeAreaInsets = .init(top: 0, left: 0, bottom: Self.customBarHeight, right: 0)

    for item in (tabBar.items)! {
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

    // TODO: Animation
    customBar.removeConstraints(customBar.constraints)

//    customBar.removeFromSuperview()

    object_setClass(tabBar, UITabBar.self)

//    additionalSafeAreaInsets = .init(top: 0, left: 0, bottom: 0, right: 0)

    for item in (tabBar.items)! {
      item.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    isBarViewShowing = false
  }

  class CustomTabBar: UITabBar {
    override func sizeThatFits(_ size: CGSize) -> CGSize {
//      super.sizeThatFits(size)
      var sizeThatFits = super.sizeThatFits(size)
      sizeThatFits.height = sizeThatFits.height + CustomTabBarController.customBarHeight
      return sizeThatFits
    }
  }

  private func currentViewLayoutSubviews() {
    viewControllers?[selectedIndex].view.setNeedsLayout()
    viewControllers?[selectedIndex].view.layoutSubviews()
  }
}


class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
  }

  @IBAction func didTapShowButton(_ sender: Any) {
    NotificationCenter.default.post(name: CustomTabBarController.showCustomTabBar, object: nil)
  }

  @IBAction func didTapHideButton(_ sender: Any) {
    NotificationCenter.default.post(name: CustomTabBarController.hideCustomTabBar, object: nil)
  }

}
