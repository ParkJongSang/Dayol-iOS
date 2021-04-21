//
//  Assets.swift
//  Dayol-iOS
//
//  Created by Sungmin on 2020/12/09.
//

import UIKit

enum Assets {
    enum Image {
        enum Home {
            static let topIcon = UIImage(named: "home_top_icon")
            static let emptyDiaryIcon = UIImage(named: "home_empty_diary")
            static let emptyFavoriteIcon = UIImage(named: "home_empty_favorite")
            static let emptyArrow = UIImage(named: "home_empty_arrow")
            static let plusButton = UIImage(named: "home_tabbar_plusbutton")
            static let diaryListActionButton = UIImage(named: "home_diaryList_dropdown")

            enum TabBarDiary {
                static let normal = UIImage(named: "home_tabbar_diary_normal")
                static let selected = UIImage(named: "home_tabbar_diary_selected")
            }

            enum TabBarFavorite {
                static let normal = UIImage(named: "home_tabbar_favorite_normal")
                static let selected = UIImage(named: "home_tabbar_favorite_selected")
            }
        }

        enum Settings {
            static let chevron = UIImage(named: "settings_chevron")

            enum Backup {
                static let info = UIImage(named: "settings_backup_info")
                static let next = UIImage(named: "settings_backup_next")
            }
        }

        enum PaperAdd {
            enum Button {
                static let on = UIImage(named: "paper_add_btn_on")
                static let off = UIImage(named: "paper_add_btn_off")
            }
        }

        enum PaperList {
            static let chevronDown = UIImage(named: "paper_list_chevron_down")
            static let addCell = UIImage(named: "paper_list_cell_add_paper")
            static let starred = UIImage(named: "paper_list_cell_starred")
        }

        enum InfoView {
            static let info = UIImage(named: "infoView_icon_info")
            static let close = UIImage(named: "infoView_icon_close")
        }

        enum DiaryCover {
            static let lock = UIImage(named: "diaryCoverLock")
        }

        enum ToolBar {
            static let info = UIImage(named: "toolBar_info")

            enum Lasso {
                static let info = UIImage(named: "toolBar_lasso_info")
            }

            enum Erase: String {
                case small
                case medium
                case large

                var image: UIImage? {
                    return UIImage(named: "toolBar_\(self.rawValue)")
                }

                var selectedImage: UIImage? {
                    return UIImage(named: "toolBar_\(self.rawValue)_select")
                }

            }

            enum TextStyle {
                static let plusButton = UIImage(named: "toolBar_textStyle_plus")
                static let minusButton = UIImage(named: "toolBar_textStyle_minus")
            }
        }

        enum Modal {
            static let down = UIImage(named: "btnModaldown")
        }
    }
}
