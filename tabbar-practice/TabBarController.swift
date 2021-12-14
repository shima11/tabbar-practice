//
//  TabBarController.swift
//  tabbar-practice
//
//  Created by Jinsei Shima on 2021/11/16.
//

import UIKit

enum TabBarNotification {
  static let showCustomTabBar: Notification.Name = .init(rawValue: "CustomTabBar.show")
  static let hideCustomTabBar: Notification.Name = .init(rawValue: "CustomTabBar.hide")
}

// NOTE: TabBarの上にCustomのViewを表示するのに、TabBarをカスタマイズしてカスタムViewを表示させるアプローチ。
class CustomTabBarController1: UITabBarController {

  static let customBarHeight: CGFloat = 44

//  private var isBarViewShowing = false

  // TODO: CustomClassにして中身を簡単にカスタマイズ
  private let customBar: UIView = .init()

  override func viewDidLoad() {
    super.viewDidLoad()

    customBar.backgroundColor = .systemGray

    tabBar.backgroundColor = .white

    NotificationCenter.default.addObserver(forName: TabBarNotification.showCustomTabBar, object: nil, queue: .main) { [weak self] notification in
      self?.showBar()
    }

    NotificationCenter.default.addObserver(forName: TabBarNotification.hideCustomTabBar, object: nil, queue: .main) { [weak self] notification in
      self?.hideBar()
    }

//    object_setClass(tabBar, CustomTabBar.self)

  }

  public func showBar() {

    guard customBar.isDescendant(of: tabBar) == false else { return }

    object_setClass(tabBar, CustomTabBar.self)

    tabBar.addSubview(customBar)
    // TODO: これだと_UIBarBackgroundよりも後ろには行かずUIBarに被る
    tabBar.sendSubviewToBack(customBar)

    customBar.frame = .init(x: 0, y: -Self.customBarHeight, width: tabBar.bounds.width, height: Self.customBarHeight)

    self.customBar.transform = .init(translationX: 0, y: Self.customBarHeight)
    self.customBar.alpha = 0
    UIViewPropertyAnimator(duration: 0.3, dampingRatio: 1) {
      self.customBar.alpha = 1
      self.customBar.transform = .identity
    }
    .startAnimation()

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

    (tabBar as? CustomTabBar)?.isBarViewShowing = true
  }

  public func hideBar() {

    guard customBar.isDescendant(of: tabBar) == true else { return }

    let animator = UIViewPropertyAnimator(duration: 0.3, dampingRatio: 1) {
      self.customBar.alpha = 0
      self.customBar.transform = .init(translationX: 0, y: Self.customBarHeight)
    }
    animator.addCompletion { _ in
      self.customBar.alpha = 1
      self.customBar.transform = .identity
      self.customBar.removeFromSuperview()
    }
    animator.startAnimation()


    object_setClass(tabBar, UITabBar.self)

    additionalSafeAreaInsets = .init(top: 0, left: 0, bottom: 0, right: 0)

    for item in (tabBar.items)! {
      item.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    (tabBar as? CustomTabBar)?.isBarViewShowing = false

  }

  class CustomTabBar: UITabBar {

    var isBarViewShowing = false

//    let backgroundView: UIView = .init()
//
//    private func setup() {
//      backgroundView.backgroundColor = .red
//      addSubview(backgroundView)
//      backgroundView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//    }
//
//    open override func willMove(toSuperview newSuperview: UIView?) {
//      super.willMove(toSuperview: newSuperview)
//      setup()
//    }

    override func layoutSubviews() {
      super.layoutSubviews()
      print(subviews)
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
      var sizeThatFits = super.sizeThatFits(size)
      if isBarViewShowing {
        sizeThatFits.height = sizeThatFits.height + CustomTabBarController1.customBarHeight
        return sizeThatFits
      } else {
        return sizeThatFits
      }
    }
  }

//  private func currentViewLayoutSubviews() {
//    viewControllers?[selectedIndex].view.setNeedsLayout()
//    viewControllers?[selectedIndex].view.layoutSubviews()
//  }
}

// NOTE: TabBarの上にCustomのViewを表示するのに、TabBarとは別でViewを管理するアプローチ。
class CustomTabBarController2: UITabBarController {

  static let customBarHeight: CGFloat = 44

  private var isCustomBarShowing = false
  private var isTabBarShowing = true

  // TODO: CustomClassにして中身を簡単にカスタマイズ
  private let customBar: UIView = .init()

