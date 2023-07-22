//
//  OnboardingViewController.swift
//  YP-TrackerApp
//
//  Created by Богдан Полыгалов on 17.07.2023.
//

import UIKit

final class OnboardingPageViewController: UIPageViewController {

    private lazy var pages: [UIViewController] = {
        let first = OnboardingViewController()
        first.image.image = UIImage(named: "OnboardingBlue")
        first.label.text = "Отслеживайте только то, что хотите"

        let second = OnboardingViewController()
        second.image.image = UIImage(named: "OnboardingRed")
        second.label.text = "Даже если это не литры воды и йога"

        return [first, second]
    }()

    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0

        pageControl.currentPageIndicatorTintColor = .black
        pageControl.pageIndicatorTintColor = .gray

        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        dataSource = self
        delegate = self

        if let first = pages.first {
            setViewControllers([first], direction: .forward, animated: true, completion: nil)
        }

        view.addSubview(pageControl)

        NSLayoutConstraint.activate([
            pageControl.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 250),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

}

extension OnboardingPageViewController: UIPageViewControllerDataSource {

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        //возвращаем предыдущий (относительно переданного viewController) дочерний контроллер
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else {
            return nil
        }
        let previousIndex = viewControllerIndex - 1
        guard previousIndex >= 0 else {
            return pages[pages.count - 1]
        }
        return pages[previousIndex]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        //возвращаем следующий (относительно переданного viewController) дочерний контроллер
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else {
            return nil
        }
        let nextIndex = viewControllerIndex + 1
        guard nextIndex < pages.count else {
            return pages[0]
        }
        return pages[nextIndex]
    }

}

extension OnboardingPageViewController: UIPageViewControllerDelegate {

    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let currentViewController = pageViewController.viewControllers?.first,
           let currentIndex = pages.firstIndex(of: currentViewController) {
            pageControl.currentPage = currentIndex
        }
    }

}
