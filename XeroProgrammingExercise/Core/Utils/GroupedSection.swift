//
//  GroupedSection.swift
//  XeroProgrammingExercise
//
//  Created by Tony Mu on 7/07/20.
//  Copyright © 2020 Xero Ltd. All rights reserved.
//

struct GroupedSection<SectionItem: Hashable, RowItem> {
    var sectionItem: SectionItem
    var rows: [RowItem]
    
    static func group(items: [RowItem], by criteria : (RowItem) -> SectionItem) -> [GroupedSection<SectionItem, RowItem>] {
        let groups = Dictionary(grouping: items, by: criteria)
        return groups.map(GroupedSection.init(sectionItem:rows:))
    }
}
