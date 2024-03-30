//
//  GDMapScrollView.swift
//  GaoDeMapDemo
//
//  Created by cc on 2024/3/29.
//

import UIKit
import SnapKit

class GDMapScrollView: UIView {
    private var mockView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage.init(named: "mock_img")
        return imgView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
        setupLayouts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubviews() {
        addSubview(mockView)
    }
     
    func setupLayouts() {
        mockView.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview()
            make.height.equalTo(SCROLL_VIEW_HEIGHT)
        }
    }
}
