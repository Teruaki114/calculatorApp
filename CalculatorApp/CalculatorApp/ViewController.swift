//
//  ViewController.swift
//  CalculatorApp
//
//  Created by てる on 2020/10/09.
//

import UIKit

class ViewController: UIViewController{
    
    //計算機の状態宣言
    var calculateStatus: CalculateStatus = .none
    //計算機の状態
    enum CalculateStatus {
        case none, plus,minus, mutiplication, division
    }
    //入力の値、空のstring宣言
    var firstNumber = ""
    var secondNumber = ""
    //数字、記号ボタンの文字を配列で設定
    let numbers = [
        ["C","%","$","÷"],
        ["7","8","9","×"],
        ["4","5","6","-"],
        ["1","2","3","+"],
        ["0",".","=",],
    ]
    
    let cellId = "cellId"
    
    //ストーリーボード紐付け
    @IBOutlet weak var calculatorCollectionView: UICollectionView!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var calculatorHeightConstraint: NSLayoutConstraint!
    
    //最初の動き
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    func setupViews(){
        calculatorCollectionView.delegate = self
        calculatorCollectionView.dataSource = self
        calculatorCollectionView.register(CalculatorViewCell.self, forCellWithReuseIdentifier: cellId)
        //フレームの横幅×１。４をコレクションビューの高さに設定
        //collectionViewの横幅
        let vWidth = view.frame.width
        //セル間の隙間
        let cellSpace =  vWidth - vWidth * 0.8
        //collectionViewの横幅からセルの隙間を引いて４分割した長さ
        let cellLength = (vWidth - cellSpace) / 4
        //セル５個分の高さに設定
        calculatorHeightConstraint.constant = cellLength * 5 + cellSpace * 2
        //コレクションビューの背景を透明
        calculatorCollectionView.backgroundColor = .clear
        //セルの左右にマージン設定
        calculatorCollectionView.contentInset = .init(top: 0, left: cellSpace * (1 / 6), bottom: 0, right: cellSpace * (1 / 6))
        //ビューの背景色設定（黒）
        view.backgroundColor = .black
        
        numberLabel.text = "0"
    }
    
    
    //配列の数
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return numbers.count
    }
    
    //collectionViewのセルサイズ、、ヘッダーサイズ
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: collectionView.frame.width, height: 10)
    }
    
    //セルサイズ
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //collectionViewの横幅
        let vWidth = view.frame.width
        //セル間の隙間
        let cellSpace =  vWidth - vWidth * 0.8
        //collectionViewの横幅からセルの隙間を引いて４分割した長さ
        var cellLength = (vWidth - cellSpace) / 4
        //高さを代入
        let heigth = cellLength
        //０を２個分のセルに結合
        if indexPath.section == 4 && indexPath.row == 0 {
            cellLength = cellLength * 2 + cellSpace / 4 + 3
        }
        //セルサイズをリターン
        return .init(width: cellLength, height: heigth)
    }
    
    //コレクションビューのセルスペース
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        //collectionViewの横幅
        let vWidth = view.frame.width
        //セル間の隙間
        let cellSpace =  vWidth - vWidth * 0.8
        //collectionViewの横幅からセルの隙間を引いて４分割した長さ
        let cellLength = (vWidth - cellSpace) / 4
        //レスポンシブにセルの間の空白を設定
        let cellsSpace = (vWidth - (cellLength * 4)) / 6
        //セルスペースをリターン
        return cellsSpace
    }
    
    //collectionViewのセルの表示数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //配列の数だけリターン
        return numbers[section].count
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //
        let cell = calculatorCollectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CalculatorViewCell
        //cellのテキストをnumbersを参照させる。sectionは[]内、rowはnumbersの
        cell.numberLabel.text = numbers[indexPath.section][indexPath.row]
        
        
        //セルの中身が数字ならダークグレー
        numbers[indexPath.section][indexPath.row].forEach { (numberString) in
            if "0"..."9" ~= numberString  || numberString.description == "."{
                cell.numberLabel.backgroundColor = .darkGray
                
                //C,%,$なら黒
            }else if numberString == "C" || numberString == "%" || numberString == "$"{
                cell.numberLabel.backgroundColor = UIColor.init(white: 1, alpha: 0.7)
                cell.numberLabel.textColor = .black
            }
        }
        return cell
    }
    //Cボタンメソッド
    func clear(){
        firstNumber = ""
        secondNumber = ""
        numberLabel.text = "0"
        calculateStatus = .none
    }
}

extension ViewController:  UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    //セル入力処理
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //セルの情報を取得
        let number = numbers[indexPath.section][indexPath.row]
        //計算機の状態なし
        if calculateStatus == .none {
            handleFirstNumberSelect(number: number)
            //計算機情報を持っていたら
        }else if calculateStatus != .none {
            handleSecondNumberSelect(number: number)
        }
    }
    
    //文字入力１回目
    private func handleFirstNumberSelect(number: String){
        //数字ならラベルに追加する処理
        switch number {
        case "0"..."9":
            firstNumber += number
            numberLabel.text = firstNumber
            if firstNumber.hasPrefix("0"){
                firstNumber = ""
            }
        case ".":
            if !confirmIncludeDecimalPoint(numberString: firstNumber) {
                firstNumber += number
                numberLabel.text = firstNumber
            }
        case "+":
            calculateStatus = .plus
        case "-":
            calculateStatus = .minus
        case "×":
            calculateStatus = .mutiplication
        case "÷":
            calculateStatus = .division
        case "C":
            clear()
        default:
            break
        }
    }
    
    //文字入力２回目
    private func handleSecondNumberSelect(number: String){
        switch number {
        case "0"..."9":
            secondNumber += number
            numberLabel.text = secondNumber
            if secondNumber.hasPrefix("0"){
                secondNumber = ""
            }
        case ".":
            if !confirmIncludeDecimalPoint(numberString: secondNumber) {
                secondNumber += number
                numberLabel.text = secondNumber
            }
        //計算処理
        case "=":
            calculateResultNumber()
        case "C":
            clear()
            
        //四則演算再定義
        case "+":
            calculateStatus = .plus
        case "-":
            calculateStatus = .minus
        case "×":
            calculateStatus = .mutiplication
        case "÷":
            calculateStatus = .division
        default:
            break
        }
    }
    
    
    //"="ラベル押下処理
    private func calculateResultNumber(){
        secondNumber = numberLabel.text ?? ""
        //ダブル型へキャスト
        let firstNum = Double(firstNumber) ?? 0
        let secondNum = Double(secondNumber) ?? 0
        
        var resultString: String?
        
        switch calculateStatus {
        case .plus:
            resultString = String(firstNum + secondNum)
        case .minus:
            resultString = String(firstNum - secondNum)
        case .mutiplication:
            resultString = String(firstNum * secondNum)
        case .division:
            resultString = String(firstNum / secondNum)
        default:
            break
        }
        //.0削除
        if let result = resultString, result.hasSuffix(".0"){
            resultString = result.replacingOccurrences(of: ".0", with: "")
        }
        numberLabel.text = resultString
        
        //計算後再利用ロジック
        firstNumber = ""
        secondNumber = ""
        firstNumber += resultString ?? ""
        calculateStatus = .none
    }
    
    private func confirmIncludeDecimalPoint(numberString: String) -> Bool{
        if numberString.range(of: ".") != nil || numberString.count  == 0 {
            return true
        }else{
            return false
        }
    }
}
