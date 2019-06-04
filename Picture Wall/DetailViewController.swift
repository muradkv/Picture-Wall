//
//  DetailViewController.swift
//  Picture Wall
//
//  Created by murad on 03/06/2019.
//  Copyright © 2019 murad. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    
    var selectedPicture: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadPicture()

    }
    
    func loadPicture() {
        if let imageLoad = selectedPicture {
            imageView.image = UIImage(named: imageLoad.path)
        }
    }

}
