//
//  CustomPresenterRow.swift
//  cimonv2
//
//  Created by Afzal Hossain on 3/3/18.
//  Copyright © 2018 Afzal Hossain. All rights reserved.
//

import Foundation
import Eureka
import UIKit



open class PresenterRow<Cell: CellType, VCType: TypedRowControllerType>: OptionsRow<Cell>, PresenterRowType where Cell: BaseCell, VCType: UIViewController, VCType.RowValue == Cell.Value {
    
    public var presentationMode: PresentationMode<VCType>?
    public var onPresentCallback: ((FormViewController, VCType) -> Void)?
    public typealias PresentedControllerType = VCType
    
    required public init(tag: String?) {
        super.init(tag: tag)
        cellProvider = CellProvider(nibName: "MotorTaskCell")
    }
    
    open override func customDidSelect() {
        super.customDidSelect()
        guard let presentationMode = presentationMode, !isDisabled else { return }
        if let controller = presentationMode.makeController() {
            controller.row = self
            controller.title = selectorTitle ?? controller.title
            onPresentCallback?(cell.formViewController()!, controller)
            presentationMode.present(controller, row: self, presentingController: self.cell.formViewController()!)
        } else {
            presentationMode.present(nil, row: self, presentingController: self.cell.formViewController()!)
        }
    }
}



/*final class CustomPresenterRow: PresenterRow<SignatureTableViewCell, CustomViewController>, RowType {
 
 }*/

final class MotorTaskPresenterRow: PresenterRow<MotorTaskCell, MotorTaskViewController>, RowType {
    
}
