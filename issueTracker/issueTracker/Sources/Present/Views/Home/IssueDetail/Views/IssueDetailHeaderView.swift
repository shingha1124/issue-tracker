//
//  IssueDetailHeaderView.swift
//  issueTracker
//
//  Created by 이준우 on 2022/06/30.
//

import RxCocoa
import RxSwift
import UIKit

final class IssueDetailHeaderView: BaseView {
    
    private let numberLabel: UILabel = {
        let label = UILabel()
        label.text = "#0"
        return label
    }()
    
    private let stateLabel: PaddingLabel = {
        let label = PaddingLabel()
        label.padding = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textColor = "#007AFF".hexToColor()
        label.backgroundColor = "#C7EBFF".hexToColor()
        label.clipsToBounds = true
        label.layer.cornerRadius = label.intrinsicContentSize.height * 1.5
        label.text = "열림"
        label.sizeToFit()
        return label
    }()
    
    private let historyLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.text = ""
        return label
    }()
    
    var state: Issue.State? = .open {
        didSet {
            switch state {
            case .open:
                stateLabel.text = "열림"
                stateLabel.textColor = "#007AFF".hexToColor()
                stateLabel.backgroundColor = "#C7EBFF".hexToColor()
            case .closed:
                stateLabel.text = "닫힘"
                stateLabel.textColor = "#0025E7".hexToColor()
                stateLabel.backgroundColor = "#CCD4FF".hexToColor()
            default:
                state = .open
            }
        }
    }
    
    var history: String? {
        didSet {
            historyLabel.text = history
        }
    }
    
    var issueNumber: Int = -1 {
        didSet {
            numberLabel.text = "#\(issueNumber)"
        }
    }
    
    override func layout() {
        super.layout()
        
        addSubview(stateLabel)
        stateLabel.snp.makeConstraints {
            $0.leading.top.equalToSuperview()
        }
        
        addSubview(numberLabel)
        numberLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalTo(stateLabel.snp.trailing).offset(10)
        }
        
        addSubview(historyLabel)
        historyLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalTo(numberLabel.snp.trailing).offset(10)
        }
        
        self.snp.makeConstraints {
            $0.height.equalTo(stateLabel)
        }
    }
}
