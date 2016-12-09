//
//  UITableViewController+MyCells.swift
//  ProjectPhoenix
//
//  Created by Jeanette Müller on 09.11.16.
//  Copyright © 2016 Jeanette Müller. All rights reserved.
//

import UIKit


extension UITableViewController {
    
    func registerCells(){
        
        self.tableView.register(BasicCell.classForCoder(), forCellReuseIdentifier: "BasicCell")
        self.tableView.register(UINib(nibName: "BasicCell", bundle:nil), forCellReuseIdentifier: "BasicCell")
        
        self.tableView.register(EpisodeCell.classForCoder(), forCellReuseIdentifier: "EpisodeCell")
        self.tableView.register(UINib(nibName: "EpisodeCell", bundle:nil), forCellReuseIdentifier: "EpisodeCell")
        
        self.tableView.register(PlaylistCell.classForCoder(), forCellReuseIdentifier: "PlaylistCell")
        self.tableView.register(UINib(nibName: "PlaylistCell", bundle:nil), forCellReuseIdentifier: "PlaylistCell")
        
        self.tableView.register(LogoCell.classForCoder(), forCellReuseIdentifier: "LogoCell")
        self.tableView.register(UINib(nibName: "LogoCell", bundle:nil), forCellReuseIdentifier: "LogoCell")
        
        self.tableView.register(RightDetailCell.classForCoder(), forCellReuseIdentifier: "RightDetailCell")
        self.tableView.register(UINib(nibName: "RightDetailCell", bundle:nil), forCellReuseIdentifier: "RightDetailCell")
        
        self.tableView.register(SubtitleCell.classForCoder(), forCellReuseIdentifier: "SubtitleCell")
        self.tableView.register(UINib(nibName: "SubtitleCell", bundle:nil), forCellReuseIdentifier: "SubtitleCell")
        
        self.tableView.register(SwitchCell.classForCoder(), forCellReuseIdentifier: "SwitchCell")
        self.tableView.register(UINib(nibName: "SwitchCell", bundle:nil), forCellReuseIdentifier: "SwitchCell")
        
        self.tableView.register(TitleCell.classForCoder(), forCellReuseIdentifier: "TitleCell")
        self.tableView.register(UINib(nibName: "TitleCell", bundle:nil), forCellReuseIdentifier: "TitleCell")
        
        self.tableView.register(UrlInputCell.classForCoder(), forCellReuseIdentifier: "UrlInputCell")
        self.tableView.register(UINib(nibName: "UrlInputCell", bundle:nil), forCellReuseIdentifier: "UrlInputCell")
        
        self.tableView.register(InputCell.classForCoder(), forCellReuseIdentifier: "InputCell")
        self.tableView.register(UINib(nibName: "InputCell", bundle:nil), forCellReuseIdentifier: "InputCell")
        
        self.tableView.register(UrlInputCell.classForCoder(), forCellReuseIdentifier: "UrlInputCell")
        self.tableView.register(UINib(nibName: "UrlInputCell", bundle:nil), forCellReuseIdentifier: "UrlInputCell")
        
        self.tableView.register(StepperCell.classForCoder(), forCellReuseIdentifier: "StepperCell")
        self.tableView.register(UINib(nibName: "StepperCell", bundle:nil), forCellReuseIdentifier: "StepperCell")
        
        self.tableView.register(ProgressCell.classForCoder(), forCellReuseIdentifier: "ProgressCell")
        self.tableView.register(UINib(nibName: "ProgressCell", bundle:nil), forCellReuseIdentifier: "ProgressCell")
        
        self.tableView.register(ChapterCell.classForCoder(), forCellReuseIdentifier: "ChapterCell")
        self.tableView.register(UINib(nibName: "ChapterCell", bundle:nil), forCellReuseIdentifier: "ChapterCell")
        
        
        self.tableView.register(EpisodesHeaderView.classForCoder(), forHeaderFooterViewReuseIdentifier: "EpisodesHeaderView")
        self.tableView.register(UINib(nibName: "EpisodesHeaderView", bundle:nil), forHeaderFooterViewReuseIdentifier: "EpisodesHeaderView")
        
    }
}