  override func viewDidLoad() {
    super.viewDidLoad()

    customBar.backgroundColor = .systemGray

    tabBar.backgroundColor = .white

    NotificationCenter.default.addObserver(forName: TabBarNotification.showCustomTabBar, object: nil, queue: .main) { [weak self] notification in
      self?.showCustomBar()
    }

    NotificationCenter.default.addObserver(forName: TabBarNotification.hideCustomTabBar, object: nil, queue: .main) { [weak self] notification in
      self?.hideCustomBar()
    }

    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapCustomBar))
    customBar.addGestureRecognizer(tapGesture)
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    print("view did layout subviews", tabBar.frame)
  }

  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    print("view will layout subviews", tabBar.frame)
  }

  @objc func didTapCustomBar() {
    print("tap custom bar")
    // TODO: 全画面モードへの遷移

    // TODO: Tabbarを隠してもすぐ元に戻ってしまう
    if isTabBarShowing {
      hideTabBar()
    } else {
      showTabBar()
    }
  }

  private var additionalOffsetY: CGFloat = .zero

  private func showTabBar() {

    guard isTabBarShowing == false else { return }

    isTabBarShowing = true

    let frame: CGRect = .init(origin: .init(x: 0, y: tabBar.frame.minY - additionalOffsetY), size: self.tabBar.bounds.size)

    additionalOffsetY = .zero
    
    let animator = UIViewPropertyAnimator(duration: 0.2, dampingRatio: 1) {
      self.tabBar.frame = frame
    }
//    animator.addCompletion { _ in
//      self.tabBar.isHidden = false
//    }
    animator.startAnimation()
  }

  private func hideTabBar() {

    guard isTabBarShowing else { return }

    isTabBarShowing = false

    print("hide tab bar", tabBar.bounds.height)

    additionalOffsetY = tabBar.bounds.height

    let frame: CGRect = .init(origin: .init(x: 0, y: tabBar.frame.minY + additionalOffsetY), size: tabBar.bounds.size)

    let animator = UIViewPropertyAnimator(duration: 0.2, dampingRatio: 1) {
      self.tabBar.frame = frame
    }
//    animator.addCompletion { _ in
//      self.tabBar.isHidden = true
//    }
    animator.startAnimation()

  }

  public func showCustomBar() {

    guard customBar.isDescendant(of: view) == false else { return }

    view.insertSubview(customBar, belowSubview: tabBar)

    self.customBar.transform = .init(translationX: 0, y: Self.customBarHeight)
    UIViewPropertyAnimator(duration: 0.2, dampingRatio: 1) {
      self.customBar.transform = .identity
    }
    .startAnimation()

    customBar.translatesAutoresizingMaskIntoConstraints = false

    customBar.removeConstraints(customBar.constraints)

    NSLayoutConstraint.activate([
      customBar.heightAnchor.constraint(equalToConstant: Self.customBarHeight),
      customBar.leftAnchor.constraint(equalTo: view.leftAnchor),
      customBar.rightAnchor.constraint(equalTo: view.rightAnchor),
      customBar.bottomAnchor.constraint(equalTo: tabBar.topAnchor),
    ])

    // TabBarの中のアイテムもSafeAreaによってズレるのでダメだった。
//    additionalSafeAreaInsets = .init(top: 0, left: 0, bottom: Self.customBarHeight, right: 0)

    // TODO: それぞれの画面で設定している場合、上書きしてしまうので良くない
    viewControllers?.forEach {
      $0.additionalSafeAreaInsets = .init(top: 0, left: 0, bottom: Self.customBarHeight, right: 0)
    }

    isCustomBarShowing = true
  }

  public func hideCustomBar() {

    guard customBar.isDescendant(of: view) == true else { return }

    let animator = UIViewPropertyAnimator(duration: 0.2, dampingRatio: 1) {
      self.customBar.transform = .init(translationX: 0, y: Self.customBarHeight)
    }
    animator.addCompletion { _ in
      self.customBar.transform = .identity
      self.customBar.removeFromSuperview()
    }
    animator.startAnimation()

//    additionalSafeAreaInsets = .init(top: 0, left: 0, bottom: 0, right: 0)

    // TODO: それぞれの画面で設定している場合、上書きしてしまうので良くない
    viewControllers?.forEach {
      $0.additionalSafeAreaInsets = .zero
    }

    isCustomBarShowing = false
  }

}
