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

    customBar.backgroundColor = .systemGray

    tabBar.backgroundColor = .white

    NotificationCenter.default.addObserver(forName: Self.showCustomTabBar, object: nil, queue: .main) { [weak self] notification in
      self?.showBar()
    }

    NotificationCenter.default.addObserver(forName: Self.hideCustomTabBar, object: nil, queue: .main) { [weak self] notification in
      self?.hideBar()
    }

  }

  public func showBar() {

    guard customBar.isDescendant(of: tabBar) == false else { return }

    object_setClass(tabBar, CustomTabBar.self)

    // TODO: Animation

    tabBar.addSubview(customBar)

    customBar.frame = .init(x: 0, y: -Self.customBarHeight, width: tabBar.bounds.width, height: Self.customBarHeight)

    // TODO: AutolayoutだとremoveFromSuperviewするときにfatalerrorになる
//    customBar.translatesAutoresizingMaskIntoConstraints = false
//
//    customBar.removeConstraints(customBar.constraints)
//
//    NSLayoutConstraint.activate([
//      customBar.heightAnchor.constraint(equalToConstant: Self.customBarHeight),
//      customBar.leftAnchor.constraint(equalTo: tabBar.leftAnchor),
//      customBar.rightAnchor.constraint(equalTo: tabBar.rightAnchor),
//      customBar.topAnchor.constraint(equalTo: tabBar.topAnchor),
//    ])

    // TODO: bottomに入れるとTabBarItemに対してもSafeAreaが効いてしまう
    additionalSafeAreaInsets = .init(top: 0, left: 0, bottom: 0.1, right: 0)

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

    guard customBar.isDescendant(of: tabBar) == true else { return }

    // TODO: Animation

    customBar.removeFromSuperview()

    object_setClass(tabBar, UITabBar.self)

    additionalSafeAreaInsets = .init(top: 0, left: 0, bottom: 0, right: 0)

    for item in (tabBar.items)! {
      item.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    isBarViewShowing = false
  }

  class CustomTabBar: UITabBar {
    override func sizeThatFits(_ size: CGSize) -> CGSize {
      var sizeThatFits = super.sizeThatFits(size)
      sizeThatFits.height = sizeThatFits.height + CustomTabBarController.customBarHeight
      return sizeThatFits
    }
  }

//  private func currentViewLayoutSubviews() {
//    viewControllers?[selectedIndex].view.setNeedsLayout()
//    viewControllers?[selectedIndex].view.layoutSubviews()
//  }
}


class ViewController1: UIViewController {

  @IBOutlet weak var safeAreaLabel: UILabel!

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    safeAreaLabel.numberOfLines = 0
  }

  override func viewSafeAreaInsetsDidChange() {
    super.viewSafeAreaInsetsDidChange()

    print("### safe area1:", view.safeAreaInsets)

    safeAreaLabel.text = "safeAreaInsets:\n \(view.safeAreaInsets)"
  }

  @IBAction func didTapShowButton(_ sender: Any) {
    NotificationCenter.default.post(name: CustomTabBarController.showCustomTabBar, object: nil)
  }

  @IBAction func didTapHideButton(_ sender: Any) {
    NotificationCenter.default.post(name: CustomTabBarController.hideCustomTabBar, object: nil)
  }

}

class ViewController2: UIViewController {

  let scrollView = UIScrollView()

  override func viewDidLoad() {
    super.viewDidLoad()

    view.addSubview(scrollView)

    scrollView.backgroundColor = .systemGray4

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
