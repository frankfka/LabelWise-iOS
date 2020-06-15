//
//  NoPermissionsView.swift
//  LabelWise
//
//  Created by Frank Jia on 2020-06-14.
//  Copyright © 2020 Frank Jia. All rights reserved.
//

import SwiftUI

struct NoPermissionsView: View {
    private static let ViewPadding: CGFloat = CGFloat.App.Layout.LargestPadding
    private static let ItemSpacing: CGFloat = CGFloat.App.Layout.Padding
    private static let IconSize: CGFloat = CGFloat.App.Icon.LargeIcon
    private static let IconColor: Color = Color.App.AppRed
    private static let TitleFont: Font = Font.App.Subtitle
    private static let TitleColor: Color = Color.App.Text
    private static let HelpTextFont: Font = Font.App.NormalText
    private static let HelpTextColor: Color = Color.App.Text
    
    var body: some View {
        VStack(spacing: NoPermissionsView.ItemSpacing) {
            Spacer()
            Image.App.XMarkCircle
                .resizable()
                .frame(width: NoPermissionsView.IconSize, height: NoPermissionsView.IconSize)
                .foregroundColor(NoPermissionsView.IconColor)
            Text("No Camera Permissions")
                .withAppStyle(font: NoPermissionsView.TitleFont, color: NoPermissionsView.TitleColor)
            Text("Camera permissions are required to scan labels and can be granted through iOS Settings. Restart the app after permissions are granted.")
                .withAppStyle(font: NoPermissionsView.HelpTextFont, color: NoPermissionsView.HelpTextColor)
                .multiline()
                .multilineTextAlignment(.center)
            Spacer()
        }
        .padding(NoPermissionsView.ViewPadding)
    }
}

struct NoPermissionsView_Previews: PreviewProvider {
    static var previews: some View {
        NoPermissionsView()
    }
}
