//
//  CalculatorViewCell.swift
//  CalculatorApp
//
//  Created by てる on 2020/10/12.
//

import Foundation
import UIKit

//セルをカスタムする
class CalculatorViewCell: UICollectionViewCell {
    
    override var isHighlighted: Bool{
        didSet{
            if isHighlighted {
                self.numberLabel.alpha = 0.3
            }else{
                self.numberLabel.alpha = 1
            }
        }
    }
    //セルのカスタム
    let numberLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 30)
        //        label.adjustsFontSizeToFitWidth = true
        label.clipsToBounds = true
        label.backgroundColor = .orange
        return label
    }()
    
    
    override init(frame: CGRect){
        super.init(frame: frame)
        addSubview(numberLabel)
        //UIをセルと同じ大きさに
        numberLabel.frame.size = self.frame.size
        //丸くする
        numberLabel.layer.cornerRadius = self.frame.height / 2
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
