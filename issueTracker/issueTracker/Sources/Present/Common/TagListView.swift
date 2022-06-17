//
//  TagListView.swift
//  issueTracker
//
//  Created by seongha shin on 2022/06/14.
//

import UIKit

final class TagListView: UIView {
    
    class Config {
        var font: UIFont = .systemFont(ofSize: 15, weight: .regular)
        var hSpacing: CGFloat = 3
        var vSpacing: CGFloat = 3
        var cornerRadius: CGFloat = 5
        var isCapsule = false
    }
    
    class TagConfig {
        var textColor: UIColor = .white
        var backgroundColor: UIColor = .black
    }
    
    struct Tag {
        let text: String
        let config: TagConfig
        
        init(text: String, config: TagConfig) {
            self.text = text
            self.config = config
        }
    }
    
    private var tags: [Tag] = []
    private let config: Config
    
    init(config: Config) {
        self.config = config
        super.init(frame: .zero)
        
        snp.makeConstraints {
            $0.height.equalTo(0)
        }
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addTag(_ text: Tag) {
        tags.append(text)
    }
    
    func addTags(_ texts: [Tag]) {
        texts.forEach {
            addTag($0)
        }
    }
    
    func clear() {
        self.subviews.forEach {
            $0.removeFromSuperview()
        }
        tags.removeAll()
    }
    
    func updateTag() {
        
        if tags.isEmpty {
            frame.size = CGSize(width: frame.size.width, height: 0)
            return
        }
        
        layoutIfNeeded()
        
        let maxWidth = frame.width
        
        let labels = tags.map { tag -> PaddingLabel in
            let label = PaddingLabel()
            label.padding = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
            label.text = tag.text
            label.textColor = tag.config.textColor
            label.backgroundColor = tag.config.backgroundColor
            label.font = config.font
            label.clipsToBounds = true
            
            label.layer.cornerRadius = config.isCapsule ? label.intrinsicContentSize.height / 2 :  config.cornerRadius
            self.addSubview(label)
            return label
        }
        
        var stackHeight = 0.0
        var stackWidth = 0.0
        labels.forEach { label in
            let labelSize = label.intrinsicContentSize
            label.frame.size = labelSize
            if stackWidth + labelSize.width > maxWidth {
                stackHeight += labelSize.height + config.vSpacing
                stackWidth = labelSize.width
                label.frame.origin = CGPoint(x: 0, y: stackHeight)
            } else {
                label.frame.origin = CGPoint(x: stackWidth, y: stackHeight)
                stackWidth += labelSize.width + config.hSpacing
            }
        }
        
        let lastLabel = labels[labels.count - 1]
        
        snp.updateConstraints {
            $0.height.equalTo(lastLabel.frame.origin.y + lastLabel.frame.height)
        }
    }
}
