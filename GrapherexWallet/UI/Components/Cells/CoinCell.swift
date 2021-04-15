//
//  Copyright (c) 2020 Open Whisper Systems. All rights reserved.
//

import Foundation
import UIKit

final class CoinCell: NiblessView {
    // MARK: - Properties
    
    private struct Constants {
        static let coinImageSize: CGFloat = 45.0
    }
    
    private let coinImage: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private let coinLabel: UILabel = {
        let view = UILabel()
        view.font = .wlt_robotoRegularFont(withSize: 14)
        view.textColor = .wlt_primaryLabelColor
        return view
    }()
    
    private lazy var coinStack: UIStackView = {
       let stack = UIStackView(arrangedSubviews: [coinImage, coinLabel])
        stack.axis = .horizontal
        stack.spacing = 10
        return stack
    }()
    
    private let balanceLabel: UILabel = {
        let view = UILabel()
        view.textColor = .wlt_primaryLabelColor
        view.font = .wlt_robotoRegularFont(withSize: 14)
        view.textAlignment = .right
        return view
    }()
    
    private let currencyBalanceLabel: UILabel = {
        let view = UILabel()
        view.textColor = .wlt_secondaryLabelColor
        view.font = .wlt_robotoRegularFont(withSize: 12)
        view.textAlignment = .right
        return view
    }()
    
    private lazy var balanceStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [balanceLabel, currencyBalanceLabel])
        stack.axis = .vertical
        stack.distribution = .fillEqually
        return stack
    }()
    
    private let priceLabel: UILabel = {
        let view = UILabel()
        view.textColor = .wlt_darkGray63Color
        view.font = .wlt_robotoRegularFont(withSize: 14)
        view.textAlignment = .right
        return view
    }()
    
    private let priceChangeLabel: UILabel = {
        let view = UILabel()
        view.font = .wlt_robotoRegularFont(withSize: 12)
        view.textAlignment = .right
        return view
    }()
    
    private lazy var priceStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [priceLabel, priceChangeLabel])
        stack.axis = .vertical
        stack.distribution = .fillEqually
        return stack
    }()
    
    private lazy var containerStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [coinStack, balanceStack, priceStack])
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        return stack
    }()
    
    var currencyItem: CoinDataItem? {
        didSet {
            render()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        activateConstraints()
    }
}

fileprivate extension CoinCell {
    
    func render() {
        guard let currencyItem = currencyItem else { return }
        coinImage.sd_setImage(with: URL(string: currencyItem.currency.icon))
        coinLabel.text = currencyItem.currency.symbol
        balanceLabel.text = currencyItem.balance
        currencyBalanceLabel.text = currencyItem.currencyBalance
        priceLabel.text = currencyItem.stockPrice
        
        let arrowType = currencyItem.priceChangeType == .positive ? "▲" : "▼"
        priceChangeLabel.text = currencyItem.priceChange + arrowType
        priceChangeLabel.textColor = currencyItem.priceChangeType.tintColor
    }
    
    func setup() {
        backgroundColor = .wlt_primaryBackgroundColor

        addSubview(containerStack)
    }
    
    func activateConstraints() {
        containerStack.autoPinEdgesToSuperviewEdges()
        
        coinImage.wltSetContentHuggingHorizontalHigh()
        coinImage.autoSetDimension(.height, toSize: Constants.coinImageSize)
        coinImage.autoMatch(.height, to: .width, of: coinImage)
        coinLabel.wltSetContentHuggingHorizontalLow()
    }
}

