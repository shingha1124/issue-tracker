//
//  LabelListDataSource.swift
//  issueTracker
//
//  Created by 이준우 on 2022/06/15.
//

import UIKit

final class LabelListDataSource: NSObject, UITableViewDataSource {
    
    private var labels: [LabelInfo] = []
    
    func updateLabelList(labels: [LabelInfo]) {
        self.labels = labels
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        labels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: LabelListTableViewCell.identifier, for: indexPath) as? LabelListTableViewCell else {
            return UITableViewCell()
        }
        
        let labelInfo = labels[indexPath.row]
        cell.updateValues(labelName: labelInfo.labelName, description: labelInfo.labelDescription)
        
        return cell
    }
}
