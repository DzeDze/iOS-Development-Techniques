//
//  CustomCell.swift
//  TaskGroupSample
//
//  Created by Vince P. Nguyen on 2024-10-12.
//

import UIKit

class CustomCell: UITableViewCell {
    lazy var imgView: UIImageView = {
        let imgV = UIImageView()
        imgV.contentMode = .scaleAspectFill
        imgV.clipsToBounds = true
        imgV.translatesAutoresizingMaskIntoConstraints = false
        return imgV
    }()
    
    lazy var quoteLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 16)
        lbl.textAlignment = .left
        lbl.numberOfLines = 0
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 300, height: 150)
    }
    
    private func layout() {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 8
        
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(imgView)
        stackView.addArrangedSubview(quoteLbl)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        //layout stackView
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalToSystemSpacingBelow: contentView.topAnchor, multiplier: 1),
            stackView.leadingAnchor.constraint(equalToSystemSpacingAfter: contentView.leadingAnchor, multiplier: 1),
            contentView.bottomAnchor.constraint(equalToSystemSpacingBelow: stackView.bottomAnchor, multiplier: 1),
            contentView.trailingAnchor.constraint(equalToSystemSpacingAfter: stackView.trailingAnchor, multiplier: 1)
        ])
        
        NSLayoutConstraint.activate([
            imgView.heightAnchor.constraint(equalTo: imgView.widthAnchor)
        ])
        
        imgView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        quoteLbl.setContentHuggingPriority(.defaultLow, for: .horizontal)
    }
}
