//
//  UIApplication+Extension.swift
//
//  BiometricAuthentication
//
//  Created by Zaid Sheikh on 08/06/2023.
//

import UIKit

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
