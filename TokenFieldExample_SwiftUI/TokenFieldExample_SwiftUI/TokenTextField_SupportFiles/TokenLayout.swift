//
//  TokenLayout.swift
//
//  Created by Jayant on 12/01/24.
//


import SwiftUI


struct TokenLayout: Layout {
    
    var alignment: Alignment = .center
    var horizontalSpacingBetweenItem: CGFloat = 10
    var verticalSpacingBetweenItem: CGFloat = 0

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let maxWidth = proposal.width ?? 0
        var totalHeight: CGFloat = 0

        let rows = generateRows(maxWidth, proposal, subviews)

        for (index, _) in rows.enumerated() {
            totalHeight += rows[index].maxHeight(proposal)
            totalHeight += index == rows.count - 1 ? 0 : verticalSpacingBetweenItem
        }

        return CGSize(width: maxWidth, height: totalHeight)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        var origin = CGPoint(x: bounds.origin.x, y: bounds.origin.y)

        let maxWidth = bounds.width
        let rows = generateRows(maxWidth, proposal, subviews)

        for (index, row) in rows.enumerated() {
            let totalWidth = row.reduce(0) { partialResult, view in
                let width = view.sizeThatFits(proposal).width
                return partialResult + width
            }
            let totalSpacing = CGFloat(row.count - 1) * horizontalSpacingBetweenItem
            let remainingSpace = maxWidth - totalWidth - totalSpacing

            switch alignment {
            case .leading:
                origin.x = bounds.minX
            case .trailing:
                origin.x = bounds.maxX - (totalWidth + totalSpacing)
            case .center:
                origin.x = bounds.minX + remainingSpace / 2
            default:
                break
            }

            for view in row {
                let viewSize = view.sizeThatFits(proposal)
                view.place(at: origin, proposal: proposal)
                origin.x += (viewSize.width + horizontalSpacingBetweenItem)
            }

            origin.y += (row.maxHeight(proposal) + (index == rows.count - 1 ? 0 : verticalSpacingBetweenItem))
        }
    }

    func generateRows(_ maxWidth: CGFloat, _ proposal: ProposedViewSize, _ subviews: Subviews) -> [[LayoutSubviews.Element]] {
        var row: [LayoutSubviews.Element] = []
        var rows: [[LayoutSubviews.Element]] = []
        var origin = CGRect.zero.origin

        for view in subviews {
            let viewSize = view.sizeThatFits(proposal)
            let totalWidth = origin.x + viewSize.width + (row.isEmpty ? 0 : horizontalSpacingBetweenItem)

            if totalWidth > maxWidth {
                rows.append(row)
                row.removeAll()
                origin.x = 0
            }

            row.append(view)
            origin.x += (viewSize.width + horizontalSpacingBetweenItem)
        }

        if !row.isEmpty {
            rows.append(row)
        }

        return rows
    }
}


extension Array where Element == LayoutSubviews.Element {
    func maxHeight(_ proposal: ProposedViewSize) -> CGFloat {
        return self.compactMap { view in
            return view.sizeThatFits(proposal).height
            
        }.max() ?? 0
    }
}
