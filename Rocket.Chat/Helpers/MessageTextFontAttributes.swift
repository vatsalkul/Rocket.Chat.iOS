//
//  MessageTextFontAttributes.swift
//  Rocket.Chat
//
//  Created by Rafael Kellermann Streit on 01/03/17.
//  Copyright © 2017 Rocket.Chat. All rights reserved.
//

import UIKit

struct MessageTextFontAttributes {

    static let defaultFontSize = CGFloat(15)

    struct FontColor {
        let defaultFontColor: UIColor
        let systemFontColor: UIColor
        let failedFontColor: UIColor
    }

    static func defaultFontColor(for theme: Theme? = nil) -> UIColor {
        return theme?.bodyText ?? ThemeManager.theme.bodyText
    }

    static func systemFontColor(for theme: Theme? = ThemeManager.theme) -> UIColor {
        return theme?.auxiliaryText ?? ThemeManager.theme.auxiliaryText
    }

    static func failedFontColor(for theme: Theme? = ThemeManager.theme) -> UIColor {
        return theme?.auxiliaryText ?? ThemeManager.theme.auxiliaryText
    }

    static let defaultFont = UIFont.systemFont(ofSize: defaultFontSize)
    static let italicFont = UIFont.italicSystemFont(ofSize: defaultFontSize)
    static let boldFont = UIFont.boldSystemFont(ofSize: defaultFontSize)

}
